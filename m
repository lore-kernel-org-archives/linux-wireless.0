Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:48007 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337Ab1CHSPe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 13:15:34 -0500
Received: by mail-iy0-f170.google.com with SMTP id 12so9481630iyb.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2011 10:15:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299591449-14741-1-git-send-email-coelho@ti.com>
References: <1299421940-26292-7-git-send-email-shahar_levi@ti.com>
	<1299591449-14741-1-git-send-email-coelho@ti.com>
Date: Tue, 8 Mar 2011 20:15:30 +0200
Message-ID: <AANLkTi=hswVxfrn-E9gLORiAqBA=2B3dBC77mtBe6W_J@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: fixes for 1281/1283 support - New boot sequence
From: "Levi, Shahar" <shahar_levi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 8, 2011 at 3:37 PM, Luciano Coelho <coelho@ti.com> wrote:
> This patch fixes up some issues with patch 06/15 in the wl128x support
> series:
>
> * Remove unnecessary else block in wl128x_switch_fref;
> * Remove unnecessary change in main.c;
> * Remove some unnecessary debug prints and comments;
> * Fix potential use of uninitialized value (pll_config)
> * Add more all the defines for HCI_IO_DS_* instead of having them in a comment
>
> This has been compile-tested only.  I will test this changes after I
> go through the whole series and, if everything is still ok, I'll merge
> this patch into 06/15.
>
> Cc: Shahar Levi <shahar_levi@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>  drivers/net/wireless/wl12xx/boot.c |  106 +++++++++++++++---------------------
>  drivers/net/wireless/wl12xx/boot.h |    5 ++
>  2 files changed, 48 insertions(+), 63 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
> index e0d60ab..ffdcb7e 100644
> --- a/drivers/net/wireless/wl12xx/boot.c
> +++ b/drivers/net/wireless/wl12xx/boot.c
> @@ -533,46 +533,42 @@ static int wl128x_switch_fref(struct wl1271 *wl, bool *is_ref_clk)
>
>        /* if working on XTAL-only mode go directly to TCXO TO FREF SWITCH */
>        if ((wl->ref_clock == CONF_REF_CLK_38_4_M_XTAL) ||
> -           (wl->ref_clock == CONF_REF_CLK_26_M_XTAL)) {
> -               wl1271_debug(DEBUG_BOOT, "XTAL-only mode go directly to"
> -                                        " TCXO TO FREF SWITCH");
I believe that debug should be say in that function that check the ref value.

...
> @@ -753,8 +742,9 @@ int wl1271_load_firmware(struct wl1271 *wl)
>                        clk |= ((wl->tcxo_clock & 0x3) << 1) << 4;
>                else
>                        clk |= ((wl->ref_clock & 0x3) << 1) << 4;
> -       } else
> -               clk |= ((wl->ref_clock & 0x3) << 1) << 4;
> +       } else {
> +               clk |= (wl->ref_clock << 1) << 4;
> +       }
This implantation is due to the fact only those two bits is valid for
clk setting (from MCP).
CONF_REF_CLK_38_4_M_XTAL should be set as 19M.
I will address is as separate patch.

>
>        wl1271_write32(wl, DRPW_SCRATCH_START, clk);
>
> @@ -788,18 +778,8 @@ int wl1271_load_firmware(struct wl1271 *wl)
>        /* WL1271: The reference driver skips steps 7 to 10 (jumps directly
>         * to upload_fw) */
>
> -       if (wl->chip.id == CHIP_ID_1283_PG20) {
> -               /*
> -                * Configure SDIO/wSPI DS according to the following table:
> -                * 00   8mA.
> -                * 01   4mA (default).
> -                * 10   6mA.
> -                * 11   2mA.
> -                * Write bits [1:0] of Register 0xd14
> -                * data is in pWlanParams->PlatformConfiguration bits [2:1]
Those two lines above is redundant. however I believe the comment
should be stay.

> -                */
> +       if (wl->chip.id == CHIP_ID_1283_PG20)
>                wl1271_top_reg_write(wl, SDIO_IO_DS, HCI_IO_DS_6MA);
> -       }
>
>        ret = wl1271_boot_upload_firmware(wl);
>        if (ret < 0)
> diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
> index daaf0e7..429c926 100644
> --- a/drivers/net/wireless/wl12xx/boot.h
> +++ b/drivers/net/wireless/wl12xx/boot.h
> @@ -125,7 +125,12 @@ struct wl1271_static_data {
>  #define MCS_PLL_N_REG_VAL            0x07
>
>  #define SDIO_IO_DS                   0xd14
> +
> +/* SDIO/wSPI DS configuration values */
> +#define HCI_IO_DS_8MA                0
> +#define HCI_IO_DS_4MA                1 /* default */
>  #define HCI_IO_DS_6MA                2
> +#define HCI_IO_DS_2MA                4
This value should be 3.

>
>  #define HW_CONFIG_19_2_M             1
>  #define HW_CONFIG_26_M               2
> --
> 1.7.1
Thanks for you fixes, comments above.

-- 
All the best,
Shahar

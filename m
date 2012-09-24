Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41054 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab2IXOda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 10:33:30 -0400
Received: by ieak13 with SMTP id k13so10980631iea.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2012 07:33:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348475664-22502-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1348475664-22502-1-git-send-email-rmanohar@qca.qualcomm.com>
Date: Mon, 24 Sep 2012 07:33:27 -0700
Message-ID: <CAMcMvsjBcPJ2W9KEih3UtC8kNVYs0EthMdmGwbHYMzReH6aNcQ@mail.gmail.com> (sfid-20120924_163338_105263_5EC4EDEF)
Subject: Re: [PATCH] ath9k_hw: fix BT sleep state on chip wakeup
From: Paul Stewart <pstew@chromium.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 24, 2012 at 1:34 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> Whenever both WLAN and BT in/out sleep mode, sometimes WLAN
> is not able to take back the shared LNA control after resumes
> from sleep mode. The idea is that for WLAN to check if BT owns
> LNA control and BT is in sleep mode when WLAN just resumes from
> sleep mode. If the condition is true, do a BTCOEX_RC_WARM_RESET
> for WLAN to take back the control of shared LNA.
> Now the issue is the BT sleep value read from MCI register is
> overlooked by assigning u32 into u8. Hence the above condition never
> be met so that WLAN used to report beacon losses and frequent
> connection drops.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Tested-by: Paul Stewart <pstew@chromium.org>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_mci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> index cab2384..d3fae36 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> @@ -1410,7 +1410,7 @@ void ar9003_mci_set_power_awake(struct ath_hw *ah)
>         }
>         REG_WRITE(ah, AR_DIAG_SW, (diag_sw | BIT(27) | BIT(19) | BIT(18)));
>         lna_ctrl = REG_READ(ah, AR_OBS_BUS_CTRL) & 0x3;
> -       bt_sleep = REG_READ(ah, AR_MCI_RX_STATUS) & AR_MCI_RX_REMOTE_SLEEP;
> +       bt_sleep = MS(REG_READ(ah, AR_MCI_RX_STATUS), AR_MCI_RX_REMOTE_SLEEP);
>
>         REG_WRITE(ah, AR_BTCOEX_CTRL2, btcoex_ctrl2);
>         REG_WRITE(ah, AR_DIAG_SW, diag_sw);
> --
> 1.7.12.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

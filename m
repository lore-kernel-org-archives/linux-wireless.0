Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34865 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbcBPGRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 01:17:40 -0500
Received: by mail-io0-f180.google.com with SMTP id g203so155253654iof.2
        for <linux-wireless@vger.kernel.org>; Mon, 15 Feb 2016 22:17:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455574327-2591-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1455574327-2591-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Tue, 16 Feb 2016 11:47:40 +0530
Message-ID: <CAFqt6zbRK610rbWEUvsw=Ci5hXVJ6YQL3io_Rh5hF38maRWdvQ@mail.gmail.com> (sfid-20160216_071744_698331_E9A216C1)
Subject: Re: [PATCH] rtlwifi: Change long delays to sleeps
From: Souptick Joarder <jrdr.linux@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 16, 2016 at 3:42 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Routine rtl_addr_delay() uses delay statements in code that can
> sleep. To improve system responsiveness, the various delay statements
> are changed.
>
> In addition, routines rtl_rfreg_delay() and rtl_bb_delay() are
> rewritten to use the code in rtl_addr_delay() for most of their
> input values.
>
> Suggested-by: Byeoungwook Kim <quddnr145@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> Kalle,
>
> This patch will interfere with a set of 3 patches submitted by Byeoungwook Kim
> <quddnr145@gmail.com> on Feb. 3, 2016 that are currently in the deferred list
> at patchwork.
>
> Larry
>
>  drivers/net/wireless/realtek/rtlwifi/core.c | 44 ++++++++---------------------
>  1 file changed, 12 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
> index 02eba0e..16ad0d6 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
> @@ -54,59 +54,39 @@ EXPORT_SYMBOL(channel5g_80m);
>  void rtl_addr_delay(u32 addr)
>  {
>         if (addr == 0xfe)
> -               mdelay(50);
> +               msleep(50);
>         else if (addr == 0xfd)
> -               mdelay(5);
> +               msleep(5);
>         else if (addr == 0xfc)
> -               mdelay(1);
> +               msleep(1);
>         else if (addr == 0xfb)
> -               udelay(50);
> +               usleep_range(50, 100);
>         else if (addr == 0xfa)
> -               udelay(5);
> +               usleep_range(5, 10);
>         else if (addr == 0xf9)
> -               udelay(1);
> +               usleep_range(1, 2);

         why udelay is replaced by usleep_range?
>  }
>  EXPORT_SYMBOL(rtl_addr_delay);
>
>  void rtl_rfreg_delay(struct ieee80211_hw *hw, enum radio_path rfpath, u32 addr,
>                      u32 mask, u32 data)
>  {
> -       if (addr == 0xfe) {
> -               mdelay(50);
> -       } else if (addr == 0xfd) {
> -               mdelay(5);
> -       } else if (addr == 0xfc) {
> -               mdelay(1);
> -       } else if (addr == 0xfb) {
> -               udelay(50);
> -       } else if (addr == 0xfa) {
> -               udelay(5);
> -       } else if (addr == 0xf9) {
> -               udelay(1);
> +       if (addr >= 0xf9 && addr <= 0xfe) {
> +               rtl_addr_delay(addr);
>         } else {
>                 rtl_set_rfreg(hw, rfpath, addr, mask, data);
> -               udelay(1);
> +               usleep_range(1, 2);
>         }
>  }
>  EXPORT_SYMBOL(rtl_rfreg_delay);
>
>  void rtl_bb_delay(struct ieee80211_hw *hw, u32 addr, u32 data)
>  {
> -       if (addr == 0xfe) {
> -               mdelay(50);
> -       } else if (addr == 0xfd) {
> -               mdelay(5);
> -       } else if (addr == 0xfc) {
> -               mdelay(1);
> -       } else if (addr == 0xfb) {
> -               udelay(50);
> -       } else if (addr == 0xfa) {
> -               udelay(5);
> -       } else if (addr == 0xf9) {
> -               udelay(1);
> +       if (addr >= 0xf9 && addr <= 0xfe) {
> +               rtl_addr_delay(addr);
>         } else {
>                 rtl_set_bbreg(hw, addr, MASKDWORD, data);
> -               udelay(1);
> +               usleep_range(1, 2);
>         }
>  }
>  EXPORT_SYMBOL(rtl_bb_delay);
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-Souptick

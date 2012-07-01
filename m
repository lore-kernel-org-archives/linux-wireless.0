Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47108 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2GAX7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 19:59:37 -0400
Received: by lbbgm6 with SMTP id gm6so6943654lbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jul 2012 16:59:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341062181-28071-12-git-send-email-hauke@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de> <1341062181-28071-12-git-send-email-hauke@hauke-m.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 2 Jul 2012 09:59:15 +1000
Message-ID: <CAGRGNgU3=WoGBrSBsuiGhTs2tx3iZMt_fjqYaxLk7rSAMw8jHQ@mail.gmail.com> (sfid-20120702_015941_367889_0EB86BC6)
Subject: Re: [PATCH v2 11/18] brcmsmac: remove some unnessessacry casts and
 void pointer
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, arend@broadcom.com,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,

On Sat, Jun 30, 2012 at 11:16 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/main.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index 478b374..8bad8b6 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -4241,10 +4240,8 @@ static void brcms_b_watchdog(void *arg)
>  }
>
>  /* common watchdog code */
> -static void brcms_c_watchdog(void *arg)
> +static void brcms_c_watchdog(struct brcms_c_info *wlc)
>  {
> -       struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
> -
>         BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
>
>         if (!wlc->pub->up)
> @@ -4284,7 +4281,9 @@ static void brcms_c_watchdog(void *arg)
>
>  static void brcms_c_watchdog_by_timer(void *arg)
>  {
> -       brcms_c_watchdog(arg);
> +       struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
> +
> +       brcms_c_watchdog(wlc);

You remove 2 cases of this pattern in your patch then add one. Why?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

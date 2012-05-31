Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34102 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2EaKwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 06:52:44 -0400
Received: by obbtb18 with SMTP id tb18so1185343obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 03:52:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338460487-3277-1-git-send-email-pontus.fuchs@gmail.com>
References: <1338460487-3277-1-git-send-email-pontus.fuchs@gmail.com>
Date: Thu, 31 May 2012 16:22:44 +0530
Message-ID: <CAD2nsn0xqnnY9yRKvvq=yOgy0G8FeJ9qn4CX7JK3GkzceZ93Ew@mail.gmail.com> (sfid-20120531_125247_831216_2E09F0E6)
Subject: Re: [PATCH] mac80211: Clear wowlan flag when drv_suspend returns failure
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pontus,

On Thu, May 31, 2012 at 4:04 PM, Pontus Fuchs <pontus.fuchs@gmail.com> wrote:
> drv_resume can get called without a prior call to drv_suspend.
> Consider the following steps:
>
> 1. Suspend is started but driver's drv_suspend returns error.
> 2. Suspend is aborted. local->wowlan flag is left set.
> 3. Interface is removed.

got a doubt, in which path interface remove happens ?

> 4. Suspend again. This time open_count is 0 so drv_suspend is
>   not called and local->wowlan not cleared.
> 5. On resume ieee80211_reconfig will call drv_resume since
>   local->wowlan is set.
>
> Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
> ---
>  net/mac80211/pm.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
> index af1c4e2..98c128b 100644
> --- a/net/mac80211/pm.c
> +++ b/net/mac80211/pm.c
> @@ -77,6 +77,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
>                int err = drv_suspend(local, wowlan);
>                if (err < 0) {
>                        local->quiescing = false;
> +                       local->wowlan = false;
>                        return err;
>                } else if (err > 0) {
>                        WARN_ON(err != 1);
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi

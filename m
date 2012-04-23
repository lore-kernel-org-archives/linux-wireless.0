Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64122 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab2DWPaT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 11:30:19 -0400
Received: by obbta14 with SMTP id ta14so12808890obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 08:30:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F956DD2.2020309@gmail.com>
References: <4F956DD2.2020309@gmail.com>
Date: Mon, 23 Apr 2012 18:30:18 +0300
Message-ID: <CAB3XZEefFCdcGVp3MS4GrJCavMb87RKAXkhO7CmettD1_G=xHQ@mail.gmail.com> (sfid-20120423_173024_779027_2245FB60)
Subject: Re: [PATCH/RFC] mac80211: wake queues if ieee80211_suspend failed
From: Eliad Peller <eliad@wizery.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Vitaly,

On Mon, Apr 23, 2012 at 5:57 PM, Vitaly Wool <vitalywool@gmail.com> wrote:
> Sometimes I'm seeing that after a rejected suspend which was
> rejected by the driver's suspend routine, the device can not
> associate to any AP any more. Investigation shows that it's
> due to the fact that the queues are left stopped with the
> reason IEEE80211_QUEUE_STOP_REASON_SUSPEND.
>
> With that known, it looks like we need to wake queues on an
> unsuccessful suspend attempt explicitly.
>
> ---
>  net/mac80211/pm.c           |    2 ++
>  1 file changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
> index 844cefb..fd57913 100644
> --- a/net/mac80211/pm.c
> +++ b/net/mac80211/pm.c
> @@ -96,6 +96,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct
> cfg80211_wowlan *wowlan)
>                int err = drv_suspend(local, wowlan);
>                if (err) {
>                        local->quiescing = false;
> +                       ieee80211_wake_queues_by_reason(hw,
> +
> IEEE80211_QUEUE_STOP_REASON_SUSPEND);
>                        return err;
>                }

it seems right.
looks like there's a similar issue with WLAN_STA_BLOCK_BA being set
for all the stations and not cleared on error.

Eliad.

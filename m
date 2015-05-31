Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35162 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936AbbEaKYC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 06:24:02 -0400
Received: by wicmx19 with SMTP id mx19so51546410wic.0
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 03:24:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433067731-20114-1-git-send-email-chaitanya.mgit@gmail.com>
References: <1433067731-20114-1-git-send-email-chaitanya.mgit@gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sun, 31 May 2015 15:53:40 +0530
Message-ID: <CABPxzY+WrV3XAdHvbg_SzPENjxBHqxV45HKVd--aDT-N9NbkUg@mail.gmail.com> (sfid-20150531_122409_564167_65F03913)
Subject: Re: [PATCH] mac80211: Fix power save state stuck in ACTIVE caused by
 race between suspend and Tx packet.
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Chaitanya T K <chaitanya.mgit@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 31, 2015 at 3:52 PM, Chaitanya T K <chaitanya.mgit@gmail.com> wrote:
> From: Chaitanya T K <chaitanya.mgit@gmail.com>
>
> If we receive suspend after TX path has executed
> dynamic ps disable work, the driver will be in
> ACTIVE state during suspend and even after it
> resumes.
>
> As before suspend all data packets are flushed
> it is safe to put the driver in to sleep for
> optimal power during suspend or up on resume.
>
> Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
> ---
>  net/mac80211/pm.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
> index ac6ad62..c9d71c2 100644
> --- a/net/mac80211/pm.c
> +++ b/net/mac80211/pm.c
> @@ -76,6 +76,21 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
>                         if (sdata->vif.type != NL80211_IFTYPE_STATION)
>                                 continue;
>                         ieee80211_mgd_quiesce(sdata);
> +                       /* This is to handle a race where suspend
> +                        * is invoked after dynamic ps work disables
> +                        * power save due to TX. This causes the driver
> +                        * to be stuck in ACTIVE during suspend and
> +                        * after resume unless there is another TX,
> +                        * after which the dynamic ps puts driver
> +                        * back to DOZE.
> +                        */
> +                       if (sdata->u.mgd.associated &&
> +                           sdata->u.mgd.powersave &&
> +                            !(local->hw.conf.flags & IEEE80211_CONF_PS)) {
> +                               local->hw.conf.flags |= IEEE80211_CONF_PS;
> +                               ieee80211_hw_config(local,
> +                                                   IEEE80211_CONF_CHANGE_PS);
> +                       }
>                 }
>
>                 err = drv_suspend(local, wowlan);


Johannes,

I was final able to fix my "from" problem in git send-email.
Sorry for previous spamming. We can continue the discussion
in this thread.

Regards,
Chaitanya T K>


-- 
Thanks,
Regards,
Chaitanya T K.

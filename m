Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35097 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3CNXAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 19:00:25 -0400
Message-ID: <51425681.2040207@candelatech.com> (sfid-20130315_000033_922618_0D7EF8DA)
Date: Thu, 14 Mar 2013 16:00:17 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Don't restart sta-timer if not associated.
References: <1363299471-10442-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1363299471-10442-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/14/2013 03:17 PM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> I found another crash when deleting lots of virtual stations
> in a congested environment.  I think the problem is that
> the ieee80211_mlme_notify_scan_completed could call
> ieee80211_restart_sta_timer for a non-associated interface
> that was about to be deleted.
>
> With the following patch I am unable to reproduce the
> crash.

Nevermind..this seems to break association...will work on
this some more.

Ben

>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 81e0619... a1cc8c4... M	net/mac80211/mlme.c
>   net/mac80211/mlme.c |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 81e0619..a1cc8c4 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2931,6 +2931,9 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
>   	u32 flags;
>
>   	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
> +		if (unlikely(!sdata->u.mgd.associated))
> +			return;
> +
>   		__ieee80211_stop_poll(sdata);
>
>   		/* let's probe the connection once */
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


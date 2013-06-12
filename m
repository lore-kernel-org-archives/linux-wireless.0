Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53860 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab3FLWNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 18:13:53 -0400
Message-ID: <51B8F299.4070104@candelatech.com> (sfid-20130613_001357_266405_785DC48B)
Date: Wed, 12 Jun 2013 15:13:45 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: fix TX aggregation TID struct leak
References: <1371070209-24107-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1371070209-24107-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/12/2013 01:50 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Ben reports that kmemleak is saying TX aggregation TID
> structs are leaked. Given his workload, I suspect that
> they're leaked because stations are destroyed before
> their aggregation sessions get a chance to start. Fix
> this by simply freeing structs that are not used yet.
>
> Reported-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   net/mac80211/sta_info.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index b429798..aaf68d2 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -149,6 +149,7 @@ static void cleanup_single_sta(struct sta_info *sta)
>   	 * directly by station destruction.
>   	 */
>   	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
> +		kfree(sta->ampdu_mlme.tid_start_tx[i]);
>   		tid_tx = rcu_dereference_raw(sta->ampdu_mlme.tid_tx[i]);
>   		if (!tid_tx)
>   			continue;
>


This does fix the TID leakage for me.

Tested-by:  Ben Greear <greearb@candelatech.com>

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


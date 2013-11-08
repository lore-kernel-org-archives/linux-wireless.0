Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:47658 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab3KHOnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 09:43:08 -0500
Message-ID: <1383921747.4264.1.camel@porter.coelho.fi> (sfid-20131108_154312_370548_17CDBF24)
Subject: Re: [RFC v3 1/4] mac80211: don't transmit beacon with CSA count 0
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: sw@simonwunderlich.de, johannes@sipsolutions.net
Date: Fri, 08 Nov 2013 16:42:27 +0200
In-Reply-To: <1383921579-22373-1-git-send-email-luciano.coelho@intel.com>
References: <1383921579-22373-1-git-send-email-luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While rebasing this patches to send series out, I noticed that mesh CSA
was also recently merged, so I'll have to take care of that too.  But I
decided to send these out anyway, so review can start.

I'll send a v4 with mesh taken into consideration as well.

Heheh, this started as a simple 2 liner patch, and look where we are
now. :D

--
Cheers,
Luca.

On Fri, 2013-11-08 at 16:39 +0200, Luciano Coelho wrote:
> A beacon should never have a Channel Switch Announcement information
> element with a count of 0, because a count of 1 means switch just
> before the next beacon.  So, if a count of 0 was valid in a beacon, it
> would have been transmitted in the next channel already, which is
> useless.  A CSA count equal to zero is only meaningful in action
> frames or probe_responses.
> 
> Fix the ieee80211_csa_is_complete() and ieee80211_update_csa()
> functions accordingly.
> 
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---
> In v2, updated the documentation to reflect the change.  This is going
> to be sent to linux-wireless for comments from the community too.
> 
> In v3, removed the part of the documentation that belongs in the next
> patch.
>     
>  include/net/mac80211.h |  8 ++++----
>  net/mac80211/tx.c      | 10 +++++++---
>  2 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 7ceed99..ec6ed6d 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2680,10 +2680,10 @@ enum ieee80211_roc_type {
>   * @channel_switch_beacon: Starts a channel switch to a new channel.
>   *	Beacons are modified to include CSA or ECSA IEs before calling this
>   *	function. The corresponding count fields in these IEs must be
> - *	decremented, and when they reach zero the driver must call
> + *	decremented, and when they reach 1 the driver must call
>   *	ieee80211_csa_finish(). Drivers which use ieee80211_beacon_get()
>   *	get the csa counter decremented by mac80211, but must check if it is
> - *	zero using ieee80211_csa_is_complete() after the beacon has been
> + *	1 using ieee80211_csa_is_complete() after the beacon has been
>   *	transmitted and then call ieee80211_csa_finish().
>   *
>   * @join_ibss: Join an IBSS (on an IBSS interface); this is called after all
> @@ -3383,13 +3383,13 @@ static inline struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
>   * @vif: &struct ieee80211_vif pointer from the add_interface callback.
>   *
>   * After a channel switch announcement was scheduled and the counter in this
> - * announcement hit zero, this function must be called by the driver to
> + * announcement hits 1, this function must be called by the driver to
>   * notify mac80211 that the channel can be changed.
>   */
>  void ieee80211_csa_finish(struct ieee80211_vif *vif);
>  
>  /**
> - * ieee80211_csa_is_complete - find out if counters reached zero
> + * ieee80211_csa_is_complete - find out if counters reached 1
>   * @vif: &struct ieee80211_vif pointer from the add_interface callback.
>   *
>   * This function returns whether the channel switch counters reached zero.
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index c558b24..57d9feb 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -2409,8 +2409,12 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
>  	if (WARN_ON(counter_offset_beacon >= beacon_data_len))
>  		return;
>  
> -	/* warn if the driver did not check for/react to csa completeness */
> -	if (WARN_ON(beacon_data[counter_offset_beacon] == 0))
> +	/* Warn if the driver did not check for/react to csa
> +	 * completeness.  A beacon with CSA counter set to 0 should
> +	 * never occur, because a counter of 1 means switch just
> +	 * before the next beacon.
> +	 */
> +	if (WARN_ON(beacon_data[counter_offset_beacon] == 1))
>  		return;
>  
>  	beacon_data[counter_offset_beacon]--;
> @@ -2476,7 +2480,7 @@ bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
>  	if (WARN_ON(counter_beacon > beacon_data_len))
>  		goto out;
>  
> -	if (beacon_data[counter_beacon] == 0)
> +	if (beacon_data[counter_beacon] == 1)
>  		ret = true;
>   out:
>  	rcu_read_unlock();



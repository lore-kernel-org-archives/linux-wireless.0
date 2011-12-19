Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49827 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1LSTpe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 14:45:34 -0500
Date: Mon, 19 Dec 2011 14:39:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Yogesh Ashok Powar <yogesh.powar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH V2] mac80211: Fixing sparse warning at sta_info.c
Message-ID: <20111219193957.GC31462@tuxdriver.com> (sfid-20111219_204536_386770_EA522036)
References: <82612>
 <20111216061715.GA11190@dugs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111216061715.GA11190@dugs>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applying: mac80211: Fixing sparse warning at sta_info.c
error: patch failed: net/mac80211/sta_info.c:974
error: net/mac80211/sta_info.c: patch does not apply

What tree did you use as a base for your patch?

On Fri, Dec 16, 2011 at 11:47:15AM +0530, Yogesh Ashok Powar wrote:
> The commit 42624d4913a00219a8fdbb4bafd634d1d843be85
> created following sparse warning
> >net/mac80211/sta_info.c:965:24: warning: incorrect type in assignment (different address spaces)
> >net/mac80211/sta_info.c:965:24:    expected struct tid_ampdu_tx *tid_tx
> >net/mac80211/sta_info.c:965:24:    got struct tid_ampdu_tx [noderef] <asn:4>*<noident>
> 
> Making use of rcu_dereference_protected to fix the problem.
> 
> V2:
>  - Replacing rcu_dereference with rcu_dereference_protected
>    as suggested by Johannes.
>  - Adding mutex_lock/unlock to satisfy the condition at
>    rcu_dereference_protected
> 
> Cc: Nishant Sarmukadam <nishants@marvell.com>
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> ---
>  net/mac80211/sta_info.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index c6ca9bd..e4307b7 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -959,10 +959,13 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
>  	 * until the aggregation stop completes. Refer
>  	 * http://thread.gmane.org/gmane.linux.kernel.wireless.general/81936
>  	 */
> +
> +	mutex_lock(&sta->ampdu_mlme.mtx);
> +
>  	for (i = 0; i < STA_TID_NUM; i++) {
> -		if (!sta->ampdu_mlme.tid_tx[i])
> +		tid_tx = rcu_dereference_protected_tid_tx(sta, i);
> +		if (!tid_tx)
>  			continue;
> -		tid_tx = sta->ampdu_mlme.tid_tx[i];
>  		if (skb_queue_len(&tid_tx->pending)) {
>  #ifdef CONFIG_MAC80211_HT_DEBUG
>  			wiphy_debug(local->hw.wiphy, "TX A-MPDU  purging %d "
> @@ -974,6 +977,8 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
>  		kfree_rcu(tid_tx, rcu_head);
>  	}
>  
> +	mutex_unlock(&sta->ampdu_mlme.mtx);
> +
>  	__sta_info_free(local, sta);
>  
>  	return 0;
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

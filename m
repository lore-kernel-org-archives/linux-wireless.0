Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:40470 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461AbaDJG7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 02:59:14 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFTv2 3/5] ath10k: rework peer accounting
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-4-git-send-email-michal.kazior@tieto.com>
Date: Thu, 10 Apr 2014 09:59:07 +0300
In-Reply-To: <1397040531-6224-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 9 Apr 2014 12:48:49 +0200")
Message-ID: <87k3axhdqc.fsf@kamboji.qca.qualcomm.com> (sfid-20140410_085925_495589_9B498DF0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It was troublesome to iterate over peers and
> perform sleepable calls. This will be necessary
> for some upcomming changes to tx flushing.
>
> Make peer allocation and initial setup
> protected by both ar->conf_mutex and
> ar->data_lock. This way it's possible to iterate
> over peers with conf_mutex and call sleepable
> functions.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

First comments, but I need to read this much more carefully still:

> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -199,9 +199,14 @@ struct ath10k_dfs_stats {
>  #define ATH10K_MAX_NUM_PEER_IDS (1 << 11) /* htt rx_desc limit */
>  
>  struct ath10k_peer {
> +	/* protected by conf_mutex + data_lock */
>  	struct list_head list;

This really needs a lot more documentation. And besides, don't we
actually want to protect struct ath10k::peers, not this?

> +/* hold conf_mutex for simple iteration, or conf_mutex+data_lock for
> + * modifications */
>  struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
>  				     const u8 *addr)
>  {
>  	struct ath10k_peer *peer;
>  
> -	lockdep_assert_held(&ar->data_lock);
> -
>  	list_for_each_entry(peer, &ar->peers, list) {
>  		if (peer->vdev_id != vdev_id)
>  			continue;

The comment here makes me suspicious. How can we safely iterate the list
if we don't take data_lock? Doesn't it mean that the list can change
while we have conf_mutex?

-- 
Kalle Valo

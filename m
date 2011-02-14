Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7277 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab1BNPsI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 10:48:08 -0500
Subject: Re: [PATCH 4/5] iwlwifi: auto-tune tx queue size to minimize
 latency
From: wwguy <wey-yi.w.guy@intel.com>
To: "Nathaniel J. Smith" <njs@pobox.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
In-Reply-To: <1297619803-2832-5-git-send-email-njs@pobox.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	 <1297619803-2832-5-git-send-email-njs@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 07:46:18 -0800
Message-ID: <1297698378.4723.14.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nathaniel,

On Sun, 2011-02-13 at 09:56 -0800, Nathaniel J. Smith wrote:
> We maintain several ring buffers that queue up packets for the
> hardware to transmit. These buffers can be quite large, and the
> quality of wireless connections can vary greatly; as a result, it can
> be that a full queue might take multiple seconds to drain.
> 
> For instance, if there is a high-bandwidth outgoing flow, like a large
> file upload, then it will completely fill the tx queues. Once the
> queues are full, then any other outgoing packets -- like those sent
> when a user clicks on an HTTP link, or types into an SSH session --
> will have to wait at the end of the line, and will not actually be
> transmitted until multiple seconds have passed.  This results in a
> suboptimal level of interactive response.
> 
> So we really don't want to allow too many packets to get queued up. On
> the other hand, we do want to queue up *some* packets, to maintain
> throughput -- and the queue size that maintains interactivity for a
> degraded 1 Mb/s connection might not be so great for some
> super-fancy 802.11n 600 Mb/s connection.
> 
> This patch estimates how long it takes the hardware to transmit one
> packet (by comparing each packet's queue residency time to the number
> of packets it had to wait behind), and then further smooths these
> estimates with an EWMA. Then, it uses the estimated packet
> transmission time to choose the maximum queue size that will still
> produce reasonably bounded queue residency times, given current
> conditions.
> 
> Signed-off-by: Nathaniel J. Smith <njs@pobox.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 +
>  drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    3 +++
>  drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
>  drivers/net/wireless/iwlwifi/iwl-dev.h      |   11 +++++++++++
>  drivers/net/wireless/iwlwifi/iwl-tx.c       |   26 ++++++++++++++++++++++++++
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 ++
>  6 files changed, 44 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index f2e9e59..d52bcb3 100644

>  
> +void iwl_tx_queue_update_high_mark(struct iwl_tx_queue *txq, int index)
> +{
> +	struct iwl_queue *q = &txq->q;
> +	struct timespec now, diff;
> +	int enqueue_depth = txq->txb[index].enqueue_depth;
> +	int this_ns_per_packet, avg_ns_per_packet;
> +	int new_high_mark;
> +
> +	getrawmonotonic(&now);
> +	diff = timespec_sub(now, txq->txb[index].enqueue_time);
> +	this_ns_per_packet = (NSEC_PER_SEC / enqueue_depth) * diff.tv_sec;
> +	this_ns_per_packet += diff.tv_nsec / enqueue_depth;
> +	/* Just some sanity checks for paranoia's sake */
> +	if (this_ns_per_packet < 0 && this_ns_per_packet > NSEC_PER_SEC)
> +		return;
> +	ewma_add(&q->ns_per_packet, this_ns_per_packet);
> +	avg_ns_per_packet = ewma_read(&q->ns_per_packet);
> +	new_high_mark = IWL_TX_HIGH_MARK_IN_NSEC / avg_ns_per_packet;
> +	new_high_mark = clamp(new_high_mark, 2, q->n_window - 2);
> +	atomic_set(&q->high_mark, new_high_mark);
> +}
> +EXPORT_SYMBOL(iwl_tx_queue_update_high_mark);
> +
> +

should the high_mark get reset when interface up or queue reset.

Wey



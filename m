Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10298 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab0BSSA3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 13:00:29 -0500
Subject: Re: [PATCH 2/3] iwlwifi: sanity check before counting number of
 tfds can be free
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20100219164041.GA3995@dhcp-lab-161.englab.brq.redhat.com>
References: <1266559301-19581-1-git-send-email-reinette.chatre@intel.com>
	 <1266559301-19581-3-git-send-email-reinette.chatre@intel.com>
	 <20100219164041.GA3995@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain
Date: Fri, 19 Feb 2010 09:57:01 -0800
Message-Id: <1266602221.16888.14.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

Thanks for the feedback.

On Fri, 2010-02-19 at 08:40 -0800, Stanislaw Gruszka wrote:
> Hi Reinette 
> On Thu, Feb 18, 2010 at 10:01:40PM -0800, Reinette Chatre wrote:
> > This fix starts to address
> > http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2160 . There are
> > more situations in which this problem (freed tfds below zero) can occur so
> > this bug is not closed yet.
> 
> Only starts ... ,hmm so these two patches does not fix any issue.
> 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
> > index 87ce2bd..9196d3f 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-tx.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
> > @@ -1131,6 +1131,7 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
> >  	struct iwl_queue *q = &txq->q;
> >  	struct iwl_tx_info *tx_info;
> >  	int nfreed = 0;
> > +	struct ieee80211_hdr *hdr;
> >  
> >  	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
> >  		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
> > @@ -1145,13 +1146,19 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
> >  
> >  		tx_info = &txq->txb[txq->q.read_ptr];
> >  		iwl_tx_status(priv, tx_info->skb[0]);
> > +
> > +		if (tx_info->skb[0]) {
> > +			hdr = (struct ieee80211_hdr *)
> > +				((struct sk_buff *)tx_info->skb[0])->data;
> 
> Not needed cast.
> 
you are right, no need to cast.

> > +			if (hdr && ieee80211_is_data_qos(hdr->frame_control))
> > +				nfreed++;
> > +		}
> 
> I think additional line is needed to make things work. Something like below
> should work, but I have no time to test it today.
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
> index de45f30..6b516c4 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-5000.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
> @@ -1153,8 +1153,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
>  				   tx_resp->failure_frame);
>  
>  		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
> -		if (ieee80211_is_data_qos(tx_resp->frame_ctrl))
> -			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
> +		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;

Correct, I miss this place, there is no need to check tx_resp here, and
I will prefer to do sanity check before decrement the tfds_in_queue to
prevent it go into negative range.

>  
>  		if (priv->mac80211_registered &&
>  		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
> diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
> index 281d318..c051f9f 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-tx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
> @@ -1132,6 +1132,7 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
>  	struct iwl_queue *q = &txq->q;
>  	struct iwl_tx_info *tx_info;
>  	int nfreed = 0;
> +	struct ieee80211_hdr *hdr;
>  
>  	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
>  		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
> @@ -1146,13 +1147,18 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
>  
>  		tx_info = &txq->txb[txq->q.read_ptr];
>  		iwl_tx_status(priv, tx_info->skb[0]);
> +
> +		if (tx_info->skb[0]) {
> +			hdr = (struct ieee80211_hdr *) tx_info->skb[0]->data;
> +			if (hdr && ieee80211_is_data_qos(hdr->frame_control))
> +				nfreed++;
> +		}
>  		tx_info->skb[0] = NULL;
>  
>  		if (priv->cfg->ops->lib->txq_inval_byte_cnt_tbl)
>  			priv->cfg->ops->lib->txq_inval_byte_cnt_tbl(priv, txq);
>  
>  		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
> -		nfreed++;
>  	}
>  	return nfreed;
>  }
> 
Thanks very much for checking, I will re-submit the patch to fix the
issues.

Wey



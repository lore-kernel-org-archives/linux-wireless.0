Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:65157 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGPLjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 07:39:25 -0400
Received: by mail-pd0-f179.google.com with SMTP id ft15so1094475pdb.38
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 04:39:25 -0700 (PDT)
Message-ID: <53C66422.10702@gmail.com> (sfid-20140716_133929_396779_8AF32EB0)
Date: Wed, 16 Jul 2014 17:08:10 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org,
	Denton Gentry <denton.gentry@gmail.com>
Subject: Re: [PATCH v3] ath10k: fix Rx aggregation reordering
References: <1405505855-13741-1-git-send-email-michal.kazior@tieto.com> <1405509540-32691-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1405509540-32691-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/16/2014 04:49 PM, Michal Kazior wrote:

(...)

> +static void ath10k_htt_rx_addba(struct ath10k *ar, struct htt_resp *resp)
> +{
> +	struct htt_rx_addba *ev = &resp->rx_addba;
> +	struct ath10k_peer *peer;
> +	struct ath10k_vif *arvif;
> +	u16 info0, tid, peer_id;
> +
> +	info0 = __le32_to_cpu(ev->info0);
> +	tid = MS(info0, HTT_RX_BA_INFO0_TID);
> +	peer_id = MS(info0, HTT_RX_BA_INFO0_PEER_ID);
> +
> +	ath10k_dbg(ATH10K_DBG_HTT,
> +		   "htt rx addba tid %hu peer_id %hu size %hhu\n",
> +		   tid, peer_id, ev->window_size);
> +
> +	spin_lock_bh(&ar->data_lock);
> +	peer = ath10k_peer_find_by_id(ar, peer_id);
> +	if (!peer) {
> +		ath10k_warn("received addba event for invalid peer_id: %hu\n",
> +			    peer_id);
> +		spin_unlock_bh(&ar->data_lock);
> +		return;
> +	}

Here my concern in amount of time holding the lock...

spin_lock_bh(&ar->data_lock);
peer = ath10k_peer_find_by_id(ar, peer_id);
if (!peer) {
	spin_unlock_bh(&ar->data_lock);
	ath10k_warn("received addba event for invalid peer_id: %hu\n",
		    peer_id);
	return;
}

No need to of putting the debug message inside the critical region...  :-)

> +
> +	arvif = ath10k_get_arvif(ar, peer->vdev_id);
> +	if (!arvif) {
> +		ath10k_warn("received addba event for invalid vdev_id: %u\n",
> +			    peer->vdev_id);
> +		spin_unlock_bh(&ar->data_lock);

Ditto

> +		return;
> +	}
> +
> +	ath10k_dbg(ATH10K_DBG_HTT,
> +		   "htt rx start rx ba session sta %pM tid %hu size %hhu\n",
> +		   peer->addr, tid, ev->window_size);
> +
> +	ieee80211_start_rx_ba_session_offl(arvif->vif, peer->addr, tid);
> +	spin_unlock_bh(&ar->data_lock);
> +}
> +
> +static void ath10k_htt_rx_delba(struct ath10k *ar, struct htt_resp *resp)
> +{
> +	struct htt_rx_addba *ev = &resp->rx_addba;
> +	struct ath10k_peer *peer;
> +	struct ath10k_vif *arvif;
> +	u16 info0, tid, peer_id;
> +
> +	info0 = __le32_to_cpu(ev->info0);
> +	tid = MS(info0, HTT_RX_BA_INFO0_TID);
> +	peer_id = MS(info0, HTT_RX_BA_INFO0_PEER_ID);
> +
> +	ath10k_dbg(ATH10K_DBG_HTT,
> +		   "htt rx delba tid %hu peer_id %hu\n",
> +		   tid, peer_id);
> +
> +	spin_lock_bh(&ar->data_lock);
> +	peer = ath10k_peer_find_by_id(ar, peer_id);
> +	if (!peer) {
> +		ath10k_warn("received addba event for invalid peer_id: %hu\n",
> +			    peer_id);
> +		spin_unlock_bh(&ar->data_lock);
> +		return;

Ditto..

> +	}
> +
> +	arvif = ath10k_get_arvif(ar, peer->vdev_id);
> +	if (!arvif) {
> +		ath10k_warn("received addba event for invalid vdev_id: %u\n",
> +			    peer->vdev_id);
> +		spin_unlock_bh(&ar->data_lock);
> +		return;
> +	}
> +
> +	ath10k_dbg(ATH10K_DBG_HTT,
> +		   "htt rx stop rx ba session sta %pM tid %hu\n",
> +		   peer->addr, tid);
> +
> +	ieee80211_stop_rx_ba_session_offl(arvif->vif, peer->addr, tid);
> +	spin_unlock_bh(&ar->data_lock);
> +}
> +
>   void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
>   {
>   	struct ath10k_htt *htt = &ar->htt;
> @@ -1515,10 +1596,19 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
>   	case HTT_T2H_MSG_TYPE_STATS_CONF:
>   		trace_ath10k_htt_stats(skb->data, skb->len);
>   		break;
> -	case HTT_T2H_MSG_TYPE_TX_INSPECT_IND:
>   	case HTT_T2H_MSG_TYPE_RX_ADDBA:
> +		ath10k_htt_rx_addba(ar, resp);
> +		break;
>   	case HTT_T2H_MSG_TYPE_RX_DELBA:
> -	case HTT_T2H_MSG_TYPE_RX_FLUSH:
> +		ath10k_htt_rx_delba(ar, resp);
> +		break;
> +	case HTT_T2H_MSG_TYPE_RX_FLUSH: {
> +		/* Ignore this event because mac80211 takes care of Rx
> +		 * aggregation reordering.
> +		 */
> +		break;
> +	}
> +	case HTT_T2H_MSG_TYPE_TX_INSPECT_IND:
>   	default:
>   		ath10k_dbg(ATH10K_DBG_HTT, "htt event (%d) not handled\n",
>   			   resp->hdr.msg_type);
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index b8314a5..67bf8ed 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4331,6 +4331,38 @@ static u64 ath10k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
>   	return 0;
>   }
>   
> +static int ath10k_ampdu_action(struct ieee80211_hw *hw,
> +			       struct ieee80211_vif *vif,
> +			       enum ieee80211_ampdu_mlme_action action,
> +			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
> +			       u8 buf_size)
> +{
> +	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
> +
> +	ath10k_dbg(ATH10K_DBG_MAC, "mac ampdu vdev_id %i sta %pM tid %hu action %d\n",
> +		   arvif->vdev_id, sta->addr, tid, action);
> +
> +	switch (action) {
> +	case IEEE80211_AMPDU_RX_START:
> +	case IEEE80211_AMPDU_RX_STOP:
> +		/* HTT AddBa/DelBa events trigger mac80211 Rx BA session
> +		 * creation/removal. Do we need to verify this?
> +		 */
> +		return 0;
> +	case IEEE80211_AMPDU_TX_START:
> +	case IEEE80211_AMPDU_TX_STOP_CONT:
> +	case IEEE80211_AMPDU_TX_STOP_FLUSH:
> +	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
> +	case IEEE80211_AMPDU_TX_OPERATIONAL:
> +		/* Firmware offloads Tx aggregation entirely so deny mac80211
> +		 * Tx aggregation requests.
> +		 */
> +		break;

Instead of break here we can directly do: return -EOPNOTSUPP;

> +	}
> +
> +	return -EOPNOTSUPP;
> +}
> +

-- 
Regards,
Varka Bhadram.


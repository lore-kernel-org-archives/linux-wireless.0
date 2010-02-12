Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:47284
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab0BLOAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2010 09:00:08 -0500
Message-ID: <4B755D4B.8060005@mit.edu>
Date: Fri, 12 Feb 2010 08:53:15 -0500
From: Andy Lutomirski <luto@mit.edu>
MIME-Version: 1.0
To: "reinette chatre" <reinette.chatre@intel.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3943-devel@lists.sourceforge.net,
	Trieu 'Andrew' Nguyen <trieux.t.nguyen@intel.com>
Subject: Re: [PATCH 12/12] iwlwifi: Monitor and recover the aggregation TX
 flow failure
References: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com> <1265913725-4279-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1265913725-4279-13-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinette Chatre wrote:
> From: Trieu 'Andrew' Nguyen <trieux.t.nguyen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This change monitors the tx statistics to detect the drop in throughput.
> When the throughput drops, the ratio of the actual_ack_count and the expected_
> ack_count also drops.  At the same time, the aggregated ba_timeout (the number
> of ba timeout retries) also rises.  If the actual_ack_count/expected_ack_count
> ratio is 0 and the number of ba timeout retries rises to 16, no tx packets
> (tcp, udp, or ping - icmp) can be delivered.  The driver recovers from this
> situation by reseting the uCode firmware.  If the actual_ack_count/expected_
> ack_count ratio drops below 50% (but not 0) and the aggregated ba_timeout
> retries just exceed 5 (but not 16), then the driver can reset the radio to
> bring the throughput up.

Any chance this fixes big 2120?  Maybe I'm too optimistic, but I'll try 
to test it this afternoon.

http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2120

--Andy

> 
> Signed-off-by: Trieu 'Andrew' Nguyen <trieux.t.nguyen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c |   14 +++++++++-
>  drivers/net/wireless/iwlwifi/iwl-dev.h |    3 ++
>  drivers/net/wireless/iwlwifi/iwl-rx.c  |   46 ++++++++++++++++++++++++++++++++
>  3 files changed, 62 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 31b156d..4157c6c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -2941,10 +2941,21 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
>  			return ret;
>  	case IEEE80211_AMPDU_TX_START:
>  		IWL_DEBUG_HT(priv, "start Tx\n");
> -		return iwl_tx_agg_start(priv, sta->addr, tid, ssn);
> +		ret = iwl_tx_agg_start(priv, sta->addr, tid, ssn);
> +		if (ret == 0) {
> +			priv->agg_tids_count++;
> +			IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
> +				priv->agg_tids_count);
> +		}
> +		return ret;
>  	case IEEE80211_AMPDU_TX_STOP:
>  		IWL_DEBUG_HT(priv, "stop Tx\n");
>  		ret = iwl_tx_agg_stop(priv, sta->addr, tid);
> +		if ((ret == 0) && (priv->agg_tids_count > 0)) {
> +			priv->agg_tids_count--;
> +			IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
> +				priv->agg_tids_count);
> +		}
>  		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
>  			return 0;
>  		else
> @@ -3364,6 +3375,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
>  	priv->iw_mode = NL80211_IFTYPE_STATION;
>  	priv->current_ht_config.smps = IEEE80211_SMPS_STATIC;
>  	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
> +	priv->agg_tids_count = 0;
>  
>  	/* Choose which receivers/antennas to use */
>  	if (priv->cfg->ops->hcmd->set_rxon_chain)
> diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
> index 71cf155..f81317d 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-dev.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
> @@ -1072,6 +1072,9 @@ struct iwl_priv {
>  	/* storing the jiffies when the plcp error rate is received */
>  	unsigned long plcp_jiffies;
>  
> +	/* reporting the number of tids has AGG on. 0 means no AGGREGATION */
> +	u8 agg_tids_count;
> +
>  	/* force reset */
>  	unsigned long last_force_reset_jiffies;
>  
> diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
> index aba8f4c..fed554a 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-rx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
> @@ -616,6 +616,11 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
>  
>  #define REG_RECALIB_PERIOD (60)
>  
> +/* the threshold ratio of actual_ack_cnt to expected_ack_cnt in percent */
> +#define ACK_CNT_RATIO (50)
> +#define BA_TIMEOUT_CNT (5)
> +#define BA_TIMEOUT_MAX (16)
> +
>  #define PLCP_MSG "plcp_err exceeded %u, %u, %u, %u, %u, %d, %u mSecs\n"
>  void iwl_rx_statistics(struct iwl_priv *priv,
>  			      struct iwl_rx_mem_buffer *rxb)
> @@ -625,6 +630,9 @@ void iwl_rx_statistics(struct iwl_priv *priv,
>  	int combined_plcp_delta;
>  	unsigned int plcp_msec;
>  	unsigned long plcp_received_jiffies;
> +	int actual_ack_cnt_delta;
> +	int expected_ack_cnt_delta;
> +	int ba_timeout_delta;
>  
>  	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
>  		     (int)sizeof(priv->statistics),
> @@ -639,6 +647,44 @@ void iwl_rx_statistics(struct iwl_priv *priv,
>  #ifdef CONFIG_IWLWIFI_DEBUG
>  	iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
>  #endif
> +	actual_ack_cnt_delta = le32_to_cpu(pkt->u.stats.tx.actual_ack_cnt) -
> +		le32_to_cpu(priv->statistics.tx.actual_ack_cnt);
> +	expected_ack_cnt_delta = le32_to_cpu(
> +			pkt->u.stats.tx.expected_ack_cnt) -
> +		le32_to_cpu(priv->statistics.tx.expected_ack_cnt);
> +	ba_timeout_delta = le32_to_cpu(
> +			pkt->u.stats.tx.agg.ba_timeout) -
> +		le32_to_cpu(priv->statistics.tx.agg.ba_timeout);
> +	if ((priv->agg_tids_count > 0) &&
> +		(expected_ack_cnt_delta > 0) &&
> +		(((actual_ack_cnt_delta * 100) / expected_ack_cnt_delta) <
> +			ACK_CNT_RATIO) &&
> +		(ba_timeout_delta > BA_TIMEOUT_CNT)) {
> +		IWL_DEBUG_RADIO(priv,
> +			"actual_ack_cnt delta = %d, expected_ack_cnt = %d\n",
> +			actual_ack_cnt_delta, expected_ack_cnt_delta);
> +
> +#ifdef CONFIG_IWLWIFI_DEBUG
> +		IWL_DEBUG_RADIO(priv, "rx_detected_cnt delta = %d\n",
> +			priv->delta_statistics.tx.rx_detected_cnt);
> +		IWL_DEBUG_RADIO(priv,
> +			"ack_or_ba_timeout_collision delta = %d\n",
> +			priv->delta_statistics.tx.ack_or_ba_timeout_collision);
> +#endif
> +		IWL_DEBUG_RADIO(priv, "agg ba_timeout delta = %d\n",
> +			ba_timeout_delta);
> +		if ((actual_ack_cnt_delta == 0) &&
> +			(ba_timeout_delta >=
> +				BA_TIMEOUT_MAX)) {
> +			IWL_DEBUG_RADIO(priv,
> +				"call iwl_force_reset(IWL_FW_RESET)\n");
> +			iwl_force_reset(priv, IWL_FW_RESET);
> +		} else {
> +			IWL_DEBUG_RADIO(priv,
> +				"call iwl_force_reset(IWL_RF_RESET)\n");
> +			iwl_force_reset(priv, IWL_RF_RESET);
> +		}
> +	}
>  	/*
>  	 * check for plcp_err and trigger radio reset if it exceeds
>  	 * the plcp error threshold plcp_delta.


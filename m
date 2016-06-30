Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55858 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbcF3LAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 07:00:43 -0400
Date: Thu, 30 Jun 2016 16:29:51 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: Fix 10.4 extended peer stats update
Message-ID: <20160630105951.GA10001@atheros-ThinkPad-T61> (sfid-20160630_130048_069577_7895EC0E)
References: <1464851602-12969-1-git-send-email-mohammed@qca.qualcomm.com>
 <87vb0r5529.fsf@kamboji.qca.qualcomm.com>
 <87r3bf54v6.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87r3bf54v6.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Thu, Jun 30, 2016 at 10:49:02AM +0000, Valo, Kalle wrote:
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
> 
> >> @@ -261,6 +263,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
> >>  			.board = QCA4019_HW_1_0_BOARD_DATA_FILE,
> >>  			.board_size = QCA4019_BOARD_DATA_SZ,
> >>  			.board_ext_size = QCA4019_BOARD_EXT_DATA_SZ,
> >> +			.extd_peer_stats = true,
> >>  		},
> >>  	},
> >>  };
> >
> > This is not a hardware feature so hw_params is not really the right
> > place to handle this. In the pending branch I tried to solve this a bit
> > differently:
> >
> > https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=ecf4daadc7677518ec7185dbddab959ac6e2db96
> >
> > I added a bool "extended" to struct ath10k_fw_stats which is used to
> > detect if extended stats are used. Would that work? Please note that I
> > have only compile tested the patch.

[shafi] thanks for taking time to do this, the change looks fine to me !
since 'ath10k_sta_update_rx_duration' is called right after 'ath10k_wmi_pull_fw_stats'
this should properly update the rx_duration based on the current data

> 
> Here's a diff of what I did:
> 
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 58932c09efc5..b734345ab598 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -180,7 +180,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>  			.board = QCA99X0_HW_2_0_BOARD_DATA_FILE,
>  			.board_size = QCA99X0_BOARD_DATA_SZ,
>  			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
> -			.extd_peer_stats = true,
>  		},
>  	},
>  	{
> @@ -203,7 +202,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>  			.board = QCA9984_HW_1_0_BOARD_DATA_FILE,
>  			.board_size = QCA99X0_BOARD_DATA_SZ,
>  			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
> -			.extd_peer_stats = true,
>  		},
>  	},
>  	{
> @@ -261,7 +259,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>  			.board = QCA4019_HW_1_0_BOARD_DATA_FILE,
>  			.board_size = QCA4019_BOARD_DATA_SZ,
>  			.board_ext_size = QCA4019_BOARD_EXT_DATA_SZ,
> -			.extd_peer_stats = true,
>  		},
>  	},
>  };
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 73a0b1ae1559..3707d8a707a2 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -263,6 +263,7 @@ struct ath10k_fw_stats_pdev {
>  };
>  
>  struct ath10k_fw_stats {
> +	bool extended;
>  	struct list_head pdevs;
>  	struct list_head vdevs;
>  	struct list_head peers;
> @@ -754,7 +755,6 @@ struct ath10k {
>  			const char *board;
>  			size_t board_size;
>  			size_t board_ext_size;
> -			bool extd_peer_stats;
>  		} fw;
>  	} hw_params;
>  
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index 001c0a144614..355e1ae665f9 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -327,6 +327,7 @@ static void ath10k_debug_fw_stats_reset(struct ath10k *ar)
>  {
>  	spin_lock_bh(&ar->data_lock);
>  	ar->debug.fw_stats_done = false;
> +	ar->debug.fw_stats.extended = false;
>  	ath10k_fw_stats_pdevs_free(&ar->debug.fw_stats.pdevs);
>  	ath10k_fw_stats_vdevs_free(&ar->debug.fw_stats.vdevs);
>  	ath10k_fw_stats_peers_free(&ar->debug.fw_stats.peers);
> diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
> index af3d49af9eab..0da8a57e0ba7 100644
> --- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
> +++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
> @@ -19,14 +19,14 @@
>  #include "debug.h"
>  
>  static void ath10k_sta_update_extd_stats_rx_duration(struct ath10k *ar,
> -						     struct list_head *head)
> +						     struct ath10k_fw_stats *stats)
>  {
> -	struct ieee80211_sta *sta;
>  	struct ath10k_fw_extd_stats_peer *peer;
> +	struct ieee80211_sta *sta;
>  	struct ath10k_sta *arsta;
>  
>  	rcu_read_lock();
> -	list_for_each_entry(peer, head, list) {
> +	list_for_each_entry(peer, &stats->peers_extd, list) {
>  		sta = ieee80211_find_sta_by_ifaddr(ar->hw, peer->peer_macaddr,
>  						   NULL);
>  		if (!sta)
> @@ -38,13 +38,14 @@ static void ath10k_sta_update_extd_stats_rx_duration(struct ath10k *ar,
>  }
>  
>  static void ath10k_sta_update_stats_rx_duration(struct ath10k *ar,
> -						struct list_head *head)
> -{	struct ieee80211_sta *sta;
> +						struct ath10k_fw_stats *stats)
> +{
>  	struct ath10k_fw_stats_peer *peer;
> +	struct ieee80211_sta *sta;
>  	struct ath10k_sta *arsta;
>  
>  	rcu_read_lock();
> -	list_for_each_entry(peer, head, list) {
> +	list_for_each_entry(peer, &stats->peers, list) {
>  		sta = ieee80211_find_sta_by_ifaddr(ar->hw, peer->peer_macaddr,
>  						   NULL);
>  		if (!sta)
> @@ -58,11 +59,10 @@ static void ath10k_sta_update_stats_rx_duration(struct ath10k *ar,
>  void ath10k_sta_update_rx_duration(struct ath10k *ar,
>  				   struct ath10k_fw_stats *stats)
>  {
> -	if (ar->hw_params.fw.extd_peer_stats)
> -		ath10k_sta_update_stats_rx_duration(ar, &stats->peers);
> +	if (stats->extended)
> +		ath10k_sta_update_extd_stats_rx_duration(ar, stats);
>  	else
> -		ath10k_sta_update_extd_stats_rx_duration(ar,
> -							 &stats->peers_extd);
> +		ath10k_sta_update_stats_rx_duration(ar, stats);
>  }
>  
>  static ssize_t ath10k_dbg_sta_read_aggr_mode(struct file *file,
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 5f2d423b1c33..16bd79716a6c 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -3008,6 +3008,8 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
>  	if ((stats_id & WMI_10_4_STAT_PEER_EXTD) == 0)
>  		return 0;
>  
> +	stats->extended = true;
> +
>  	for (i = 0; i < num_peer_stats; i++) {
>  		const struct wmi_10_4_peer_extd_stats *src;
>  		struct ath10k_fw_extd_stats_peer *dst;
> 
> 
> -- 
> Kalle Valo

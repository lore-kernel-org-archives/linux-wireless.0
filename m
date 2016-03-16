Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57009 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbcCPMw7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 08:52:59 -0400
Date: Wed, 16 Mar 2016 18:22:19 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Cc: ath10k@lists.infradead.org, Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5] ath10k: Enable debugfs provision to enable Peer Stats
 feature
Message-ID: <20160316125219.GA7889@atheros-ThinkPad-T61> (sfid-20160316_135302_424343_6507E78D)
References: <1456501770-20986-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456501770-20986-1-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

I had resent this change (to avoid any confusions with compilation issues)
as a part of the below series
[PATCH v1 1/3] ath10k: Enable debugfs provision to enable Peer Stats feature
[PATCH v1 2/3] ath10k: Introduce Extended Resource Config support
 for 10.4
[PATCH v1 3/3] ath10k: Enable parsing per station rx duration for
  10.4

Please let me know if there are any issues.

thanks,
shafi

On Fri, Feb 26, 2016 at 09:19:30PM +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Provide a debugfs entry to enable/ disable Peer Stats feature.
> Peer Stats feature is for developers/users who are more interested
> in studying in Rx/Tx stats with multiple clients connected, hence
> disable this by default. Enabling this feature by default results
> in unneccessary processing of Peer Stats event for every 500ms
> and updating peer_stats list (allocating memory) and cleaning it up
> ifexceeds the higher limit and this can be an unnecessary overhead
> during long run stress testing.
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> ---
> Dependencies:-
> 
> [PATCH] ath10k: Reduce number of peers to support peer stats feature
> (in upstream review)
> 
>   ath10k: Fix updating peer stats rx duration (in upstream review)
>   ath10k: Fix pointless update of peer stats list (in upstream review)
> 
>  drivers/net/wireless/ath/ath10k/core.c  |    2 +-
>  drivers/net/wireless/ath/ath10k/core.h  |   12 +++++
>  drivers/net/wireless/ath/ath10k/debug.c |   80 +++++++++++++++++++++++++++++--
>  drivers/net/wireless/ath/ath10k/mac.c   |    2 +-
>  drivers/net/wireless/ath/ath10k/wmi.c   |   12 ++---
>  5 files changed, 94 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index c84c2d3..c4c31b2 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1509,7 +1509,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
>  	case ATH10K_FW_WMI_OP_VERSION_10_1:
>  	case ATH10K_FW_WMI_OP_VERSION_10_2:
>  	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
> -		if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map)) {
> +		if (ath10k_peer_stats_enabled(ar)) {
>  			ar->max_num_peers = TARGET_10X_TX_STATS_NUM_PEERS;
>  			ar->max_num_stations = TARGET_10X_TX_STATS_NUM_STATIONS;
>  		} else {
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index a62b62a..cebf22c 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -549,6 +549,9 @@ enum ath10k_dev_flags {
>  
>  	/* Bluetooth coexistance enabled */
>  	ATH10K_FLAG_BTCOEX,
> +
> +	/* Per Station statistics service */
> +	ATH10K_FLAG_PEER_STATS,
>  };
>  
>  enum ath10k_cal_mode {
> @@ -876,6 +879,15 @@ struct ath10k {
>  	u8 drv_priv[0] __aligned(sizeof(void *));
>  };
>  
> +static inline bool ath10k_peer_stats_enabled(struct ath10k *ar)
> +{
> +	if (test_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags) &&
> +	    test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map))
> +		return true;
> +
> +	return false;
> +}
> +
>  struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
>  				  enum ath10k_bus bus,
>  				  enum ath10k_hw_rev hw_rev,
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index 06581fa..406e8bc 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -319,7 +319,7 @@ static void ath10k_debug_fw_stats_reset(struct ath10k *ar)
>  void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
>  {
>  	struct ath10k_fw_stats stats = {};
> -	bool is_start, is_started, is_end, peer_stats_svc;
> +	bool is_start, is_started, is_end;
>  	size_t num_peers;
>  	size_t num_vdevs;
>  	int ret;
> @@ -346,13 +346,11 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
>  	 *  b) consume stat update events until another one with pdev stats is
>  	 *     delivered which is treated as end-of-data and is itself discarded
>  	 */
> -
> -	peer_stats_svc = test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map);
> -	if (peer_stats_svc)
> +	if (ath10k_peer_stats_enabled(ar))
>  		ath10k_sta_update_rx_duration(ar, &stats.peers);
>  
>  	if (ar->debug.fw_stats_done) {
> -		if (!peer_stats_svc)
> +		if (!ath10k_peer_stats_enabled(ar))
>  			ath10k_warn(ar, "received unsolicited stats update event\n");
>  
>  		goto free;
> @@ -2169,6 +2167,73 @@ static const struct file_operations fops_btcoex = {
>  	.open = simple_open
>  };
>  
> +static ssize_t ath10k_write_peer_stats(struct file *file,
> +				       const char __user *ubuf,
> +				       size_t count, loff_t *ppos)
> +{
> +	struct ath10k *ar = file->private_data;
> +	char buf[32];
> +	size_t buf_size;
> +	int ret = 0;
> +	bool val;
> +
> +	buf_size = min(count, (sizeof(buf) - 1));
> +	if (copy_from_user(buf, ubuf, buf_size))
> +		return -EFAULT;
> +
> +	buf[buf_size] = '\0';
> +
> +	if (strtobool(buf, &val) != 0)
> +		return -EINVAL;
> +
> +	mutex_lock(&ar->conf_mutex);
> +
> +	if (ar->state != ATH10K_STATE_ON &&
> +	    ar->state != ATH10K_STATE_RESTARTED) {
> +		ret = -ENETDOWN;
> +		goto exit;
> +	}
> +
> +	if (!(test_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags) ^ val))
> +		goto exit;
> +
> +	if (val)
> +		set_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags);
> +	else
> +		clear_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags);
> +
> +	ath10k_info(ar, "restarting firmware due to Peer stats change");
> +
> +	queue_work(ar->workqueue, &ar->restart_work);
> +	ret = count;
> +
> +exit:
> +	mutex_unlock(&ar->conf_mutex);
> +	return ret;
> +}
> +
> +static ssize_t ath10k_read_peer_stats(struct file *file, char __user *ubuf,
> +				      size_t count, loff_t *ppos)
> +
> +{
> +	char buf[32];
> +	struct ath10k *ar = file->private_data;
> +	int len = 0;
> +
> +	mutex_lock(&ar->conf_mutex);
> +	len = scnprintf(buf, sizeof(buf) - len, "%d\n",
> +			test_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags));
> +	mutex_unlock(&ar->conf_mutex);
> +
> +	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
> +}
> +
> +static const struct file_operations fops_peer_stats = {
> +	.read = ath10k_read_peer_stats,
> +	.write = ath10k_write_peer_stats,
> +	.open = simple_open
> +};
> +
>  static ssize_t ath10k_debug_fw_checksums_read(struct file *file,
>  					      char __user *user_buf,
>  					      size_t count, loff_t *ppos)
> @@ -2335,6 +2400,11 @@ int ath10k_debug_register(struct ath10k *ar)
>  		debugfs_create_file("btcoex", S_IRUGO | S_IWUSR,
>  				    ar->debug.debugfs_phy, ar, &fops_btcoex);
>  
> +	if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map))
> +		debugfs_create_file("peer_stats", S_IRUGO | S_IWUSR,
> +				    ar->debug.debugfs_phy, ar,
> +				    &fops_peer_stats);
> +
>  	debugfs_create_file("fw_checksums", S_IRUSR,
>  			    ar->debug.debugfs_phy, ar, &fops_fw_checksums);
>  
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 96e2f8a..d5ef201 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4100,7 +4100,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
>  
>  	ar->ani_enabled = true;
>  
> -	if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map)) {
> +	if (ath10k_peer_stats_enabled(ar)) {
>  		param = ar->wmi.pdev_param->peer_stats_update_period;
>  		ret = ath10k_wmi_pdev_set_param(ar, param,
>  						PEER_DEFAULT_STATS_UPDATE_PERIOD);
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 7026138..ef390ae 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -2865,11 +2865,8 @@ static int ath10k_wmi_10_2_4_op_pull_fw_stats(struct ath10k *ar,
>  		const struct wmi_10_2_4_ext_peer_stats *src;
>  		struct ath10k_fw_stats_peer *dst;
>  		int stats_len;
> -		bool ext_peer_stats_support;
>  
> -		ext_peer_stats_support = test_bit(WMI_SERVICE_PEER_STATS,
> -						  ar->wmi.svc_map);
> -		if (ext_peer_stats_support)
> +		if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map))
>  			stats_len = sizeof(struct wmi_10_2_4_ext_peer_stats);
>  		else
>  			stats_len = sizeof(struct wmi_10_2_4_peer_stats);
> @@ -2886,7 +2883,7 @@ static int ath10k_wmi_10_2_4_op_pull_fw_stats(struct ath10k *ar,
>  
>  		dst->peer_rx_rate = __le32_to_cpu(src->common.peer_rx_rate);
>  
> -		if (ext_peer_stats_support)
> +		if (ath10k_peer_stats_enabled(ar))
>  			dst->rx_duration = __le32_to_cpu(src->rx_duration);
>  		/* FIXME: expose 10.2 specific values */
>  
> @@ -5517,7 +5514,8 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
>  
>  	config.num_vdevs = __cpu_to_le32(TARGET_10X_NUM_VDEVS);
>  	config.num_peer_keys = __cpu_to_le32(TARGET_10X_NUM_PEER_KEYS);
> -	if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map)) {
> +
> +	if (ath10k_peer_stats_enabled(ar)) {
>  		config.num_peers = __cpu_to_le32(TARGET_10X_TX_STATS_NUM_PEERS);
>  		config.num_tids = __cpu_to_le32(TARGET_10X_TX_STATS_NUM_TIDS);
>  	} else {
> @@ -5579,7 +5577,7 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
>  	    test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
>  		features |= WMI_10_2_COEX_GPIO;
>  
> -	if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map))
> +	if (ath10k_peer_stats_enabled(ar))
>  		features |= WMI_10_2_PEER_STATS;
>  
>  	cmd->resource_config.feature_mask = __cpu_to_le32(features);
> -- 
> 1.7.9.5
> 

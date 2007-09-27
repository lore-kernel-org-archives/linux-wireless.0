Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:32394 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbXI0Ehy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 00:37:54 -0400
Date: Wed, 26 Sep 2007 21:35:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH] iwlwifi: set fixed rate through debugfs
Message-Id: <20070926213517.042008a9.randy.dunlap@oracle.com>
In-Reply-To: <11908636823439-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
	<11908636662994-git-send-email-yi.zhu@intel.com>
	<11908636683204-git-send-email-yi.zhu@intel.com>
	<11908636692415-git-send-email-yi.zhu@intel.com>
	<119086367088-git-send-email-yi.zhu@intel.com>
	<11908636712746-git-send-email-yi.zhu@intel.com>
	<11908636732679-git-send-email-yi.zhu@intel.com>
	<11908636743625-git-send-email-yi.zhu@intel.com>
	<11908636753775-git-send-email-yi.zhu@intel.com>
	<11908636772860-git-send-email-yi.zhu@intel.com>
	<11908636781043-git-send-email-yi.zhu@intel.com>
	<1190863679136-git-send-email-yi.zhu@intel.com>
	<11908636801368-git-send-email-yi.zhu@intel.com>
	<11908636823439-git-send-email-yi.zhu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 27 Sep 2007 11:27:42 +0800 Zhu Yi wrote:

> This patch adds fixed rate setting through debugfs

Is this just for developer/tester debug use, not for normal use?


> $ echo <rate_n_flags> > \
> /sys/kernel/debug/ieee80211/phy<X>/stations/<mac>/rate_scale_table
> 
> Currently there is no way to turn to rate scaling working again.
> Will be fixed in later.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   72 +++++++++++++++++++++++++++-
>  1 files changed, 70 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> index c4b8ca1..e5f8cce 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> @@ -123,7 +123,9 @@ struct iwl_rate_scale_priv {
>  	struct iwl_link_quality_cmd lq;
>  	struct iwl_scale_tbl_info lq_info[LQ_SIZE];
>  #ifdef CONFIG_MAC80211_DEBUGFS
> -       struct dentry *rs_sta_dbgfs_scale_table_file;
> +	struct dentry *rs_sta_dbgfs_scale_table_file;
> +	struct iwl_rate dbg_fixed;
> +	struct iwl_priv *drv;
>  #endif
>  };
>  
> @@ -136,6 +138,14 @@ static void rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
>  			     struct iwl_link_quality_cmd *tbl);
>  
>  
> +#ifdef CONFIG_MAC80211_DEBUGFS
> +static void rs_dbgfs_set_mcs(struct iwl_rate_scale_priv *rs_priv,
> +				struct iwl_rate *mcs, int index);
> +#else
> +static void rs_dbgfs_set_mcs(struct iwl_rate_scale_priv *rs_priv,
> +				struct iwl_rate *mcs, int index)
> +{}
> +#endif
>  static s32 expected_tpt_A[IWL_RATE_COUNT] = {
>  	0, 0, 0, 0, 40, 57, 72, 98, 121, 154, 177, 186, 186
>  };
> @@ -1866,6 +1876,9 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
>  	IWL_DEBUG_HT("MIMO RATE 0x%X SISO MASK 0x%X\n", crl->active_siso_rate,
>  		     crl->active_mimo_rate);
>  #endif /*CONFIG_IWLWIFI_HT*/
> +#ifdef CONFIG_MAC80211_DEBUGFS
> +	crl->drv = priv;
> +#endif
>  
>  	if (priv->assoc_station_added)
>  		priv->lq_mngr.lq_ready = 1;
> @@ -1885,6 +1898,8 @@ static void rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
>  	struct iwl_rate new_rate;
>  	struct iwl_scale_tbl_info tbl_type = { 0 };
>  
> +	rs_dbgfs_set_mcs(lq_data, tx_mcs, index);
> +
>  	rs_get_tbl_info_from_mcs(tx_mcs, lq_data->phymode,
>  				  &tbl_type, &rate_idx);
>  
> @@ -1919,6 +1934,8 @@ static void rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
>  					ant_toggle_count = 1;
>  				}
>  			}
> +
> +			rs_dbgfs_set_mcs(lq_data, &new_rate, index);
>  			lq_cmd->rs_table[index].rate_n_flags =
>  					cpu_to_le32(new_rate.rate_n_flags);
>  			repeat_rate--;
> @@ -1947,6 +1964,7 @@ static void rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
>  
>  		use_ht_possible = 0;
>  
> +		rs_dbgfs_set_mcs(lq_data, &new_rate, index);
>  		lq_cmd->rs_table[index].rate_n_flags =
>  				cpu_to_le32(new_rate.rate_n_flags);
>  
> @@ -2002,7 +2020,54 @@ static int open_file_generic(struct inode *inode, struct file *file)
>  	file->private_data = inode->i_private;
>  	return 0;
>  }
> +static void rs_dbgfs_set_mcs(struct iwl_rate_scale_priv *rs_priv,
> +				struct iwl_rate *mcs, int index)
> +{
> +	const u32 cck_rate = 0x820A;
> +	if (rs_priv->dbg_fixed.rate_n_flags) {
> +		if (index < 12)
> +			mcs->rate_n_flags = rs_priv->dbg_fixed.rate_n_flags;
> +		else
> +			mcs->rate_n_flags = cck_rate;
> +		IWL_DEBUG_RATE("Fixed rate ON\n");
> +		return;
> +	}
> +
> +	IWL_DEBUG_RATE("Fixed rate OFF\n");
> +}
>  
> +static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
> +			const char __user *user_buf, size_t count, loff_t *ppos)
> +{
> +	struct iwl_rate_scale_priv *rs_priv = file->private_data;
> +	char buf[64];
> +	int buf_size;
> +	u32 parsed_rate;
> +
> +	memset(buf, 0, sizeof(buf));
> +	buf_size = min(count, sizeof(buf) -  1);
> +	if (copy_from_user(buf, user_buf, buf_size))
> +		return -EFAULT;
> +
> +	if (sscanf(buf, "%x", &parsed_rate) == 1)
> +		rs_priv->dbg_fixed.rate_n_flags = parsed_rate;
> +	else
> +		rs_priv->dbg_fixed.rate_n_flags = 0;
> +
> +	rs_priv->active_rate = 0x0FFF;
> +	rs_priv->active_siso_rate = 0x1FD0;
> +	rs_priv->active_mimo_rate = 0x1FD0;
> +
> +	IWL_DEBUG_RATE("sta_id %d rate 0x%X\n",
> +		rs_priv->lq.sta_id, rs_priv->dbg_fixed.rate_n_flags);
> +
> +	if (rs_priv->dbg_fixed.rate_n_flags) {
> +		rs_fill_link_cmd(rs_priv, &rs_priv->dbg_fixed, &rs_priv->lq);
> +		rs_send_lq_cmd(rs_priv->drv, &rs_priv->lq, CMD_ASYNC);
> +	}
> +
> +	return count;
> +}
>  static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
>  			char __user *user_buf, size_t count, loff_t *ppos)
>  {
> @@ -2013,9 +2078,11 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
>  	struct iwl_rate_scale_priv *rs_priv = file->private_data;
>  
>  	desc += sprintf(buff+desc, "sta_id %d\n", rs_priv->lq.sta_id);
> -	desc += sprintf(buff+desc, "failed=%d success=%d rate=%X\n",
> +	desc += sprintf(buff+desc, "failed=%d success=%d rate=0%X\n",
>  			rs_priv->total_failed, rs_priv->total_success,
>  			rs_priv->active_rate);
> +	desc += sprintf(buff+desc, "fixed rate 0x%X\n",
> +			rs_priv->dbg_fixed.rate_n_flags);
>  	desc += sprintf(buff+desc, "general:"
>  		"flags=0x%X mimo-d=%d s-ant0x%x d-ant=0x%x\n",
>  		rs_priv->lq.general_params.flags,
> @@ -2045,6 +2112,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
>  }
>  
>  static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
> +	.write = rs_sta_dbgfs_scale_table_write,
>  	.read = rs_sta_dbgfs_scale_table_read,
>  	.open = open_file_generic,
>  };
> -- 
> 1.5.1
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


---
~Randy
Phaedrus says that Quality is about caring.

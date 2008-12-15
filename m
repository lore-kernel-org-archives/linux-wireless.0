Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45641 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbYLOPYf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 10:24:35 -0500
Subject: Re: [PATCH 1/2] iwlwifi: misc cleanups.
From: Dan Williams <dcbw@redhat.com>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	reinette.chatre@intel.com
In-Reply-To: <eb3ff54b0812142300w211f08ek51dc24de85e7c85@mail.gmail.com>
References: <eb3ff54b0812142300w211f08ek51dc24de85e7c85@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 10:23:37 -0500
Message-Id: <1229354617.12163.26.camel@localhost.localdomain> (sfid-20081215_162439_526238_A5EC2E98)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-15 at 09:00 +0200, Rami Rosen wrote:
> This patch removes unused parameters in methods in iwl-tx.c:
> 
> - remove a parameter (is_unicast) from iwl_tx_cmd_build_basic()
> - remove a parameter (sta_id) from iwl_tx_cmd_build_rate()
> - remove two parameters (sta_id and priv) from iwl_tx_cmd_build_hwcrypto()
> 
> (wireless-testing).
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c
> b/drivers/net/wireless/iwlwifi/iwl-tx.c
> index 3cb4363..ffede8b 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-tx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
> @@ -645,7 +645,7 @@ static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
>  				  struct iwl_tx_cmd *tx_cmd,
>  				  struct ieee80211_tx_info *info,
>  				  struct ieee80211_hdr *hdr,
> -				  int is_unicast, u8 std_id)
> +				  u8 std_id)
>  {
>  	__le16 fc = hdr->frame_control;
>  	__le32 tx_flags = tx_cmd->tx_flags;
> @@ -705,7 +705,7 @@ static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
>  static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
>  			      struct iwl_tx_cmd *tx_cmd,
>  			      struct ieee80211_tx_info *info,
> -			      __le16 fc, int sta_id,
> +			      __le16 fc,
>  			      int is_hcca)
>  {
>  	u32 rate_flags = 0;
> @@ -764,11 +764,10 @@ static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
>  	tx_cmd->rate_n_flags = iwl_hw_set_rate_n_flags(rate_plcp, rate_flags);
>  }
> 
> -static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
> -				      struct ieee80211_tx_info *info,
> +static void iwl_tx_cmd_build_hwcrypto(struct ieee80211_tx_info *info,
>  				      struct iwl_tx_cmd *tx_cmd,
> -				      struct sk_buff *skb_frag,
> -				      int sta_id)
> +				      struct sk_buff *skb_frag)
> +				

^^^ inserted whitespace

>  {
>  	struct ieee80211_key_conf *keyconf = info->control.hw_key;
> 
> @@ -834,7 +833,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
>  	u16 len, len_org;
>  	u16 seq_number = 0;
>  	__le16 fc;
> -	u8 hdr_len, unicast;
> +	u8 hdr_len;
>  	u8 sta_id;
>  	u8 wait_write_ptr = 0;
>  	u8 tid = 0;
> @@ -854,8 +853,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
>  		goto drop_unlock;
>  	}
> 
> -	unicast = !is_multicast_ether_addr(hdr->addr1);
> -
> +	
>  	fc = hdr->frame_control;
> 
>  #ifdef CONFIG_IWLWIFI_DEBUG
> @@ -977,7 +975,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
>  	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
> 
>  	if (info->control.hw_key)
> -		iwl_tx_cmd_build_hwcrypto(priv, info, tx_cmd, skb, sta_id);
> +		iwl_tx_cmd_build_hwcrypto(info, tx_cmd, skb);
> 
>  	/* Set up TFD's 2nd entry to point directly to remainder of skb,
>  	 * if any (802.11 null frames have no payload). */
> @@ -996,10 +994,10 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
>  	len = (u16)skb->len;
>  	tx_cmd->len = cpu_to_le16(len);
>  	/* TODO need this for burst mode later on */
> -	iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, unicast, sta_id);
> +	iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, sta_id);
> 
>  	/* set is_hcca to 0; it probably will never be implemented */
> -	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, sta_id, 0);
> +	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, 0);
> 
>  	iwl_update_tx_stats(priv, le16_to_cpu(fc), len);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


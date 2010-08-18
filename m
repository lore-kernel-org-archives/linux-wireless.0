Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36612 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab0HRVOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 17:14:41 -0400
Date: Wed, 18 Aug 2010 17:03:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath9k_common: Move bt_stomp to common for sharing
 with ath9k_htc.
Message-ID: <20100818210320.GC2793@tuxdriver.com>
References: <1282141669-9823-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1282141669-9823-1-git-send-email-vnatarajan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 18, 2010 at 07:57:48PM +0530, Vivek Natarajan wrote:
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/common.h |   11 ++++++++

> diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
> index 97809d3..fcc3f9a 100644
> --- a/drivers/net/wireless/ath/ath9k/common.h
> +++ b/drivers/net/wireless/ath/ath9k/common.h
> @@ -52,6 +52,14 @@
>  #define ATH_EP_RND(x, mul) 						\
>  	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
>  
> +/* Defines the BT AR_BT_COEX_WGHT used */
> +enum ath_stomp_type {
> +	ATH_BTCOEX_NO_STOMP,
> +	ATH_BTCOEX_STOMP_ALL,
> +	ATH_BTCOEX_STOMP_LOW,
> +	ATH_BTCOEX_STOMP_NONE
> +};
> +
>  int ath9k_cmn_padpos(__le16 frame_control);
>  int ath9k_cmn_get_hw_crypto_keytype(struct sk_buff *skb);
>  void ath9k_cmn_update_ichannel(struct ieee80211_hw *hw,
> @@ -65,3 +73,6 @@ int ath9k_cmn_key_config(struct ath_common *common,
>  void ath9k_cmn_key_delete(struct ath_common *common,
>  			  struct ieee80211_key_conf *key);
>  int ath9k_cmn_count_streams(unsigned int chainmask, int max);
> +void ath9k_cmn_btcoex_bt_stomp(struct ath_common *common,
> +				  enum ath_stomp_type stomp_type);
> +

Please don't add blank lines at the ends of files...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

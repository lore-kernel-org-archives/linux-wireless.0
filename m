Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab2E3JfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 05:35:11 -0400
Message-ID: <1338370507.4511.10.camel@jlt3.sipsolutions.net> (sfid-20120530_113516_972634_DBB11FA5)
Subject: Re: [PATCH v3] mac80211: add op to configure default key id
From: Johannes Berg <johannes@sipsolutions.net>
To: Yoni Divinsky <yoni.divinsky@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 30 May 2012 11:35:07 +0200
In-Reply-To: <1338366999-5268-1-git-send-email-yoni.divinsky@ti.com>
References: <1338366999-5268-1-git-send-email-yoni.divinsky@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-30 at 11:36 +0300, Yoni Divinsky wrote:
> There are hardwares which support offload of data packets
> for example when auto ARP is enabled the hw will send
> the ARP response. In such cases if WEP encryption is
> configured the hw must know the default WEP key in order
> to encrypt the packets correctly.
> 
> When hw_accel is enabled and encryption type is set to WEP,
> the driver should get the default key index from mac80211.
> 
> Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
> ---
> 
> v2 to v3:
> 	removed the return value of set_default_key_idx op
>         since it should not fail at this point.
> 
>  include/net/mac80211.h      |    7 ++++++-
>  net/mac80211/driver-ops.h   |   14 ++++++++++++++
>  net/mac80211/driver-trace.h |   24 ++++++++++++++++++++++++
>  net/mac80211/key.c          |    2 ++
>  4 files changed, 46 insertions(+), 1 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 4d6e6c6..aecdca7 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1427,6 +1427,10 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
>   * rekeying), it will not include a valid phase 1 key. The valid phase 1 key is
>   * provided by update_tkip_key only. The trigger that makes mac80211 call this
>   * handler is software decryption with wrap around of iv16.
> + *
> + * The set_default_key_idx() call updates the default WEP key index configured
> + * to the hardware for WEP encryption type. This is required for hw which
> + * supports offload of data packets (i.e. auto ARP respones).
>   */
>  
>  /**
> @@ -2361,7 +2365,6 @@ struct ieee80211_ops {
>  					u16 tids, int num_frames,
>  					enum ieee80211_frame_release_type reason,
>  					bool more_data);
> -
>  	int	(*get_et_sset_count)(struct ieee80211_hw *hw,
>  				     struct ieee80211_vif *vif, int sset);
>  	void	(*get_et_stats)(struct ieee80211_hw *hw,

No need for this change

> @@ -2370,6 +2373,8 @@ struct ieee80211_ops {
>  	void	(*get_et_strings)(struct ieee80211_hw *hw,
>  				  struct ieee80211_vif *vif,
>  				  u32 sset, u8 *data);
> +	void (*set_default_key_idx)(struct ieee80211_hw *hw,
> +				    struct ieee80211_vif *vif, int idx);

Missing kernel-doc.

johannes


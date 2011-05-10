Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35707 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1EJTp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 15:45:58 -0400
Date: Tue, 10 May 2011 15:39:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	greearb@candelatech.com
Subject: Re: [PATCH 2.6.39] ath9k: fix a regression in PS frame filter
 handling
Message-ID: <20110510193914.GF2520@tuxdriver.com> (sfid-20110510_214611_323756_08E7C7DF)
References: <1304972747-11775-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1304972747-11775-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This doesn't seem to apply against wireless-2.6...

On Mon, May 09, 2011 at 10:25:47PM +0200, Felix Fietkau wrote:
> Only leave filtering enabled for AP or VLAN interfaces, clear the
> destination mask for all other interfaces.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Reported-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |    5 +++++
>  drivers/net/wireless/ath/ath9k/xmit.c |    6 +++++-
>  2 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 3de115d..3d999b7 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1778,6 +1778,11 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
>  	struct ieee80211_key_conf ps_key = { };
>  
>  	ath_node_attach(sc, sta);
> +
> +	if (vif->type != NL80211_IFTYPE_AP &&
> +	    vif->type != NL80211_IFTYPE_AP_VLAN)
> +		return 0;
> +
>  	an->ps_key = ath_key_config(common, vif, sta, &ps_key);
>  
>  	return 0;
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 744779d..ee71d38 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1795,6 +1795,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
>  	struct sk_buff *skb = bf->bf_mpdu;
>  	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> +	struct ieee80211_vif *vif = tx_info->control.vif;
>  	struct list_head bf_head;
>  	struct ath_atx_tid *tid = NULL;
>  	u8 tidno;
> @@ -1829,7 +1830,10 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
>  		if (txctl->paprd)
>  			bf->bf_state.bfs_paprd_timestamp = jiffies;
>  
> -		if (tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
> +		if ((vif && vif->type != NL80211_IFTYPE_AP &&
> +		            vif->type != NL80211_IFTYPE_AP_VLAN) ||
> +		    !ieee80211_is_data(hdr->frame_control) ||
> +		    (tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT))
>  			ath9k_hw_set_clrdmask(sc->sc_ah, bf->bf_desc, true);
>  
>  		ath_tx_send_normal(sc, txctl->txq, tid, &bf_head);
> -- 
> 1.7.3.2
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

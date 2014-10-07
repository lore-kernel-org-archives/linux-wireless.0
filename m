Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46832 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbaJGTAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 15:00:12 -0400
Date: Tue, 7 Oct 2014 14:50:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH v2 3/6] ath9k: Fix sequence number assignment
Message-ID: <20141007185005.GK25590@tuxdriver.com> (sfid-20141007_210018_375830_8B426EE0)
References: <1412657081-3202-1-git-send-email-sujith@msujith.org>
 <1412657081-3202-4-git-send-email-sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1412657081-3202-4-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmmm...am I missing something?

  CC      drivers/net/wireless/ath/ath9k/tx99.o
In file included from include/linux/byteorder/little_endian.h:4:0,
                 from ./arch/x86/include/uapi/asm/byteorder.h:4,
                 from include/asm-generic/bitops/le.h:5,
                 from ./arch/x86/include/asm/bitops.h:506,
                 from include/linux/bitops.h:33,
                 from include/linux/kernel.h:10,
                 from include/linux/skbuff.h:17,
                 from include/linux/if_ether.h:23,
                 from include/linux/etherdevice.h:25,
                 from drivers/net/wireless/ath/ath9k/ath9k.h:20,
                 from drivers/net/wireless/ath/ath9k/tx99.c:17:
drivers/net/wireless/ath/ath9k/tx99.c: In function ‘ath9k_build_tx99_skb’:
drivers/net/wireless/ath/ath9k/tx99.c:74:37: error: ‘struct ath_tx’ has no member named ‘seq_no’
  hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
                                     ^
include/uapi/linux/byteorder/little_endian.h:34:51: note: in definition of macro ‘__cpu_to_le16’
 #define __cpu_to_le16(x) ((__force __le16)(__u16)(x))
                                                   ^
drivers/net/wireless/ath/ath9k/tx99.c:74:19: note: in expansion of macro ‘cpu_to_le16’
  hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
                   ^
make[3]: *** [drivers/net/wireless/ath/ath9k/tx99.o] Error 1

On Tue, Oct 07, 2014 at 10:14:38AM +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Currently, ath9k uses a global counter for all
> frames that need to be assigned a sequence number.
> QoS-data frames are handled properly since they
> have a per-tid counter. But, beacons and other
> management frames use the same counter even if
> multiple interfaces or contexts are present.
> 
> Fix this issue by making the counter per-interface
> and using it when mac80211 sets IEEE80211_TX_CTL_ASSIGN_SEQ.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h  |  4 +++-
>  drivers/net/wireless/ath/ath9k/beacon.c | 12 ++----------
>  drivers/net/wireless/ath/ath9k/xmit.c   | 34 ++++++++++++++++++++++-----------
>  3 files changed, 28 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index bfa0b15..01a7db0 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -294,7 +294,6 @@ struct ath_tx_control {
>   *  (axq_qnum).
>   */
>  struct ath_tx {
> -	u16 seq_no;
>  	u32 txqsetup;
>  	spinlock_t txbuflock;
>  	struct list_head txbuf;
> @@ -563,6 +562,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs);
>  int ath_txq_update(struct ath_softc *sc, int qnum,
>  		   struct ath9k_tx_queue_info *q);
>  void ath_update_max_aggr_framelen(struct ath_softc *sc, int queue, int txop);
> +void ath_assign_seq(struct ath_common *common, struct sk_buff *skb);
>  int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
>  		 struct ath_tx_control *txctl);
>  void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> @@ -592,6 +592,8 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
>  struct ath_vif {
>  	struct list_head list;
>  
> +	u16 seq_no;
> +
>  	/* BSS info */
>  	u8 bssid[ETH_ALEN];
>  	u16 aid;
> diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
> index a6af855..ecb783b 100644
> --- a/drivers/net/wireless/ath/ath9k/beacon.c
> +++ b/drivers/net/wireless/ath/ath9k/beacon.c
> @@ -144,16 +144,8 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
>  	mgmt_hdr->u.beacon.timestamp = avp->tsf_adjust;
>  
>  	info = IEEE80211_SKB_CB(skb);
> -	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
> -		/*
> -		 * TODO: make sure the seq# gets assigned properly (vs. other
> -		 * TX frames)
> -		 */
> -		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> -		sc->tx.seq_no += 0x10;
> -		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> -		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
> -	}
> +
> +	ath_assign_seq(common, skb);
>  
>  	if (vif->p2p)
>  		ath9k_beacon_add_noa(sc, avp, skb);
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 151ae49..493a183 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -2139,6 +2139,28 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
>  	return bf;
>  }
>  
> +void ath_assign_seq(struct ath_common *common, struct sk_buff *skb)
> +{
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct ieee80211_vif *vif = info->control.vif;
> +	struct ath_vif *avp;
> +
> +	if (!(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
> +		return;
> +
> +	if (!vif)
> +		return;
> +
> +	avp = (struct ath_vif *)vif->drv_priv;
> +
> +	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
> +		avp->seq_no += 0x10;
> +
> +	hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> +	hdr->seq_ctrl |= cpu_to_le16(avp->seq_no);
> +}
> +
>  static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
>  			  struct ath_tx_control *txctl)
>  {
> @@ -2162,17 +2184,7 @@ static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
>  	if (info->control.hw_key)
>  		frmlen += info->control.hw_key->icv_len;
>  
> -	/*
> -	 * As a temporary workaround, assign seq# here; this will likely need
> -	 * to be cleaned up to work better with Beacon transmission and virtual
> -	 * BSSes.
> -	 */
> -	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
> -		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
> -			sc->tx.seq_no += 0x10;
> -		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> -		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
> -	}
> +	ath_assign_seq(ath9k_hw_common(sc->sc_ah), skb);
>  
>  	if ((vif && vif->type != NL80211_IFTYPE_AP &&
>  	            vif->type != NL80211_IFTYPE_AP_VLAN) ||
> -- 
> 2.1.2
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

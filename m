Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34841
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934134AbXCWTnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 15:43:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH v4] d80211: Add software sequence support
Date: Fri, 23 Mar 2007 20:42:52 +0100
Cc: Jiri Benc <jbenc@suse.cz>, "Linville"@poseidon.kernel.org,
	"John" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Jouni Malinen <jkmaline@cc.hut.fi>
References: <200703232021.29700.IvDoorn@gmail.com>
In-Reply-To: <200703232021.29700.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703232042.53005.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 March 2007 20:21, Ivo van Doorn wrote:
> Most hardware can keep track of sequence numbers themselves,
> unfortunately *most* doesn't cover all devices. ;)
> This patch will keep track of the (per-bss) sequence number
> if the flag IEEE80211_HW_SOFTWARE_SEQUENCE has been set.

You should update the description as well. ;)

> This 4rd version of the patch has some minor code style fixes
> as suggested by Jiri.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> ---
> 
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index e7a613d..c06d1ce 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -54,6 +54,16 @@ static u8 * ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len);
>  static int ieee80211_mgmt_start_xmit(struct sk_buff *skb,
>  				     struct net_device *dev);
>  
> +static inline void ieee80211_include_sequence(struct ieee80211_sub_if_data *sdata,
> +					      struct ieee80211_hdr *hdr)
> +{
> +	/* Set the sequence number for this frame. */
> +	hdr->seq_ctrl = cpu_to_le16(sdata->sequence);
> +
> +	/* Increase the sequence number. */
> +	sdata->sequence = (sdata->sequence + 0x10) & IEEE80211_SCTL_SEQ;
> +}
> +
>  struct ieee80211_key_conf *
>  ieee80211_key_data2conf(struct ieee80211_local *local,
>  			const struct ieee80211_key *data)
> @@ -445,6 +455,7 @@ ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
>  	size_t hdrlen, per_fragm, num_fragm, payload_len, left;
>  	struct sk_buff **frags, *first, *frag;
>  	int i;
> +	u16 seq;
>  	u8 *pos;
>  	int frag_threshold = tx->local->fragmentation_threshold;
>  
> @@ -463,6 +474,7 @@ ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
>  		goto fail;
>  
>  	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREFRAGS);
> +	seq = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ;
>  	pos = first->data + hdrlen + per_fragm;
>  	left = payload_len - per_fragm;
>  	for (i = 0; i < num_fragm - 1; i++) {
> @@ -490,7 +502,7 @@ ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
>  		memcpy(fhdr, first->data, hdrlen);
>  		if (i == num_fragm - 2)
>  			fhdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREFRAGS);
> -		fhdr->seq_ctrl = cpu_to_le16(i + 1);
> +		fhdr->seq_ctrl = cpu_to_le16(seq | ((i + 1) & IEEE80211_SCTL_FRAG));
>  		copylen = left > per_fragm ? per_fragm : left;
>  		memcpy(skb_put(frag, copylen), pos, copylen);
>  
> @@ -900,6 +912,16 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
>  	return TXRX_CONTINUE;
>  }
>  
> +static ieee80211_txrx_result
> +ieee80211_tx_h_sequence(struct ieee80211_txrx_data *tx)
> +{
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
> +
> +	if (ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control)) >= 24)
> +		ieee80211_include_sequence(tx->sdata, hdr);
> +
> +	return TXRX_CONTINUE;
> +}
>  
>  /* This function is called whenever the AP is about to exceed the maximum limit
>   * of buffered frames for power saving STAs. This situation should not really
> @@ -1770,6 +1792,8 @@ struct sk_buff * ieee80211_beacon_get(struct ieee80211_hw *hw, int if_id,
>  	skb_reserve(skb, local->hw.extra_tx_headroom);
>  	memcpy(skb_put(skb, bh_len), b_head, bh_len);
>  
> +	ieee80211_include_sequence(sdata, (struct ieee80211_hdr *)skb->data);
> +
>  	ieee80211_beacon_add_tim(local, ap, skb);
>  
>  	if (b_tail) {
> @@ -4381,6 +4405,7 @@ static ieee80211_rx_handler ieee80211_rx_handlers[] =
>  static ieee80211_tx_handler ieee80211_tx_handlers[] =
>  {
>  	ieee80211_tx_h_check_assoc,
> +	ieee80211_tx_h_sequence,
>  	ieee80211_tx_h_ps_buf,
>  	ieee80211_tx_h_select_key,
>  	ieee80211_tx_h_michael_mic_add,
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 9df8ef0..4b7c427 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -317,6 +317,8 @@ struct ieee80211_sub_if_data {
>  	int ieee802_1x; /* IEEE 802.1X PAE - drop packet to/from unauthorized
>  			 * port */
>  
> +	u16 sequence;
> +
>  	/* Fragment table for host-based reassembly */
>  	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
>  	unsigned int fragment_next;
> 
> 

-- 
Greetings Michael.

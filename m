Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:36636 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723Ab2KVTnS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:43:18 -0500
Message-ID: <50ADE0E3.2020909@neratec.com> (sfid-20121122_204331_265120_3282308A)
Date: Thu, 22 Nov 2012 09:22:59 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: support radiotap vendor namespace RX data
References: <1353061591-22284-1-git-send-email-johannes@sipsolutions.net>  <87ehjtygci.fsf@purkki.adurom.net> <1353063966.9490.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353063966.9490.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Shouldn't all functions between ieee80211_rx
and remove_monitor_info map header with
(struct ieee80211_hdr *)(skb->data + status->vendor_radiotap_len) ?

Otherwise function like should_drop_frame uses header mapped over
potential vendor data.

Wojtek
> From: Johannes Berg <johannes.berg@intel.com>
>
> In some cases, in particular for experimentation, it
> can be useful to be able to add vendor namespace data
> to received frames in addition to the normal radiotap
> data.
>
> Allow doing this through mac80211 by adding fields to
> the RX status descriptor that describe the data while
> the data itself is prepended to the frame.
>
> Also add some example code to hwsim, but don't enable
> it because it doesn't use a proper OUI identifier.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   drivers/net/wireless/mac80211_hwsim.c | 33 +++++++++++++++-
>   include/net/mac80211.h                | 12 ++++++
>   net/mac80211/rx.c                     | 71 +++++++++++++++++++++++++++++------
>   3 files changed, 103 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 23a3e74..e60a878 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -751,7 +751,11 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
>   				continue;
>   		}
>   
> -		nskb = skb_copy(skb, GFP_ATOMIC);
> +		/*
> +		 * reserve some space for our vendor and the normal
> +		 * radiotap header, since we're copying anyway
> +		 */
> +		nskb = skb_copy_expand(skb, 64, 0, GFP_ATOMIC);
>   		if (nskb == NULL)
>   			continue;
>   
> @@ -769,6 +773,33 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
>   				(data->tsf_offset - data2->tsf_offset) +
>   				24 * 8 * 10 / txrate->bitrate);
>   
> +#if 0
> +		/*
> +		 * Don't enable this code by default as the OUI 00:00:00
> +		 * is registered to Xerox so we shouldn't use it here, it
> +		 * might find its way into pcap files.
> +		 * Note that this code requires the headroom in the SKB
> +		 * that was allocated earlier.
> +		 */
> +		rx_status.vendor_radiotap_oui[0] = 0x00;
> +		rx_status.vendor_radiotap_oui[1] = 0x00;
> +		rx_status.vendor_radiotap_oui[2] = 0x00;
> +		rx_status.vendor_radiotap_subns = 127;
> +		/*
> +		 * Radiotap vendor namespaces can (and should) also be
> +		 * split into fields by using the standard radiotap
> +		 * presence bitmap mechanism. Use just BIT(0) here for
> +		 * the presence bitmap.
> +		 */
> +		rx_status.vendor_radiotap_bitmap = BIT(0);
> +		/* We have 8 bytes of (dummy) data */
> +		rx_status.vendor_radiotap_len = 8;
> +		/* For testing, also require it to be aligned */
> +		rx_status.vendor_radiotap_align = 8;
> +		/* push the data */
> +		memcpy(skb_push(nskb, 8), "ABCDEFGH", 8);
> +#endif
> +
>   		memcpy(IEEE80211_SKB_RXCB(nskb), &rx_status, sizeof(rx_status));
>   		ieee80211_rx_irqsafe(data2->hw, nskb);
>   	}
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 1bec63e..fde8a99 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -825,12 +825,21 @@ enum mac80211_rx_flags {
>    * @ampdu_reference: A-MPDU reference number, must be a different value for
>    *	each A-MPDU but the same for each subframe within one A-MPDU
>    * @ampdu_delimiter_crc: A-MPDU delimiter CRC
> + * @vendor_radiotap_bitmap: radiotap vendor namespace presence bitmap
> + * @vendor_radiotap_len: radiotap vendor namespace length
> + * @vendor_radiotap_align: radiotap vendor namespace alignment. Note
> + *	that the actual data must be at the start of the SKB data
> + *	already.
> + * @vendor_radiotap_oui: radiotap vendor namespace OUI
> + * @vendor_radiotap_subns: radiotap vendor sub namespace
>    */
>   struct ieee80211_rx_status {
>   	u64 mactime;
>   	u32 device_timestamp;
>   	u32 ampdu_reference;
>   	u32 flag;
> +	u32 vendor_radiotap_bitmap;
> +	u16 vendor_radiotap_len;
>   	u16 freq;
>   	u8 rate_idx;
>   	u8 vht_nss;
> @@ -839,6 +848,9 @@ struct ieee80211_rx_status {
>   	u8 antenna;
>   	s8 signal;
>   	u8 ampdu_delimiter_crc;
> +	u8 vendor_radiotap_align;
> +	u8 vendor_radiotap_oui[3];
> +	u8 vendor_radiotap_subns;
>   };
>   
>   /**
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 51c9a9f..5d12c02 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -40,6 +40,8 @@
>   static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
>   					   struct sk_buff *skb)
>   {
> +	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
> +
>   	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS) {
>   		if (likely(skb->len > FCS_LEN))
>   			__pskb_trim(skb, skb->len - FCS_LEN);
> @@ -51,6 +53,9 @@ static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
>   		}
>   	}
>   
> +	if (status->vendor_radiotap_len)
> +		__pskb_pull(skb, status->vendor_radiotap_len);
> +
>   	return skb;
>   }
>   
> @@ -73,32 +78,48 @@ static inline int should_drop_frame(struct sk_buff *skb, int present_fcs_len)
>   }
>   
>   static int
> -ieee80211_rx_radiotap_len(struct ieee80211_local *local,
> -			  struct ieee80211_rx_status *status)
> +ieee80211_rx_radiotap_space(struct ieee80211_local *local,
> +			    struct ieee80211_rx_status *status)
>   {
>   	int len;
>   
>   	/* always present fields */
>   	len = sizeof(struct ieee80211_radiotap_header) + 9;
>   
> -	if (ieee80211_have_rx_timestamp(status))
> +	/* allocate extra bitmap */
> +	if (status->vendor_radiotap_len)
> +		len += 4;
> +
> +	if (ieee80211_have_rx_timestamp(status)) {
> +		len = ALIGN(len, 8);
>   		len += 8;
> +	}
>   	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
>   		len += 1;
>   
> -	if (len & 1) /* padding for RX_FLAGS if necessary */
> -		len++;
> +	/* padding for RX_FLAGS if necessary */
> +	len = ALIGN(len, 2);
>   
>   	if (status->flag & RX_FLAG_HT) /* HT info */
>   		len += 3;
>   
>   	if (status->flag & RX_FLAG_AMPDU_DETAILS) {
> -		/* padding */
> -		while (len & 3)
> -			len++;
> +		len = ALIGN(len, 4);
>   		len += 8;
>   	}
>   
> +	if (status->vendor_radiotap_len) {
> +		if (WARN_ON_ONCE(status->vendor_radiotap_align == 0))
> +			status->vendor_radiotap_align = 1;
> +		/* align standard part of vendor namespace */
> +		len = ALIGN(len, 2);
> +		/* allocate standard part of vendor namespace */
> +		len += 6;
> +		/* align vendor-defined part */
> +		len = ALIGN(len, status->vendor_radiotap_align);
> +		/* vendor-defined part is already in skb */
> +	}
> +
>   	return len;
>   }
>   
> @@ -132,14 +153,25 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
>   			    (1 << IEEE80211_RADIOTAP_CHANNEL) |
>   			    (1 << IEEE80211_RADIOTAP_ANTENNA) |
>   			    (1 << IEEE80211_RADIOTAP_RX_FLAGS));
> -	rthdr->it_len = cpu_to_le16(rtap_len);
> +	rthdr->it_len = cpu_to_le16(rtap_len + status->vendor_radiotap_len);
>   
>   	pos = (unsigned char *)(rthdr + 1);
>   
> +	if (status->vendor_radiotap_len) {
> +		rthdr->it_present |=
> +			cpu_to_le32(BIT(IEEE80211_RADIOTAP_VENDOR_NAMESPACE)) |
> +			cpu_to_le32(BIT(IEEE80211_RADIOTAP_EXT));
> +		put_unaligned_le32(status->vendor_radiotap_bitmap, pos);
> +		pos += 4;
> +	}
> +
>   	/* the order of the following fields is important */
>   
>   	/* IEEE80211_RADIOTAP_TSFT */
>   	if (ieee80211_have_rx_timestamp(status)) {
> +		/* padding */
> +		while ((pos - (u8 *)rthdr) & 7)
> +			*pos++ = 0;
>   		put_unaligned_le64(
>   			ieee80211_calculate_rx_timestamp(local, status,
>   							 mpdulen, 0),
> @@ -211,7 +243,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
>   	/* IEEE80211_RADIOTAP_RX_FLAGS */
>   	/* ensure 2 byte alignment for the 2 byte field as required */
>   	if ((pos - (u8 *)rthdr) & 1)
> -		pos++;
> +		*pos++ = 0;
>   	if (status->flag & RX_FLAG_FAILED_PLCP_CRC)
>   		rx_flags |= IEEE80211_RADIOTAP_F_RX_BADPLCP;
>   	put_unaligned_le16(rx_flags, pos);
> @@ -261,6 +293,21 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
>   			*pos++ = 0;
>   		*pos++ = 0;
>   	}
> +
> +	if (status->vendor_radiotap_len) {
> +		/* ensure 2 byte alignment for the vendor field as required */
> +		if ((pos - (u8 *)rthdr) & 1)
> +			*pos++ = 0;
> +		*pos++ = status->vendor_radiotap_oui[0];
> +		*pos++ = status->vendor_radiotap_oui[1];
> +		*pos++ = status->vendor_radiotap_oui[2];
> +		*pos++ = status->vendor_radiotap_subns;
> +		put_unaligned_le16(status->vendor_radiotap_len, pos);
> +		pos += 2;
> +		/* align the actual payload as requested */
> +		while ((pos - (u8 *)rthdr) & (status->vendor_radiotap_align - 1))
> +			*pos++ = 0;
> +	}
>   }
>   
>   /*
> @@ -289,7 +336,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
>   	 */
>   
>   	/* room for the radiotap header based on driver features */
> -	needed_headroom = ieee80211_rx_radiotap_len(local, status);
> +	needed_headroom = ieee80211_rx_radiotap_space(local, status);
>   
>   	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
>   		present_fcs_len = FCS_LEN;
> @@ -2595,7 +2642,7 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
>   		goto out_free_skb;
>   
>   	/* room for the radiotap header based on driver features */
> -	needed_headroom = ieee80211_rx_radiotap_len(local, status);
> +	needed_headroom = ieee80211_rx_radiotap_space(local, status);
>   
>   	if (skb_headroom(skb) < needed_headroom &&
>   	    pskb_expand_head(skb, needed_headroom, 0, GFP_ATOMIC))


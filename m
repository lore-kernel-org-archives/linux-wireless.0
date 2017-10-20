Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:37055 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752041AbdJTULF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Oct 2017 16:11:05 -0400
Subject: Re: [PATCH] ath10k: rebuild crypto header in RX data frames
To: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <150851690590.5158.11970481736247725763.stgit@potku.adurom.net>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <c9bdd915-0667-eee0-3b52-1fdf15abf249@dd-wrt.com> (sfid-20171020_221121_805668_01585A08)
Date: Fri, 20 Oct 2017 22:11:00 +0200
MIME-Version: 1.0
In-Reply-To: <150851690590.5158.11970481736247725763.stgit@potku.adurom.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i suggest the following patch on top of yours. please tell me if my 
thoughts are correct here. its mainly a guess

--- htt_rx.c    (revision 3656)
+++ htt_rx.c    (working copy)
@@ -550,6 +550,11 @@
                 return IEEE80211_TKIP_IV_LEN;
         case HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2:
                 return IEEE80211_CCMP_HDR_LEN;
+       case HTT_RX_MPDU_ENCRYPT_AES_CCMP_256:
+               return IEEE80211_CCMP_256_HDR_LEN;
+       case HTT_RX_MPDU_ENCRYPT_AES_GCMP_128:
+       case HTT_RX_MPDU_ENCRYPT_AES_GCMP_256:
+               return IEEE80211_GCMP_HDR_LEN;
         case HTT_RX_MPDU_ENCRYPT_WEP128:
         case HTT_RX_MPDU_ENCRYPT_WAPI:
                 break;
@@ -575,6 +580,11 @@
                 return IEEE80211_TKIP_ICV_LEN;
         case HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2:
                 return IEEE80211_CCMP_MIC_LEN;
+       case HTT_RX_MPDU_ENCRYPT_AES_CCMP_256:
+               return IEEE80211_CCMP_256_MIC_LEN;
+       case HTT_RX_MPDU_ENCRYPT_AES_GCMP_128:
+       case HTT_RX_MPDU_ENCRYPT_AES_GCMP_256:
+               return IEEE80211_GCMP_MIC_LEN;
         case HTT_RX_MPDU_ENCRYPT_WEP128:
         case HTT_RX_MPDU_ENCRYPT_WAPI:
                 break;
@@ -1012,6 +1022,7 @@
                 return;
         case HTT_RX_MPDU_ENCRYPT_WEP40:
         case HTT_RX_MPDU_ENCRYPT_WEP104:
+       case HTT_RX_MPDU_ENCRYPT_WEP128:
                 hdr = skb_push(msdu, IEEE80211_WEP_IV_LEN);
                 memcpy(hdr, rxd->mpdu_start.pn, IEEE80211_WEP_IV_LEN - 1);
                 hdr[3] = rxd->msdu_end.common.key_id_octet;
@@ -1032,7 +1043,21 @@
                 hdr[3] = 0x20 | (rxd->msdu_end.common.key_id_octet << 6);
                 memcpy(hdr + 4, rxd->mpdu_start.pn + 2, 4);
                 return;
-       case HTT_RX_MPDU_ENCRYPT_WEP128:
+       case HTT_RX_MPDU_ENCRYPT_AES_CCMP_256:
+               hdr = skb_push(msdu, IEEE80211_CCMP_256_HDR_LEN);
+               memcpy(hdr, rxd->mpdu_start.pn, 2);
+               hdr[2] = 0;
+               hdr[3] = 0x20 | (rxd->msdu_end.common.key_id_octet << 6);
+               memcpy(hdr + 4, rxd->mpdu_start.pn + 2, 4);
+               return;
+       case HTT_RX_MPDU_ENCRYPT_AES_GCMP_128:
+       case HTT_RX_MPDU_ENCRYPT_AES_GCMP_256:
+               hdr = skb_push(msdu, IEEE80211_GCMP_HDR_LEN);
+               memcpy(hdr, rxd->mpdu_start.pn, 2);
+               hdr[2] = 0;
+               hdr[3] = 0x20 | (rxd->msdu_end.common.key_id_octet << 6);
+               memcpy(hdr + 4, rxd->mpdu_start.pn + 2, 4);
+               return;
         case HTT_RX_MPDU_ENCRYPT_WAPI:
                 return;
         default:
@@ -1098,16 +1123,41 @@
         hdr = (void *)msdu->data;

         /* MIC */
-       if ((status->flag & RX_FLAG_MIC_STRIPPED) &&
-           enctype == HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2)
-               skb_trim(msdu, msdu->len - 8);
-
+       if (status->flag & RX_FLAG_MIC_STRIPPED) {
+           switch(enctype)
+           {
+           case HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2:
+           skb_trim(msdu, msdu->len - IEEE80211_CCMP_MIC_LEN);
+           break;
+           case HTT_RX_MPDU_ENCRYPT_AES_CCMP_256:
+           skb_trim(msdu, msdu->len - IEEE80211_CCMP_256_MIC_LEN);
+           break;
+           case HTT_RX_MPDU_ENCRYPT_AES_GCMP_128:
+           skb_trim(msdu, msdu->len - IEEE80211_GCMP_MIC_LEN);
+           break;
+           case HTT_RX_MPDU_ENCRYPT_AES_GCMP_256:
+           skb_trim(msdu, msdu->len - IEEE80211_GCMP_MIC_LEN);
+           break;
+           default:
+           break;
+           }
+       }
         /* ICV */
-       if (status->flag & RX_FLAG_ICV_STRIPPED &&
-           enctype != HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2)
+       if (status->flag & RX_FLAG_ICV_STRIPPED) {
+           switch(enctype)
+           {
+           case HTT_RX_MPDU_ENCRYPT_WEP40:
+           case HTT_RX_MPDU_ENCRYPT_WEP104:
+           case HTT_RX_MPDU_ENCRYPT_TKIP_WITHOUT_MIC:
+           case HTT_RX_MPDU_ENCRYPT_WEP128:
+           case HTT_RX_MPDU_ENCRYPT_TKIP_WPA:
                 skb_trim(msdu, msdu->len -
                          ath10k_htt_rx_crypto_tail_len(ar, enctype));
-
+           break;
+           default:
+           break;
+           }
+       }
         /* MMIC */
         if ((status->flag & RX_FLAG_MMIC_STRIPPED) &&
             !ieee80211_has_morefrags(hdr->frame_control) &&
Index: rx_desc.h
===================================================================
--- rx_desc.h   (revision 3656)
+++ rx_desc.h   (working copy)
@@ -239,6 +239,9 @@
         HTT_RX_MPDU_ENCRYPT_WAPI             = 5,
         HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2     = 6,
         HTT_RX_MPDU_ENCRYPT_NONE             = 7,
+       HTT_RX_MPDU_ENCRYPT_AES_CCMP_256     = 8,
+       HTT_RX_MPDU_ENCRYPT_AES_GCMP_128     = 9,
+       HTT_RX_MPDU_ENCRYPT_AES_GCMP_256     = 10,
  };

  #define RX_MPDU_START_INFO0_PEER_IDX_MASK     0x000007ff



Am 20.10.2017 um 18:28 schrieb Kalle Valo:
> From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>
> RX data frames notified through HTT_T2H_MSG_TYPE_RX_IND and
> HTT_T2H_MSG_TYPE_RX_FRAG_IND expect PN/TSC check to be done
> on host (mac80211) rather than firmware. Rebuild cipher header
> in every received data frames (that are notified through those
> HTT interfaces) from the PN/TSC and key_id information available
> from rx descriptor of the first msdu of each mpdu. Skip setting
> RX_FLAG_IV_STRIPPED flag for the packets which requires mac80211
> PN/TSC check support and set appropriate RX_FLAG for stripped
> crypto tail. QCA988X, QCA9887, QCA99X0, QCA9984, QCA9888 and
> QCA4019 currently need the rebuilding of cipher header to perform
> PN/TSC check for replay attack.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath10k/htt_rx.c |  120 ++++++++++++++++++++++++++----
>   1 file changed, 104 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index a3f5dc78353f..9a070ad05179 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -995,8 +995,55 @@ static int ath10k_htt_rx_nwifi_hdrlen(struct ath10k *ar,
>   	return len;
>   }
>   
> +static void ath10k_htt_rx_build_crypto_hdr(struct ath10k *ar,
> +					   struct sk_buff *msdu,
> +					   struct htt_rx_desc *rxd,
> +					   struct ieee80211_rx_status *status,
> +					   enum htt_rx_mpdu_encrypt_type type)
> +{
> +	u8 *hdr;
> +
> +	if (!(status->flag & RX_FLAG_DECRYPTED) ||
> +	    status->flag & RX_FLAG_IV_STRIPPED)
> +		return;
> +
> +	switch (type) {
> +	case HTT_RX_MPDU_ENCRYPT_NONE:
> +		return;
> +	case HTT_RX_MPDU_ENCRYPT_WEP40:
> +	case HTT_RX_MPDU_ENCRYPT_WEP104:
> +		hdr = skb_push(msdu, IEEE80211_WEP_IV_LEN);
> +		memcpy(hdr, rxd->mpdu_start.pn, IEEE80211_WEP_IV_LEN - 1);
> +		hdr[3] = rxd->msdu_end.common.key_id_octet;
> +		return;
> +	case HTT_RX_MPDU_ENCRYPT_TKIP_WITHOUT_MIC:
> +	case HTT_RX_MPDU_ENCRYPT_TKIP_WPA:
> +		hdr = skb_push(msdu, IEEE80211_TKIP_IV_LEN);
> +		hdr[0] = rxd->mpdu_start.pn[1];
> +		hdr[1] = 0;
> +		hdr[2] = rxd->mpdu_start.pn[0];
> +		hdr[3] = 0x20 | (rxd->msdu_end.common.key_id_octet << 6);
> +		memcpy(hdr + 4, rxd->mpdu_start.pn + 2, 4);
> +		return;
> +	case HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2:
> +		hdr = skb_push(msdu, IEEE80211_CCMP_HDR_LEN);
> +		memcpy(hdr, rxd->mpdu_start.pn, 2);
> +		hdr[2] = 0;
> +		hdr[3] = 0x20 | (rxd->msdu_end.common.key_id_octet << 6);
> +		memcpy(hdr + 4, rxd->mpdu_start.pn + 2, 4);
> +		return;
> +	case HTT_RX_MPDU_ENCRYPT_WEP128:
> +	case HTT_RX_MPDU_ENCRYPT_WAPI:
> +		return;
> +	default:
> +		ath10k_warn(ar, "unsupported encryption type %d\n", type);
> +		return;
> +	}
> +}
> +
>   static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
>   					struct sk_buff *msdu,
> +					struct htt_rx_desc *first_rxd,
>   					struct ieee80211_rx_status *status,
>   					enum htt_rx_mpdu_encrypt_type enctype,
>   					bool is_decrypted)
> @@ -1050,8 +1097,14 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
>   
>   	hdr = (void *)msdu->data;
>   
> -	/* Tail */
> -	if (status->flag & RX_FLAG_IV_STRIPPED)
> +	/* MIC */
> +	if ((status->flag & RX_FLAG_MIC_STRIPPED) &&
> +	    enctype == HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2)
> +		skb_trim(msdu, msdu->len - 8);
> +
> +	/* ICV */
> +	if (status->flag & RX_FLAG_ICV_STRIPPED &&
> +	    enctype != HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2)
>   		skb_trim(msdu, msdu->len -
>   			 ath10k_htt_rx_crypto_tail_len(ar, enctype));
>   
> @@ -1075,7 +1128,9 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
>   static void ath10k_htt_rx_h_undecap_nwifi(struct ath10k *ar,
>   					  struct sk_buff *msdu,
>   					  struct ieee80211_rx_status *status,
> -					  const u8 first_hdr[64])
> +					  struct htt_rx_desc *first_rxd,
> +					  const u8 first_hdr[64],
> +					  enum htt_rx_mpdu_encrypt_type enctype)
>   {
>   	struct ieee80211_hdr *hdr;
>   	struct htt_rx_desc *rxd;
> @@ -1108,6 +1163,8 @@ static void ath10k_htt_rx_h_undecap_nwifi(struct ath10k *ar,
>   	ether_addr_copy(sa, ieee80211_get_SA(hdr));
>   	skb_pull(msdu, hdr_len);
>   
> +	ath10k_htt_rx_build_crypto_hdr(ar, msdu, first_rxd, status, enctype);
> +
>   	/* push original 802.11 header */
>   	hdr = (struct ieee80211_hdr *)first_hdr;
>   	hdr_len = ieee80211_hdrlen(hdr->frame_control);
> @@ -1160,6 +1217,7 @@ static void *ath10k_htt_rx_h_find_rfc1042(struct ath10k *ar,
>   static void ath10k_htt_rx_h_undecap_eth(struct ath10k *ar,
>   					struct sk_buff *msdu,
>   					struct ieee80211_rx_status *status,
> +					struct htt_rx_desc *first_rxd,
>   					const u8 first_hdr[64],
>   					enum htt_rx_mpdu_encrypt_type enctype)
>   {
> @@ -1196,6 +1254,8 @@ static void ath10k_htt_rx_h_undecap_eth(struct ath10k *ar,
>   	memcpy(skb_push(msdu, sizeof(struct rfc1042_hdr)), rfc1042,
>   	       sizeof(struct rfc1042_hdr));
>   
> +	ath10k_htt_rx_build_crypto_hdr(ar, msdu, first_rxd, status, enctype);
> +
>   	/* push original 802.11 header */
>   	hdr = (struct ieee80211_hdr *)first_hdr;
>   	hdr_len = ieee80211_hdrlen(hdr->frame_control);
> @@ -1212,7 +1272,9 @@ static void ath10k_htt_rx_h_undecap_eth(struct ath10k *ar,
>   static void ath10k_htt_rx_h_undecap_snap(struct ath10k *ar,
>   					 struct sk_buff *msdu,
>   					 struct ieee80211_rx_status *status,
> -					 const u8 first_hdr[64])
> +					 struct htt_rx_desc *first_rxd,
> +					 const u8 first_hdr[64],
> +					 enum htt_rx_mpdu_encrypt_type enctype)
>   {
>   	struct ieee80211_hdr *hdr;
>   	size_t hdr_len;
> @@ -1231,6 +1293,8 @@ static void ath10k_htt_rx_h_undecap_snap(struct ath10k *ar,
>   	skb_put(msdu, l3_pad_bytes);
>   	skb_pull(msdu, sizeof(struct amsdu_subframe_hdr) + l3_pad_bytes);
>   
> +	ath10k_htt_rx_build_crypto_hdr(ar, msdu, first_rxd, status, enctype);
> +
>   	hdr = (struct ieee80211_hdr *)first_hdr;
>   	hdr_len = ieee80211_hdrlen(hdr->frame_control);
>   	memcpy(skb_push(msdu, hdr_len), hdr, hdr_len);
> @@ -1240,6 +1304,7 @@ static void ath10k_htt_rx_h_undecap(struct ath10k *ar,
>   				    struct sk_buff *msdu,
>   				    struct ieee80211_rx_status *status,
>   				    u8 first_hdr[64],
> +				    struct htt_rx_desc *first_rxd,
>   				    enum htt_rx_mpdu_encrypt_type enctype,
>   				    bool is_decrypted)
>   {
> @@ -1263,17 +1328,20 @@ static void ath10k_htt_rx_h_undecap(struct ath10k *ar,
>   
>   	switch (decap) {
>   	case RX_MSDU_DECAP_RAW:
> -		ath10k_htt_rx_h_undecap_raw(ar, msdu, status, enctype,
> -					    is_decrypted);
> +		ath10k_htt_rx_h_undecap_raw(ar, msdu, first_rxd, status,
> +					    enctype, is_decrypted);
>   		break;
>   	case RX_MSDU_DECAP_NATIVE_WIFI:
> -		ath10k_htt_rx_h_undecap_nwifi(ar, msdu, status, first_hdr);
> +		ath10k_htt_rx_h_undecap_nwifi(ar, msdu, status, first_rxd,
> +					      first_hdr, enctype);
>   		break;
>   	case RX_MSDU_DECAP_ETHERNET2_DIX:
> -		ath10k_htt_rx_h_undecap_eth(ar, msdu, status, first_hdr, enctype);
> +		ath10k_htt_rx_h_undecap_eth(ar, msdu, status, first_rxd,
> +					    first_hdr, enctype);
>   		break;
>   	case RX_MSDU_DECAP_8023_SNAP_LLC:
> -		ath10k_htt_rx_h_undecap_snap(ar, msdu, status, first_hdr);
> +		ath10k_htt_rx_h_undecap_snap(ar, msdu, status, first_rxd,
> +					     first_hdr, enctype);
>   		break;
>   	}
>   }
> @@ -1316,7 +1384,8 @@ static void ath10k_htt_rx_h_csum_offload(struct sk_buff *msdu)
>   
>   static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
>   				 struct sk_buff_head *amsdu,
> -				 struct ieee80211_rx_status *status)
> +				 struct ieee80211_rx_status *status,
> +				 bool fill_crypt_header)
>   {
>   	struct sk_buff *first;
>   	struct sk_buff *last;
> @@ -1406,14 +1475,20 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
>   		status->flag |= RX_FLAG_DECRYPTED;
>   
>   		if (likely(!is_mgmt))
> -			status->flag |= RX_FLAG_IV_STRIPPED |
> -					RX_FLAG_MMIC_STRIPPED;
> +			status->flag |= RX_FLAG_MMIC_STRIPPED;
> +
> +		if (fill_crypt_header)
> +			status->flag |= RX_FLAG_MIC_STRIPPED |
> +					RX_FLAG_ICV_STRIPPED;
> +		else
> +			status->flag |= RX_FLAG_IV_STRIPPED;
>   }
>   
>   	skb_queue_walk(amsdu, msdu) {
>   		ath10k_htt_rx_h_csum_offload(msdu);
> -		ath10k_htt_rx_h_undecap(ar, msdu, status, first_hdr, enctype,
> -					is_decrypted);
> +		ath10k_htt_rx_h_undecap(ar, msdu, status, first_hdr,
> +					(void *)first->data - sizeof(*rxd),
> +					enctype, is_decrypted);
>   
>   		/* Undecapping involves copying the original 802.11 header back
>   		 * to sk_buff. If frame is protected and hardware has decrypted
> @@ -1424,6 +1499,9 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
>   		if (is_mgmt)
>   			continue;
>   
> +		if (fill_crypt_header)
> +			continue;
> +
>   		hdr = (void *)msdu->data;
>   		hdr->frame_control &= ~__cpu_to_le16(IEEE80211_FCTL_PROTECTED);
>   	}
> @@ -1434,6 +1512,9 @@ static void ath10k_htt_rx_h_deliver(struct ath10k *ar,
>   				    struct ieee80211_rx_status *status)
>   {
>   	struct sk_buff *msdu;
> +	struct sk_buff *first_subframe;
> +
> +	first_subframe = skb_peek(amsdu);
>   
>   	while ((msdu = __skb_dequeue(amsdu))) {
>   		/* Setup per-MSDU flags */
> @@ -1442,6 +1523,13 @@ static void ath10k_htt_rx_h_deliver(struct ath10k *ar,
>   		else
>   			status->flag |= RX_FLAG_AMSDU_MORE;
>   
> +		if (msdu == first_subframe) {
> +			first_subframe = NULL;
> +			status->flag &= ~RX_FLAG_ALLOW_SAME_PN;
> +		} else {
> +			status->flag |= RX_FLAG_ALLOW_SAME_PN;
> +		}
> +
>   		ath10k_process_rx(ar, status, msdu);
>   	}
>   }
> @@ -1584,7 +1672,7 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
>   		ath10k_htt_rx_h_unchain(ar, &amsdu);
>   
>   	ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
> -	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
> +	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status, true);
>   	ath10k_htt_rx_h_deliver(ar, &amsdu, rx_status);
>   
>   	return num_msdus;
> @@ -1923,7 +2011,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb,
>   			budget_left -= skb_queue_len(&amsdu);
>   			ath10k_htt_rx_h_ppdu(ar, &amsdu, status, vdev_id);
>   			ath10k_htt_rx_h_filter(ar, &amsdu, status);
> -			ath10k_htt_rx_h_mpdu(ar, &amsdu, status);
> +			ath10k_htt_rx_h_mpdu(ar, &amsdu, status, false);
>   			ath10k_htt_rx_h_deliver(ar, &amsdu, status);
>   			break;
>   		case -EAGAIN:
>
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565

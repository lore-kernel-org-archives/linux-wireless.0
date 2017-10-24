Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:54267 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751661AbdJXVPo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Oct 2017 17:15:44 -0400
Received: by mail-lf0-f66.google.com with SMTP id l23so25557277lfk.10
        for <linux-wireless@vger.kernel.org>; Tue, 24 Oct 2017 14:15:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <720ce165-4a06-1d6e-6158-7983d75eea8a@dd-wrt.com>
References: <1508867652-16199-1-git-send-email-kvalo@qca.qualcomm.com> <720ce165-4a06-1d6e-6158-7983d75eea8a@dd-wrt.com>
From: Jasmine Strong <jas@eero.com>
Date: Tue, 24 Oct 2017 14:15:22 -0700
Message-ID: <CAGyitvNvCFAfuRg=uKLvZeZVzxsQ14GeXR702FHwu+RLLE_WAQ@mail.gmail.com> (sfid-20171024_231548_954850_6C4D7249)
Subject: Re: [PATCH v2] ath10k: rebuild crypto header in Rx data frames
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        ath10k <ath10k@lists.infradead.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seems to work okay on mixed networks of 9882, 4019 and 9888.

On Tue, Oct 24, 2017 at 1:41 PM, Sebastian Gottschall
<s.gottschall@dd-wrt.com> wrote:
> patch works. tested in sta and ap mode so far on 9984
>
> Am 24.10.2017 um 19:54 schrieb Kalle Valo:
>>
>> From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>>
>> Rx data frames notified through HTT_T2H_MSG_TYPE_RX_IND and
>> HTT_T2H_MSG_TYPE_RX_FRAG_IND expect PN/TSC check to be done
>> on host (mac80211) rather than firmware. Rebuild cipher header
>> in every received data frames (that are notified through those
>> HTT interfaces) from the rx_hdr_status tlv available in the
>> rx descriptor of the first msdu. Skip setting RX_FLAG_IV_STRIPPED
>> flag for the packets which requires mac80211 PN/TSC check support
>> and set appropriate RX_FLAG for stripped crypto tail. Hw QCA988X,
>> QCA9887, QCA99X0, QCA9984, QCA9888 and QCA4019 currently need the
>> rebuilding of cipher header to perform PN/TSC check for replay
>> attack.
>>
>> Tested-by: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> ---
>>
>> v2:
>>
>> * Construct cipher header from rx_hdr_status tlv rather than from
>>    the msdu_start and mpdu_start tlvs. This fixes connection
>>    issues, also reduces the amount of code change.
>>
>> * Make sure the frame is qos data before clearing AMSDU_PRESENT
>>    bit of qos control field.
>>
>> * Fix traffic issue with QCA988X and QCA9887 hw by taking care of
>>    padding bytes added for 4-byte alignment before the cipher
>>    header.
>>
>> TODO:
>>
>> * CCMP-256 and GCMP/GCMP-256 are not yet supported
>>
>>   drivers/net/wireless/ath/ath10k/htt_rx.c | 91
>> ++++++++++++++++++++++++++------
>>   1 file changed, 74 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> index a3f5dc78353f..aae4f0ea9360 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> @@ -1050,8 +1050,14 @@ static void ath10k_htt_rx_h_undecap_raw(struct
>> ath10k *ar,
>>         hdr =3D (void *)msdu->data;
>>   -     /* Tail */
>> -       if (status->flag & RX_FLAG_IV_STRIPPED)
>> +       /* MIC */
>> +       if ((status->flag & RX_FLAG_MIC_STRIPPED) &&
>> +           enctype =3D=3D HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2)
>> +               skb_trim(msdu, msdu->len - 8);
>> +
>> +       /* ICV */
>> +       if (status->flag & RX_FLAG_ICV_STRIPPED &&
>> +           enctype !=3D HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2)
>>                 skb_trim(msdu, msdu->len -
>>                          ath10k_htt_rx_crypto_tail_len(ar, enctype));
>>   @@ -1075,7 +1081,8 @@ static void ath10k_htt_rx_h_undecap_raw(struct
>> ath10k *ar,
>>   static void ath10k_htt_rx_h_undecap_nwifi(struct ath10k *ar,
>>                                           struct sk_buff *msdu,
>>                                           struct ieee80211_rx_status
>> *status,
>> -                                         const u8 first_hdr[64])
>> +                                         const u8 first_hdr[64],
>> +                                         enum htt_rx_mpdu_encrypt_type
>> enctype)
>>   {
>>         struct ieee80211_hdr *hdr;
>>         struct htt_rx_desc *rxd;
>> @@ -1083,6 +1090,7 @@ static void ath10k_htt_rx_h_undecap_nwifi(struct
>> ath10k *ar,
>>         u8 da[ETH_ALEN];
>>         u8 sa[ETH_ALEN];
>>         int l3_pad_bytes;
>> +       int bytes_aligned =3D ar->hw_params.decap_align_bytes;
>>         /* Delivered decapped frame:
>>          * [nwifi 802.11 header] <-- replaced with 802.11 hdr
>> @@ -1111,6 +1119,14 @@ static void ath10k_htt_rx_h_undecap_nwifi(struct
>> ath10k *ar,
>>         /* push original 802.11 header */
>>         hdr =3D (struct ieee80211_hdr *)first_hdr;
>>         hdr_len =3D ieee80211_hdrlen(hdr->frame_control);
>> +
>> +       if (!(status->flag & RX_FLAG_IV_STRIPPED)) {
>> +               memcpy(skb_push(msdu,
>> +                               ath10k_htt_rx_crypto_param_len(ar,
>> enctype)),
>> +                      (void *)hdr + round_up(hdr_len, bytes_aligned),
>> +                       ath10k_htt_rx_crypto_param_len(ar, enctype));
>> +       }
>> +
>>         memcpy(skb_push(msdu, hdr_len), hdr, hdr_len);
>>         /* original 802.11 header has a different DA and in
>> @@ -1171,6 +1187,7 @@ static void ath10k_htt_rx_h_undecap_eth(struct
>> ath10k *ar,
>>         u8 sa[ETH_ALEN];
>>         int l3_pad_bytes;
>>         struct htt_rx_desc *rxd;
>> +       int bytes_aligned =3D ar->hw_params.decap_align_bytes;
>>         /* Delivered decapped frame:
>>          * [eth header] <-- replaced with 802.11 hdr & rfc1042/llc
>> @@ -1199,6 +1216,14 @@ static void ath10k_htt_rx_h_undecap_eth(struct
>> ath10k *ar,
>>         /* push original 802.11 header */
>>         hdr =3D (struct ieee80211_hdr *)first_hdr;
>>         hdr_len =3D ieee80211_hdrlen(hdr->frame_control);
>> +
>> +       if (!(status->flag & RX_FLAG_IV_STRIPPED)) {
>> +               memcpy(skb_push(msdu,
>> +                               ath10k_htt_rx_crypto_param_len(ar,
>> enctype)),
>> +                      (void *)hdr + round_up(hdr_len, bytes_aligned),
>> +                       ath10k_htt_rx_crypto_param_len(ar, enctype));
>> +       }
>> +
>>         memcpy(skb_push(msdu, hdr_len), hdr, hdr_len);
>>         /* original 802.11 header has a different DA and in
>> @@ -1212,12 +1237,14 @@ static void ath10k_htt_rx_h_undecap_eth(struct
>> ath10k *ar,
>>   static void ath10k_htt_rx_h_undecap_snap(struct ath10k *ar,
>>                                          struct sk_buff *msdu,
>>                                          struct ieee80211_rx_status
>> *status,
>> -                                        const u8 first_hdr[64])
>> +                                        const u8 first_hdr[64],
>> +                                        enum htt_rx_mpdu_encrypt_type
>> enctype)
>>   {
>>         struct ieee80211_hdr *hdr;
>>         size_t hdr_len;
>>         int l3_pad_bytes;
>>         struct htt_rx_desc *rxd;
>> +       int bytes_aligned =3D ar->hw_params.decap_align_bytes;
>>         /* Delivered decapped frame:
>>          * [amsdu header] <-- replaced with 802.11 hdr
>> @@ -1233,6 +1260,14 @@ static void ath10k_htt_rx_h_undecap_snap(struct
>> ath10k *ar,
>>         hdr =3D (struct ieee80211_hdr *)first_hdr;
>>         hdr_len =3D ieee80211_hdrlen(hdr->frame_control);
>> +
>> +       if (!(status->flag & RX_FLAG_IV_STRIPPED)) {
>> +               memcpy(skb_push(msdu,
>> +                               ath10k_htt_rx_crypto_param_len(ar,
>> enctype)),
>> +                      (void *)hdr + round_up(hdr_len, bytes_aligned),
>> +                       ath10k_htt_rx_crypto_param_len(ar, enctype));
>> +       }
>> +
>>         memcpy(skb_push(msdu, hdr_len), hdr, hdr_len);
>>   }
>>   @@ -1267,13 +1302,15 @@ static void ath10k_htt_rx_h_undecap(struct
>> ath10k *ar,
>>                                             is_decrypted);
>>                 break;
>>         case RX_MSDU_DECAP_NATIVE_WIFI:
>> -               ath10k_htt_rx_h_undecap_nwifi(ar, msdu, status,
>> first_hdr);
>> +               ath10k_htt_rx_h_undecap_nwifi(ar, msdu, status, first_hd=
r,
>> +                                             enctype);
>>                 break;
>>         case RX_MSDU_DECAP_ETHERNET2_DIX:
>>                 ath10k_htt_rx_h_undecap_eth(ar, msdu, status, first_hdr,
>> enctype);
>>                 break;
>>         case RX_MSDU_DECAP_8023_SNAP_LLC:
>> -               ath10k_htt_rx_h_undecap_snap(ar, msdu, status, first_hdr=
);
>> +               ath10k_htt_rx_h_undecap_snap(ar, msdu, status, first_hdr=
,
>> +                                            enctype);
>>                 break;
>>         }
>>   }
>> @@ -1316,7 +1353,8 @@ static void ath10k_htt_rx_h_csum_offload(struct
>> sk_buff *msdu)
>>     static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
>>                                  struct sk_buff_head *amsdu,
>> -                                struct ieee80211_rx_status *status)
>> +                                struct ieee80211_rx_status *status,
>> +                                bool fill_crypt_header)
>>   {
>>         struct sk_buff *first;
>>         struct sk_buff *last;
>> @@ -1326,7 +1364,6 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar=
,
>>         enum htt_rx_mpdu_encrypt_type enctype;
>>         u8 first_hdr[64];
>>         u8 *qos;
>> -       size_t hdr_len;
>>         bool has_fcs_err;
>>         bool has_crypto_err;
>>         bool has_tkip_err;
>> @@ -1351,15 +1388,17 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k
>> *ar,
>>          * decapped header. It'll be used for undecapping of each MSDU.
>>          */
>>         hdr =3D (void *)rxd->rx_hdr_status;
>> -       hdr_len =3D ieee80211_hdrlen(hdr->frame_control);
>> -       memcpy(first_hdr, hdr, hdr_len);
>> +       memcpy(first_hdr, hdr, RX_HTT_HDR_STATUS_LEN);
>>         /* Each A-MSDU subframe will use the original header as the base
>> and be
>>          * reported as a separate MSDU so strip the A-MSDU bit from QoS
>> Ctl.
>>          */
>>         hdr =3D (void *)first_hdr;
>> -       qos =3D ieee80211_get_qos_ctl(hdr);
>> -       qos[0] &=3D ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
>> +
>> +       if (ieee80211_is_data_qos(hdr->frame_control)) {
>> +               qos =3D ieee80211_get_qos_ctl(hdr);
>> +               qos[0] &=3D ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
>> +       }
>>         /* Some attention flags are valid only in the last MSDU. */
>>         last =3D skb_peek_tail(amsdu);
>> @@ -1406,9 +1445,14 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *a=
r,
>>                 status->flag |=3D RX_FLAG_DECRYPTED;
>>                 if (likely(!is_mgmt))
>> -                       status->flag |=3D RX_FLAG_IV_STRIPPED |
>> -                                       RX_FLAG_MMIC_STRIPPED;
>> -}
>> +                       status->flag |=3D RX_FLAG_MMIC_STRIPPED;
>> +
>> +               if (fill_crypt_header)
>> +                       status->flag |=3D RX_FLAG_MIC_STRIPPED |
>> +                                       RX_FLAG_ICV_STRIPPED;
>> +               else
>> +                       status->flag |=3D RX_FLAG_IV_STRIPPED;
>> +       }
>>         skb_queue_walk(amsdu, msdu) {
>>                 ath10k_htt_rx_h_csum_offload(msdu);
>> @@ -1424,6 +1468,9 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar=
,
>>                 if (is_mgmt)
>>                         continue;
>>   +             if (fill_crypt_header)
>> +                       continue;
>> +
>>                 hdr =3D (void *)msdu->data;
>>                 hdr->frame_control &=3D
>> ~__cpu_to_le16(IEEE80211_FCTL_PROTECTED);
>>         }
>> @@ -1434,6 +1481,9 @@ static void ath10k_htt_rx_h_deliver(struct ath10k
>> *ar,
>>                                     struct ieee80211_rx_status *status)
>>   {
>>         struct sk_buff *msdu;
>> +       struct sk_buff *first_subframe;
>> +
>> +       first_subframe =3D skb_peek(amsdu);
>>         while ((msdu =3D __skb_dequeue(amsdu))) {
>>                 /* Setup per-MSDU flags */
>> @@ -1442,6 +1492,13 @@ static void ath10k_htt_rx_h_deliver(struct ath10k
>> *ar,
>>                 else
>>                         status->flag |=3D RX_FLAG_AMSDU_MORE;
>>   +             if (msdu =3D=3D first_subframe) {
>> +                       first_subframe =3D NULL;
>> +                       status->flag &=3D ~RX_FLAG_ALLOW_SAME_PN;
>> +               } else {
>> +                       status->flag |=3D RX_FLAG_ALLOW_SAME_PN;
>> +               }
>> +
>>                 ath10k_process_rx(ar, status, msdu);
>>         }
>>   }
>> @@ -1584,7 +1641,7 @@ static int ath10k_htt_rx_handle_amsdu(struct
>> ath10k_htt *htt)
>>                 ath10k_htt_rx_h_unchain(ar, &amsdu);
>>         ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
>> -       ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
>> +       ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status, true);
>>         ath10k_htt_rx_h_deliver(ar, &amsdu, rx_status);
>>         return num_msdus;
>> @@ -1923,7 +1980,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k
>> *ar, struct sk_buff *skb,
>>                         budget_left -=3D skb_queue_len(&amsdu);
>>                         ath10k_htt_rx_h_ppdu(ar, &amsdu, status, vdev_id=
);
>>                         ath10k_htt_rx_h_filter(ar, &amsdu, status);
>> -                       ath10k_htt_rx_h_mpdu(ar, &amsdu, status);
>> +                       ath10k_htt_rx_h_mpdu(ar, &amsdu, status, false);
>>                         ath10k_htt_rx_h_deliver(ar, &amsdu, status);
>>                         break;
>>                 case -EAGAIN:
>
>
>
> --
> Mit freundlichen Gr=C3=BCssen / Regards
>
> Sebastian Gottschall / CTO
>
> NewMedia-NET GmbH - DD-WRT
> Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
> Registergericht: Amtsgericht Darmstadt, HRB 25473
> Gesch=C3=A4ftsf=C3=BChrer: Peter Steinh=C3=A4user, Christian Scheele
> http://www.dd-wrt.com
> email: s.gottschall@dd-wrt.com
> Tel.: +496251-582650 / Fax: +496251-5826565
>
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k

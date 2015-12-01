Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:35461 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbbLAJnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:43:00 -0500
Received: by ykba77 with SMTP id a77so530797ykb.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2015 01:42:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <565CA735.3090001@codeaurora.org>
References: <1448888219-2798-1-git-send-email-grzegorz.bajorski@tieto.com>
	<565CA735.3090001@codeaurora.org>
Date: Tue, 1 Dec 2015 10:42:59 +0100
Message-ID: <CAPGg_YByL-fQ48tZ_2zeSv+Uvmu9AObOahH_x+0NMVKh+_9+8Q@mail.gmail.com> (sfid-20151201_104308_868257_89904F81)
Subject: Re: [PATCH] ath10k: deliver mgmt frames from htt to monitor vifs only
From: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
To: Peter Oh <poh@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-11-30 20:44 GMT+01:00 Peter Oh <poh@codeaurora.org>:
>
> On 11/30/2015 04:56 AM, Grzegorz Bajorski wrote:
>>
>> Until now only WMI originating mgmt frames were
>> reported to mac80211. Management frames on HTT
>> were basically dropped (except frames which looked
>> like management but had FCS error).
>>
>> To allow sniffing all frames (including offloaded
>> frames) without interfering with mac80211
>> operation and states a new rx_flag was introduced
>> and is not being used to distinguish frames and
>> classify them for mac80211.
>
> Does this change valid for all the firmware 10.1, 10.2, 10.4, and etc.?

Yes.

>
>>
>> Signed-off-by: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
>> ---
>> depends on:
>> mac80211: allow drivers to report (non-)monitor frames
>>
>>   drivers/net/wireless/ath/ath10k/htt_rx.c | 70
>> ++++++++++++++++----------------
>>   drivers/net/wireless/ath/ath10k/wmi.c    |  6 +++
>>   2 files changed, 40 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> index 396645b..898eff0 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> @@ -1076,20 +1076,25 @@ static void ath10k_htt_rx_h_undecap_raw(struct
>> ath10k *ar,
>>         hdr = (void *)msdu->data;
>>         /* Tail */
>> -       skb_trim(msdu, msdu->len - ath10k_htt_rx_crypto_tail_len(ar,
>> enctype));
>> +       if (status->flag & RX_FLAG_IV_STRIPPED)
>> +               skb_trim(msdu, msdu->len -
>> +                        ath10k_htt_rx_crypto_tail_len(ar, enctype));
>>         /* MMIC */
>> -       if (!ieee80211_has_morefrags(hdr->frame_control) &&
>> +       if ((status->flag & RX_FLAG_MMIC_STRIPPED) &&
>> +           !ieee80211_has_morefrags(hdr->frame_control) &&
>>             enctype == HTT_RX_MPDU_ENCRYPT_TKIP_WPA)
>>                 skb_trim(msdu, msdu->len - 8);
>>         /* Head */
>> -       hdr_len = ieee80211_hdrlen(hdr->frame_control);
>> -       crypto_len = ath10k_htt_rx_crypto_param_len(ar, enctype);
>> +       if (status->flag & RX_FLAG_IV_STRIPPED) {
>> +               hdr_len = ieee80211_hdrlen(hdr->frame_control);
>> +               crypto_len = ath10k_htt_rx_crypto_param_len(ar, enctype);
>>   -     memmove((void *)msdu->data + crypto_len,
>> -               (void *)msdu->data, hdr_len);
>> -       skb_pull(msdu, crypto_len);
>> +               memmove((void *)msdu->data + crypto_len,
>> +                       (void *)msdu->data, hdr_len);
>> +               skb_pull(msdu, crypto_len);
>> +       }
>>   }
>>     static void ath10k_htt_rx_h_undecap_nwifi(struct ath10k *ar,
>> @@ -1330,6 +1335,7 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
>>         bool has_tkip_err;
>>         bool has_peer_idx_invalid;
>>         bool is_decrypted;
>> +       bool is_mgmt;
>>         u32 attention;
>>         if (skb_queue_empty(amsdu))
>> @@ -1338,6 +1344,9 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
>>         first = skb_peek(amsdu);
>>         rxd = (void *)first->data - sizeof(*rxd);
>>   +     is_mgmt = !!(rxd->attention.flags &
>> +                    __cpu_to_le32(RX_ATTENTION_FLAGS_MGMT_TYPE));
>> +
>>         enctype = MS(__le32_to_cpu(rxd->mpdu_start.info0),
>>                      RX_MPDU_START_INFO0_ENCRYPT_TYPE);
>>   @@ -1379,6 +1388,7 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k
>> *ar,
>>                           RX_FLAG_MMIC_ERROR |
>>                           RX_FLAG_DECRYPTED |
>>                           RX_FLAG_IV_STRIPPED |
>> +                         RX_FLAG_ONLY_MONITOR |
>>                           RX_FLAG_MMIC_STRIPPED);
>>         if (has_fcs_err)
>> @@ -1387,10 +1397,21 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k
>> *ar,
>>         if (has_tkip_err)
>>                 status->flag |= RX_FLAG_MMIC_ERROR;
>>   -     if (is_decrypted)
>> -               status->flag |= RX_FLAG_DECRYPTED |
>> -                               RX_FLAG_IV_STRIPPED |
>> -                               RX_FLAG_MMIC_STRIPPED;
>> +       /* Firmware reports all necessary management frames via WMI
>> already.
>> +        * They are not reported to monitor interfaces at all so pass the
>> ones
>> +        * coming via HTT to monitor interfaces instead. This simplifies
>> +        * matters a lot.
>> +        */
>> +       if (is_mgmt)
>> +               status->flag |= RX_FLAG_ONLY_MONITOR;
>> +
>> +       if (is_decrypted) {
>> +               status->flag |= RX_FLAG_DECRYPTED;
>> +
>> +               if (likely(!is_mgmt))
>> +                       status->flag |= RX_FLAG_IV_STRIPPED |
>> +                                       RX_FLAG_MMIC_STRIPPED;
>
> Management frames are encrypted in MFP condition.
> This change seems breaking MFP frame from working.

This patch don't affect processing PMF frames by mac80211 and higher layers.
With this change, mgmt frames from HTT instead of being dropped can be
sent to mac80211 _only_ to monitor vif's. Frames from wmi_mgmt_rx are
send to mac80211 to all vif _except_ monitor.

Behavior does not change - we take PMF frames from WMI path. The only
diffrent is that frames from WMI never go to moniotr vif - we take
them form HTT path.

>>
>> +}
>>         skb_queue_walk(amsdu, msdu) {
>>                 ath10k_htt_rx_h_csum_offload(msdu);
>> @@ -1403,6 +1424,8 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
>>                  */
>>                 if (!is_decrypted)
>>                         continue;
>> +               if (is_mgmt)
>> +                       continue;
>
> Ditto.
> Could you provide test results in MFP case?
>
>>                 hdr = (void *)msdu->data;
>>                 hdr->frame_control &=
>> ~__cpu_to_le16(IEEE80211_FCTL_PROTECTED);
>> @@ -1503,14 +1526,6 @@ static bool ath10k_htt_rx_amsdu_allowed(struct
>> ath10k *ar,
>>                                         struct sk_buff_head *amsdu,
>>                                         struct ieee80211_rx_status
>> *rx_status)
>>   {
>> -       struct sk_buff *msdu;
>> -       struct htt_rx_desc *rxd;
>> -       bool is_mgmt;
>> -       bool has_fcs_err;
>> -
>> -       msdu = skb_peek(amsdu);
>> -       rxd = (void *)msdu->data - sizeof(*rxd);
>> -
>>         /* FIXME: It might be a good idea to do some fuzzy-testing to drop
>>          * invalid/dangerous frames.
>>          */
>> @@ -1520,23 +1535,6 @@ static bool ath10k_htt_rx_amsdu_allowed(struct
>> ath10k *ar,
>>                 return false;
>>         }
>>   -     is_mgmt = !!(rxd->attention.flags &
>> -                    __cpu_to_le32(RX_ATTENTION_FLAGS_MGMT_TYPE));
>> -       has_fcs_err = !!(rxd->attention.flags &
>> -                        __cpu_to_le32(RX_ATTENTION_FLAGS_FCS_ERR));
>> -
>> -       /* Management frames are handled via WMI events. The pros of such
>> -        * approach is that channel is explicitly provided in WMI events
>> -        * whereas HTT doesn't provide channel information for Rxed
>> frames.
>> -        *
>> -        * However some firmware revisions don't report corrupted frames
>> via
>> -        * WMI so don't drop them.
>> -        */
>> -       if (is_mgmt && !has_fcs_err) {
>> -               ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx mgmt ctrl\n");
>> -               return false;
>> -       }
>> -
>>         if (test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags)) {
>>                 ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx cac running\n");
>>                 return false;
>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c
>> b/drivers/net/wireless/ath/ath10k/wmi.c
>> index 9021079..847f91a 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>> @@ -2298,6 +2298,12 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar,
>> struct sk_buff *skb)
>>         hdr = (struct ieee80211_hdr *)skb->data;
>>         fc = le16_to_cpu(hdr->frame_control);
>>   +     /* Firmware is guaranteed to report all essential management
>> frames via
>> +        * WMI while it can deliver some extra via HTT. Since there can be
>> +        * duplicates split the reporting wrt monitor/sniffing.
>> +        */
>> +       status->flag |= RX_FLAG_SKIP_MONITOR;
>> +
>>         ath10k_wmi_handle_wep_reauth(ar, skb, status);
>>         /* FW delivers WEP Shared Auth frame with Protected Bit set and
>
>



-- 
Pozdrawiam / Best Regards
Grzegorz Bajorski

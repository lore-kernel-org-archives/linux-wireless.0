Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:59894 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3IQFTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 01:19:38 -0400
Received: by mail-bk0-f53.google.com with SMTP id d7so1953761bkh.12
        for <linux-wireless@vger.kernel.org>; Mon, 16 Sep 2013 22:19:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8738p4laid.fsf@qca.qualcomm.com>
References: <1379335757-15180-1-git-send-email-michal.kazior@tieto.com>
	<1379335757-15180-4-git-send-email-michal.kazior@tieto.com>
	<8738p4laid.fsf@qca.qualcomm.com>
Date: Tue, 17 Sep 2013 07:19:35 +0200
Message-ID: <CA+BoTQ=q9ojX4bp61rExY7b9Pk+=Zpg_qNxfXYvt8eXscdC=bA@mail.gmail.com> (sfid-20130917_071944_458671_4B5B50CB)
Subject: Re: [RFC 3/4] ath10k: cleanup RX decap handling
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 September 2013 23:30, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Native Wifi frames are always decapped as non-QoS
>> data frames meaning mac80211 couldn't set sk_buff
>> priority properly. The patch fixes this by using
>> the original 802.11 header.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> The patch title doesn't seem to match with the content. Unless I'm
> mistaken it looks like you are adding native wifi frame format support
> and doing some cleanup at the same time. They should be in separate
> patches.

You're right. I'll split it up.

Nwifi was supported, however QoS Data frames were reported as Data
frames though.


>> @@ -652,6 +652,19 @@ static void ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
>>                       skb_trim(skb, skb->len - FCS_LEN);
>>                       break;
>>               case RX_MSDU_DECAP_NATIVE_WIFI:
>> +                     hdr = (struct ieee80211_hdr *)skb->data;
>> +                     hdr_len = ieee80211_hdrlen(hdr->frame_control);
>> +                     memcpy(addr, ieee80211_get_DA(hdr), ETH_ALEN);
>> +                     skb_pull(skb, hdr_len);
>> +
>> +                     hdr = (struct ieee80211_hdr *)hdr_buf;
>> +                     hdr_len = ieee80211_hdrlen(hdr->frame_control);
>> +                     memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
>> +
>> +                     hdr = (struct ieee80211_hdr *)skb->data;
>> +                     qos = ieee80211_get_qos_ctl(hdr);
>> +                     qos[0] &= ~IEEE80211_QOS_CTL_A_MSDU_PRESENT;
>> +                     memcpy(ieee80211_get_DA(hdr), addr, ETH_ALEN);
>>                       break;
>
> It would be good to have small comments what each part is doing("remove
> the native wifi header", "copy the real 802.11 header", "copy correct
> destination address" etc), makes it a lot faster to skim the code. Also
> document why IEEE80211_QOS_CTL_A_MSDU_PRESENT needs to be cleared.

Okay.


>>       case RX_MSDU_DECAP_RAW:
>> -             /* remove trailing FCS */
>> -             skb_trim(skb, skb->len - 4);
>> +             skb_trim(skb, skb->len - FCS_LEN);
>>               break;
>
> Please keep the comment still

Why? The point of the comment was to explain the literal "4". Using
define makes the comment redundant.


>
>>       case RX_MSDU_DECAP_NATIVE_WIFI:
>> -             /* nothing to do here */
>> +             hdr = (struct ieee80211_hdr *)skb->data;
>> +             hdr_len = ieee80211_hdrlen(hdr->frame_control);
>> +             memcpy(addr, ieee80211_get_DA(hdr), ETH_ALEN);
>> +             skb_pull(skb, hdr_len);
>> +
>> +             hdr = (struct ieee80211_hdr *)rxd->rx_hdr_status;
>> +             hdr_len = ieee80211_hdrlen(hdr->frame_control);
>> +             memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
>> +
>> +             hdr = (struct ieee80211_hdr *)skb->data;
>> +             memcpy(ieee80211_get_DA(hdr), addr, ETH_ALEN);
>>               break;
>
> Again add small comments describing how we are modifying the headers.

Okay.


>>       case RX_MSDU_DECAP_ETHERNET2_DIX:
>> -             /* macaddr[6] + macaddr[6] + ethertype[2] */
>> -             skb_pull(skb, 6 + 6 + 2);
>> +             rfc1042 = hdr;
>> +             rfc1042 += roundup(hdr_len, 4);
>> +             rfc1042 += roundup(ath10k_htt_rx_crypto_param_len(enctype), 4);
>> +
>> +             skb_pull(skb, sizeof(struct ethhdr));
>> +             memcpy(skb_push(skb, sizeof(struct rfc1042_hdr)),
>> +                    rfc1042, sizeof(struct rfc1042_hdr));
>> +             memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
>>               break;
>
> Ditto.

Comment was supposed to explain where those numbers come from. Using
structures explains it now.


>>       case RX_MSDU_DECAP_8023_SNAP_LLC:
>> -             /* macaddr[6] + macaddr[6] + len[2] */
>> -             /* we don't need this for non-A-MSDU */
>> -             skb_pull(skb, 6 + 6 + 2);
>> +             skb_pull(skb, sizeof(struct amsdu_subframe_hdr));
>> +             memcpy(skb_push(skb, hdr_len), hdr, hdr_len);
>>               break;
>
> And here.

Ditto.


Michał.

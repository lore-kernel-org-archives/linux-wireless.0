Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:53983 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaG1Hwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 03:52:31 -0400
Received: by mail-lb0-f180.google.com with SMTP id v6so5567644lbi.11
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2014 00:52:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53D5EF33.1080208@gmail.com>
References: <1406528765-4669-1-git-send-email-janusz.dziedzic@tieto.com>
	<53D5EF33.1080208@gmail.com>
Date: Mon, 28 Jul 2014 09:52:30 +0200
Message-ID: <CALhHN=rOF+-8gJCM4tBNk39ksd_F_w_h2GB=njP6N6PXqkZiXg@mail.gmail.com> (sfid-20140728_095236_198812_976B150A)
Subject: Re: [PATCH v2] ath10k: extend debug code for RX path
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 July 2014 08:35, Varka Bhadram <varkabhadram@gmail.com> wrote:
> On 07/28/2014 11:56 AM, Janusz Dziedzic wrote:
>>
>> Print sequence number, AMSDU_MORE flag and AC when additional
>> debug enabled in RX path. This is usefull for debugging purpose.
>>
>> Signed-off-by: Janusz Dziedzic<janusz.dziedzic@tieto.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/htt_rx.c |   41
>> ++++++++++++++++++++++++++++--
>>   1 file changed, 39 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> index d80fcda..f7c8021 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> @@ -818,19 +818,55 @@ static bool ath10k_htt_rx_h_channel(struct ath10k
>> *ar,
>>         return true;
>>   }
>>   +static const char * const tid_to_ac[] = {
>
>
> No space required '*' and const.
>
Seems checkpatch didn't find this.

> static const char *const tid_to_ac[] = {
>
>
>
>> +       "BE",
>> +       "BK",
>> +       "BK",
>> +       "BE",
>> +       "VI",
>> +       "VI",
>> +       "VO",
>> +       "VO",
>> +};
>> +
>> +static char *ath10k_get_tid(struct ieee80211_hdr *hdr, char *out, size_t
>> size)
>> +{
>> +       u8 *qc;
>> +       int tid;
>> +
>> +       if (!ieee80211_is_data_qos(hdr->frame_control))
>> +               return "";
>
>
> return NULL would be more readable...?
>
We don't need extra "(null)" in printf, empty string is what I expect
here (same as other params in this dbg info).
Anyway I can return "out" here and initialize as empty before calling
ath10k_get_tid().

>
>> +
>> +       qc = ieee80211_get_qos_ctl(hdr);
>> +       tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
>> +       if (tid < 8)
>> +               snprintf(out, size, "tid %d (%s)", tid, tid_to_ac[tid]);
>> +       else
>> +               snprintf(out, size, "tid %d", tid);
>> +
>> +       return out;
>> +}
>> +
>>   static void ath10k_process_rx(struct ath10k *ar,
>>                               struct ieee80211_rx_status *rx_status,
>>                               struct sk_buff *skb)
>>   {
>>         struct ieee80211_rx_status *status;
>> +       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>> +       char tid[32];
>>         status = IEEE80211_SKB_RXCB(skb);
>>         *status = *rx_status;
>>         ath10k_dbg(ATH10K_DBG_DATA,
>> -                  "rx skb %p len %u %s%s%s%s%s %srate_idx %u vht_nss %u
>> freq %u band %u flag 0x%x fcs-err %imic-err %i\n",
>> +                  "rx skb %p len %u peer %pM %s %s sn %u %s%s%s%s%s
>> %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i
>> amsdu-more %i\n",
>>                    skb,
>>                    skb->len,
>> +                  ieee80211_get_SA(hdr),
>> +                  ath10k_get_tid(hdr, tid, sizeof(tid)),
>> +                  is_multicast_ether_addr(ieee80211_get_DA(hdr)) ?
>> +                                                       "mcast" : "ucast",
>
>
> should match open paranthesis...
>
> is_multicast_ether_addr(ieee80211_get_DA(hdr)) ?
>
>                         "mcast" : "ucast",
>
Could you describe this more (I didn't find clear description about this)?

BR
Janusz

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:46418 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754470Ab2APMfp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 07:35:45 -0500
Received: by mail-iy0-f172.google.com with SMTP id e16so9364724iaa.31
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2012 04:35:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1326716492.3510.10.camel@jlt3.sipsolutions.net>
References: <1326707004-3352-1-git-send-email-yoni.divinsky@ti.com>
	<1326716492.3510.10.camel@jlt3.sipsolutions.net>
Date: Mon, 16 Jan 2012 14:35:43 +0200
Message-ID: <CANJm+iAiSHAEO2iHkKum_5KtdC9xVv9x3Di4nnshqW=X8J0Pog@mail.gmail.com> (sfid-20120116_133548_732887_D4FEC162)
Subject: Re: [PATCH] mac80211: fix tx->skb NULL pointer dereference
From: "Divinsky, Yonatan" <yoni.divinsky@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 16, 2012 at 2:21 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-01-16 at 11:43 +0200, Yoni Divinsky wrote:
>> In function ieee80211_tx_h_encrypt the var info was
>> initialized from tx->skb, since the fucntion
>> is called after the function ieee80211_tx_h_fragment
>> tx->skb is not valid anymore.
>
> Wow, that's quite a while ago, I guess nobody tests WAPI often? :-)
Who said anything about WAPI ;-)
>
>> @@ -1001,8 +1001,6 @@ ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
>>  static ieee80211_tx_result debug_noinline
>>  ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
>>  {
>> -     struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
>> -
>>       if (!tx->key)
>>               return TX_CONTINUE;
>>
>> @@ -1017,13 +1015,7 @@ ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
>>       case WLAN_CIPHER_SUITE_AES_CMAC:
>>               return ieee80211_crypto_aes_cmac_encrypt(tx);
>>       default:
>> -             /* handle hw-only algorithm */
>> -             if (info->control.hw_key) {
>> -                     ieee80211_tx_set_protected(tx);
>> -                     return TX_CONTINUE;
>> -             }
>> -             break;
>> -
>> +             return ieee80211_crypto_default_encrypt(tx);
>
> How about
> ieee80211_require_hw_crypto() or something like that?
To be consistent with the other encryptions I think it would
be better to use something like: ieee80211_crypto_hw_encrypt(tx)

>
>> +ieee80211_tx_result
>> +ieee80211_crypto_default_encrypt(struct ieee80211_tx_data *tx)
>> +{
>> +     struct sk_buff *skb;
>> +     struct ieee80211_tx_info *info = NULL;
>> +
>> +     skb_queue_walk(&tx->skbs, skb) {
>> +             info  = IEEE80211_SKB_CB(skb);
>> +
>> +             /* handle hw-only algorithm */
>> +             if (info == NULL || !info->control.hw_key)
>> +                     return TX_DROP;
>
> info == NULL can't happen
I agree,

thanks,
Yoni
>
> johannes
>

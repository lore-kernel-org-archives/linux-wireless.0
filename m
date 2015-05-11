Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36457 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbbEKNdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 09:33:07 -0400
Received: by wizk4 with SMTP id k4so105757096wiz.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 06:33:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431349862.1964.28.camel@sipsolutions.net>
References: <1431349503-5461-1-git-send-email-michal.kazior@tieto.com>
	<1431349862.1964.28.camel@sipsolutions.net>
Date: Mon, 11 May 2015 15:33:05 +0200
Message-ID: <CA+BoTQmz0jL8CM6QobGPzQdmxR6JcaW=fm38E+J82f4dipTr8g@mail.gmail.com> (sfid-20150511_153312_214238_CF572522)
Subject: Re: [PATCH] mac80211: fix AP_VLAN crypto tailroom calculation
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 May 2015 at 15:11, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2015-05-11 at 13:05 +0000, Michal Kazior wrote:
[...]
>> +static bool
>> +ieee80211_need_crypto_tx_tailroom(struct ieee80211_sub_if_data *sdata)
>> +{
>> +     struct ieee80211_sub_if_data *parent_sdata;
>> +
>> +     if (sdata->crypto_tx_tailroom_needed_cnt)
>> +             return true;
>> +
>> +     if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN && sdata->bss) {
>> +             parent_sdata = container_of(sdata->bss,
>> +                                         struct ieee80211_sub_if_data,
>> +                                         u.ap);
>> +             if (parent_sdata->crypto_tx_tailroom_needed_cnt)
>> +                     return true;
>> +     }
>> +
>> +     return false;
>> +}
>> +
>>  static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
>>                               struct sk_buff *skb,
>>                               int head_need, bool may_encrypt)
>> @@ -1600,7 +1619,7 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
>>       struct ieee80211_local *local = sdata->local;
>>       int tail_need = 0;
>>
>> -     if (may_encrypt && sdata->crypto_tx_tailroom_needed_cnt) {
>> +     if (may_encrypt && ieee80211_need_crypto_tx_tailroom(sdata)) {
>
> This makes that check far more inefficient - I think you should write it
> differently and have the management code copy the value to the VLAN
> interfaces so the existing check here is sufficient.

I didn't want to pre-optimize but you're probably right. I'll look
into it more. Thanks!


Michał

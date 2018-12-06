Return-Path: <SRS0=7mY+=OP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A86C04EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 21:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF96D2081C
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 21:16:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="jrVfhXBP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF96D2081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbeLFVQt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Dec 2018 16:16:49 -0500
Received: from 6.mo1.mail-out.ovh.net ([46.105.43.205]:41775 "EHLO
        6.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbeLFVQs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Dec 2018 16:16:48 -0500
Received: from player711.ha.ovh.net (unknown [10.109.160.253])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id 4A422145B6C
        for <linux-wireless@vger.kernel.org>; Thu,  6 Dec 2018 17:27:05 +0100 (CET)
Received: from awhome.eu (p57B7EDEA.dip0.t-ipconnect.de [87.183.237.234])
        (Authenticated sender: postmaster@awhome.eu)
        by player711.ha.ovh.net (Postfix) with ESMTPSA id F2F838730E7;
        Thu,  6 Dec 2018 16:27:03 +0000 (UTC)
Subject: Re: [RFC PATCH v2 2/2] mac80211: Add support for Extended Key ID
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1544113623;
        bh=C6e8wg8ouzV7iYywAEJ0TfossPSVcUncKIhCrKBbzJM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=jrVfhXBPkXtg93soumeyKGZ6+LnsqrWzMLQws5N7hWqWYwDWRIlRMnXUFV1sTIRRt
         gkFh1j/XJ5v82/2Ix3Qxk72WQEHNNgSfyZaDsKbGr9+Exf6B6mUFMtkpUY4o+hSKSF
         JMb1OqVw1CEYWrMG8jJhJiL5wC2Q9PgLzHuk9YKk=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20181111110235.14213-1-alexander@wetzel-home.de>
 <20181111110235.14213-3-alexander@wetzel-home.de>
 <24665c3e0e7e970eb8cd63dad57e2b0b3097cfcc.camel@sipsolutions.net>
 <d20b43fc-408c-d3fb-75b2-9c2bffd37264@wetzel-home.de>
 <61c9ed7fc16517991cda3c9d930b53c24306234e.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <cb55102c-456c-3aea-44c2-cd9d0ebc3c3e@wetzel-home.de>
Date:   Thu, 6 Dec 2018 17:27:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <61c9ed7fc16517991cda3c9d930b53c24306234e.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 5609514814210448583
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudefjedgkeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> 
>>>> -	/* PTK only using key ID 0 needs special handling on rekey */
>>>> -	if (new_key && sta && ptk0rekey) {
>>>> +	/* PTK rekey without Extended Key ID needs special handling */
>>>> +	if (new_key && pairwise && sta &&
>>>> +	    !test_sta_flag(sta, WLAN_STA_EXT_KEY_ID)) {
>>>>    		local = old_key->local;
>>>>    		sdata = old_key->sdata;
>>>
>>> This seems wrong, even if you have ext key ID support and everything,
>>> but you do 0 -> 0 rekeying, then you still need all the special handling
>>> (in fact also then if you go 1->1!). So it seems you'd instead want to
>>> see if you're going from a TX key to a TX key with the same key ID, and
>>> then you don't need this flag at all.
>>>
>>
>> The intention for Extended Key ID is, to have a comparable short time
>> frame where both key IDs can be used. When replacing e.g. key ID 0 again
>> it should be idle for a long time. I guess if someone starts re-keying
>> in 1s intervals it may become an issue, but then anyone re-keying that
>> often can't be helped...
> 
> Sure. But ... not sure how that's related?
> 
>> With Extended Key IDs it's impossible to directly switch from a TX key
>> with one key ID to another one with the same id.
>>
>> 1) Association
>> 2) key ID 0 installed RX only
>> 3) key Id 0 set_tx
>> 4) rekey timeout passes
>> 5) key ID 1 installed RX only
>> 6) key ID 1 set_tx (also making key ID 0 RX only)
>> 7) rekey timeout passes
>> 8) key ID 0 replaced with new RX only key
>> 9) key ID 0 set_tx
>> 10) rekey timeout passes
>> ...
>>
>> So nobody will use the key being replaced, we don't have to protect
>> against PN poisoning.
> 
> Exactly.
> 
>> And when a driver supports Extended Key ID we
>> don't care about if the driver is able to rekey PTK0 correctly.
> 
> Strictly speaking, that's false, since you don't know if wpa_s actually
> used it, and the peer STA allowed it.
> 
> It's also not what you implemented, you implemented checking if
> NL80211_KEY_RX_ONLY was ever used.
> 
> However, what I'm trying to say is that I'm not sure this makes sense?
> 
> It seems to me it would be safer, and easier (no station flag), to just
> check
> 
>   if ("we're replacing the current TX key")
> 
> and trigger the workarounds in that case. No?
> 
> Yes, parts of the issue also manifest themselves on the RX side, but if
> you're not replacing the current key then you were using extended key ID
> support?
> 
Ah, now I get it:-)
Will try that out also.


>>>> +++ b/net/mac80211/sta_info.c
>>>> @@ -350,6 +350,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>>>>    	sta->sta.max_rx_aggregation_subframes =
>>>>    		local->hw.max_rx_aggregation_subframes;
>>>>    
>>>> +	sta->ptk_idx = NUM_DEFAULT_KEYS - 1;
>>>
>>> That makes no sense? Why should it be 3? That's invalid anyway?
>>
>> Yes, that's the whole reason for that change:-) Setting it to 2 would
>> also be fine, as long as it's not 0 or 1.
> 
> Hmm, ok. So that probably wants a big comment saying that it relies on
> key idx 2/3 being invalid. I'm not sure I like the NUM_DEFAULT_KEYS-1,
> better perhaps to do something like
> 
> 	/* comment saying why */
> 	BUILD_BUG_ON(ARRAY_SIZE(sta->ptks) > 2);
> 	sta->ptk_idx = 2;
> 
> or so?
> 
>> ieee80211_tx_h_select_key starts encrypting packets as soon as
>> sta->ptk[tx->sta->ptk_idx] is not null.
> 
> Right, so I guess this makes sense.
> 
> johannes
>Thank you very much for all the helpful tips and suggestions!

Alexander

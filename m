Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4A4C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 22:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B3232081B
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 22:05:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="na+Km/4z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B3232081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbeLEWFk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 17:05:40 -0500
Received: from 6.mo173.mail-out.ovh.net ([46.105.43.93]:55895 "EHLO
        6.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbeLEWFk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 17:05:40 -0500
Received: from player756.ha.ovh.net (unknown [10.109.160.93])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 11B95E4CA8
        for <linux-wireless@vger.kernel.org>; Wed,  5 Dec 2018 22:58:19 +0100 (CET)
Received: from awhome.eu (p57B7EDEA.dip0.t-ipconnect.de [87.183.237.234])
        (Authenticated sender: postmaster@awhome.eu)
        by player756.ha.ovh.net (Postfix) with ESMTPSA id 9C39B944036;
        Wed,  5 Dec 2018 21:58:17 +0000 (UTC)
Subject: Re: [RFC PATCH v2 2/2] mac80211: Add support for Extended Key ID
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1544047096;
        bh=6AuEtmHkJ5E1r8rnB40nvgEr2eMucjrbHXr7yBvv2Jc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=na+Km/4zZRRggQBcv8ShTed+w1JA5SlsIYx273DDGJaTyhE+DiMtIyZhxfoFvPRmQ
         4kasVfdvf5CNuIwjjANpKK3wdL485NLQ2sqaL7X3MabeSFOUytmJySC0l+WNukHRXT
         QXLGvCLAUXAMaDRymTCwhzmLqbJuaJy0yuThaqIc=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20181111110235.14213-1-alexander@wetzel-home.de>
 <20181111110235.14213-3-alexander@wetzel-home.de>
 <24665c3e0e7e970eb8cd63dad57e2b0b3097cfcc.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <d20b43fc-408c-d3fb-75b2-9c2bffd37264@wetzel-home.de>
Date:   Wed, 5 Dec 2018 22:58:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <24665c3e0e7e970eb8cd63dad57e2b0b3097cfcc.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 5330573111093107911
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudefhedgudehjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>> + * @IEEE80211_KEY_FLAG_RX_ONLY: Set by mac80211 to indicate that the key
>> + *      must not be used for TX (yet).
> 
> I'm not sure that's relevant, since you have one key pointer for TX?
> 
>> + * @IEEE80211_KEY_FLAG_SET_TX: Set by mac80211 to indicate that a previously
>> + *      installed key with IEEE80211_KEY_FLAG_RX_ONLY should take over TX also.
> 
> That also doesn't seem relevant ...
> 
> Oh, all of this is for HW offloads?
> 
> I _think_ I would prefer to have new key ops instead. Now you'd have
> 
> SET_KEY / <empty flags>
> SET_KEY / RX_ONLY
> SET_KEY / SET_TX
> 
> but I think maybe
> 
> SET_KEY
> SET_KEY_RX_ONLY
> KEY_ENABLE_TX
> 
> would make more sense?

Fine for me and should make it more understandable. So I'll try that.

> 
>> +	if (pairwise && params->flag == NL80211_KEY_SET_TX) {
>> +		mutex_lock(&local->sta_mtx);
>> +		sta = sta_info_get_bss(sdata, mac_addr);
>> +
>> +		if (!sta ||
>> +		   !(key = rcu_dereference(sta->ptk[key_idx])) ||
> 
> indentation here is off by one
> 
Thanks.

>> +		   !(key->conf.flags | IEEE80211_KEY_FLAG_RX_ONLY)) {
> 
> that makes no sense, should be & I guess
>
yes, I think that was one of the bugs I fixed the last weeks:-)


>> -	/* PTK only using key ID 0 needs special handling on rekey */
>> -	if (new_key && sta && ptk0rekey) {
>> +	/* PTK rekey without Extended Key ID needs special handling */
>> +	if (new_key && pairwise && sta &&
>> +	    !test_sta_flag(sta, WLAN_STA_EXT_KEY_ID)) {
>>   		local = old_key->local;
>>   		sdata = old_key->sdata;
> 
> This seems wrong, even if you have ext key ID support and everything,
> but you do 0 -> 0 rekeying, then you still need all the special handling
> (in fact also then if you go 1->1!). So it seems you'd instead want to
> see if you're going from a TX key to a TX key with the same key ID, and
> then you don't need this flag at all.
> 
The intention for Extended Key ID is, to have a comparable short time 
frame where both key IDs can be used. When replacing e.g. key ID 0 again 
it should be idle for a long time. I guess if someone starts re-keying 
in 1s intervals it may become an issue, but then anyone re-keying that 
often can't be helped...

With Extended Key IDs it's impossible to directly switch from a TX key 
with one key ID to another one with the same id.

1) Association
2) key ID 0 installed RX only
3) key Id 0 set_tx
4) rekey timeout passes
5) key ID 1 installed RX only
6) key ID 1 set_tx (also making key ID 0 RX only)
7) rekey timeout passes
8) key ID 0 replaced with new RX only key
9) key ID 0 set_tx
10) rekey timeout passes
...

So nobody will use the key being replaced, we don't have to protect 
against PN poisoning. And when a driver supports Extended Key ID we 
don't care about if the driver is able to rekey PTK0 correctly.


>> +++ b/net/mac80211/sta_info.c
>> @@ -350,6 +350,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>>   	sta->sta.max_rx_aggregation_subframes =
>>   		local->hw.max_rx_aggregation_subframes;
>>   
>> +	sta->ptk_idx = NUM_DEFAULT_KEYS - 1;
> 
> That makes no sense? Why should it be 3? That's invalid anyway?

Yes, that's the whole reason for that change:-) Setting it to 2 would 
also be fine, as long as it's not 0 or 1.

ieee80211_tx_h_select_key starts encrypting packets as soon as 
sta->ptk[tx->sta->ptk_idx] is not null.

So installing the first key as RX only will also activate the key for 
TX. the AP will therefore encrypt EAPOL #3 of the initial connect...

To avoid expensive run time checks I simply switched the default setting 
to make sure sta->ptk[tx->sta->ptk_idx] will be NULL at the initial key 
install.

Alexander






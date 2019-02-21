Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CACC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 21:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CDB620836
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 21:57:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="V/bf5yHR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfBUV47 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 16:56:59 -0500
Received: from 7.mo177.mail-out.ovh.net ([46.105.61.149]:48568 "EHLO
        7.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfBUV47 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 16:56:59 -0500
X-Greylist: delayed 1199 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2019 16:56:56 EST
Received: from player798.ha.ovh.net (unknown [10.109.159.20])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id A4E5DE18EF
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 22:20:17 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player798.ha.ovh.net (Postfix) with ESMTPSA id 570E230F6A26;
        Thu, 21 Feb 2019 21:20:16 +0000 (UTC)
Subject: Re: [RFC PATCH v3 05/12] mac80211: Mark A-MPDU keyid borders for
 drivers
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1550784015;
        bh=obkJ/JWWLYklj5powYUE/YyiNbBbcn2QpJeZR08YH+Q=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=V/bf5yHRw4So+MKAFckqTLJYNvIkBNKBcm2Kv2LkMBltyhyUHDu7ptdE07FKz80Hu
         ZuQTM34h8/WGBZ24iUmoXU92pgXz1qq+U7uSJ3qnhvHlGKIgfA0qmFj4l4gNrgnhq1
         Mrf92MzaegJbCkPwyhecAMP5Wb7aCgevViGR7EYI=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-6-alexander@wetzel-home.de>
 <c64a7a722fefe698e86dbc61ab4d6d2e087ae853.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <a4cf7a7a-104d-b685-8fd4-a9dfac97ecb9@wetzel-home.de>
Date:   Thu, 21 Feb 2019 22:20:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <c64a7a722fefe698e86dbc61ab4d6d2e087ae853.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 1590052147194567879
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrtdekgdduheduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am 15.02.19 um 12:50 schrieb Johannes Berg:
> 
>> The intent of the wording was probably written without considering
>> Extended Key IDs. At least it makes no sense for me to forbid mixing
>> MPDUs using keyid 0 and 1 in one A-MPDU.
> 
> I think it may make sense - reprogramming the hardware engines may take
> some time, and doing that in the middle of the A-MPDU may not be
> feasible? You don't just have to load the key (that you need to do
> anyway) but also extract the status? I dunno, I'm more handwaving, but
> it doesn't make sense to add such a requirement when only one key index
> can be used to start with.
> 

I'm pretty new to all that and I know I have still huge gaps everywhere.
But the card must be able to process MPDUs using both KeyIDs at that 
moment already. When receiving a A-MPDU it should not be very hard to 
check each MPDU and process it accordingly. (TX should even be simpler: 
The driver simply can decide if he want's to have a key border in the 
A-MPDU or not and switch to key when it wants.)

Forbidding to mix unicast with both keyIDs is adding an ugly overhead to 
an otherwise quite simple solution and adds complexity, at least for us 
here.
So while I would like to understand the reason for that rule it's still 
a rule and breaking it seems to be a bad idea.

>> The code is assuming that the driver is not aggregating MPDUs more than
>> 5s apart. We probably don't have wait nearly so long but I'm not sure
>> what is the minimum time.
> 
> OTOH, if you have a lot of BE/VI/VO traffic BK might be starved even
> longer than that, technically indefinitely.
> 

Hm, there is nothing preventing us to drop this "idle" switch as long as 
we also drop the 10s Rx accel offload when idle fallback in the COMPAT 
patch. (We have to drop the RX idle accel patch or get a small risk of 
dropping packets in unlikely but possible scenarios. If that are eapol 
packets things will become hairy, probably disconnecting the sta.)

It just feels strange to potentially still use the old key for one 
packet more without time limit. It could be, that the first EAPOL packet 
we send for the next rekey would still use the previous key, the second 
eapol packet the current.


>> +static struct ieee80211_key debug_noinline
>> +*ieee80211_select_sta_key(struct ieee80211_tx_data *tx)
>> +{
>> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
>> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
>> +	struct sta_info *sta = tx->sta;
>> +	struct ieee80211_key *key;
>> +	struct ieee80211_key *next_key;
>> +
>> +	key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx]);
>> +
>> +	if (likely(sta->ptk_idx_next == INVALID_PTK_KEYIDX))
>> +		return key;
>> +
>> +	/* Only when using Extended Key ID the code below can be executed */
>> +
>> +	if (!ieee80211_is_data_present(hdr->frame_control))
>> +		return key;
>> +
>> +	if (sta->ptk_idx_next == sta->ptk_idx) {
>> +		/* First packet using new key with A-MPDU active*/
>> +		sta->ptk_idx_next = INVALID_PTK_KEYIDX;
>> +		ieee80211_check_fast_xmit(tx->sta);
> 
> I'm not convinced you can call this from this context? It looks safe
> though, but it's really strange in a way.
> 

Well, it's seems to work fine, no warnings or problems so far:-)

But I also had doubts and only after finding out that 
ieee80211_check_fast_xmit() is already being called from the same 
context I dared to use it, see ieee80211_tx_prepare().

>> +	info->flags &= ~IEEE80211_TX_CTL_AMPDU;
> 
> Like you say above, I don't think this really makes a lot of sense. If
> we don't have any free bits I guess we should try to find some ...

Well, all I can think of is quite invasive, so I hoped you would have a 
better idea:

Move the flags out from CB and use the freed space for a pointer to the 
new construct.
That will touch a ton of code and slow down things a bit.

The question here also would be, if we should use a struct able to 
handle other extensions or just a long long for flags.

If it comes to that I would propose to merge the other patches up to 
this one and then start looking into that...

Alexander


Return-Path: <SRS0=o7U+=Q6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F99C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 17:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C48EE20663
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 17:26:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="c4/lq3eu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfBWR0T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Feb 2019 12:26:19 -0500
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:39863 "EHLO
        19.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfBWR0S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Feb 2019 12:26:18 -0500
Received: from player157.ha.ovh.net (unknown [10.109.159.68])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id EF6B115C960
        for <linux-wireless@vger.kernel.org>; Sat, 23 Feb 2019 18:26:14 +0100 (CET)
Received: from awhome.eu (p57B7E5A0.dip0.t-ipconnect.de [87.183.229.160])
        (Authenticated sender: postmaster@awhome.eu)
        by player157.ha.ovh.net (Postfix) with ESMTPSA id A7D2F2F31B6E;
        Sat, 23 Feb 2019 17:26:13 +0000 (UTC)
Subject: Re: [RFC PATCH v3 03/12] mac80211: IEEE 802.11 Extended Key ID
 support
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1550942772;
        bh=6PovUQmVEqrjUJvi8LSYN8iFSU00aX4PJzFby63WhK0=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To;
        b=c4/lq3euVhlQXMId+I4qsNU/tiQcEFH3z/4ZHUPArpRc0ovo6V3VqiicWvQ5a4Lnz
         KD4flOcGCRbrDNEUpIS5K6CuWatpsltwQ8sML4SviqHakeM+g/K+2Z3erDy/+s/n9N
         ytlHXayxnQrk/9yVwa8zvTsRpjNf/oahBVyty0UQ=
From:   Alexander Wetzel <alexander@wetzel-home.de>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-4-alexander@wetzel-home.de>
 <f4d8db23bc3804fdc98f2ce7a702215bd82fd4e3.camel@sipsolutions.net>
 <e27bffe8-4c75-34d9-b326-39ffb05b73eb@wetzel-home.de>
 <171d2db4-7639-4738-2a6d-c899f0247aee@wetzel-home.de>
Message-ID: <f3c2a4ad-0019-60c7-be09-d52a8b137efa@wetzel-home.de>
Date:   Sat, 23 Feb 2019 18:26:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <171d2db4-7639-4738-2a6d-c899f0247aee@wetzel-home.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 9382686877008796871
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddruddvgddutddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


>>>
>>>> +    sta = sta_info_get_bss(sdata, mac_addr);
>>>> +
>>>> +    if (!sta)
>>>> +        return -EINVAL;
>>>> +
>>>> +    if (sta->ptk_idx == key_idx)
>>>> +        return 0;
>>>> +
>>>> +    mutex_lock(&local->key_mtx);
>>>> +    key = key_mtx_dereference(local, sta->ptk[key_idx]);
>>>> +
>>>> +    if (key && key->flags & KEY_FLAG_RX_ONLY)
>>>
>>> do you even need the flag? Isn't it equivalent to checking
>>>     sta->ptk_idx != key->idx
>>> or so?
>>>
>>> Less data to maintain would be better.
>>
>> I have to look at that again. It will change some assumptions for sure 
>> but still could work out with some slight differences. I'll have to 
>> look deeper into that since I remember two moments where I was sure 
>> needing the flag. That may well be outdated, but at a first glance it 
>> would at least open the door to first install two key in legacy mode 
>> and then switch between them. (Which should be no problem, of course)
>> I'll follow up on that separately, but that may take some time. When 
>> it works you'll get a new RFC.

I gave that a closer look today and tried to get rid of 
KEY_FLAG_RX_ONLY. It looks like it could work, but only with a 
(pointless looking) trade off:

The problem is the initial key install. Normal and Extended Key Installs 
both call ieee80211_add_key() and the function has to "mark" either the 
key or the sta to be using Extended Key ID so we later know if we have 
to activate Tx for the key or not.

Without that ptk_idx will still be set to INVALID_PTK_KEYIDX in either 
case and therefore useless. ieee80211_key_replace() will then have no 
way to figure out if it must set ptk_idx and activate the key for TX or 
not.

Both checking a key Flag (for RX only) or a station flag (for Extended 
Key ID being used) would solve the problem but I do not see an good way 
to do it without one or the other.

Now we could of course use some other existing variable like setting 
ptk_idx to INVALID_PTK_KEYIDX+1 in ieee80211_add_key(). But it still 
would be some kind of flag, only stored where nobody would expect it...

Storing the information with the key simplifies the delay tailroom 
handling a bit but I think I can get that operational with a station 
flag for Extended Key ID also. But for me that trade off looks pointless..

I can of course go ahead if you see some benefit or other way ahead...
But I would pull the plug on the plan to get rid of RX_Only Key flag 
with that.

Alexander

Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A39AC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 23:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD29F206C0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 23:05:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="n9tGLr1U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfBVXFB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 18:05:01 -0500
Received: from 18.mo3.mail-out.ovh.net ([87.98.172.162]:42336 "EHLO
        18.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfBVXFA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 18:05:00 -0500
Received: from player750.ha.ovh.net (unknown [10.109.143.209])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id A29E01FBB66
        for <linux-wireless@vger.kernel.org>; Sat, 23 Feb 2019 00:04:56 +0100 (CET)
Received: from awhome.eu (p57B7E5A0.dip0.t-ipconnect.de [87.183.229.160])
        (Authenticated sender: postmaster@awhome.eu)
        by player750.ha.ovh.net (Postfix) with ESMTPSA id 0EE9331A73EF;
        Fri, 22 Feb 2019 23:04:54 +0000 (UTC)
Subject: Re: [RFC PATCH v3 02/12] nl80211/cfg80211: Extended Key ID support
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1550876693;
        bh=ooPPKluiKmNqzjnKGl1eZYUKD3lTAUQ1P6/gfv568Q8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=n9tGLr1U20tfeStJ7YJJX8+FPS+zxdd9JNoDKO3n0NrWKk5C65mkkNr6R3/WUBxax
         pGHwsPU2KPwEgV5iAx7ifRxujm0U75DiVHu298lQfZErDyzGTDmw9jBe2CJMb+wPud
         sWaiDgyOIcEWO+gBUL4NBWBLsM8zsGLRhGiSqkJ8=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-3-alexander@wetzel-home.de>
 <790f69239a9635c62c9349323c069e4ac9ad51c9.camel@sipsolutions.net>
 <a0e99ac4-4c10-55e6-3ded-5bb5a3ddfb78@wetzel-home.de>
 <7377d6a44d9238e90f9bde55bc96cdecb3a4e25a.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <2a2d4f6c-e220-ba2b-cbb9-191afdd0e888@wetzel-home.de>
Date:   Sat, 23 Feb 2019 00:04:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <7377d6a44d9238e90f9bde55bc96cdecb3a4e25a.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 9230127438849318087
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddruddtgddujedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



Am 22.02.19 um 09:30 schrieb Johannes Berg:

>> With Extended Key ID we stick to a similar approach: NL80211_CMD_NEW_KEY
>> is called to install the new key and nl80211_key_install_mode allows to
>> select between a "legacy" or "extended" key install: NL80211_KEY_RX_TX
>> for "legacy" or NL80211_KEY_RX_ONLY for "extended".
> 
> Ah. That's where the "EXT" came from in the mac80211 names :-) FWIW, I'm
> not sure that makes sense. Yes, we think of it as an "extension" or
> being "extended" now while we work on it, but ultimately it'll be a
> simple part of the API. But I digress.

"EXT" is only intended to be the short form for "Extended Key ID for 
Individually Addressed Frames" from IEEE 802.11 - 2016 and not as 
"extension for nl80211/mac80211".

>> NL80211_KEY_SWITCH_TX is only allowed with NL80211_CMD_SET_KEY and is
>> the only Extended Key ID action allowed for that function.
> 
> Yes, but what does it *do*? Your documentation said:
> 
> 	Switch Tx to a Rx only, referenced by sta mac and idx.
> 
> but that seems backwards to me based on the above requirement:
> 	Allow a key to be used for decryption first and switch it to a
> 	"normal" Rx/Tx key with a second call.
> 
Ah, now I see your point!

I'm viewing a Rx only key as something different, a new "key group" like 
the existing broadcast or unicast key groups. (Which btw. also why I 
have a problems to not have a key marked as such.)

"Switch TX" was intended to bring across, that the Tx status would 
switch from the "other" key to the referenced one. (That's also the 
reason I did not want to use ENABLE_TX.)

Or in other words:
Make a potential existing RX/TX key to a RX only key and the current Rx 
only key to the RX/Tx key. The key referenced by sta and mac must be 
flagged Rx only or the command will have no effect/fail. (The last 
requirement would vanish when we drop the Rx_Only key flag.)

> IOW, you said we need to have the ability to first install RX-only, and
> then switch the key to RX & TX. I'd have called this "ENABLE_TX" or
> something like that. Or perhaps SWITCH_(ON_)TX if you're so inclined,
> but the documentation should then say
> 
> 	Switch key from RX-only to TX/RX, referenced by ...
> 
> no? That's what I meant by "the other way around".

What do you think about:
	Switch key referenced by referenced by sta mac and idx from RX-
	only to RX/TX and make any other RX/TX key for the sta a RX-only
	key.

> 
>> Any non-pairwise keys can only use NL80211_KEY_RX_TX which is of course
>> always the default and also allowed for "legacy" pairwise keys.
> 
> Right.
> 
>> A Extended Key Install will:
>> 1) call NL80211_CMD_NEW_KEY with all the usual parameters of a new key
>> install plus the flag NL80211_KEY_RX_ONLY set.
> 
> So far makes sense.
> 
>> 2) Once ready will call NL80211_CMD_SET_KEY with flag
>> NL80211_KEY_SWITCH_TX to activate a specific key.
> 
> Also makes sense, but the documentation doesn't.
> 
> I think we should rename these perhaps
> 
> 	NL80211_KEY_RX_TX - install key and enable RX/TX (default)
> 	NL80211_KEY_RX_ONLY - install unicast key for RX only
> 	NL80211_KEY_ENABLE_TX - enable TX for a previously installed
> 				RX_ONLY key
> 
> I think?
> 
> About the ENABLE_TX vs. SWITCH_TX - we don't allow to switch TX *off*
> again, only *on*, so I think "enable" makes more sense than "switch".
>
See above. NL80211_KEY_ENABLE_TX would also implicit disable Tx for the 
"other" pairwise key (if present). Mac80211 e.g. evaluates delay 
tailromm for both keys again and always reduces it for the Rx only key 
when it was set and even sets the RX_only flag again.

That said I'm happy with any of these:
	NL80211_KEY_ENABLE_TX
	NL80211_KEY_SWITCH_TX
	NL80211_KEY_MOVE_TX

After that discussion I'm now wondering if we maybe should change the 
naming more fundamentally, similar to what I proposed for mac80211:

	NL80211_KEY_SET - install key and enable RX/TX (default)
	NL80211_KEY_EXT_SET add unicast key for Extended Key ID
	NL80211_KEY_EXT_ENABLE - Set the key referenced by
		sta mac the to the preferred TX key for sta

Here it would be nice to be able to use "NL80211_EXT_KEY_", but that 
would break the naming schema quite badly. And using 
NL80211_KEY_EXT_KEY_ looks also confusing...

Any preferences or other options? I think you have now all details about 
that and whatever looks best for you is it now.

> Anyway, my whole comment was only about the documentation text which
> seemed backward or at least unclear to me.
>
I did not see that when coming from understanding the code to writing 
comments/documentation. Chances are other readers will interpret that 
like  you did and not as intended... And the area is complex enough 
without those misunderstandings.

>> ok, I'll remove all the drive-by comment "cleanups".
>> It (often) looks kind of untidy and not really worth separate patches
>> and I'm kind of responsible for (most) of them.. I see why you don't
>> want to see those fixed drive-by...
>>
>> My understanding is now that we prefer to not change those and I'll
>> leave them alone.
> 
> I have no objection to even the most trivial cleanup patches going in
> separately, and if you like multiple in a bigger "clean up this area"
> patch, but here I think it detracts from the patch.
> 
I understand.
Honestly I would feel silly to put most of the drive-by changes into a 
dedicated patch and not worth the time for a review.
So I guess I'll only do separate patches if I really care about the 
format/comment in future:-)


Alexander


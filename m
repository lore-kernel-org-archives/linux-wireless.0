Return-Path: <SRS0=o7U+=Q6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57953C4360F
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 23:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6CC620661
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 23:29:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="LGeKzGn5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbfBWX1J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Feb 2019 18:27:09 -0500
Received: from 2.mo4.mail-out.ovh.net ([46.105.72.36]:39453 "EHLO
        2.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfBWX1J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Feb 2019 18:27:09 -0500
X-Greylist: delayed 1199 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Feb 2019 18:27:06 EST
Received: from player774.ha.ovh.net (unknown [10.109.160.40])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 7227C1D6D4A
        for <linux-wireless@vger.kernel.org>; Sat, 23 Feb 2019 23:50:19 +0100 (CET)
Received: from awhome.eu (p57B7E5A0.dip0.t-ipconnect.de [87.183.229.160])
        (Authenticated sender: postmaster@awhome.eu)
        by player774.ha.ovh.net (Postfix) with ESMTPSA id 2785530047AC;
        Sat, 23 Feb 2019 22:50:18 +0000 (UTC)
Subject: Re: [RFC PATCH v3 04/12] mac80211: Compatibility Extended Key ID
 support
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1550962217;
        bh=MexGk4lRDoc0vTzBMrmTRimFbMK3VindmMbHSYHyahw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=LGeKzGn52Qbi6uAL3vJvxdp3DX0jJE7wBPL3YB3Cy/qMTSnW0PhizQw3/jfLKgcja
         BKUKUFYGp4pmJsRVqb9Y2ZI1wlEpmxN6e0NxkFJYy9MywE9XBtDKC5AEFkVGPrUwOh
         MWYAm1rrxLfWLHkI+OFc2K2NAKJ5xzLo/D+5syc0=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-5-alexander@wetzel-home.de>
 <0519f25cf73d8a91202e40b08e94de8d2520411e.camel@sipsolutions.net>
 <bad49ffb-5334-03f5-62e0-4f06d7c36242@wetzel-home.de>
 <b963b4257bba8b5423b93dd58c5828604fc07df4.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <028ee74c-0a34-44a6-d11b-f8a37706d86e@wetzel-home.de>
Date:   Sat, 23 Feb 2019 23:50:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <b963b4257bba8b5423b93dd58c5828604fc07df4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 14855967797681528007
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddruddvgdduieelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Thu, 2019-02-21 at 21:07 +0100, Alexander Wetzel wrote:
>>>
>>>> +	if (!ext_native && key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
>>>> +		key->flags |= KEY_FLAG_RX_SW_CRYPTO;
>>>> +		/* Activate Rx crypto offload after max 10s when idle */
>>>> +		ieee80211_queue_delayed_work(&local->hw, &sta->ext_key_compat_wk,
>>>> +					     round_jiffies_relative(HZ * 10));
>>>> +	}
>>>
>>> Is there much point in this?
>>>
>>>> +		if (unlikely(rx->key->flags & KEY_FLAG_RX_SW_CRYPTO)) {
>>>> +			rx->key->flags &= ~KEY_FLAG_RX_SW_CRYPTO;
>>>> +			cancel_delayed_work(&rx->sta->ext_key_compat_wk);
>>>> +			ieee80211_queue_delayed_work(&rx->local->hw,
>>>> +						     &rx->sta->ext_key_compat_wk, 0);
>>>> +		}
>>>
>>> We'll almost certainly do it from here, so never exercise the other
>>> path?
>>
>> This is mostly to have a definite time we know the new key is used also
>> for RX. In probably 99.9% of all cases it will be triggered from the Rx
>> path.
>> Some special purpose devices may not send any packets for a long time
>> and trigger the fallback, as (wrong) firewall rules. (I've e.g. tested
>> it by dropping all outgoing packets on the remote sta.)
>>
>> The idea was to be sure that a rekey intervall >10s prevents activating
>> Rx crypt when rekeying the next key. Which now sounds kind of thin...
> 
> Not sure I even understand this?
> 
> You meant "Rx crypto offload"? I'm not really sure we _care_ that much?
> 
> Then again, an issue may be that some firmware may want (need) the keys
> for RX so it can look at certain frames (action frames?) itself. So if
> we never install the RX key and then only get an action frame that the
> firmware should handle, we lose. Such firmware could not support COMPAT
> mode then I guess, which may mean a bunch of iwlwifi devices shouldn't
> use COMPAT mode.

We still seem to have a problem understanding each other here. That 
sounds like something we have to sort out with the RFC patch series to 
avoid bad surprises later... It's probably nothing, but here we go:-)

First, COMPAT drivers must not have any key installed for Rx offload in 
Hw. Any active Rx key will be changed to a Tx only key with mac80211 
taking over the Rx decryption in software.

That is bad, weak CPU devices asked to take over decryption will be not 
able to handle the same load as with HW. (My test router can't and with 
Sw crypto I'm around 20MBit/s slower. The router even become 
unresponsive on a shell when stressing it in a quick test some weeks 
ago, with a single client uploading.)

So we try to handle as few packets as possible with SW crypto and as 
soon as we see a packet encrypted with the new key activate Rx crypto 
with the new key again. Any packets send with the old key after that are 
very likely mangled by the Rx crypto offload and lost and part of the 
price we have to pay for being able to use extended Key ID with cards 
never designed for it and at least with traffic between ath9k/iwldvm not 
an issue at all.

But it's of course all that is irrelevant when we are no packets to 
decrypt and the code sample above starting the discussion. That is 
handling a very rare corner case I reproduced by dropping all outgoing 
packets with iptables on the remote station. EAPOL packets of course 
don't care about iptable rules and the key could still be rekeyed, but 
EAPOL frames were the only traffic possible and since the handshake 
still use the outgoing key the receiving station never got a packet 
encrypted with the new key, preventing it to activate Rx offload. So 10s 
after the rekey the "fallback" mechanism kicked in.

Not installing the Rx key after 10s as a fallback has no real downsides, 
it only may break the assumption of someone debugging a problem that at 
10s after we installed the key to mac80211 the Hw crypto will be active 
again.
Without the fallback it's just something like extremely likely and may 
be not true in unusual setups or for problems affecting the Rx path.

Long story short, if you don't like the fallback activating mechanism 
for no Rx packets seen we can simply drop it.

As you said it's a rare case and not handling it only chances what you 
assume from what you know for sure during debugging of a problem.

Management Frame crypto is not affected by COMPAT mode workarounds or 
even by Extended Key ID at all, or I have a big flaw in my understanding:

Managment frames (802.11w) and for my understanding therefore also 
action frames do not use the keys PTK keys (IDs 0+1) but 4+5 and never 
touch the QoS MPDUs Extended Key ID is all about.

But after figuring that much out I ignored it...

Alexander




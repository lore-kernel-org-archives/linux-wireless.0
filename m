Return-Path: <SRS0=o7U+=Q6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6E5C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 21:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B072520855
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 21:47:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="u42qyKB1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfBWVrn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Feb 2019 16:47:43 -0500
Received: from 10.mo173.mail-out.ovh.net ([46.105.74.148]:46681 "EHLO
        10.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfBWVrn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Feb 2019 16:47:43 -0500
X-Greylist: delayed 89810 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Feb 2019 16:47:41 EST
Received: from player739.ha.ovh.net (unknown [10.109.160.39])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id C53BCEA113
        for <linux-wireless@vger.kernel.org>; Sat, 23 Feb 2019 22:47:39 +0100 (CET)
Received: from awhome.eu (p57B7E5A0.dip0.t-ipconnect.de [87.183.229.160])
        (Authenticated sender: postmaster@awhome.eu)
        by player739.ha.ovh.net (Postfix) with ESMTPSA id 825653249691;
        Sat, 23 Feb 2019 21:47:38 +0000 (UTC)
Subject: Re: [RFC PATCH v3 05/12] mac80211: Mark A-MPDU keyid borders for
 drivers
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1550958457;
        bh=QSNPug9i+XNhRKqmq61Nx2+Ee29qBUDLr3X4pCufkAc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=u42qyKB1QJonFgU2Fg2Y3aGpIupioFa1p0t11b2hGTgEa/1p+KW3+BqIGeslsdcnd
         BVTqJmGKPWnmHcq6zAPv3x0rmU2X4pv0zxkfbzTT7NxBD5i115078skgQ4UIpWWE/S
         FWpqoCT1uAu8Hm+Rl2DmVnOkXIPfc/nHnlnV5xzc=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-6-alexander@wetzel-home.de>
 <c64a7a722fefe698e86dbc61ab4d6d2e087ae853.camel@sipsolutions.net>
 <a4cf7a7a-104d-b685-8fd4-a9dfac97ecb9@wetzel-home.de>
 <fbe9234012f91ba6a209f426e95a284f482554c1.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <cb65932d-118c-5f1e-d001-36907238ea68@wetzel-home.de>
Date:   Sat, 23 Feb 2019 22:47:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <fbe9234012f91ba6a209f426e95a284f482554c1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 13797621886936751303
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddruddvgdduheeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


>>>> The code is assuming that the driver is not aggregating MPDUs more than
>>>> 5s apart. We probably don't have wait nearly so long but I'm not sure
>>>> what is the minimum time.
>>>
>>> OTOH, if you have a lot of BE/VI/VO traffic BK might be starved even
>>> longer than that, technically indefinitely.
>>>
>>
>> Hm, there is nothing preventing us to drop this "idle" switch as long as
>> we also drop the 10s Rx accel offload when idle fallback in the COMPAT
>> patch. (We have to drop the RX idle accel patch or get a small risk of
>> dropping packets in unlikely but possible scenarios. If that are eapol
>> packets things will become hairy, probably disconnecting the sta.)
>>
>> It just feels strange to potentially still use the old key for one
>> packet more without time limit. It could be, that the first EAPOL packet
>> we send for the next rekey would still use the previous key, the second
>> eapol packet the current.
> 
> Not sure I understand this. If we have no TX going on at all, then
> surely we can switch with the next packet, before we encrypt it?

Well, yes. But how can we figure out we are indeed idle?
(Chances are there is something and I missed it, I've not even look at 
many subsystems in mac80211 and probably even don't know some of them 
exist...)

The driver/card must have given up on waiting for more frames to 
aggregate and send out whatever it had in the queue.

You just told me above that a card may keep a partially assembled A-MPDU 
in the buffer for >5s if we have higher priority traffic... That was my 
idea to just handle it time-based with an insane but still ok long time.

Checking if all higher priority TIDs are idle sounds complicated and we 
still must know when the driver/card gives up and send out the bufferd 
frames even if the A-MPDU is not full. That does not make the idea to 
handle it time-based any simpler...

I'm not even sure it makes much sense to send out packets with 5s delay 
at all, tcp will already have queued retransmitts and for udp the frames 
are either also considered to be lost by the application or we don't 
care about them any more.

So yes, we can switch Tx to the new key immediately when we are sure the 
driver/card has no A-MPDU "in aggregation" at that time. I guess we can 
add a call the driver, asking it to tell us if a TID is idle, which also 
sounds complicated. So I guess I just would send the "key border" signal 
even when idle and accept that this can in corner cases use different 
keys for even and odd EAPOL frames.


>>>> +	info->flags &= ~IEEE80211_TX_CTL_AMPDU;
>>>
>>> Like you say above, I don't think this really makes a lot of sense. If
>>> we don't have any free bits I guess we should try to find some ...
>>
>> Well, all I can think of is quite invasive, so I hoped you would have a
>> better idea:
> 
> I think we have free bits in enum mac80211_tx_control_flags, so that
> should be workable? They won't be preserved until TX status, but that's
> OK for this purpose, no?

Wonderful idea:-)
I'll rewrite drop you a new patch revision with all the other changes we 
discussed (or are still discussing).

If nothing new pops up - either in our discussions or when rewriting the 
key border signal - I would drop RFC from the next patch series all the 
POC patches after this one so we can focus on the merge relevant defects.

Alexander

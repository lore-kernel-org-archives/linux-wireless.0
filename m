Return-Path: <SRS0=tIsG=Q7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6F1C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 13:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB49720663
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 13:04:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="BUWqCI+o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfBXNEN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Feb 2019 08:04:13 -0500
Received: from 3.mo1.mail-out.ovh.net ([46.105.60.232]:33113 "EHLO
        3.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbfBXNEN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Feb 2019 08:04:13 -0500
Received: from player716.ha.ovh.net (unknown [10.109.146.1])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id 3565E15BA43
        for <linux-wireless@vger.kernel.org>; Sun, 24 Feb 2019 14:04:08 +0100 (CET)
Received: from awhome.eu (p57B7E5A0.dip0.t-ipconnect.de [87.183.229.160])
        (Authenticated sender: postmaster@awhome.eu)
        by player716.ha.ovh.net (Postfix) with ESMTPSA id 2380D2F4A135;
        Sun, 24 Feb 2019 13:04:06 +0000 (UTC)
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1551013445;
        bh=BZLa0c8Q59JlZ9M9G8rPZCF+XirEUKHezfGa0Ihwhyg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=BUWqCI+oDwbchfDvGu5Na0XnYwBftJhMsqVaOa4fN3JSIsj2Aits544MR61VoJJ6X
         u4tSU8UVnuYm27HLW7ebzNm5LrVQtFaoiin8zrSzlQhzxr5Kjiss6ZMI/cmJPg0BOh
         zq5VWEzpldw7DvLH7VneQ2DbQKh1WhctzORAnepI=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-8-alexander@wetzel-home.de>
 <1a3b6e515c73a2c185e8dad84ab2ebfd8982a6ce.camel@sipsolutions.net>
 <e84c30de-28d6-7d1b-0fa3-d1ca466e257b@wetzel-home.de>
 <69e6577f90d99289acaa9853fe236e6f15f9e774.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <14c9d8f7-7cf6-d7e1-a1c0-9f1a10920d4e@wetzel-home.de>
Date:   Sun, 24 Feb 2019 14:04:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <69e6577f90d99289acaa9853fe236e6f15f9e774.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10828905305824697543
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrudeggdegkecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>>   and I've had some time to improve my test setup and
>> hopefully have better access to a mvm card for testing.
> 
> If all that's lacking is a few NICs then I'm sure we/I can help out with
> that :)
> 

Thanks, but as you suspected the NICs are the smallest problem...

I've simply delayed setting up a good lab far too long. So prior to 
shifting the focus to drivers I have to remedy that somehow.
Not really relevant here, but if you want to know what I plan for the 
future here my thoughts on it. If not you better skip that section:-)

Current plan is, to get one (ideally two, depending on price) mini PCs 
(amd64) with m.2 slots, good antennas and one or two matching Intel AC 
9260 cards.

Additionally I want to get rid of the whitelist in my development 
notebook by flashing coreboot, opening the path to install a minipci to 
m.2 adapter mount a second/third Intel 9260 card.

The core boot flash rollout is imminent, just do not want to risk the 
system by soldering wires to the mainboard till the generic support is 
sorted out. If that goes wrong I could brick my main system and lose 
access to my dvm card, but no risk no fun:-)

With that setup and using AC-9260 in all devices I'll have near-perfect 
setup to test and observe AC-9260 and can simply swap out cards to test 
and and maybe also get working after (hopefully) getting AC-9260 
Extended Key ID "certified" as reference implementation.
With three stations I can then try my hand at the still open mesh 
support for Extended Key ID, but that should wpa_supplicant only.

That said the initial heavy lifting is done. I'm still amazed I get that 
off the ground and working end2end with comparable ease. While there is 
still much work left the structures are all in place and it's now mainly 
closing the gaps.

I currently plan stick to the project a bit langer getting at least some 
intel cards and ath9k working, finalize the already existing Extended 
Key ID and PTK0 rekey patches and also update wireshark again.

I suspect I'll need at least one year for that in the best case, 
potentially much longer.

I already have three bugs/issues flagged for analysis. Nothing really 
relevant for the generic support but all three itching enough I'll plan 
to look into them:
1) Wrong time stamps with at least iwlwifi when using monitor in 
parallel to the normal connection for outgoing MPDUs (probably mac80211 
issue, )
2) Probably: Wpa_supplicant scan list is flushed too often, preventing 
fast reconnects
3) Wireshark can't handle Extended Key IDs decoding (and decoding should 
get at least some other generic improvements

Chances are I'll be busy with coreboot for some time and then 
finding/setting up some mini PC(s). That's nothing I've had any need for 
so far and suitable systems with M.2 slots with at least two external 
antennas are hard to find. (So I may end up mounting external antennas 
to the system myself.)

To continue I primarily need another Extended Key ID AP, ideally able to 
support NATIVE and COMPAT mode. Having a second device (or maybe just 
second M.2 card in the same one?) for sniffing nice.

Finding a really good sniffer able to also capture A-MPDU frames 
including control frames would be awesome. All the so-called good 
sniffing USB sticks I got my hands on crap even for sniffing normal 
frames compared to my built-in dvm card nobody seems to suggest for 
sniffing...
Full-speed sniffing to observe a rekey during load is hardly a common 
use case and I suspect usb interface alone an indication the card won't 
be able to handle it well. And some things like the cleartext packet 
leaks only becomes visible at higher speeds. (Which btw also need a 
follow up. My crypt skills are not the best, but with my current 
understanding I'm quite sure a retransmit of a previously encrypted 
frame in the clear text gives away the TK key for all other frames 
encrypted with the same TK.)

So plenty of work and reason to get a better test environment set up:-)

I hope the newer mvm cards will be as good as my old mvm card and when 
using the same card in the AP, sta and sniffer able to get basically 
every frame as long as the sniffer has the best antennas.

If someone here has a suggestion what works for I would appreciate some 
pointers here:-) Don't want sink too much money at it but if it's 
something around 300€ or so I could simply start with one and decide 
later if I really need a second one. Non-amd64 systems would also be ok, 
but it must at least work with vanilla kernels and something like 
Debian. I'm wasted enough time of porting my patches for each test and 
keep them in sync.

If someone is willing to donate a suitable test system I would not say 
no, but I'll plan to finish that with private funds also.

I probably should work on the new AP, but then I always wanted to test 
coreboot and finding out my notebook is now supported is too alluring to 
resist;-)


>>>> I also have tested patch for iwldvm using the Compat mode and I think
>>>> mvm cards will also work with that.
>>>
>>> No they don't, no firmware is available for that.
>>
>> So far I only looked at the dvm part of iwlwifi with only minutes spend
>> on mvm to port the NATIVE solution from dvm.
> 
> :)
> 
>> Are you saying that mvm cards can't seamless switch a RX/TX key to TX
>> only one? mvm seems to support SW crypto as needed and switching RX/TX
>> to TX keys is the only other requirement for COMPAT mode.
> 
> No, sorry. I misread your statement. I thought you were saying "mvm
> cards will also work with iwldvm" rather than "mvm cards will also work
> with compat mode" :-)
> 
> I think they all should just be made to work in native mode, the
> firmware basically supports this as you found, there must be some small
> bugs.

Agree. And with your statements that it already should work and the 
option to get ucode updates I like our chances:-) With some luck it 
could even work and I made some error the first time. I'll give that a 
second look with what I have at hand soon. But after bombing you with 
mails for what feels like most of the weekend I'll postpone that for now:-)

As mentioned above I'm currently aiming for two or three Intel AC-9260 
cards for the next development round. It's seems to be the most modern 
card and the price difference between the cards is irrelevant compared 
to both efforts and costs to get the cards working in two or three 
devices. If you thing another card would be better for development I'll 
just use that one instead...

Alexander

Alexander

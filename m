Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:45817 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967AbbI3TEv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 15:04:51 -0400
Subject: Re: Can we ignore frames with invalid BSSID in IBSS mode?
To: Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
References: <5605D228.7050609@candelatech.com>
 (sfid-20150926_010105_789618_F93D668E)
 <1443595615.1859.2.camel@sipsolutions.net> <560BFABC.8090504@candelatech.com>
 <1443626224.1859.9.camel@sipsolutions.net> <560C036C.7000401@candelatech.com>
 <1443633267.1859.11.camel@sipsolutions.net>
 <560C19F3.6070903@candelatech.com>
 <1443637830.1859.17.camel@sipsolutions.net>
 <560C2B46.2040200@candelatech.com>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <560C324A.2000002@openwrt.org> (sfid-20150930_210459_936564_77E4A197)
Date: Wed, 30 Sep 2015 21:04:42 +0200
MIME-Version: 1.0
In-Reply-To: <560C2B46.2040200@candelatech.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-09-30 20:34, Ben Greear wrote:
> On 09/30/2015 11:30 AM, Johannes Berg wrote:
>> On Wed, 2015-09-30 at 10:20 -0700, Ben Greear wrote:
>>>
>>> Yes, it is a transmitter side problem, and A-MSDU on IBSS
>>> is disabled by default in all ath10k firmware versions that I am aware of.
>>
>> Right.
>>
>>> I was hoping there might be a way to allow A-MSDU + IBSS + ath10k
>>> to work in future kernels without applying out-of-tree
>>> kernel hacks.  This would let people with appropriate firmware
>>> enable IBSS + A-MSDU for added performance in cases where they
>>> knew the peer could support the needed work-around.
>>>
>>> I don't think it is worth a lot of effort, but if it were relatively
>>> simple to fix, then maybe it is worth it.
>>>
>>
>> Had it been a receiver-side issue, then it'd seem reasonable to work
>> around it. But it being a transmitter-side issue it doesn't really seem
>> so - *every* possible peer would have to be adjusted, and some might
>> not even be able to get adjusted (e.g. devices that have A-MSDU
>> deaggregation in hardware/firmware) ...
>>
>> So to do that properly you'd have to advertise some sort of quirk
>> vendor IE, and all that, which seems excessive given the limited use.
> 
> I was figuring the main users of this would be people rolling out
> IBSS mesh networks and such, and they might have good knowledge of exactly
> what peers will be used.
> 
> It is a small enough hack to the stack to just ignore the BSSID for
> adhoc, and since CT firmware related patches are not accepted upstream
> anyway, I guess anyone doing this is likely running custom patches
> already.
I think instead of making a bunch of assumptions about who is going to
use this for what, you should just leave A-MSDU disabled for IBSS.

If you present this as a way to improve performance, users will probably
mindlessly enable it without trying to understand why it wasn't enabled
by default. Afterwards, they will create annoying and hard-to-debug bug
reports for you and other people to waste time on.

- Felix

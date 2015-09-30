Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58581 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbbI3RUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 13:20:52 -0400
Subject: Re: Can we ignore frames with invalid BSSID in IBSS mode?
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
References: <5605D228.7050609@candelatech.com>
 (sfid-20150926_010105_789618_F93D668E)
 <1443595615.1859.2.camel@sipsolutions.net> <560BFABC.8090504@candelatech.com>
 <1443626224.1859.9.camel@sipsolutions.net> <560C036C.7000401@candelatech.com>
 <1443633267.1859.11.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <560C19F3.6070903@candelatech.com> (sfid-20150930_192107_313707_2C1A34F5)
Date: Wed, 30 Sep 2015 10:20:51 -0700
MIME-Version: 1.0
In-Reply-To: <1443633267.1859.11.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/2015 10:14 AM, Johannes Berg wrote:
> On Wed, 2015-09-30 at 08:44 -0700, Ben Greear wrote:
>>
>> Any idea how this could be done in the stack instead of the driver?
>
> I don't see why it should be?
>
>> The problem is that this is a receiver-side issue, so even if I manage
>> to hack the ath10k firmware or driver rx logic, it would not fix any other
>> IBSS peer connected to ath10k peer.
>>
>
> You mean it's a transmitter-side issue? In that case you should
> probably simply disable aggregation on the broken transmitter ...

Yes, it is a transmitter side problem, and A-MSDU on IBSS
is disabled by default in all ath10k firmware versions that I am aware of.

I was hoping there might be a way to allow A-MSDU + IBSS + ath10k
to work in future kernels without applying out-of-tree
kernel hacks.  This would let people with appropriate firmware
enable IBSS + A-MSDU for added performance in cases where they
knew the peer could support the needed work-around.

I don't think it is worth a lot of effort, but if it were relatively
simple to fix, then maybe it is worth it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44460 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab1CKU33 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 15:29:29 -0500
Message-ID: <4D7A85FC.4090708@candelatech.com>
Date: Fri, 11 Mar 2011 12:28:44 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: fix channel type recalculation with HT and
 non-HT interfaces
References: <1299873939-1171-1-git-send-email-nbd@openwrt.org>	 <4D7A8350.9000406@candelatech.com> <1299875041.4320.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1299875041.4320.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2011 12:24 PM, Johannes Berg wrote:
> On Fri, 2011-03-11 at 12:17 -0800, Ben Greear wrote:
>> On 03/11/2011 12:05 PM, Felix Fietkau wrote:
>>> When running an AP interface along with the cooked monitor interface created
>>> by hostapd, adding an interface and deleting it again triggers a channel type
>>> recalculation during which the (non-HT) monitor interface takes precedence
>>> over the HT AP interface, thus causing the channel type to be set to non-HT.
>>> Fix this by not overriding HT interfaces with a non-HT channel type.
>
> The fix seems right.
>
>> After staring at that code a bit more, should that list-for-each-entry
>> loop be entirely different such that it better calculates a proper
>> super-channel for mixed interface types?
>>
>> If seems like a bad case of last-one-wins as currently written.
>>
>> The code probably (mostly?) works right because we limit the
>> bss_conf.channel_type based on existing super-chan when
>> adding new interfaces, but it still seems like brittle code to me.
>
> But I'm not sure what you mean?
>
> With the fix, we go through and use the widest possible channel of all
> interfaces. The only conflict can happen with HT40- and HT40+, but we
> should never get into that situation since we can't have one interface
> with HT40- and another with HT40+ at the same time to start with. Am I
> missing something?

Maybe I'm missing something, but from what I can tell:

If we have two interfaces:

first interface is HT40, second is HT20:
   -> superchan == HT20

first interface is HT20, second is HT40:
   -> superchan == HT40

It seems wrong that the ordering would influence superchan before we go into
the "switch (superchan)" logic.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


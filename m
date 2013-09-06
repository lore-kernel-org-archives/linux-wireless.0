Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51949 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab3IFVW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Sep 2013 17:22:29 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r86LMS2F020316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 6 Sep 2013 14:22:29 -0700
Message-ID: <522A4794.7080106@candelatech.com> (sfid-20130906_232244_174758_8C6A0B32)
Date: Fri, 06 Sep 2013 14:22:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Specifying priority for management frames?
References: <5228CAB6.5060308@candelatech.com> <5228CD6B.5010209@candelatech.com>
In-Reply-To: <5228CD6B.5010209@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2013 11:28 AM, Ben Greear wrote:
> On 09/05/2013 11:17 AM, Ben Greear wrote:
>> While debugging a problem with group-rekeys, we noticed that the sniffer (on external machine)
>> reported management packets are sent in the best-effort QoS queue.
>>
>> It seems to me that these should be in the VO queue instead, or at least
>> we should be able to specify the queue in supplicant when sending the frames?
>
>
> Hrmm, actually it appears the mac80211 layer tries to send on VO.  Maybe
> some of my hackings are messing this up...I'll go dig deeper.

I've dug a bit deeper, but not all the way I guess.

When I sniff on a separate machine, the EAP packets still
show QoS being 'Best Effort' in wireshark.

UDP data packets sent with proper IP TOS show up in
VI or VO as specified.

So, I think this means that either the EAP packets are not actually
going out the VO queue, or they are somehow missing some wifi QoS config
in their header.

I just tested this with the latest wireless-testing tree, totally un-modified.

The sniffer is running my standard set of patches, but I doubt that matters
since it does properly show QoS on UDP packets.

I'll go look to see if I can figure out where the wifi frame TOS bits
are configured..but if someone has suggestions, let me know!

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


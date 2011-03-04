Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42199 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1CDPxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 10:53:14 -0500
Message-ID: <4D710ADB.4060001@candelatech.com>
Date: Fri, 04 Mar 2011 07:52:59 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: jpo234 <pommnitz@yahoo.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k:  Put hardware in PROMISC mode if there is more
 than 1 stations.
References: <1299191945-13257-1-git-send-email-greearb@candelatech.com> <loom.20110304T110306-345@post.gmane.org> <4D70F3CD.3040009@candelatech.com> <20110304142814.GA3899@redhat.com>
In-Reply-To: <20110304142814.GA3899@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/04/2011 06:28 AM, Stanislaw Gruszka wrote:
> On Fri, Mar 04, 2011 at 06:14:37AM -0800, Ben Greear wrote:
>> On 03/04/2011 02:04 AM, jpo234 wrote:
>>> | From: Ben Greear<greearb@...>
>>> |
>>> | It seems ath5k has issues receiving broadcast packets (ARPs) when
>>> | using multiple STA interfaces associated with multiple APs.
>>> | This patch ensures the NIC is always in PROMISC mode if there
>>> | are more than 1 stations associated.
>>>
>>> Is this a band aid or a real fix?
>>
>> I don't know.  It definitely makes things work, but it smells
>> like a hack.  Considering ath9k works fine, it must be something
>> in the ath5k driver, but I can't see any other problems.
>
> In opposite to ath9k, there is no possibility to set multiple sta
> addresses in the ath5k hw. I'm not sure if multiple station virtual
> interfaces have sense is such case.

There is an ssid-mask, and sending directed (layer-2 ethernet frames
directly to/from the STA's MAC addresses) work fine.  It's just ARP
(and probably other broadcast or multicast) that fails to work, as
far as I can tell.

Since my patch only takes affect when there are more than one virtual
station, I think it might be OK, even if it's a bit of a hack.  Normal
users won't see their NIC suddenly go promisc, for instance.

Thanks,
Ben

>
> Stanislaw


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

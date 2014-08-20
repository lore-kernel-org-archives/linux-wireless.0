Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46522 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbaHTUrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 16:47:36 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so7504462wiv.13
        for <linux-wireless@vger.kernel.org>; Wed, 20 Aug 2014 13:47:35 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
Date: Wed, 20 Aug 2014 22:47:32 +0200
Message-ID: <1478683.D306USvBEk@debian64> (sfid-20140820_224740_262490_7FF1D158)
In-Reply-To: <53F394FF.7050209@candelatech.com>
References: <5338F1B8.5040305@candelatech.com> <53ECED3E.4080907@candelatech.com> <53F394FF.7050209@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, August 19, 2014 11:18:39 AM Ben Greear wrote:
> On 08/14/2014 10:09 AM, Ben Greear wrote:
> > On 08/14/2014 05:39 AM, Christian Lamparter wrote:
> >> On Tuesday, August 12, 2014 11:34:59 AM Ben Greear wrote:
> >>>
> >>> Without encryption, I see download rate of around 400 - 420Mbps.
> >>>
> >>> So, your patch looks like a good improvement to me, and I'll be
> >>> happy to test further patches if you happen to do those assembler
> >>> optimizations you talk about above.
> >>
> >> Maybe, that will depend on what the results for: "wpa2, *HW*-crypt,
> >> download, udp" are.
> > 
> > I'll do that test sometime soon and post the results.
> 
> I ran that today, and I get about the same throughput with hw-crypt or
> sw-crypt (350-355Mbps UDP download goodput).
> 
> I still see 400+Mbps with Open authentication.
> 
> So, maybe the bottleneck now is elsewhere...
Can you rule out that the "udp generator" (either the application
or the hardware) is now the bottleneck for this test? [Does the
datasheet mention the throughput of the hw-crypto? Or do you know
someone at QCA which can tell you if the hardware is filling up
the aggregates with additional padding to meet the MPDU start
spacing]

I'll look into the assembler implementation of aes-ccm. But I'm
afraid that this won't increase the throughput (and only decrease
the load on the CPU a bit).

Also, just for fun: what goodput can you achieve over gbit ethernet?
[Because ethernet is also affected by filtering, bridging, 
pcie-throughput... if it is setup in the same way so you could
rule out that iptables, its friends or the pcie-port is a
bottleneck].

Regards
Christian

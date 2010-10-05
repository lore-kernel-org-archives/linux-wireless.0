Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47283 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab0JERYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 13:24:15 -0400
Message-ID: <4CAB5F3D.9060201@candelatech.com>
Date: Tue, 05 Oct 2010 10:24:13 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com>
In-Reply-To: <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2010 10:16 AM, Luis R. Rodriguez wrote:
> On Tue, Oct 5, 2010 at 10:00 AM, Ben Greear<greearb@candelatech.com>  wrote:
>> I started seeing this very soon after creating interfaces.
>
> Can you be more specific how one can reproduce?
Enable SLUB debugging, DEBUG_PAGEALLOC (Debug page memory allocations),
lockdep, pre-empt.

Please try creating a bunch of stations on one ath9k phy, and
configure them to use WPA (we're using one supplicant per STA).

If you don't hit it within 2 minutes of creating STAs and starting
WPA, do let me know and I'll try to come up with something
more specific.  But, at least for us, it seems extremely easy to
hit this issue.

The same kernel boots fine with no such errors on a system with ath5k, btw.

I wish there was a way to get slub debugging to print the backtrace for the
code that deleted the memory, but so far, I haven't found anything.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


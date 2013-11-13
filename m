Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45731 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600Ab3KMSZB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:25:01 -0500
Message-ID: <5283C3F7.4090700@candelatech.com> (sfid-20131113_192512_995146_16093F29)
Date: Wed, 13 Nov 2013 10:24:55 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC:  Add precise timing to wifi association messages?
References: <5283BDB6.5020700@candelatech.com>  <5283BE63.8090801@candelatech.com> (sfid-20131113_190112_830842_FCA007A3) <1384366716.14578.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1384366716.14578.13.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/13/2013 10:18 AM, Johannes Berg wrote:
> On Wed, 2013-11-13 at 10:01 -0800, Ben Greear wrote:
> 
>> I chose a poor example here...my intention is to just add timers to existing
>> messages...
> 
> What does this do that printk timestamps don't?

Sub-second precision, and the same in 'dmesg' output.

There may be a way to get /var/log/messages to show sub-second
precision, but at least it is not enabled by default on the systems
I use.  dmesg has no timestamps at all from what I can tell.

Things like ath9k debugging typically do not go to /var/log/messages
at all, so I was stuck using dmesg (I'll post a similar patch for ath9k
debugging in case someone likes it.)

The format I chose matches wpa_supplicant logs as well, which I found
useful.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


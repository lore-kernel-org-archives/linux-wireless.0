Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35957 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919Ab1ELQnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 12:43:47 -0400
Message-ID: <4DCC0E3E.1080709@candelatech.com> (sfid-20110512_184350_678616_7DC98DD7)
Date: Thu, 12 May 2011 09:43:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC ] wireless: Support can-scan-one logic.
References: <1305057374-9875-1-git-send-email-greearb@candelatech.com>	 (sfid-20110510_215629_728045_43BAA3DE) <1305188791.3461.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1305188791.3461.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/12/2011 01:26 AM, Johannes Berg wrote:
> On Tue, 2011-05-10 at 12:56 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> Enable this by passing a -1 for a scan frequency.
>>
>> When enabled, the system will only scan the current active
>> channel if at least one VIF is actively using it.  If no
>> VIFS are active or this flag is disabled, then default
>> behaviour is used.
>>
>> This helps when using multiple STA interfaces that otherwise might
>> constantly be trying to scan all channels.
>
> I still don't see what stops you from doing this in userspace, I don't
> remember a compelling reason for implementing this in the kernel.

The reasons are relatively small, but enough to make the patch useful to me.

First, it works with non-userspace scan logic (sme).

Second, if user is running more than one supplicant, it might be difficult
to know how many interfaces are associated.  Or, if a single supplicant process
isn't managing all wireless interfaces (maybe a few VAPs plus some STA interfaces
using in-kernel scanning (sme))?

> Clearly, you need to modify userspace anyhow. Also, what if, in the
> future, we have multiplel STA interfaces on different channels? Which

I'm not sure that having STA on different channels would ever actually work.  The attempt to
support that kind of thing in ath9k certainly didn't work too well.

If it ever was implemented, then the -1 could mean choose all channels
upon which something is associated.

I do have a patch to wpa_supplicant that lets the user enable this
feature if they want.  I currently probe the support for this feature
by attempting a scan on channel -1 and detecting failure.  This way, I
can have my code work on un-patched kernels as well as kernels with this
patch installed.

> one(s) should it pick then? The -1 trick will also break all
> non-mac80211 drivers, or maybe simply not work?

If passing a bogus value from user-space breaks the driver, then
the driver is busted.  I would assume it would simply not work.
My patch to wpa_supplicant disables the feature by default, so
someone has to actively turn it on to pass in -1.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37142 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1F3Vil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 17:38:41 -0400
Message-ID: <4E0CECDD.7040409@candelatech.com> (sfid-20110630_233851_711623_0877A416)
Date: Thu, 30 Jun 2011 14:38:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Crash in mlme.c, wireless-testing 2.6.39-wl + hacks
References: <4E0CE929.7040300@candelatech.com>	 (sfid-20110630_232253_480125_B86CAA5E) <1309469454.3873.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1309469454.3873.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2011 02:30 PM, Johannes Berg wrote:
> On Thu, 2011-06-30 at 14:22 -0700, Ben Greear wrote:
>> We see occasional crashes in mlme.c when testing a certain
>> configuration:  30 stations, configured for in-kernel authentication,
>> re-configure them for supplicant, let them associate, delete one of
>> them.
>>
>> I added a BUG_ON in __cfg80211_mlme_deauth to check for null
>> bssid and it hit.
>>
>> Please note this is hacked code, so it's possible it's something
>> I am doing.  I'm going to add some extra checks in this method to
>> keep from crashing, but it may be a while until I can test against
>> clean upstream kernels for this particular config.
>
> It'd help if you at least said what you changed, since you say you
> changed things in this area but don't say what I don't think I'll bother
> looking at this.

Very little significant changes in this area, but I've a non-related
proprietary module loaded, and patches to various other parts of the
networking code.

The full tree is here if you want to take a look, or I can send
you a full unified diff:

http://dmz2.candelatech.com/git/gitweb.cgi?p=linux.wireless-testing-ct.ct/.git;a=summary

Seems a tricky timing related bug, possibly we're only hitting it because
we're testing on an older C3 processor system that is significantly slower
than our normal test systems.

Anyway, no worries if you don't care to look at it.  Looks like we're
the only ones hitting it, and I think I have a proper enough work-around.

If/when I get a chance, will try un-tainted kernel, and will re-post if
we can reproduce the bug.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


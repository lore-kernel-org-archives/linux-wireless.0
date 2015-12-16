Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36008 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbbLPOLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 09:11:38 -0500
Message-ID: <56717119.1040701@candelatech.com> (sfid-20151216_151214_688171_FC730E75)
Date: Wed, 16 Dec 2015 06:11:37 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
References: <5670DA9A.4010102@candelatech.com>			 (sfid-20151216_042934_976896_DCE1A2B3) <1450257464.3159.1.camel@sipsolutions.net>		 <56716386.4070107@candelatech.com>	 <1450272308.8247.11.camel@sipsolutions.net>	 <567168AF.4060804@candelatech.com> <1450273362.8247.15.camel@sipsolutions.net>
In-Reply-To: <1450273362.8247.15.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2015 05:42 AM, Johannes Berg wrote:
> On Wed, 2015-12-16 at 05:35 -0800, Ben Greear wrote:
>
>> Well, the old code used it as a key, and the old documentation used
>> it as a key, so it is a bit of a regression to change the behaviour
>> now.
>
> But it's still used as a key, no? Just the value changed. If you treat
> it as a key then you'd just have it for a frame incoming and outgoing?
>
>>> I think this is pretty much a done deal by now though since I don't
>>> really want to break wmediumd.
>>
>> It was not the only user-space to use the API :)
>
> So you're saying you have code that broke? How did it break though, I
> don't really see it yet. Can you explain?

My code expected that the key was the MAC of the radio, not the
MAC of a vif.  It set up mappings accordingly in the user-space
program.

And, if I change a vif's mac address, the previous 'key' is no longer
valid with the new patch.  If I have multiple vifs on one radio
and want to send a broadcast pkt to that radio, then at best the
patched API is lame because you would have to specify the address
of one of the vifs on the radio, but it is not really destined for
just that vif.

A fair bit of code was written, and not just by me, against the
API that assumed the MAC of the radio was a unique key.  The
code can be changed of course, but if Bob's change does not
really offer any advantage, then I think the patch should
be reverted.

If wmediumd needs more info, then I think adding a new netlink
message or attribute is the way to go..that way it should be fully
backwards compatible.


>> Well, that would be fine too.  The nice thing about the
>> address,though, is that you can query it as part of
>> /sys/class/ieee..... and other already-implemented
>> interfaces.  Finding the radio-id would require new API in this case,
>> which is a bit of work.
>
> Well, it was always rather awkward since it was the *second* address :)

Yes, it was always weird, but predictably so.

>
> You can query the ID/index already through the netlink API, or even
> from sysfs since the virtual device name is essentially
> 	sprintf(name, "hwsim%d", idx)

Good lord, please don't even suggest parsing the name.  You can easily
rename a phy device.  I do it all the time to keep a phyname associated
with a real radio through module reloads.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


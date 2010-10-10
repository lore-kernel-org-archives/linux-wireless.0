Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37609 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab0JJPjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 11:39:21 -0400
Message-ID: <4CB1DE18.9070400@candelatech.com>
Date: Sun, 10 Oct 2010 08:39:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	rainbow lum <rainbowlum@gmail.com>
Subject: Re: phyX enumeration conflict
References: <201010082159.59262.chunkeey@googlemail.com>	 <1286698152.3547.4.camel@jlt3.sipsolutions.net> <1286698604.3547.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286698604.3547.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/10/2010 01:16 AM, Johannes Berg wrote:
> On Sun, 2010-10-10 at 10:09 +0200, Johannes Berg wrote:
>
>> The commit failed to take into account that allocated wireless devices
>> (wiphys) are not added into the device list upon allocation, but only
>> when they are registered. Therefore, it opened up a race between
>> allocating and registering a name, so that if two processes allocate and
>> register concurrently ("alloc, alloc, register, register" rather than
>> "alloc, register, alloc, register") the code will attempt to use the
>> same name twice.
>
> And as for the actual feature, as far as I'm concerned the discussion
> ends here because we otherwise need to use something as complex as idr.
> A udev rule can't break the kernel and works just as well, even if
> you'll have to use a different namespace, i.e. not "phy%d" -- use say
> "wiphy%d" instead.

Sorry about that.  If anyone has any example udev magic to do this sort
of thing, I'd like to try that out.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

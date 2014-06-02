Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:40050 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaFBT3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 15:29:05 -0400
Received: by mail-oa0-f48.google.com with SMTP id g18so5105002oah.35
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2014 12:29:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <538CC949.5020901@candelatech.com>
References: <53891ACD.7070902@candelatech.com>
	<87wqczz3h9.fsf@kamboji.qca.qualcomm.com>
	<538CA904.4000508@candelatech.com>
	<87ioojz1b1.fsf@kamboji.qca.qualcomm.com>
	<538CB782.1000509@candelatech.com>
	<538CC68C.10808@gmail.com>
	<538CC949.5020901@candelatech.com>
Date: Mon, 2 Jun 2014 22:29:03 +0300
Message-ID: <CANUX_P2vbKD3zkwE=DvJJWpo=gEMORCBy=XFoC2YSFpmg9sr_A@mail.gmail.com> (sfid-20140602_212909_241066_29C96DE3)
Subject: Re: Firmware debugging patches?
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach
egrumbach@gmail.com


On Mon, Jun 2, 2014 at 9:58 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 06/02/2014 11:46 AM, Emmanuel Grumbach wrote:
>>> [Good stuff snipped, adding linux-wireless as this is a more
>>> general issue if we are going to consider general framework]
>>>
>>>
>>> Maybe we should start with goals before getting to implementation
>>> details.  Here's my wish list that is ath10k specific, but probably
>>> similar to other firmware users:
>>>
>>> 1)  We need the firmware crash text currently printed to
>>> /var/log/messages.
>>>
>>> 2)  It would be nice to get the firmware RAM and stack dumps at time of
>>> crash to debug more interesting crashes.
>>
>> Right - but typically you'll have closed source / IP / whatever there..
>
> I mean that we need the raw data (ie, binary dump, something printed
> in ascii-hex, etc).  I understand it will take proprietary tools to
> decode it to something a developer can actually debug.
>
>>> 3)  It would be nice to know about firmware debug messages for
>>> the period of time directly before the crash (maybe 2-5 minutes?)
>>>
>>> 4)  It would be nice to have this interleaved with kernel, supplicant,
>>> and related logs.
>>>
>>>
>>> We need a solution for different types of users.  I suspect the number
>>> of crashes seen in the wild will be more for users nearer the top
>>> of this list.
>>>
>>> a) Normal Fedora/Ubuntu/etc default-installed distribution user
>>> with ath10k NIC has wifi issues, firmware crashes, they don't
>>> really know what firmware means or that it crashed, but some automated crash-log
>>> tool notices and gathers debug info for automated bug reporting.
>>
>> I am working on that for our firmware. I recently added such capability relying on udev to notify the userspace that something bad happens. I gather all the data and prepare a binary file that is sent through debugfs (pulled by a script triggered by udev). I remember the first crash only.
>
> How is this binary blob encoded?

Different TLV based binary blobs concatenated. The actual encoding of
each of them is another story.

>
> At least for drivers that can recover from firmware crashes, I think
> we should continue to report crashes, not just the first.
>

I remember the first until udev kicks the script that will empty the
buffer. Then I take the second crash's log.

> Maybe could store another one after initial crash has been read
> and 1 minute has elapsed, or if initial crash has not been read
> in 1 day, or something like that.
>
> Also, if we use debugfs then we require upstream kernels to have this
> compiled in and mounted if we want to handle this class of user.

Agreed. I rely on debugfs. But this is "just" the way to reach the filesystem.
Give me another way and I am fine with it.
FWIW Ubuntu which is not exactly the distribution of the super
advanced users has it mounted by default.

>
> I am not sure this is really the case currently.  But, once the
> blob is generated and stored in RAM, it would be easily enough to
> add ethtool option to dump it w/out debugfs support.  This will
> still not really address my concerns because it may take a year
> or two for the latest ethtool binary to make it to normal-ish users.

I understand.

>
>>>
>>> b) Slightly more advanced user actually notices the problem at coffee shop
>>> earlier today, posts about it when they get home, and we ask for
>>> debug info.
>>>
>>> c) Experienced and determined user has similar issues, but is able to
>>> reproduce the problem and/or turn on more advanced debugging efforts.
>>>
>>> d)  Even more determined user that can and will recompile kernels and/or
>>> try patches.
>>>
>>>
>>> Anything that has to be enabled before-hand will not help a) and b) above.
>>>
>>> If support is not compiled into default kernels, c) will not help you either.
>>>
>>> If it is difficult or requires acquiring cutting edge tools not in their
>>> distribution by default, many of c) and some of d) will just ignore the problem or use
>>> different hardware.
>>>
>>> If we are storing crashes for something like ethtool to report, we need
>>> RAM and/or disk storage so the firmware RAM dumps and such can be stored until
>>> the user and/or automated tools ask for them.  We need some way to automatically
>>> clean up old crashes so disk/ram is not overly utilized.  For APs,
>>> they are low on both RAM and 'disk', so storing crash logs for any
>>> length of time may be problematic.
>>
>> I did something simpler - but it works. I don't really know the ethtool infrastructure though.
>
> I think ethtool would not be overly hard to implement...basic framework is already
> in the wifi stack.
>
> Thanks,
> Ben
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>

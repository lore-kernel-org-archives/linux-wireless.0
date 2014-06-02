Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34046 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaFBTsY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 15:48:24 -0400
Message-ID: <538CD507.1050803@candelatech.com> (sfid-20140602_214827_974744_2A1E9885)
Date: Mon, 02 Jun 2014 12:48:23 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Firmware debugging patches?
References: <53891ACD.7070902@candelatech.com> <87wqczz3h9.fsf@kamboji.qca.qualcomm.com> <538CA904.4000508@candelatech.com> <87ioojz1b1.fsf@kamboji.qca.qualcomm.com> <538CB782.1000509@candelatech.com> <538CC68C.10808@gmail.com> <538CC949.5020901@candelatech.com> <CANUX_P2vbKD3zkwE=DvJJWpo=gEMORCBy=XFoC2YSFpmg9sr_A@mail.gmail.com>
In-Reply-To: <CANUX_P2vbKD3zkwE=DvJJWpo=gEMORCBy=XFoC2YSFpmg9sr_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/02/2014 12:29 PM, Emmanuel Grumbach wrote:

>>>> a) Normal Fedora/Ubuntu/etc default-installed distribution user
>>>> with ath10k NIC has wifi issues, firmware crashes, they don't
>>>> really know what firmware means or that it crashed, but some automated crash-log
>>>> tool notices and gathers debug info for automated bug reporting.
>>>
>>> I am working on that for our firmware. I recently added such capability relying on udev to notify the userspace that something bad happens. I gather all the data and prepare a binary file that is sent through debugfs (pulled by a script triggered by udev). I remember the first crash only.
>>
>> How is this binary blob encoded?
> 
> Different TLV based binary blobs concatenated. The actual encoding of
> each of them is another story.

Should we try to make the 'Type' in TLV be consistent as convenient
across different drivers?  That might someday help auto-reporting tools?

Do you have a link to your patch that defines the types you used?

>> At least for drivers that can recover from firmware crashes, I think
>> we should continue to report crashes, not just the first.
>>
> 
> I remember the first until udev kicks the script that will empty the
> buffer. Then I take the second crash's log.

Sounds good enough to me.

>> Maybe could store another one after initial crash has been read
>> and 1 minute has elapsed, or if initial crash has not been read
>> in 1 day, or something like that.
>>
>> Also, if we use debugfs then we require upstream kernels to have this
>> compiled in and mounted if we want to handle this class of user.
> 
> Agreed. I rely on debugfs. But this is "just" the way to reach the filesystem.
> Give me another way and I am fine with it.
> FWIW Ubuntu which is not exactly the distribution of the super
> advanced users has it mounted by default.

That sounds promising...Looks like Fedora 20 does as well, so maybe
debugfs will be good enough for crash dumps.


It does not resolve my interest in firmware logs interleaved with
kernel logs and possibly supplicant, however.

Looks like trace-cmds could do that, but it will not be
running for normal users when they experience crashes.

Any suggestions other than printk for this feature?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


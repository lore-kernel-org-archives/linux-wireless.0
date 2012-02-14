Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44473 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab2BNW3m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 17:29:42 -0500
Message-ID: <4F3AE048.5030503@openwrt.org> (sfid-20120214_232945_547811_C8798626)
Date: Tue, 14 Feb 2012 23:29:28 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Sujith <m.sujith@gmail.com>, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [ath9k-devel] [PATCH 3/7] ath9k: Merge wiphy and misc debugfs
 files
References: <20280.43962.403799.188541@gargle.gargle.HOWL> <4F3947A1.2060103@candelatech.com> <20281.48485.409968.741657@gargle.gargle.HOWL> <4F39BF5F.3030408@candelatech.com> <20281.52354.478076.479135@gargle.gargle.HOWL> <20120214073855.6843.qmail@stuge.se> <20282.7088.898987.229335@gargle.gargle.HOWL> <4F3A9ACB.3010009@candelatech.com> <20282.43026.335779.405152@gargle.gargle.HOWL> <4F3AAB3F.7030308@candelatech.com>
In-Reply-To: <4F3AAB3F.7030308@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-14 7:43 PM, Ben Greear wrote:
> On 02/14/2012 10:29 AM, Sujith wrote:
>> Ben Greear wrote:
>>> Actually, I think it might be useful to have a second level of debugging.
>>> I hope to soon have time&  resources to add some logic to dump lots of register
>>> info and such in human-readable format, (like, when DMA times out).  That is going to be a lot
>>> of strings added to the driver, so the compile size will definitely
>>> increase.  If keeping the size small is important, then this sort of verbose thing
>>> could be hidden behind a second level of debugging...
>>
>> That could be implemented similar to what usbmon does. A debugfs file that could
>> be read and redirected to a file. And there would be no overhead to the
>> driver, I think. We could call it the 'event log'. :)
> 
> I was thinking about adding a method that grabbed as many registers
> as I have info for and dumping them with printk when DMA errors
> hit.  This would make kernel splats more useful.
> 
> And also have a debugfs file called 'registers' or similar that one
> could cat out and get similar info.  And this can let folks look
> at steady-state or whatever.
> 
> But, the logic to turn the register bit values into strings would
> be in the driver (and thus add some code size bloat).
> 
> My hope is that this would allow a better chance of understanding
> the stop-DMA errors that some people get reliably (but which I can never reliably
> reproduce).
> 
> I'm not sure how that plays into your 'event log' idea, but maybe
> one will help the other.
I think the 'let's dump all kinds of random crap when the issue occurs
until we find somebody that can parse it' approach won't work here, and
I really think it's not a good idea in general.

In the past the stop-DMA crap has been a symptom with a wild variety of
different causes, most of which were actually *software* race
conditions, e.g. dma tx or rx enable during reset, locking issues, etc.

In addition to those software causes, there was one actual hardware
condition that also triggered this error, and even this wouldn't have
showed up in a normal register dump, because it required setting up the
MAC observation bus in a particular way.

That hardware trigger for this issue was analyzed not by dumping random
data, but by actually talking to hardware designers that could look
through the code and guide the debugging process.

Let's not carpet-bomb the driver with lots of debug crap that probably
won't ever lead anybody to any good solution for the remaining issues,
let's fix stuff the old-fashioned way: by reading the code,
understanding what's going on, analyzing problems in a systematic way,
rather than clouding the whole process with assumptions based on old
bugs that have since been fixed.

- Felix

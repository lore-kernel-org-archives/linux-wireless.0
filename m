Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49508 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab2BNSnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 13:43:24 -0500
Message-ID: <4F3AAB3F.7030308@candelatech.com> (sfid-20120214_194327_857765_5133BC7F)
Date: Tue, 14 Feb 2012 10:43:11 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [ath9k-devel] [PATCH 3/7] ath9k: Merge wiphy and misc debugfs
 files
References: <20280.43962.403799.188541@gargle.gargle.HOWL> <4F3947A1.2060103@candelatech.com> <20281.48485.409968.741657@gargle.gargle.HOWL> <4F39BF5F.3030408@candelatech.com> <20281.52354.478076.479135@gargle.gargle.HOWL> <20120214073855.6843.qmail@stuge.se> <20282.7088.898987.229335@gargle.gargle.HOWL> <4F3A9ACB.3010009@candelatech.com> <20282.43026.335779.405152@gargle.gargle.HOWL>
In-Reply-To: <20282.43026.335779.405152@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2012 10:29 AM, Sujith wrote:
> Ben Greear wrote:
>> Actually, I think it might be useful to have a second level of debugging.
>> I hope to soon have time&  resources to add some logic to dump lots of register
>> info and such in human-readable format, (like, when DMA times out).  That is going to be a lot
>> of strings added to the driver, so the compile size will definitely
>> increase.  If keeping the size small is important, then this sort of verbose thing
>> could be hidden behind a second level of debugging...
>
> That could be implemented similar to what usbmon does. A debugfs file that could
> be read and redirected to a file. And there would be no overhead to the
> driver, I think. We could call it the 'event log'. :)

I was thinking about adding a method that grabbed as many registers
as I have info for and dumping them with printk when DMA errors
hit.  This would make kernel splats more useful.

And also have a debugfs file called 'registers' or similar that one
could cat out and get similar info.  And this can let folks look
at steady-state or whatever.

But, the logic to turn the register bit values into strings would
be in the driver (and thus add some code size bloat).

My hope is that this would allow a better chance of understanding
the stop-DMA errors that some people get reliably (but which I can never reliably
reproduce).

I'm not sure how that plays into your 'event log' idea, but maybe
one will help the other.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


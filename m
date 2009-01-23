Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:52600 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZAWTSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:18:55 -0500
Cc: bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Message-Id: <82AB87FD-0247-4049-AA3D-309C3C1539FF@ing.unibs.it> (sfid-20090123_201858_602604_74550027)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200901231902.06336.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: integration of opensource firmware with b43 kernel driver
Date: Fri, 23 Jan 2009 20:18:52 +0100
References: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it> <200901231902.06336.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 23, 2009, at 7:02 PM, Michael Buesch wrote:

> On Friday 23 January 2009 18:36:37 Francesco Gringoli wrote:
>> Hello,
>>
>> we have been testing the firmware for a week now and it seems stable.
>> I personally tested it also on a Linksys WRT54GL and it works both in
>> station and in AP modes. I collected the feedbacks that some of you
>> sent and it seems that the firmware now runs on these board:
>>
>> - 4306, 4311, 4318, 4320
>
> I don't think it has enough testing, yet.
Sure, it seems to be stable on _our_ boards but I can't tell if it  
shows the same behavior on other hardware revisions.
>
>
>> I was considering the suggestions you all gave me a few days ago and
>> other questions related to the possible integration of this firmware
>> into the kernel, and I came to these conclusions/questions (please
>> forgive me for this long message :-) )
>
> I don't think we want to have the firmware in the kernel.
> Instead distributions should simply ship the firmware in a package.
> That's not our business.

I agree with you, distributions could easily package the firmware and  
distribute it to users when it will be stable, I was just wondering  
about.

>> - change the name of the initvals for the opensource firmware: this
>
> Why?
>
>> [cut]
>> initvals have already been uploaded. What can we do?
>
> Nothing. Why do we need to have different names?
Well, I was only considering a question raised by John, we can surely  
maintain these names.

>> - detection of the opensource firmware capabilities: are you really
>> sure we cannot use a shm location that the bcm proprietary firmware
>> uses for some other purpose?
>
> Yes, well. You're not intermixing an earlier discussion into this,  
> where
> you didn't indicate opensource capabilities to the kernel.
> If you indicate OS capabilities, you can use whatever offset you  
> want, of course.
Excellent. We will modify the firmware accordingly and encode the  
options.

>> - what to do with rts procedure: we can implement this feature easily
>> but I'm not sure about the value it can add to people (the majority  
>> of
>> users?) that use the bcm board in station mode. This is different for
>> those who run a bcm card in AP mode, but we can clearly discourage
>> them to run this firmware in AP mode if  not sure about rts usage by
>> stations. However, we put this task in the todo list.
>
> RTS/CTS is not specific to AP mode. It's used on any station in the  
> BSS.
> See IEEE 802.11 specs.
Yes, in fact we put this task in the todo list.

>> - tx header layout: the opensource firmware is now using the old
>> memory layout in the tx header (<351). Do you think switching to 410
>> format is mandatory now or we can concentrate on the other tasks?
>
> Yes, the old format is deprecated and will be removed soon.
Ok, first task in the todo list!

>> - I would like to start considering N-phy on the firmware side. I  
>> have
>> a late 2008 MacBook Pro and I'm not sure if beginning this work on
>> this platform is a waste of time or not as Apple could have asked
>> Broadcom a customized chipset. Should I start or is it better if I  
>> buy
>> a N-phy pci board for my x86 box?
>
> A little bit of b43-asm work is still needed for this core.
> There are a few FIXMEs in the code. Not sure, maybe there's more to  
> do.
> I didn't try that, yet.
> Before you start, you'll have to verify whether the assembler works  
> correctly.
> Same for the disassembler.
Ok, thanks for the hint. I will check,

Cheers,
-FG

>
>
> -- 
> Greetings, Michael.

-------

Francesco Gringoli, PhD - Assistant Professor
Dept. of Electrical Engineering for Automation
University of Brescia
via Branze, 38
25123 Brescia
ITALY

Ph:  ++39.030.3715843
FAX: ++39.030.380014
WWW: http://www.ing.unibs.it/~gringoli





Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:44126 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZAWTqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:46:49 -0500
Cc: bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Message-Id: <FE3E070D-F92B-4A76-80E5-019D4735FBED@ing.unibs.it> (sfid-20090123_204653_458478_591894F9)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200901232033.28470.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: integration of opensource firmware with b43 kernel driver
Date: Fri, 23 Jan 2009 20:46:45 +0100
References: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it> <200901231902.06336.mb@bu3sch.de> <82AB87FD-0247-4049-AA3D-309C3C1539FF@ing.unibs.it> <200901232033.28470.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 23, 2009, at 8:33 PM, Michael Buesch wrote:

> On Friday 23 January 2009 20:18:52 Francesco Gringoli wrote:
>>> Nothing. Why do we need to have different names?
>> Well, I was only considering a question raised by John, we can surely
>> maintain these names.
>
> I guess I missed that. What was the question?
> Note that proprietary and open firmwares are in separate  
> directories, so
> I don't see why we should rename them.
> Renaming firmware is a huge pain. We did it several times in the  
> past and
> I really want to avoid it. It creates a major confusion for users  
> for some months.
Sorry sorry sorry and sorry again... it was a Larry question, not  
John's... pardon me

-- Is using the Broadcom names for the firmware the best course of
-- action? What if the opensource firmware files were named something
-- like "os-ucode5.fw", etc. and b43 were coded to check for those files
-- first? It would then fall back to the standard firmware if the
-- opensource version is not found.

However, it's not a problem maintaining these names.

>>>> - detection of the opensource firmware capabilities: are you really
>>>> sure we cannot use a shm location that the bcm proprietary firmware
>>>> uses for some other purpose?
>>>
>>> Yes, well. You're not intermixing an earlier discussion into this,
>>> where
>>> you didn't indicate opensource capabilities to the kernel.
>>> If you indicate OS capabilities, you can use whatever offset you
>>> want, of course.
>> Excellent. We will modify the firmware accordingly and encode the
>> options.
>
> Thanks. Would be nice if you could also do the corresponding driver  
> patch.
Ok, it should be simple.

>>>> - tx header layout: the opensource firmware is now using the old
>>>> memory layout in the tx header (<351). Do you think switching to  
>>>> 410
>>>> format is mandatory now or we can concentrate on the other tasks?
>>>
>>> Yes, the old format is deprecated and will be removed soon.
>> Ok, first task in the todo list!
>
> Well, doesn't need to the the first one. Just note that support for  
> this is
> scheduled to be removed in summer 2008. So if any problems show up  
> (broadcom
> releases yet another API, for example), I will immediately remove it.
Well, it's the first because it's the easiest :-)

>> Ok, thanks for the hint. I will check,
>
> There are a few things we're not yet sure about.
> For example the operand for the GPR number got an additional bit.
> But we're not sure if the real number of GPRs also was doubled in  
> the hardware.
> There are a few FIXMEs in the code for this...
> I think this simply has to be tested by trial and error.
Thanks, I will surely check this.

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





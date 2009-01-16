Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:59162 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726AbZAPDTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 22:19:09 -0500
Message-ID: <496FFC9F.1000907@lwfinger.net> (sfid-20090116_041915_786732_D1E4D0C4)
Date: Thu, 15 Jan 2009 21:18:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Artur Skawina <art.08.09@gmail.com>
CC: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200901152042.42372.chunkeey@web.de> <496F9740.5010109@gmail.com> <200901152341.02130.chunkeey@web.de> <496FCDDD.7090203@gmail.com>
In-Reply-To: <496FCDDD.7090203@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Artur Skawina wrote:
> Christian Lamparter wrote:
>> well... I'm still looking for an explanation for your other problems:
>> =============================================================================
>> BUG kmalloc-4096: Poison overwritten
>> -----------------------------------------------------------------------------
>>
>>   Object 0xddec18c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>>   Object 0xddec18d0:  >69< 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ikkkkkkkkkkkkkkk
>>   Object 0xddec18e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>>
>> The odd thing is here that it's only a "single" bit in the object flipped and not more!
> 
> yes, that does not look good. i didn't find anything obvious under wireless/p54
> that could be responsible for it, didn't look at the rest of the stack yet.
> I'd say ignore this for now, until i'm able to reproduce it; one try on a very
> different machine didn't help and i didn't have a lot of time to retest after
> the kernel upgrade(s) today. 
> 
>> And we all have slub/slab debug options enabled as well (in fact, we had to fix the usbdriver for that,
>> see patch "p54usb: rewriting rx/tx routines to make use of usb_anchor's facilities" )
>>
>> can you check your RAM with memtest or something?
> 
> yes, i just need to plan for enough downtime... 

I too have seen real single bit changes - in my case 6b went to 6a,
and my memory is fine. I wouldn't necessarily blame your hardware.

Larry

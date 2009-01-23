Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36324 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603AbZAWSDH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 13:03:07 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: integration of opensource firmware with b43 kernel driver
Date: Fri, 23 Jan 2009 19:02:06 +0100
Cc: Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it>
In-Reply-To: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901231902.06336.mb@bu3sch.de> (sfid-20090123_190312_461592_0B30ECE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 January 2009 18:36:37 Francesco Gringoli wrote:
> Hello,
> 
> we have been testing the firmware for a week now and it seems stable.  
> I personally tested it also on a Linksys WRT54GL and it works both in  
> station and in AP modes. I collected the feedbacks that some of you  
> sent and it seems that the firmware now runs on these board:
> 
> - 4306, 4311, 4318, 4320

I don't think it has enough testing, yet.

> I was considering the suggestions you all gave me a few days ago and  
> other questions related to the possible integration of this firmware  
> into the kernel, and I came to these conclusions/questions (please  
> forgive me for this long message :-) )

I don't think we want to have the firmware in the kernel.
Instead distributions should simply ship the firmware in a package.
That's not our business.

> - change the name of the initvals for the opensource firmware: this  

Why?

> seems a little bit complicated as now the decision about the initval- 
> files' names and the detection of the firmware type are respectively  
> based on the phy type and on the firmware date. This means that  
> initval-files' names can be determine as soon as the hardware type has  
> been probed, while the firmware needs to be started before the kernel  
> can determine if it is opensource or not: at this time, however, the  
> initvals have already been uploaded. What can we do?

Nothing. Why do we need to have different names?

> - detection of the opensource firmware capabilities: are you really  
> sure we cannot use a shm location that the bcm proprietary firmware  
> uses for some other purpose?

Yes, well. You're not intermixing an earlier discussion into this, where
you didn't indicate opensource capabilities to the kernel.
If you indicate OS capabilities, you can use whatever offset you want, of course.

> - what to do with rts procedure: we can implement this feature easily  
> but I'm not sure about the value it can add to people (the majority of  
> users?) that use the bcm board in station mode. This is different for  
> those who run a bcm card in AP mode, but we can clearly discourage  
> them to run this firmware in AP mode if  not sure about rts usage by  
> stations. However, we put this task in the todo list.

RTS/CTS is not specific to AP mode. It's used on any station in the BSS.
See IEEE 802.11 specs.

> - tx header layout: the opensource firmware is now using the old  
> memory layout in the tx header (<351). Do you think switching to 410  
> format is mandatory now or we can concentrate on the other tasks?

Yes, the old format is deprecated and will be removed soon.

> - I would like to start considering N-phy on the firmware side. I have  
> a late 2008 MacBook Pro and I'm not sure if beginning this work on  
> this platform is a waste of time or not as Apple could have asked  
> Broadcom a customized chipset. Should I start or is it better if I buy  
> a N-phy pci board for my x86 box?

A little bit of b43-asm work is still needed for this core.
There are a few FIXMEs in the code. Not sure, maybe there's more to do.
I didn't try that, yet.
Before you start, you'll have to verify whether the assembler works correctly.
Same for the disassembler.

-- 
Greetings, Michael.

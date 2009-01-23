Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:51604 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbZAWRgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 12:36:43 -0500
Message-Id: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it> (sfid-20090123_183648_238511_C433F7E0)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: integration of opensource firmware with b43 kernel driver
Date: Fri, 23 Jan 2009 18:36:37 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

we have been testing the firmware for a week now and it seems stable.  
I personally tested it also on a Linksys WRT54GL and it works both in  
station and in AP modes. I collected the feedbacks that some of you  
sent and it seems that the firmware now runs on these board:

- 4306, 4311, 4318, 4320

I was considering the suggestions you all gave me a few days ago and  
other questions related to the possible integration of this firmware  
into the kernel, and I came to these conclusions/questions (please  
forgive me for this long message :-) )

- change the name of the initvals for the opensource firmware: this  
seems a little bit complicated as now the decision about the initval- 
files' names and the detection of the firmware type are respectively  
based on the phy type and on the firmware date. This means that  
initval-files' names can be determine as soon as the hardware type has  
been probed, while the firmware needs to be started before the kernel  
can determine if it is opensource or not: at this time, however, the  
initvals have already been uploaded. What can we do?

- detection of the opensource firmware capabilities: are you really  
sure we cannot use a shm location that the bcm proprietary firmware  
uses for some other purpose? Once, in fact, the kernel has determined  
that the firmware is opensource it can also use a given location in a  
different manner than it would do for a proprietary firmware. However  
this is not a problem at all :-) as we can use one location in the  
"high" shm-memory area, let's say > 0xb00, just choose one.

- what to do with rts procedure: we can implement this feature easily  
but I'm not sure about the value it can add to people (the majority of  
users?) that use the bcm board in station mode. This is different for  
those who run a bcm card in AP mode, but we can clearly discourage  
them to run this firmware in AP mode if  not sure about rts usage by  
stations. However, we put this task in the todo list.

- tx header layout: the opensource firmware is now using the old  
memory layout in the tx header (<351). Do you think switching to 410  
format is mandatory now or we can concentrate on the other tasks?

- I would like to start considering N-phy on the firmware side. I have  
a late 2008 MacBook Pro and I'm not sure if beginning this work on  
this platform is a waste of time or not as Apple could have asked  
Broadcom a customized chipset. Should I start or is it better if I buy  
a N-phy pci board for my x86 box?

Thank you for your time.
Cheers,
-FG

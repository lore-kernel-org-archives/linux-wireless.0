Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:52447 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbZAILL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 06:11:29 -0500
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>
Message-Id: <9F70A0D3-6334-45FB-9DAF-263FE89C847E@ing.unibs.it> (sfid-20090109_121138_171691_B46CC964)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200901091149.28683.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [b43] opensource firmware
Date: Fri, 9 Jan 2009 12:00:41 +0100
References: <200901091129.22708.mb@bu3sch.de> <200901091149.28683.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

I think someone else other than us two (me and Lorenzo, here) should  
test the firmware. Have you tested it on your boards?

1) We are pretty sure this firmware works on the hardware we have  
tested it for now six months... nevertheless some external testing  
should be required
2) On Linux RTS/CTS seems to be default disable (at least on the  
kernel we used for testing, 2.6.27-rc5-wl) but if someone enables it  
the driver+firmware chain could freeze and leave the system in  
undetermined state
3) The firmware does not support the QoS interface of b43, it should  
be disable on module load.

Cheers,
-FG

On Jan 9, 2009, at 11:49 AM, Michael Buesch wrote:

> I'd like to start merging this into the "firmware" directory
> of the mainline kernel.
>
> On Friday 09 January 2009 11:29:22 Michael Buesch wrote:
>>
>> ----------  Forwarded Message  ----------
>>
>> Subject: opensource firmware
>> Date: Friday 09 January 2009
>> From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
>> To: bcm43xx-dev@lists.berlios.de
>>
>> Hello folks,
>>
>> we have been involved in the past few months in testing modifications
>> to the standard 802.11 MAC for research purposes. During this time we
>> did some tests with Broadcom 802.11b/g boards and we wrote down a
>> simple 802.11 compliant firmware that we used as a starting point for
>> the modified MAC algorithms.
>>
>> Although the base firmware is not fully 802.11 compliant, e.g., it
>> does not support RTS/CTS procedure or QoS, we believe that someone
>> could be interested in testing it. The firmware does not require the
>> kernel to be modified and it uses the same shared memory layout and
>> global registers usage of the original stuff from broadcom to ease
>> loading by the b43 driver (and ease our writing...). We wrote it to
>> make the b43 driver recognize it as Broadcom version 5 firmware: it
>> still uses the original initval files of that version of the
>> Broadcom's firmware, we do not include them as usual users have to
>> extract these files following the b43 installation instructions.
>>
>> Lorenzo and I tested this firmware only on 4306 and 4318 hardware  
>> (pci
>> and minipci, pc-card based architectures seem to have problems), and
>> we did simple tests on the integrated board of a Linksys WRT54GL, so
>> we are quite sure it runs on 4306, 4318 and 4320 cards. We did all  
>> the
>> works on kernel 2.6.27-rc5-wl.
>>
>> The firmware along with the instructions to build it from the  
>> assembly
>> code using the tools developed by the b43 community can be found here
>>
>> 	http://www.ing.unibs.it/openfwwf
>>
>> In the firmware website you can find more information about the fw
>> algorithm, its interaction with Broadcom hardware and other
>> information that we discovered as we were writing it.
>>
>> We would like to underline that this work would have not been  
>> possible
>> without the instruments already developed by the b43 community
>> (assembler/disassembler), hardware specifications (sipsolution's
>> website), the opensource test firmware written by Michael Buesch and
>> useful talks with those guys (b43 developers), which we deeply
>> acknowledge. As we used several definition files written by Michael
>> for its firmware and we have prepared a source tar file that includes
>> them, we kindly ask Michael if this could be a problem.
>>
>> Finally we stress that this is a TEST firmware and some stuff needs  
>> to
>> be fixed (e.g. RTS/CTS and QoS), we have been using it as a starting
>> point to implement other MAC algorithms for research purposes: if
>> someone is interested in this kind of work and would like to share
>> ideas also on research topics, please let us know.
>>
>> Cheers,
>> Francesco Gringoli
>> Lorenzo Nava
>> _______________________________________________
>> Bcm43xx-dev mailing list
>> Bcm43xx-dev@lists.berlios.de
>> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>>
>>
>> -------------------------------------------------------
>>
>
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





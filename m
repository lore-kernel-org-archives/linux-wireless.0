Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:36398 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372AbZKYAjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 19:39:35 -0500
Received: by gxk26 with SMTP id 26so7252467gxk.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 16:39:42 -0800 (PST)
Message-ID: <4B0C7CC9.3060005@lwfinger.net>
Date: Tue, 24 Nov 2009 18:39:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Chris Vine <chris@cvine.freeserve.co.uk>,
	bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.df>,
	William Bourque <william.bourque@polymtl.ca>
Subject: Re: DMA errors with BCM4312 - an update
References: <4B0C2EC3.5010408@lwfinger.net> <20091124211552.533a2b4e@boulder.homenet> <200911242220.47497.mb@bu3sch.de>
In-Reply-To: <200911242220.47497.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2009 03:20 PM, Michael Buesch wrote:
> On Tuesday 24 November 2009 22:15:52 Chris Vine wrote:
>> On Tue, 24 Nov 2009 13:06:43 -0600
>> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>> This E-mail is to summarize what I have learned to date.
>>>
>>> The pm_qos change does nothing useful. It may have helped a little,
>>> but the side effects are far worse than the benefits.
>>>
>>> Most systems work better with b43 when warm booted after Broadcom's
>>> wl driver was loaded. The conclusion is that wl is making some change
>>> in the setup that b43 is not.
>>>
>>> (3) Based on the above, I have done MMIO and PCI-E configuration
>>> tracing for the two drivers and found some real differences. After
>>> seeing these, I did more RE work, and found some setup for the PCI-E
>>> core that was missed earlier. I am still working on the changes. What
>>> I have completed is found at
>>>
>>> http://bcm-v4.sipsolutions.net/PCI-E#PCI-E_Setup
>>>
>>> I doubt that most of these new routines will affect the problem
>>> interfaces as they apply only to PCI-E core revisions 7 and 8. My
>>> BCM4312 has rev 9. I do not know what versions are giving the
>>> trouble. With SSB_DEBUG enabled, it will be in a log line as follows:
>>>
>>> ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
>>>
>>> If you are seeing the DMA error, please supply the above info.
>>>
>>> The "PCI-E Miscellaneous Configuration" routine that is not yet
>>> finished does run on my system and is the source of the tracing
>>> differences. If the problem cards has a revision newer than 9, I will
>>> probably need an MMIO trace for your device.
>>
>> This is mine, the same revision as yours, but which demonstrates the
>> DMA errors:
>>
>> ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor 0x4243)
>> ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F, vendor 0x4243)
>> ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
>> ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
>> ssb: Found rev 1 PMU (capabilities 0x02A62F01)
> 
> Larry, do you also have the same PMU?

ssb: Found rev 1 PMU (capabilities 0x02A62F01)

Yes - seems to be identical.

Larry

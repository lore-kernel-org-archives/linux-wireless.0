Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbXF1OYl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2007 10:24:41 -0400
Message-ID: <4683C49F.8050803@redhat.com>
Date: Thu, 28 Jun 2007 16:24:31 +0200
From: Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
To: Matteo Croce <rootkit85@yahoo.it>
CC: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 0/4] airo fixes
References: <200706281551.37334.rootkit85@yahoo.it>
In-Reply-To: <200706281551.37334.rootkit85@yahoo.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matteo Croce skrev:
>> On Wed, 2007-06-27 at 23:14 +0200, Michal Schmidt wrote:
>> Hello,
>>
>> this is a series of four patches for the airo driver:
>>
>> 1/4: airo: don't use the interface name so much before registration
>> 2/4: airo: delay parts of initialization until the netdev is up
>> 3/4: airo: disable the PCI device when unloading module
>> 4/4: airo: start with radio off
>>
>> The first two fix the race condition Matteo Croce was experiencing.
>> The third one fixes a bug I noticed during testing.
>> The last one saves some power when the card is not used.
> 
> I have applied your 4 patches on both a vanilla 2.6.21.5 kernel and
> a 2.6.22-rc6 wireless-dev one, and i found that only patches 1/4 and 2/4 are 
> good.

> the 3/4 one gives this bogus output:
> 
> airo(): Probing for PCI adapters
> PCI: Setting latency timer of device 0000:05:08.0 to 64
> airo(eth%d): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
> airo(eth%d): Doing fast bap_reads
> airo(): WPA is supported.
> airo(eth0): MAC enabled 0:d:29:4f:c:be
> airo(): Finished probing for PCI adapters

I must have missed some pieces still printing the device name before 
registration. This should be just cosmetic. I understand the card still 
works in this case?

> and the 4/4 definitely broke all:
> 
> airo(): Probing for PCI adapters
> PCI: Setting latency timer of device 0000:05:08.0 to 64
> airo(eth%d): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
> airo(eth%d): Doing fast bap_reads
> airo(eth%d): Bad MAC enable reason = 2, rid = 0, offset = 0
> airo(eth%d): MAC could not be enabled
> airo(): Finished probing for PCI adapters

That's worse. I'll see how it is possible.
Thanks for testing!

Michal


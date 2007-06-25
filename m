Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbXFYPRS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2007 11:17:18 -0400
Message-ID: <467FDC79.6090102@redhat.com>
Date: Mon, 25 Jun 2007 17:17:13 +0200
From: Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Matteo Croce <rootkit85@yahoo.it>, linux-wireless@vger.kernel.org
Subject: Re: airo
References: <200706061903.13228.rootkit85@yahoo.it>	 <46693003.8090406@redhat.com> <200706091519.29319.rootkit85@yahoo.it>	 <200706091816.47618.rootkit85@yahoo.it>  <467FD362.8000602@redhat.com> <1182783939.5449.1.camel@xo-13-A4-25.localdomain>
In-Reply-To: <1182783939.5449.1.camel@xo-13-A4-25.localdomain>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Mon, 2007-06-25 at 16:38 +0200, Michal Schmidt wrote:
>> Matteo Croce wrote:
>>> after booting i have this situation:
>>>
>>> root@raver:~# lsmod |fgrep airo
>>> airo                   80016  0
>>> root@raver:~# dmesg |fgrep airo
>>> airo(): Probing for PCI adapters
>>> airo(eth1): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
>>> airo(eth1): Doing fast bap_reads
>>> airo(eth1): WPA is supported.
>>> airo(eth1): Couldn't register_netdev
>>> airo(): Finished probing for PCI adapters
>>> root@raver:~#
>>>
>>> I have to do this to connect:
>>>
>>> root@raver:~# rmmod airo
>>> root@raver:~# modprobe airo
>>> root@raver:~# dmesg |fgrep airo
>>> airo(): Probing for PCI adapters
>>> airo(eth1): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
>>> airo(eth1): Doing fast bap_reads
>>> airo(eth1): WPA is supported.
>>> airo(eth1): Couldn't register_netdev
>>> airo(): Finished probing for PCI adapters
>>> airo(): Probing for PCI adapters
>>> airo(eth0): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
>>> airo(eth0): Doing fast bap_reads
>>> airo(eth0): WPA is supported.
>>> airo(eth0): MAC enabled 0:d:29:4f:c:be
>>> airo(): Finished probing for PCI adapters
>>> root@raver:~#
>>>   
>> Hi Matteo,
>>
>> It looks like some other network interface gets renamed from "eth0" to
>> "eth1" at the same time the airo driver is initializing the card. Does
>> it happen always after booting? Do you have other network interfaces?
>> This patch should fix it. Can you test it?
> 
> Wow, that's somewhat ugly.  Do other drivers just not have this problem,
> or have they worked around it in similar or different ways?  Just trying
> to understand if the scope of the issue is wider than just airo.

For instance, drivers/net/wireless/atmel.c looks very similar, so I
guess it has the same race. With airo the race is just more visible,
because of all the long sleeps it does between getting the name with
dev_alloc_name and finally registering it.

eepro100.c takes rtnl_lock to avoid the issue. So does ns83820.c - it
has a big comment about how ugly it is.

Michal


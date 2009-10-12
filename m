Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f212.google.com ([209.85.217.212]:45220 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZJLA13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 20:27:29 -0400
Received: by gxk4 with SMTP id 4so9599987gxk.8
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2009 17:26:52 -0700 (PDT)
Message-ID: <4AD277C9.7090209@gmail.com>
Date: Sun, 11 Oct 2009 19:26:49 -0500
From: Quintin Pitts <geek4linux@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] p54pci: skb_over_panic, soft lockup, stall under flood
References: <4AD1EBA7.904@gmail.com> <4AD1FA5E.1010201@lwfinger.net> <200910112141.01747.chunkeey@googlemail.com>
In-Reply-To: <200910112141.01747.chunkeey@googlemail.com>
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun Oct 11 2009 14:41:01 GMT-0500 (CDT), Christian Lamparter wrote:
> On Sunday 11 October 2009 17:31:42 Larry Finger wrote:
>>> In trying to get p54pci driver to be stable on my platform and hardware
>>> - here is a generic patch that seems to accomplish that.  Since the
>>> ViewSonic V210 uses the IT8152 pci bridge - some attention was needed to
>>> get dma related allocation in the first physical 64M.  I have verified
>>> that the dma related allocation is in the first 64M and dmabounce is not
>>> being used - just for those wondering if that was part of the problems.
> 
> it8152 was an important bit:
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0702.1/0645.html
> 
> the commit sparked a discussion about it8152 pci reliability.
> It doesn't look good:
> 
> (commit author):
> "I have no idea if it's possible to get a reliable PCI bus or
> not with this chip. Right now, we only use it for it's built-in OHCI
> USB host controller and UART. You're making me hope I never have to
> use it for interfacing a PCI card!"
> 
> ( http://lkml.indiana.edu/hypermail/linux/kernel/0702.1/1907.html )
> 
> [...]
> 
> "Well on the system on a board we were trying, using the development
> baseboard from the same supplier, by simply doing a ping flood through
> the onboard rtl8139 I managed to get corrupted ethernet packets fairly
> frequently. "
> ( http://lkml.indiana.edu/hypermail/linux/kernel/0702.1/1917.html )
> 
> the sad conclusion is that: no matter what fixes you throw
> at the driver (BTW: isl38xx isn't 100% pci v2.1 compliance either)
> your chances of getting the device (with the softmac fw)
> working properly with that board are next to... not,
> unless you can magically fix the pci-bridge issues.

I feared as much.

At least that patch has given me hope.  It survives a iperf and ping
flood now with out going belly up.  Device has been up for three days
now with network still working.   But likely glitches will show up.

iperf tests at about 9.6 to 15 Mbits/sec on a 802.11g WPA network which is
about 2 times faster than what I had under WinCE.

web browsing and ssh and scp all work great at the moment.

Time will tell...

Thanks much!

Quintin.


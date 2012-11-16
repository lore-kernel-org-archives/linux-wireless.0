Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43420 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab2KPROI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 12:14:08 -0500
Message-ID: <50A67454.6000804@hauke-m.de> (sfid-20121116_181411_886063_67B06EB0)
Date: Fri, 16 Nov 2012 18:13:56 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Elliott Mitchell <ehem+outbound@m5p.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcm4716 and PCIe
References: <20121116044429.GA73539@scollay.m5p.com>
In-Reply-To: <20121116044429.GA73539@scollay.m5p.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2012 05:44 AM, Elliott Mitchell wrote:
> I happened to be browsing the linux-mips git repository and noticed the
> commit at Tue, 10 Jul 2012 16:16:47.

What commit are you talking about? Do you have a commit id?

> The Broadcom 4716 *does* have an external PCI Express interface! Take a
> look at the images on http://wiki.openwrt.org/toh/asus/rt-n16  If you
> look at the image of the underside
> (http://wiki.openwrt.org/_media/inbox/rt-n16_back_hires.jpg) on the right
> side, CON3 and CON5 are the solder pads for mounting a mini-PCIe
> connector and bracket.  Apparently V11 is a voltage regulator needed for
> that to work, but on this an example of a Broadcom 4716 board that really
> does allow a useable PCIe interface (with some hardware hacking).

Are you sure the Asus rt-n16 has a BCM4716 and not an BCM4718? Both have
the same chip id (0x4716), but a different revision number (BCM4716 =
rev 8, BCM4718 = rev 10). The BCM4716 and BCM4717 do not have a PCIe
controller, just the BCM4718 has one [0].

> What is the status of brcm4716 support?  The ASUS source code is in the
> wild, but that includes many files marked, "UNPUBLISHED PROPRIETARY
> SOURCE CODE of Broadcom Corporation".  Bit silly since they've been
> published at this point, but they still retain the rights...

Some of the code for BCM4716 is upstream, some is just in OpenWrt [1]
and not yet upstream and some is missing. The Ethernet driver is still
missing. The Asus GPL tar contains all the code expect the one for the
wireless driver, but b43 and brcmsmac already have support for this wifi
core.

Hauke

[0]: http://www.datasheetdir.com/BCM4717+Communications-Processor
[1]:
https://dev.openwrt.org/browser/trunk/target/linux/brcm47xx/patches-3.3/


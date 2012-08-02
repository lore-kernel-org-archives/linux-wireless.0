Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab2HBOpp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 10:45:45 -0400
Date: Thu, 2 Aug 2012 10:45:29 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 0/2] Fix lockdep warning in brcmsmac
Message-ID: <20120802144529.GI1785@zod.bos.redhat.com> (sfid-20120802_164548_784390_C0261B18)
References: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com>
 <20120802002353.GD1785@zod.bos.redhat.com>
 <20120802015320.GA25933@thinkpad-t410>
 <20120802120230.GE1785@zod.bos.redhat.com>
 <20120802125102.GF1785@zod.bos.redhat.com>
 <501A83AF.9060706@broadcom.com>
 <20120802134512.GG1785@zod.bos.redhat.com>
 <501A880A.6030000@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <501A880A.6030000@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 02, 2012 at 04:00:42PM +0200, Arend van Spriel wrote:
> On 08/02/2012 03:45 PM, Josh Boyer wrote:
> > #
> > # Broadcom specific AMBA
> > #
> > CONFIG_BCMA=m
> > CONFIG_BCMA_BLOCKIO=y
> > CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> > CONFIG_BCMA_HOST_PCI=y
> > CONFIG_BCMA_DRIVER_GMAC_CMN=y
> > # CONFIG_BCMA_DEBUG is not set
> 
> As you indicated not seeing anything on the bcma bus (in kernel log, you
> mean?) I was wondering about BCMA_HOST_PCI flag, but that looks fine.
> Not sure why you have BCMA_DRIVER_GMAC_CMN enabled. Grabbing straws.
> 
> I actually had a similar behaviour and noticed a PCI bridge port was
> missing. Do you see that also with lspci?

Hm.  I can't recall the full lspci output before this problem showed up,
but I do have dmesg output from before and now.  Comparing them, I see:

[    0.639235] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-ff]
[    0.639284] pci 0000:02:00.0: [14e4:4727] type 00 class 0x028000
[    0.639321] pci 0000:02:00.0: reg 10: [mem 0xfe500000-0xfe503fff 64bit]
[    0.639550] pci 0000:02:00.0: supports D1 D2
[    0.639551] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.641078] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.641091] pci 0000:00:1c.0:   bridge window [mem 0xfe500000-0xfe5fffff]

from before, and:

[    0.636241] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-ff]
[    0.636244] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.636342] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-ff]

now.  So it seems 1434:4727 is missing now.  How very very odd.

<5 minutes later>

OK, so I physically unplugged the machine from the wall and let it sit
for 5 minutes.  When I plugged it back in, that PCI bridge port magically
reappeared.  I guess that's good news.  Thanks for suffering through
with me.

I'll go test Seth's patches now.  I hate computers.

josh

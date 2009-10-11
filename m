Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:38808 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZJKTlq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 15:41:46 -0400
Received: by ewy4 with SMTP id 4so1984785ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2009 12:41:09 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] p54pci: skb_over_panic, soft lockup, stall under flood
Date: Sun, 11 Oct 2009 21:41:01 +0200
Cc: Quintin Pitts <geek4linux@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <4AD1EBA7.904@gmail.com> <4AD1FA5E.1010201@lwfinger.net>
In-Reply-To: <4AD1FA5E.1010201@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200910112141.01747.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 11 October 2009 17:31:42 Larry Finger wrote:
> > In trying to get p54pci driver to be stable on my platform and hardware
> > - here is a generic patch that seems to accomplish that.  Since the
> > ViewSonic V210 uses the IT8152 pci bridge - some attention was needed to
> > get dma related allocation in the first physical 64M.  I have verified
> > that the dma related allocation is in the first 64M and dmabounce is not
> > being used - just for those wondering if that was part of the problems.

it8152 was an important bit:

http://lkml.indiana.edu/hypermail/linux/kernel/0702.1/0645.html

the commit sparked a discussion about it8152 pci reliability.
It doesn't look good:

(commit author):
"I have no idea if it's possible to get a reliable PCI bus or
not with this chip. Right now, we only use it for it's built-in OHCI
USB host controller and UART. You're making me hope I never have to
use it for interfacing a PCI card!"

( http://lkml.indiana.edu/hypermail/linux/kernel/0702.1/1907.html )

[...]

"Well on the system on a board we were trying, using the development
baseboard from the same supplier, by simply doing a ping flood through
the onboard rtl8139 I managed to get corrupted ethernet packets fairly
frequently. "
( http://lkml.indiana.edu/hypermail/linux/kernel/0702.1/1917.html )

the sad conclusion is that: no matter what fixes you throw
at the driver (BTW: isl38xx isn't 100% pci v2.1 compliance either)
your chances of getting the device (with the softmac fw)
working properly with that board are next to... not,
unless you can magically fix the pci-bridge issues.

Regards,
	Chr

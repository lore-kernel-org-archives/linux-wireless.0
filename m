Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53666 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790AbZKXTGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 14:06:42 -0500
Received: by bwz27 with SMTP id 27so6309984bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 11:06:47 -0800 (PST)
Message-ID: <4B0C2EC3.5010408@lwfinger.net>
Date: Tue, 24 Nov 2009 13:06:43 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
CC: Michael Buesch <mb@bu3sch.df>,
	William Bourque <william.bourque@polymtl.ca>,
	Chris Vine <chris@cvine.freeserve.co.uk>
Subject: DMA errors with BCM4312 - an update
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This E-mail is to summarize what I have learned to date.

The pm_qos change does nothing useful. It may have helped a little, but the side
effects are far worse than the benefits.

Most systems work better with b43 when warm booted after Broadcom's wl driver
was loaded. The conclusion is that wl is making some change in the setup that
b43 is not.

(3) Based on the above, I have done MMIO and PCI-E configuration tracing for the
two drivers and found some real differences. After seeing these, I did more RE
work, and found some setup for the PCI-E core that was missed earlier. I am
still working on the changes. What I have completed is found at

http://bcm-v4.sipsolutions.net/PCI-E#PCI-E_Setup

I doubt that most of these new routines will affect the problem interfaces as
they apply only to PCI-E core revisions 7 and 8. My BCM4312 has rev 9. I do not
know what versions are giving the trouble. With SSB_DEBUG enabled, it will be in
a log line as follows:

ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)

If you are seeing the DMA error, please supply the above info.

The "PCI-E Miscellaneous Configuration" routine that is not yet finished does
run on my system and is the source of the tracing differences. If the problem
cards has a revision newer than 9, I will probably need an MMIO trace for your
device.

Larry


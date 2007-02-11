Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:65327 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbXBKQR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 11:17:28 -0500
Message-ID: <45CF4195.10709@lwfinger.net>
Date: Sun, 11 Feb 2007 10:17:25 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net> <200702111514.04893.mb@bu3sch.de> <45CF3D51.5050302@lwfinger.net> <200702111703.13702.mb@bu3sch.de>
In-Reply-To: <200702111703.13702.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Sunday 11 February 2007 16:59, Larry Finger wrote:
>> Michael Buesch wrote:
>>> On Sunday 11 February 2007 15:02, Rafael J. Wysocki wrote:
>>>> PM: Removing info for No Bus:0000:30:00.0
>>>> bcm43xx: IRQ_READY timeout
>>>> bcm43xx: core_up for active 802.11 core failed (-19)
>>> I never tried suspend to disk with the driver.
>> This implies that suspend to RAM works. Is that true?
> 
> No.
> 
>>> Larry, an idea why the microcode doesn't respond?
>> Is this code snippet supposed to keep the firmware loaded when the system is suspended?
> 
> Well, eh, no. Don't confuse suspend-to-ram with suspend-to-disk.
> On suspend-to-disk the kernel is (mostly) reloaded as usual.
> Just userspace is restored.
> So the driver enters through the probe routine on resume from disk.
> 
Does it then call the resume entry? Rafael's dmesg output has the line "bcm43xx: Resuming..." that
only gets printed if the resume routine was called.

Larry


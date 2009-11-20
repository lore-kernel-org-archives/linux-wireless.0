Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42376 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbZKTOLI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 09:11:08 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RFC] ssb: Generic SPROM override for devices without SPROM
Date: Fri, 20 Nov 2009 15:11:09 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <200911201212.19588.mb@bu3sch.de> <4B06A233.2070708@lwfinger.net>
In-Reply-To: <4B06A233.2070708@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200911201511.11042.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 November 2009 15:05:39 Larry Finger wrote:
> On 11/20/2009 05:12 AM, Michael Buesch wrote:
> > This patch adds a generic mechanism for overriding the SPROM mechanism
> > on devices without SPROM hardware.
> > 
> > There currently is a major problem with this:
> > It tries to deduce a MAC address from various hardware parameters. But
> > currently it will result in the same MAC address for machines of the same
> > type. Does somebody have an idea of some device-instance specific serial
> > number or something similar that could be hashed into the MAC?
> 
> You might look at the "root=" part of /proc/cmdline. Mine says
> "root=/dev/disk/by-id/ata-TOSHIBA_MK2546GSX_18C2P0KCT-part1". That disk serial
> number would certainly be unique. Even if it just said "root=/dev/sda1", it
> would be repeatable.

Ok, I think this is getting ugly :)
The problem with all this is that if you change the harddisk, or change the partitioning,
the wireless mac address would change. That would surely lead to confusion.

I think we probably have to drop this patch and instead do a mechanism that
fetches the sprom from userspace, if the card doesn't have one. This way we
can have a script in userspace that generates the image based on the PCI ID
information and just randomizes the MAC address once. The firmware loading
mechanism would be useful for that.
In case of an embedded device with the MAC in the nvram, the kernel can still
override the mac address provided by userspace.

-- 
Greetings, Michael.

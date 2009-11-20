Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41180 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751814AbZKTOer (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 09:34:47 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH RFC] ssb: Generic SPROM override for devices without SPROM
Date: Fri, 20 Nov 2009 15:34:49 +0100
Cc: bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200911201212.19588.mb@bu3sch.de> <4B06A233.2070708@lwfinger.net>
In-Reply-To: <4B06A233.2070708@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911201534.51602.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Friday 20 November 2009, Larry Finger wrote:
> On 11/20/2009 05:12 AM, Michael Buesch wrote:
[...]
> You might look at the "root=" part of /proc/cmdline. Mine says
> "root=/dev/disk/by-id/ata-TOSHIBA_MK2546GSX_18C2P0KCT-part1". That disk serial
> number would certainly be unique. Even if it just said "root=/dev/sda1", it
> would be repeatable.
[...]

"by-id" has the disadvantage that it changes with the means of accessing 
the disk, namely if your driver uses the old (obsolete) ide API or is a new
libata driver.

Technically only "by-uuid" is relatively guaranteed to be stable (unless a 
partition gets cloned with dd), with "by-label" coming close (only bad if 
any disk or USB storage device duplicates an existing label, like "root").

Regards
	Stefan Lippers-Hollmann

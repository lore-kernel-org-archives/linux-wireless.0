Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:41556 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbZKTOFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 09:05:36 -0500
Received: by gxk26 with SMTP id 26so2970183gxk.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2009 06:05:42 -0800 (PST)
Message-ID: <4B06A233.2070708@lwfinger.net>
Date: Fri, 20 Nov 2009 08:05:39 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Oncaphillis <oncaphillis@snafu.de>
Subject: Re: [PATCH RFC] ssb: Generic SPROM override for devices without SPROM
References: <200911201212.19588.mb@bu3sch.de>
In-Reply-To: <200911201212.19588.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/2009 05:12 AM, Michael Buesch wrote:
> This patch adds a generic mechanism for overriding the SPROM mechanism
> on devices without SPROM hardware.
> 
> There currently is a major problem with this:
> It tries to deduce a MAC address from various hardware parameters. But
> currently it will result in the same MAC address for machines of the same
> type. Does somebody have an idea of some device-instance specific serial
> number or something similar that could be hashed into the MAC?

You might look at the "root=" part of /proc/cmdline. Mine says
"root=/dev/disk/by-id/ata-TOSHIBA_MK2546GSX_18C2P0KCT-part1". That disk serial
number would certainly be unique. Even if it just said "root=/dev/sda1", it
would be repeatable.

Larry


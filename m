Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:50169 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932469Ab0KPJpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 04:45:19 -0500
Date: Tue, 16 Nov 2010 11:45:12 +0200
From: Jouni Malinen <j@w1.fi>
To: Ben Greear <greearb@candelatech.com>
Cc: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC/PATCH:  Allow wpa_supplicant to share scan results.
Message-ID: <20101116094512.GB21872@jm.kir.nu>
References: <4CE1CEC6.2050103@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CE1CEC6.2050103@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 15, 2010 at 04:22:30PM -0800, Ben Greear wrote:
> The attached (and inline) patch allows wpa_supplicant to share scan results
> between all VIFS on the same radio (phy).  This patch is a bit rough, but
> it does appear to do what I was hoping for.
> 
> Please let me know if this has any chance and upstream inclusion.

With the changes in wpa_supplicant/events.c, the likelihood of that
getting anywhere is about zero, but if the driver specific changes were
to be moved to src/drivers/driver_nl80211.c, this could be quite a
reasonable change to include in the upstream tree. Note the
global_init() and init2() struct wpa_driver_ops callbacks that should
make it easy to track the interfaces within driver_nl80211.c.

I would like to have more knowledge of virtual interfaces sharing the
same radio in the driver wrappers anyway, e.g., for shared_freq()
implementations. If this can be reliably detected from the driver (which
hopefully is the case with mac80211-based ones), it would be great to be
able to that without having to ask the user to configure anything.

> I know I need to at least strip out some of the debug code, and make
> this optional via the global config file, but I was hoping early feedback
> might save more work later...

What would be need for configuring this? In which case would it be
preferred to not process the scan results from other virtual interfaces
on the same radio? Wouldn't those scan events look exactly like the same
if some other application would have triggered them?


In addition, it might be interesting to considering sharing the BSS
table and scan result parsing in wpa_supplicant among the interface,
too, instead of just the scan completed events..

-- 
Jouni Malinen                                            PGP id EFC895FA

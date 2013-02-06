Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab3BFJBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 04:01:05 -0500
Message-ID: <1360141277.7910.9.camel@jlt4.sipsolutions.net> (sfid-20130206_100112_529149_DB5B6992)
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix NULL dereference BUG when using
 new_id
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Stable <stable@vger.kernel.org>
Date: Wed, 06 Feb 2013 10:01:17 +0100
In-Reply-To: <1360113382.2857.48.camel@bwh-desktop.uk.solarflarecom.com> (sfid-20130206_021632_180510_96D16282)
References: <1360108823-5141-1-git-send-email-Larry.Finger@lwfinger.net>
	 <1360109904.2857.36.camel@bwh-desktop.uk.solarflarecom.com>
	 <5111A766.70006@lwfinger.net>
	 <1360113382.2857.48.camel@bwh-desktop.uk.solarflarecom.com>
	 (sfid-20130206_021632_180510_96D16282)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 01:16 +0000, Ben Hutchings wrote:

> > I don't know why USB differs from PCI, but we do need the dynamic ID here as 
> > there are always new IDs being issued. One of the criteria for adding the ID to 
> > the table is that it works OK with dynamic addition. These devices are 
> > frequently reported by users that do not have the skills to build their own kernel.
> 
> But since there is no way to set the driver_info for a new USB ID
> (again, unlike PCI), your change will reject all dynamic IDs.  (And in
> any case, if the USB core were changed to allow setting driver_info,
> userland would have difficulty providing a valid pointer!)
> 
> It looks like the driver_info is really driver-specific data used to
> share a probe function between multiple drivers.  But you could add
> per-driver probe functions that pass the correct rtl_hal_cfg as an extra
> argument to rtl_usb_probe(), and then dynamic IDs should work.

Some (PCI?) drivers had/have numbers instead of pointers, so userland
can provide a number and it then looks up the pointer in an array.
That's only slightly indirected but makes new_id more useful in that
case.

johannes


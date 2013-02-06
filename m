Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.solarflare.com ([12.187.104.25]:18971 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab3BFBQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 20:16:26 -0500
Message-ID: <1360113382.2857.48.camel@bwh-desktop.uk.solarflarecom.com> (sfid-20130206_021632_180510_96D16282)
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix NULL dereference BUG when using
 new_id
From: Ben Hutchings <bhutchings@solarflare.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, Stable <stable@vger.kernel.org>
Date: Wed, 6 Feb 2013 01:16:22 +0000
In-Reply-To: <5111A766.70006@lwfinger.net>
References: <1360108823-5141-1-git-send-email-Larry.Finger@lwfinger.net>
	 <1360109904.2857.36.camel@bwh-desktop.uk.solarflarecom.com>
	 <5111A766.70006@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-05 at 18:44 -0600, Larry Finger wrote:
> On 02/05/2013 06:18 PM, Ben Hutchings wrote:
> > On Tue, 2013-02-05 at 18:00 -0600, Larry Finger wrote:
> >> When the new_id entry is used for a foreign USB device, rtlwifi BUGS with
> >> a NULL pointer dereference.
> > [...]
> >
> > So set no_dynamic_id in the usb_driver structures.
> >
> > (But I wonder why USB behaves differently from PCI, which requires that
> > the dynamic ID's driver_data value (defaulting to 0) matches a value
> > used in a static ID entry.)
> 
> I don't know why USB differs from PCI, but we do need the dynamic ID here as 
> there are always new IDs being issued. One of the criteria for adding the ID to 
> the table is that it works OK with dynamic addition. These devices are 
> frequently reported by users that do not have the skills to build their own kernel.

But since there is no way to set the driver_info for a new USB ID
(again, unlike PCI), your change will reject all dynamic IDs.  (And in
any case, if the USB core were changed to allow setting driver_info,
userland would have difficulty providing a valid pointer!)

It looks like the driver_info is really driver-specific data used to
share a probe function between multiple drivers.  But you could add
per-driver probe functions that pass the correct rtl_hal_cfg as an extra
argument to rtl_usb_probe(), and then dynamic IDs should work.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


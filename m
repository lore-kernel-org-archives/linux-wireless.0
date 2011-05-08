Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:32931 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab1EHBsZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 21:48:25 -0400
Subject: Re: ssb: where to reject dangling cores?
From: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	b43-dev <b43-dev@lists.infradead.org>
In-Reply-To: <BANLkTimRasoDAbK+tLNFx8zK96Xe1hnHXg@mail.gmail.com>
References: <BANLkTimRasoDAbK+tLNFx8zK96Xe1hnHXg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 May 2011 03:48:22 +0200
Message-ID: <1304819302.21680.10.camel@maggie> (sfid-20110508_034828_034939_C4E424C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-05-07 at 22:40 +0200, Rafał Miłecki wrote: 
> Michael, I can see code for ignoring dangling cores in both: ssb and b43.
> 
> In ssb it's quite common, we have:
> 1) we_support_multiple_80211_cores for 80211
> 2) inline checks in ssb_bus_scan for PCI(E)
> 3) inline check in ssb_bus_scan for ETHERNET
> 
> However there is also check in b43 at the beginning of b43_one_core_attach:
> if (!pdev ||
> 	((pdev->device != 0x4321) &&
> 	(pdev->device != 0x4313) && (pdev->device != 0x431A))) {
> 	b43dbg(wl, "Ignoring unconnected 802.11 core\n");
> 	return -ENODEV;
> }
> 
> Should I move this check into ssb?

Well, I'm not sure. _Neither_ place looks fine. It's a dirty workaround
for broken hardware.

If you really want to touch this mess, then yes. Move it into ssb.

-- 
Greetings Michael.


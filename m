Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:49342 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbZEDRH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 13:07:56 -0400
Subject: Re: [PATCH] add support for showing power constraint IE
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241456088.8683.62.camel@johannes.local>
References: <1241453167-3720-1-git-send-email-marcel@holtmann.org>
	 <1241453408.8683.53.camel@johannes.local>
	 <1241454909.2903.17.camel@localhost.localdomain>
	 <1241455125.8683.60.camel@johannes.local>
	 <1241455848.2903.18.camel@localhost.localdomain>
	 <1241456088.8683.62.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 04 May 2009 10:07:43 -0700
Message-Id: <1241456863.2903.29.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > just re-based and added the patch for the WPA/RSN length checks. So we
> > should be good now in this area.
> 
> Thanks, applied, and really pushed out now.
> 
> Do you think I should cut a new release with all the shiny new parsing
> code, or will you work on more :)

the only thing that bugs me is this:

BSS 00:1c:f0:xx:xx:xx (on wlan0)
	TSF: 3332683470455 usec (38d, 13:44:43)
	freq: 2422
	beacon interval: 100
	capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
	signal: -36.00 dBm
	SSID: Big in Japan
	Supported rates: 1.0* 2.0* 5.5* 11.0* 
	DS Paramater set: channel 3
	Country: CA (in/outdoor), data: 01 0b 1b
	ERP: <no flags>
	Extended supported rates: 6.0* 9.0 12.0* 18.0 24.0* 36.0 48.0 54.0 
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 0x0000
	WMM: parameter: 01 00 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
	Vendor specific: OUI 00:90:4c, data: 33 0c 10 1f ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	Vendor specific: OUI 00:90:4c, data: 34 03 00 05 00 00 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	Unknown IE (45): 0c 10 1f ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00
	Unknown IE (61): 03 00 01 00 00 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	WPS:	 * Version: 1.0
		 * Manufacturer: D-Link Systems
		 * Model: DIR-615
		 * Device name: Wireless N Router
		 * Config methods: Label

I didn't find any specs to decode IE 45 and 61 since all of them mark
these as reserved. Not sure if these are defined in future specs or if
they are deprecated IE. And it seems its data is similar to what is in
the vendor specific elements.

The other one that keeps showing up in my area is:

	Unknown IE (47): 06

And I do have some other vendor specific ones, that I don't really care
about and we might even never know what they are:

	Vendor specific: OUI 00:03:7f, data: 01 01 00 17 00 00
	Vendor specific: OUI 00:03:7f, data: 02 01 01 4d 00 03 a4 00 00
	Vendor specific: OUI 00:03:2f, data: 01 00 01

However, as I said before, I am quite happy now since the provided
information by iw are now the same as I get with iwlist. Actually iw has
now superior decoding capabilities and is more useful. There is still
room for improvement, but I think cutting a new release is not a bad
idea.

Regards

Marcel



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46802 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbYJWTpu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 15:45:50 -0400
From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 23 Oct 2008 12:40:50 -0700
Subject: RE: [PATCH] wireless: add regulatory_struct_hint
Message-ID: <8F0C2E89B9AA20448D482EB589641EB306B6390D@orsmsx507.amr.corp.intel.com> (sfid-20081023_214554_256214_79396CA2)
References: <1224585110.5521.8.camel@johannes.berg>
 <20081022122148.GF6190@tesla>
In-Reply-To: <20081022122148.GF6190@tesla>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From: Luis R. Rodriguez [mailto:lrodriguez@atheros.com]
>
>Since this is only for wiphys this seems reasonable. I just keep in the
>back of my mind leaving open the possibility for other wireless
>subsystems to be able to make use of the currently set regulatory domain
>and its regulatory rules, but this is in keeping with that as our
>current requests are not changing the regulatory definitions, and just
>as we have a wiphy for last_request we can add later struct
>foo_new_wireless_type there too. I am curious if band definitions
>should be shared between Bluetooth and 802.11 though. I don't think
>BT devices have any notion of regulatory though nor are they capable of
>exporting it though. Marcel is this correct? Inaky -- how about uwb, or
>WiMax?

UWB swipes over all the bands (from 3.1 to 10.6G), but keeping emission below FCCp15 limits (-41dBm, if memory serves) so it looks as interference to others. All the channel assignments are fixed and known, so in theory,
it'd be possible to coordinate.

On WiMAX the bands are allocated per country and per operator, so if the
device can tell us what it supports or what the operator is telling it to
use, it should be possible for it to report it to some band controller for coordination, but I don't know if it'll make any sense to ask the device to use only bands so and so, because the knowledge of what's allowed is in the network side.

I might be missing the crux of the question though :)


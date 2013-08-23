Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54710 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab3HWFXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 01:23:05 -0400
From: "Rymarkiewicz, WaldemarX" <waldemarx.rymarkiewicz@intel.com>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>,
	"poeschel@lemonage.de" <poeschel@lemonage.de>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"sameo@linux.intel.com" <sameo@linux.intel.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"jslaby@suse.cz" <jslaby@suse.cz>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-nfc@lists.01.org" <linux-nfc@lists.01.org>
Subject: RE: [linux-nfc] [PATCH RFC] nfc: add a driver for pn532 connected
 on	uart
Date: Fri, 23 Aug 2013 05:23:00 +0000
Message-ID: <A4DEEF93D8D14A418311321B77DB71E9C9D773@IRSMSX104.ger.corp.intel.com> (sfid-20130823_072310_027893_8BEA15BB)
References: <1377181699-1668-1-git-send-email-larsi@wh2.tu-dresden.de>
In-Reply-To: <1377181699-1668-1-git-send-email-larsi@wh2.tu-dresden.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi  Lars,

>This adds a driver for the nxp pn532 nfc chip.
>It is not meant for merging. Instead it is meant to show that some
>progress has been made and what the current state is and to help
>testing.
>Although I can do some basic things with this driver I expect it to
>contain lots of bugs. Be aware!
>This driver is heavily based on the pn533 driver and duplicates much
>code. This has do be factored out some time.

I'm not sure if this is expected approach adding new drivers. You duplicates most of pn533 code which is not good.

Also, note that pn533 and pn532  are pretty the same chips (with small differences) and it would be quite natural to support both with one driver. Pn533 already reads chip version on init, so at this point you already know with which chip you are dealing with.

I suggest to separate transport layer from the core in pn533 and add support for uart and usb separately. This is exactly what I've planned while changing pn533 to support acr122 device.

Thanks,
/Waldek

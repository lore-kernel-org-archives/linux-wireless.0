Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59090
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbXJ0WgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 18:36:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Change error message for failed rc module (was: possible bug in ssb/b43)
Date: Sun, 28 Oct 2007 00:34:41 +0200
Cc: "evan foss" <evanfoss@gmail.com>, linux-wireless@vger.kernel.org
References: <4a55afb80710271456k6c3bbfeah879b67a91a3b8d41@mail.gmail.com>
In-Reply-To: <4a55afb80710271456k6c3bbfeah879b67a91a3b8d41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710280034.41942.mb@bu3sch.de> (sfid-20071027_233630_278742_CE24B072)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 27 October 2007 23:56:39 evan foss wrote:
<snip>
> ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x11, vendor 0x4243)
> ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0A, vendor 0x4243)
> ssb: Core 2 found: USB 1.1 Host (cc 0x817, rev 0x03, vendor 0x4243)
> ssb: Core 3 found: PCI-E (cc 0x820, rev 0x01, vendor 0x4243)
> ssb: Sonics Silicon Backplane found on PCI device 0000:01:00.0
> b43-phy1: Broadcom 4311 WLAN found
> b43-phy1 debug: Found PHY: Analog 4, Type 2, Revision 8
> b43-phy1 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
> phy1: Failed to select rate control algorithm
> phy1: Failed to initialize rate control algorithm
> b43: probe of ssb0:0 failed with error -2

That's not a ssb or b43 bug.
Please compile and load rc80211_simple.

I think we should change this error message, as obviously people don't
understand that the issue is a failed module request for the rc module.
Maybe add another message like "Please install a mac80211 rate control module,
such as rc80211_simple" if the error code is -ENOENT (-2)
Another suggestion?

-- 
Greetings Michael.

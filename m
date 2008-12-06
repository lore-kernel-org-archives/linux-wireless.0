Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:65492 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYLFSKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 13:10:38 -0500
To: linux-wireless@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: Re: [PATCH] Add stlc45xx, wi-fi driver for stlc4550/4560
References: <20081206173056.6853.95209.stgit@tikku>
	<20081206173211.6853.59029.stgit@tikku>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sat, 06 Dec 2008 20:10:31 +0200
In-Reply-To: <20081206173211.6853.59029.stgit@tikku> (ext Kalle Valo's message of "Sat\, 06 Dec 2008 19\:32\:12 +0200")
Message-ID: <87hc5h5g4o.fsf@nokia.com> (sfid-20081206_191058_174029_0AF89DE8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Kalle Valo" <kalle.valo@nokia.com> writes:

> This patch adds a new driver called stlc45xx, which supports wi-fi chipsets
> stlc4550 and stlc4560 from ST-NXP Wireless. The chipset can be found, for
> example, from Nokia N800 and N810 products.
>
> The driver is implemented based on the firmware interface information
> published by ST-NXP Wireless here:
>
> http://wireless.kernel.org/en/developers/Documentation/specs#STMicroelectronicshardware
>
> Currently only SPI interface is supported.

Crap, just now I realised to try to compile this with pristine
wireless-testing tree:

In file included from drivers/net/wireless/stlc45xx.c:24:
drivers/net/wireless/stlc45xx.h:27:24: error: mach/board.h: No such file or directory
drivers/net/wireless/stlc45xx.c: In function 'stlc45xx_power_off':
drivers/net/wireless/stlc45xx.c:958: error: dereferencing pointer to incomplete type
drivers/net/wireless/stlc45xx.c:959: error: dereferencing pointer to incomplete type

I usually merge linux-omap to wireless-testing and that's why I didn't
notice this. I will implement the platform data solution in v2 which
should fix this compile error. But I would still love to hear any
comments people have about v1.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:41314 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006Ab1AaP20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 10:28:26 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 04/18] wl1251: add sysfs interface for bluetooth coexistence mode configuration
References: <4D45A5A5.5090909@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 31 Jan 2011 17:28:24 +0200
In-Reply-To: <4D45A5A5.5090909@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 18\:53\:41 +0100")
Message-ID: <87mxmhdrdz.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> Port the bt_coex_mode sysfs interface from wl1251 driver version included
> in the Maemo Fremantle kernel to allow bt-coexistence mode configuration.
> This enables userspace applications to set one of the modes
> WL1251_BT_COEX_OFF, WL1251_BT_COEX_ENABLE and WL1251_BT_COEX_MONOAUDIO.
> The default mode is WL1251_BT_COEX_OFF.

Sorry, but this was an awful hack in the fremantle kernel and I really
would not like to see this in the upstream driver. We should do better
than that :) And besides, who would use it? The only user I know is
maemo's wlancond and maemo is dead and buried anyway. RIP

I'm not saying that we don't need this, I just want to understand
where we need this. And also sysfs is not the best choise imho, maybe
debugfs is better?

> It should be noted that this driver always enabled bt-coexistence before
> and enabled bt-coexistence directly affects the receiving performance,
> rendering it unusable in some low-signal situations. Especially monitor
> mode is affected very badly with bt-coexistence enabled.

Yes, btcoex is very tricky to get right. Also one problem is that
wl1251's btcoex implementation significantly increases power
consumption.

-- 
Kalle Valo

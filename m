Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp149.mail.ukl.yahoo.com ([77.238.184.80]:25731 "HELO
	smtp149.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750824AbZJWFD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 01:03:56 -0400
Message-ID: <4AE1393A.6060707@yahoo.es>
Date: Fri, 23 Oct 2009 07:03:54 +0200
From: Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, linville@tuxdriver.com
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	mb@bu3sch.de, mboton@gmail.com
Subject: b43: add 'struct b43_wl' missing declaration
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The patch "b43: add 'struct b43_wl' missing declaration" [1], which was already acked by Michael, is still needed to fix a bunch of the following GCC warnings when CONFIG_B43_LEDS is not selected:

drivers/net/wireless/b43/leds.h:79: warning: 'struct b43_wl' declared inside parameter list
drivers/net/wireless/b43/leds.h:79: warning: its scope is only this definition or declaration, which is probably not what you want

The warnings were introduced by commit "b43: Don't use struct wldev after detach." [2].

Thanks,
Albert

[1] http://marc.info/?l=linux-kernel&m=125509895406307

[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=727c988593271599c9e5943699426afcce1a62d6;hp=a4d63a943735efa30270ce70716d43323fd40f02


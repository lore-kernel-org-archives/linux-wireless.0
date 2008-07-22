Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52705 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552AbYGVXRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 19:17:36 -0400
Date: Tue, 22 Jul 2008 16:14:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>
Subject: [patch 03/47] b43: Fix possible MMIO access while device is down
Message-ID: <20080722231414.GD8282@suse.de> (sfid-20080723_011739_511518_42C74647)
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080722231342.GA8282@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Michael Buesch <mb@bu3sch.de>

This fixes a possible MMIO access while the device is still down
from a suspend cycle. MMIO accesses with the device powered down
may cause crashes on certain devices.

Upstream commit is
33598cf261e393f2b3349cb55509e358014bfd1f

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/leds.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/b43/leds.c
+++ b/drivers/net/wireless/b43/leds.c
@@ -72,6 +72,9 @@ static void b43_led_brightness_set(struc
 	struct b43_wldev *dev = led->dev;
 	bool radio_enabled;
 
+	if (unlikely(b43_status(dev) < B43_STAT_INITIALIZED))
+		return;
+
 	/* Checking the radio-enabled status here is slightly racy,
 	 * but we want to avoid the locking overhead and we don't care
 	 * whether the LED has the wrong state for a second. */

-- 

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:47750 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762091AbYEHRnc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 13:43:32 -0400
Date: Thu, 8 May 2008 10:42:14 -0700
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
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [patch 08/16] b43: Fix dual-PHY devices
Message-ID: <20080508174214.GI855@suse.de> (sfid-20080508_194235_526656_1370271B)
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080508174122.GA855@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Michael Buesch <mb@bu3sch.de>

commit 2e35af143a1380173ba292e48e9b4913ef16b4ee upstream

This fixes operation of dual-PHY (A/B/G) devices.
Do not anounce the A-PHY to mac80211, as that's not supported, yet.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3912,6 +3912,14 @@ static int b43_wireless_core_attach(stru
 		err = -EOPNOTSUPP;
 		goto err_powerdown;
 	}
+	if (1 /* disable A-PHY */) {
+		/* FIXME: For now we disable the A-PHY on multi-PHY devices. */
+		if (dev->phy.type != B43_PHYTYPE_N) {
+			have_2ghz_phy = 1;
+			have_5ghz_phy = 0;
+		}
+	}
+
 	dev->phy.gmode = have_2ghz_phy;
 	tmp = dev->phy.gmode ? B43_TMSLOW_GMODE : 0;
 	b43_wireless_core_reset(dev, tmp);

-- 

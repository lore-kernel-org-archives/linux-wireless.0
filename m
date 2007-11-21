Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3979 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbXKUU1W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 15:27:22 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: rjw@sisk.pl, larry.finger@lwfinger.net, stefano.brivio@polimi.it,
	mb@bu3sch.de, bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] softmac: mark as obsolete and schedule for removal
Date: Wed, 21 Nov 2007 15:26:41 -0500
Message-Id: <1195676801-30719-1-git-send-email-linville@tuxdriver.com> (sfid-20071121_202729_838931_86E9D725)
In-Reply-To: <200711211920.48640.mb@bu3sch.de>
References: <200711211920.48640.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Schedule softmac for for removal in the 2.6.26 development window.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 Documentation/feature-removal-schedule.txt |    8 ++++++++
 net/ieee80211/Kconfig                      |    5 +++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c057e36..aeaa129 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -342,3 +342,11 @@ Why:	This driver's functionality has been replaced by the
 Who:	John W. Linville <linville@tuxdriver.com>
 
 ---------------------------
+
+What:	iee80211 softmac wireless networking component
+When:	2.6.26 (or after removal of bcm43xx and port of zd1211rw to mac80211)
+Files:	net/ieee80211/softmac
+Why:	No in-kernel drivers will depend on it any longer.
+Who:	John W. Linville <linville@tuxdriver.com>
+
+---------------------------
diff --git a/net/ieee80211/Kconfig b/net/ieee80211/Kconfig
index 1438ade..bd50104 100644
--- a/net/ieee80211/Kconfig
+++ b/net/ieee80211/Kconfig
@@ -1,8 +1,9 @@
 config IEEE80211
-	tristate "Generic IEEE 802.11 Networking Stack"
+	tristate "Generic IEEE 802.11 Networking Stack (DEPRECATED)"
 	---help---
 	This option enables the hardware independent IEEE 802.11
-	networking stack.
+	networking stack.  This component is deprecated in favor of the
+	mac80211 component.
 
 config IEEE80211_DEBUG
 	bool "Enable full debugging output"
-- 
1.5.3.3


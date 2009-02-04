Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:2844 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZBDGUy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 01:20:54 -0500
Subject: [PATCH 2/2] Document CONFIG_DRIVER_NL80211 in wpa_supplicant/defconfig
To: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 04 Feb 2009 01:20:37 -0500
Message-ID: <20090204062037.12891.4454.stgit@ct.roinet.com> (sfid-20090204_072101_015392_5CF80812)
In-Reply-To: <20090204062021.12891.96607.stgit@ct.roinet.com>
References: <20090204062021.12891.96607.stgit@ct.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Put it after CONFIG_DRIVER_WEXT, as it's the new Linux wireless API.
Move comments about kernel includes next to CONFIG_DRIVER_NL80211, away
from CONFIG_CLIENT_MLME.
---
 wpa_supplicant/defconfig |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/wpa_supplicant/defconfig b/wpa_supplicant/defconfig
index 7a28e6f..b95ea50 100644
--- a/wpa_supplicant/defconfig
+++ b/wpa_supplicant/defconfig
@@ -82,6 +82,15 @@ CONFIG_DRIVER_ATMEL=y
 # Driver interface for generic Linux wireless extensions
 CONFIG_DRIVER_WEXT=y
 
+# Driver interface for Linux drivers using the nl80211 kernel interface
+#CONFIG_DRIVER_NL80211=y
+# Currently, driver_nl80211.c build requires some additional parameters to be
+# able to include some of the kernel header files. Following lines can be used
+# to set these (WIRELESS_DEV must point to the root directory of the
+# wireless-testing.git tree).
+#WIRELESS_DEV=/usr/src/wireless-testing
+#CFLAGS += -I$(WIRELESS_DEV)/net/mac80211
+
 # Driver interface for FreeBSD net80211 layer (e.g., Atheros driver)
 #CONFIG_DRIVER_BSD=y
 #CFLAGS += -I/usr/local/include
@@ -360,15 +369,8 @@ CONFIG_PEERKEY=y
 
 # Include client MLME (management frame processing).
 # This can be used to move MLME processing of Linux mac80211 stack into user
-# space.
+# space.  mac80211 may need external patches to enable userspace MLME support.
 #CONFIG_CLIENT_MLME=y
-# Currently, driver_nl80211.c build requires some additional parameters to be
-# able to include some of the kernel header files. Following lines can be used
-# to set these (WIRELESS_DEV must point to the root directory of the
-# wireless-testing.git tree). In addition, mac80211 may need external patches
-# to enable userspace MLME support.
-#WIRELESS_DEV=/usr/src/wireless-testing
-#CFLAGS += -I$(WIRELESS_DEV)/net/mac80211
 
 # IEEE Std 802.11r-2008 (Fast BSS Transition)
 #CONFIG_IEEE80211R=y

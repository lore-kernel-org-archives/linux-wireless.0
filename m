Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:2844 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbZBDGUx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 01:20:53 -0500
Subject: [PATCH 1/2] Use better examples for MadWifi path in defconfig,
	clarify comments
To: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 04 Feb 2009 01:20:21 -0500
Message-ID: <20090204062021.12891.96607.stgit@ct.roinet.com> (sfid-20090204_072058_514319_9787AF51)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MadWifi is unlikely to be in ../head relative to hostapd or
wpa_supplicant, as it would be inside the hostap git repository.
MadWifi sources are more likely to be in a directory called "madwifi"
and residing outside the hostap repository.  Using "madwifi" also
demonstrates that the top-level madwifi directory is needed.
---
 hostapd/defconfig        |    2 +-
 wpa_supplicant/defconfig |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/hostapd/defconfig b/hostapd/defconfig
index 2591e71..45078f2 100644
--- a/hostapd/defconfig
+++ b/hostapd/defconfig
@@ -17,7 +17,7 @@ CONFIG_DRIVER_HOSTAP=y
 
 # Driver interface for madwifi driver
 #CONFIG_DRIVER_MADWIFI=y
-#CFLAGS += -I../head # change to reflect local setup; directory for madwifi src
+#CFLAGS += -I../../madwifi # change to the madwifi source directory
 
 # Driver interface for Prism54 driver
 #CONFIG_DRIVER_PRISM54=y
diff --git a/wpa_supplicant/defconfig b/wpa_supplicant/defconfig
index 2c66f9c..7a28e6f 100644
--- a/wpa_supplicant/defconfig
+++ b/wpa_supplicant/defconfig
@@ -51,8 +51,8 @@ CONFIG_DRIVER_HOSTAP=y
 
 # Driver interface for madwifi driver
 #CONFIG_DRIVER_MADWIFI=y
-# Change include directories to match with the local setup
-#CFLAGS += -I../madwifi/wpa
+# Set include directory to the madwifi source tree
+#CFLAGS += -I../../madwifi
 
 # Driver interface for Prism54 driver
 # (Note: Prism54 is not yet supported, i.e., this will not work as-is and is

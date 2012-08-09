Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62337 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab2HISCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:02:38 -0400
Received: by wgbdr13 with SMTP id dr13so694302wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 11:02:37 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 12/13] compat-wireless: Fetch in DRM drivers
Date: Thu,  9 Aug 2012 21:01:31 +0300
Message-Id: <1344535292-4451-13-git-send-email-ozancag@gmail.com> (sfid-20120809_200254_225933_B75CDF59)
In-Reply-To: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DRM drivers can now be sucked in when 'drm' is given as the
command line parameter.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 scripts/admin-update.sh | 45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index f0c7ad0..3cf7647 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -427,12 +427,26 @@ DRIVERS_ETH="drivers/net/ethernet/atheros
 # Bluetooth drivers
 DRIVERS_BT="drivers/bluetooth"
 
+# DRM drivers
+DRIVERS_DRM="drivers/gpu/drm/ast
+	     drivers/gpu/drm/cirrus
+	     drivers/gpu/drm/gma500
+	     drivers/gpu/drm/i2c
+	     drivers/gpu/drm/i810
+	     drivers/gpu/drm/i915
+	     drivers/gpu/drm/mgag200
+	     drivers/gpu/drm/nouveau
+	     drivers/gpu/drm/radeon
+	     drivers/gpu/drm/ttm
+	     drivers/gpu/drm/via
+	     drivers/gpu/drm/vmwgfx"
+
+# UDL uses the new dma-buf API, let's disable this for now
+#DRIVERS="$DRIVERS drivers/gpu/drm/udl"
+
 # Staging drivers if any
 STAGING_DRIVERS=""
 
-# Select which drivers to build
-DRIVERS="$DRIVERS_WLAN $DRIVERS_ETH"
-
 rm -rf drivers/
 
 mkdir -p \
@@ -444,6 +458,7 @@ mkdir -p \
 	include/pcmcia \
 	include/crypto \
 	drivers/bcma \
+	drivers/platform/x86 \
 	drivers/misc/eeprom \
 	drivers/net/usb \
 	drivers/net/ethernet/broadcom \
@@ -453,7 +468,8 @@ mkdir -p \
 	$NET_BT_DIRS \
 	$DRIVERS_WLAN \
 	$DRIVERS_ETH \
-	$DRIVERS_BT
+	$DRIVERS_BT \
+	$DRIVERS_DRM
 
 # Copy pci_ids.h for every situation
 cp $GIT_TREE/include/linux/pci_ids.h include/linux
@@ -494,6 +510,27 @@ if [[ -n "$ENABLE_NETWORK" ]]; then
 	echo "obj-\$(CONFIG_B44) += b44.o" > drivers/net/ethernet/broadcom/Makefile
 fi
 
+if [[ -n "$ENABLE_DRM" ]]; then
+	# DRM drivers
+	copyDirectories "$DRIVERS_DRM"
+
+	# Copy standalone drivers
+	echo "Copying $GIT_TREE/drivers/gpu/drm/*.[ch]"
+	cp $GIT_TREE/drivers/gpu/drm/{Makefile,*.[ch]} drivers/gpu/drm/
+
+	# Copy DRM headers
+	cp -a $GIT_TREE/include/drm include/
+
+	# drivers/gpu/drm/i915/intel_pm.c requires this
+	cp $GIT_TREE/drivers/platform/x86/intel_ips.h drivers/platform/x86
+
+	# Copy radeon reg_srcs for hostprogs
+	cp -a $GIT_TREE/drivers/gpu/drm/radeon/reg_srcs drivers/gpu/drm/radeon
+
+	# Finally get the DRM top-level makefile
+	cp $GIT_TREE/drivers/gpu/drm/Makefile drivers/gpu/drm
+fi
+
 # Staging drivers in their own directory
 for i in $STAGING_DRIVERS; do
 	if [ ! -d $GIT_TREE/$i ]; then
-- 
1.7.11.2


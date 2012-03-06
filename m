Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51742 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab2CFXZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 18:25:40 -0500
Subject: [PATCH] compat-wireless: Handle name change from iwlagn to iwlwifi
 in 3.2
From: Don Fry <donald.h.fry@intel.com>
To: mcgrof@frijolero.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Mar 2012 15:23:42 -0800
Message-ID: <1331076222.28277.2.camel@dfry-linux1> (sfid-20120307_002543_750662_F6CA6EE1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

With linux-3.2 the iwlagn driver is renamed iwlwifi.  For some kernels
(like 3.1.5) this causes the non-compat iwlagn.ko to try and run against
the compat mac80211 resulting in an oops.  This change prevents the
non-compat iwlagn.ko from being loaded.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
---
v2 based on today's compat-wireless
---
 Makefile            |   10 ++++++++++
 scripts/iwl-enable  |   11 ++++++++++-
 scripts/unload.sh   |    2 +-
 scripts/wlunload.sh |    2 +-
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 6b6f097..204c63d 100644
--- a/Makefile
+++ b/Makefile
@@ -163,6 +163,16 @@ install-scripts:
 		echo Running iwl-enable iwlagn...;\
 		$(DESTDIR)/usr/sbin/iwl-enable iwlagn ;\
 	fi
+	@if [ $(shell modinfo iwlagn > /dev/null 2>&1 && echo 1) ] \
+	 && [ $(shell modinfo iwlwifi > /dev/null 2>&1 && echo 1) ]; then \
+		echo ;\
+		echo -n "Note: iwlagn detected, we're going to disable it. " ;\
+		echo "If you would like to enable it later you can run:"  ;\
+		echo "    sudo iwl-load iwlagn"  ;\
+		echo ;\
+		echo Running iwl-enable iwlwifi...;\
+		$(DESTDIR)/usr/sbin/iwl-enable iwlwifi ;\
+	fi
 	@if [ $(shell modinfo atl1c > /dev/null 2>&1 && echo 1) ]; then \
 		echo ;\
 		echo -n "Note: atl1c detected, we're going to disable it. "  ;\
diff --git a/scripts/iwl-enable b/scripts/iwl-enable
index 765195b..b18fdc2 100755
--- a/scripts/iwl-enable
+++ b/scripts/iwl-enable
@@ -17,7 +17,14 @@ IWL_NEW="iwlagn"
 IWL_OLD="iwl4965"
 
 # Appended to module file at the end when we want to ignore one
-USAGE="Usage: $0 [ $IWL_NEW | $IWL_OLD ]"
+USAGE="Usage: $0 [ $IWL_NEW | $IWL_OLD | iwlwifi ]"
+
+function enable_iwlwifi {
+	for i in $IWL_OLD $IWL_NEW; do
+		module_disable $i
+	done
+	module_enable iwlwifi
+}
 
 function enable_iwlagn {
 	module_disable $IWL_OLD
@@ -41,6 +48,8 @@ if [ "$MODULE" == "iwl4965" ]; then
 	module_enable $IWL_OLD
 elif [ "$MODULE" == "iwlagn" ]; then
 	enable_iwlagn
+elif [ "$MODULE" == "iwlwifi" ]; then
+	enable_iwlwifi
 else
 	echo "$USAGE"
 	exit
diff --git a/scripts/unload.sh b/scripts/unload.sh
index c659a70..fc7261d 100755
--- a/scripts/unload.sh
+++ b/scripts/unload.sh
@@ -15,7 +15,7 @@ MODULES="$MODULES adm8211 zd1211rw"
 MODULES="$MODULES orinoco_cs orinoco_nortel orinoco_pci orinoco_plx"
 MODULES="$MODULES orinoco_tld orinoco_usb spectrum_cs orinoco"
 MODULES="$MODULES b43 b44 b43legacy brcm80211 ssb"
-MODULES="$MODULES iwl3945 iwlagn iwlcore"
+MODULES="$MODULES iwl3945 iwlwifi iwlagn iwlcore"
 MODULES="$MODULES ath9k ath9k_htc ath9k_common ath9k_hw "
 MODULES="$MODULES ath5k ath ath6kl ar9170usb carl9170"
 MODULES="$MODULES p54pci p54usb p54spi p54common"
diff --git a/scripts/wlunload.sh b/scripts/wlunload.sh
index cd6298d..c6c6af9 100755
--- a/scripts/wlunload.sh
+++ b/scripts/wlunload.sh
@@ -15,7 +15,7 @@ MODULES="$MODULES adm8211 zd1211rw"
 MODULES="$MODULES orinoco_cs orinoco_nortel orinoco_pci orinoco_plx"
 MODULES="$MODULES orinoco_tld orinoco_usb spectrum_cs orinoco"
 MODULES="$MODULES b43 b44 b43legacy brcm80211 ssb"
-MODULES="$MODULES iwl3945 iwlagn iwlcore"
+MODULES="$MODULES iwl3945 iwlwifi iwlagn iwlcore"
 MODULES="$MODULES ath9k ath9k_htc ath9k_common ath9k_hw "
 MODULES="$MODULES ath5k ath ath6kl ar9170usb carl9170"
 MODULES="$MODULES p54pci p54usb p54spi p54common"
-- 
1.7.4.4




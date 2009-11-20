Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39933 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbZKTWCb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 17:02:31 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] [compat-2.6] Refresh config.mk
Date: Fri, 20 Nov 2009 23:01:52 +0100
Message-Id: <1258754513-4546-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1258754513-4546-1-git-send-email-hauke@hauke-m.de>
References: <1258754513-4546-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove some unused symbols and add some new symbols.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/config.mk b/config.mk
index 35d6078..54cbb12 100644
--- a/config.mk
+++ b/config.mk
@@ -70,9 +70,7 @@ ifeq ($(CONFIG_NET_SCHED),)
  QOS_REQS_MISSING+=CONFIG_NET_SCHED
 endif
 
-ifeq ($(QOS_REQS_MISSING),) # if our dependencies match for MAC80211_QOS
-CONFIG_MAC80211_QOS=y
-else # Complain about our missing dependencies
+ifneq ($(QOS_REQS_MISSING),) # Complain about our missing dependencies
 $(warning "WARNING: You are running a kernel >= 2.6.23, you should enable in it $(QOS_REQS_MISSING) for 802.11[ne] support")
 endif
 
@@ -92,7 +90,9 @@ CONFIG_MAC80211=m
 # CONFIG_MAC80211_IBSS_DEBUG=y
 # CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
 # CONFIG_MAC80211_VERBOSE_MPL_DEBUG=y
+# CONFIG_MAC80211_VERBOSE_MHWMP_DEBUG=y
 # CONFIG_MAC80211_DEBUG_COUNTERS=y
+# CONFIG_MAC80211_DRIVER_API_TRACER=y
 
 # choose between pid and minstrel as default rate control algorithm
 CONFIG_MAC80211_RC_DEFAULT=minstrel
@@ -110,7 +110,9 @@ CONFIG_MAC80211_MESH=y
 
 CONFIG_CFG80211=m
 CONFIG_CFG80211_DEFAULT_PS=y
-CONFIG_CFG80211_DEFAULT_PS_VALUE=1
+# CONFIG_CFG80211_DEBUGFS=y
+# CONFIG_NL80211_TESTMODE=y
+# CONFIG_CFG80211_DEVELOPER_WARNINGS=y
 # CONFIG_CFG80211_REG_DEBUG=y
 # See below for wext stuff
 
@@ -147,7 +149,6 @@ ifneq ($(CONFIG_PCI),)
 
 CONFIG_ATH5K=m
 # CONFIG_ATH5K_DEBUG=y
-CONFIG_ATH5K_RFKILL=y
 CONFIG_ATH9K_HW=m
 CONFIG_ATH9K=m
 # Note: once ath9k_htc is added we'll have to move
@@ -158,11 +159,10 @@ CONFIG_ATH9K_COMMON=m
 
 
 CONFIG_IWLWIFI=m
-CONFIG_IWLWIFI_LEDS=y
-CONFIG_IWLWIFI_RFKILL=y
 CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=y
 # CONFIG_IWLWIFI_DEBUG=y
 # CONFIG_IWLWIFI_DEBUGFS=y
+# CONFIG_IWLWIFI_DEVICE_TRACING=y
 CONFIG_IWLAGN=m
 CONFIG_COMPAT_IWL4965=y
 CONFIG_IWL5000=y
@@ -179,7 +179,6 @@ CONFIG_B43_PCMCIA=y
 endif
 CONFIG_B43_PIO=y
 CONFIG_B43_LEDS=y
-CONFIG_B43_RFKILL=y
 CONFIG_B43_PHY_LP=y
 # CONFIG_B43_DEBUG=y
 # CONFIG_B43_FORCE_PIO=y
@@ -189,7 +188,6 @@ CONFIG_B43LEGACY_HWRNG=y
 CONFIG_B43LEGACY_PCI_AUTOSELECT=y
 CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
 CONFIG_B43LEGACY_LEDS=y
-CONFIG_B43LEGACY_RFKILL=y
 # CONFIG_B43LEGACY_DEBUG=y
 CONFIG_B43LEGACY_DMA=y
 CONFIG_B43LEGACY_PIO=y
@@ -314,6 +312,7 @@ CONFIG_USB_NET_CDCETHER=m
 
 CONFIG_P54_USB=m
 CONFIG_RTL8187=m
+CONFIG_RTL8187_LEDS=y
 
 CONFIG_AT76C50X_USB=m
 
-- 
1.6.3.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:63768 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750881AbYGQIOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 04:14:41 -0400
Date: Thu, 17 Jul 2008 16:15:54 +0800
From: Yingying Zhao <yingying.zhao@linux.intel.com>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH]compat-2.6: fix compiling configurations for iwlwifi
Message-ID: <20080717081554.GA1279@amber-desktop.bj.intel.com> (sfid-20080717_101445_658180_7DFA0568)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Latest iwlwifi in wireless-testing removed CONFIG_IWL4965_HT and
introduced CONFIG_IWL5000 for Intel Wireless WiFi 5000AGN support
which is built in IWL4965 module. This patch also enables IWLWIFI_LEDS,
IWLWIFI_RFKILL,IWL3945_LEDS IWLWIFI_DEBUG for iwlwifi build by default.

Signed-off-by: Zhao Yingying <yingying.zhao@intel.com>
---
 config.mk |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/config.mk b/config.mk
index b1fb68e..cafadfa 100644
--- a/config.mk
+++ b/config.mk
@@ -15,6 +15,7 @@ endif
 
 # Wireless subsystem stuff
 CONFIG_MAC80211=m
+CONFIG_MAC80211_LEDS=y
 
 # Enable QOS for 2.6.22, we'll do some hacks here to enable it.
 # You will need this for HT support (802.11n) and WME (802.11e).
@@ -77,7 +78,24 @@ CONFIG_IWLWIFI=m
 CONFIG_IWLCORE=m
 CONFIG_IWL3945=m
 CONFIG_IWL4965=m
-CONFIG_IWL4965_HT=y
+CONFIG_IWLWIFI_LEDS=y
+CONFIG_IWLWIFI_RFKILL=y
+CONFIG_IWL3945_LEDS=y
+CONFIG_IWL5000=y
+
+ifeq ($(CONFIG_IWL5000),y)
+ifeq ($(CONFIG_IWL4965),)
+$(warning "WARNING: CONFIG_IWL5000 requires CONFIG_IWL4965 is configured as m.")
+CONFIG_IWL4965=m
+endif # CONFIG_IWL4965 is empty
+endif # CONFIG_IWL5000 is y
+
+CONFIG_IWLWIFI_DEBUG=y
+
+ifeq ($(CONFIG_MAC80211_DEBUGFS),y)
+CONFIG_IWLWIFI_DEBUGFS=y
+endif
+
 CONFIG_B43=m
 # B43 uses PCMCIA only for Compact Flash. The Cardbus cards uses PCI
 # Example, bcm4318:

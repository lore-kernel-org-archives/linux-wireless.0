Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55973 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab2CDUnI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:08 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 064/101] iwlwifi: don't include iwl-prph.h everywhere
Date: Sun,  4 Mar 2012 11:29:18 -0800
Message-Id: <1330889395-533-65-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214403_357975_04BEE07D)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's only needed in a few places.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 --
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-testmode.c |    1 +
 5 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 900d430..798e24e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -43,6 +43,7 @@
 #include "iwl-agn-hw.h"
 #include "iwl-shared.h"
 #include "iwl-cfg.h"
+#include "iwl-prph.h"
 
 /* Highest firmware API version supported */
 #define IWL1000_UCODE_API_MAX 6
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 0b85ca0..0e97cfd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -45,6 +45,7 @@
 #include "iwl-trans.h"
 #include "iwl-shared.h"
 #include "iwl-cfg.h"
+#include "iwl-prph.h"
 
 /* Highest firmware API version supported */
 #define IWL5000_UCODE_API_MAX 5
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a301daf..d1e722b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -37,11 +37,9 @@
 #include <linux/leds.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
-#include <net/ieee80211_radiotap.h>
 
 #include "iwl-eeprom.h"
 #include "iwl-csr.h"
-#include "iwl-prph.h"
 #include "iwl-debug.h"
 #include "iwl-agn-hw.h"
 #include "iwl-led.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index f965ee3..e2d8084 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -75,6 +75,7 @@
 #include "iwl-agn.h"
 #include "iwl-eeprom.h"
 #include "iwl-io.h"
+#include "iwl-prph.h"
 
 /************************** EEPROM BANDS ****************************
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 63868df..5b06916 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -78,6 +78,7 @@
 #include "iwl-testmode.h"
 #include "iwl-trans.h"
 #include "iwl-fh.h"
+#include "iwl-prph.h"
 
 
 /* Periphery registers absolute lower bound. This is used in order to
-- 
1.7.0.4


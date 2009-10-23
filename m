Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24351 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbZJWUmq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/18] iwlwifi: remove duplicate defines
Date: Fri, 23 Oct 2009 13:42:30 -0700
Message-Id: <1256330556-20997-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

RX_FREE_BUFFERS and RX_LOW_WATERMARK are currently defined in four places.
Based on how files are included we only need the definition in iwl-fh.h

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reported-by: Frans Pop <elendil@planet.nl>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h |    6 ------
 drivers/net/wireless/iwlwifi/iwl-3945.h    |    6 ------
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    6 ------
 3 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index ccdac69..6fd10d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -248,12 +248,6 @@ struct iwl3945_eeprom {
 #define TFD_CTL_PAD_SET(n)         (n << 28)
 #define TFD_CTL_PAD_GET(ctl)       (ctl >> 28)
 
-/*
- * RX related structures and functions
- */
-#define RX_FREE_BUFFERS 64
-#define RX_LOW_WATERMARK 8
-
 /* Sizes and addresses for instruction and data memory (SRAM) in
  * 3945's embedded processor.  Driver access is via HBUS_TARG_MEM_* regs. */
 #define IWL39_RTC_INST_LOWER_BOUND		(0x000000)
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 964c019..ebb999a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -130,12 +130,6 @@ struct iwl3945_frame {
 #define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
 #define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
 
-/*
- * RX related structures and functions
- */
-#define RX_FREE_BUFFERS 64
-#define RX_LOW_WATERMARK 8
-
 #define SUP_RATE_11A_MAX_NUM_CHANNELS  8
 #define SUP_RATE_11B_MAX_NUM_CHANNELS  4
 #define SUP_RATE_11G_MAX_NUM_CHANNELS  12
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b520e55..e7ce673 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -407,12 +407,6 @@ struct iwl_host_cmd {
 	u8 id;
 };
 
-/*
- * RX related structures and functions
- */
-#define RX_FREE_BUFFERS 64
-#define RX_LOW_WATERMARK 8
-
 #define SUP_RATE_11A_MAX_NUM_CHANNELS  8
 #define SUP_RATE_11B_MAX_NUM_CHANNELS  4
 #define SUP_RATE_11G_MAX_NUM_CHANNELS  12
-- 
1.5.6.3


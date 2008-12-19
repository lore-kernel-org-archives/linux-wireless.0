Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16973 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbYLSCoz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:44:55 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/43] iwlwifi: 3945 unfold iwl-3945-commands.h
Date: Fri, 19 Dec 2008 10:37:02 +0800
Message-Id: <1229654263-21454-3-git-send-email-yi.zhu@intel.com> (sfid-20081219_034500_992463_54875BB5)
In-Reply-To: <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch unfolds includes of iwl-3945-commands.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h       |   10 +---------
 drivers/net/wireless/iwlwifi/iwl-3945-led.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.c          |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c      |    1 +
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index c6f4eb5..e9ccd07 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -144,6 +144,11 @@ enum {
 	REPLY_MAX = 0xff
 };
 
+/* Tx rates */
+#define IWL_CCK_RATES	4
+#define IWL_OFDM_RATES	8
+#define IWL_MAX_RATES	(IWL_CCK_RATES + IWL_OFDM_RATES)
+
 /******************************************************************************
  * (0)
  * Commonly used structures and definitions:
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 1df385b..21719eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -73,13 +73,7 @@
  * uCode queue management definitions ...
  * Queue #4 is the command queue for 3945 and 4965.
  */
-#define IWL_CMD_QUEUE_NUM       4
-
-/* Tx rates */
-#define IWL_CCK_RATES 4
-#define IWL_OFDM_RATES 8
-#define IWL_HT_RATES 0
-#define IWL_MAX_RATES  (IWL_CCK_RATES+IWL_OFDM_RATES+IWL_HT_RATES)
+#define IWL_CMD_QUEUE_NUM	4
 
 /* Time constants */
 #define SHORT_SLOT_TIME 9
@@ -281,8 +275,6 @@ struct iwl3945_eeprom {
 /* End of EEPROM */
 
 
-#include "iwl-3945-commands.h"
-
 #define PCI_LINK_CTRL      0x0F0
 #define PCI_POWER_SOURCE   0x0C8
 #define PCI_REG_WUM8       0x0E8
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index 4c63890..b0d420f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -38,8 +38,8 @@
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
 
+#include "iwl-3945-commands.h"
 #include "iwl-3945.h"
-#include "iwl-helpers.h"
 
 
 static const struct {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 3861a3b..48ca1ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -36,6 +36,7 @@
 
 #include <linux/workqueue.h>
 
+#include "iwl-3945-commands.h"
 #include "iwl-3945.h"
 
 #define RS_NAME "iwl-3945-rs"
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 77cf2d4..4690b93 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -40,6 +40,7 @@
 
 #include "iwl-3945-core.h"
 #include "iwl-3945-fh.h"
+#include "iwl-3945-commands.h"
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
 #include "iwl-3945-rs.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3726939..17b8f52 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -47,6 +47,7 @@
 #include <asm/div64.h>
 
 #include "iwl-3945-core.h"
+#include "iwl-3945-commands.h"
 #include "iwl-3945.h"
 #include "iwl-3945-fh.h"
 #include "iwl-helpers.h"
-- 
1.5.3.6


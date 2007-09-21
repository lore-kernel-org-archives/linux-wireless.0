Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2177 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbXIUDHx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 23:07:53 -0400
From: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Zhu Yi <chuyee@santarosa.sh.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH net-2.6.24] iwlwifi: remove per-file CFLAGS for IWL define
Date: Fri, 21 Sep 2007 11:00:50 +0800
Message-Id: <11903436502774-git-send-email-yi.zhu@intel.com>
To: David Miller <davem@davemloft.net>, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <chuyee@santarosa.sh.intel.com>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/Makefile       |    6 ------
 drivers/net/wireless/iwl-3945-rs.c  |    2 ++
 drivers/net/wireless/iwl-3945.c     |    2 ++
 drivers/net/wireless/iwl-4965-rs.c  |    2 ++
 drivers/net/wireless/iwl-4965.c     |    2 ++
 drivers/net/wireless/iwl3945-base.c |    2 ++
 drivers/net/wireless/iwl4965-base.c |    2 ++
 7 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index d5d0427..a1345c6 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -55,15 +55,9 @@ obj-$(CONFIG_ADM8211)	+= adm8211.o
 
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
-CFLAGS_iwl3945-base.o	= -DIWL=3945
-CFLAGS_iwl-3945.o	= -DIWL=3945
-CFLAGS_iwl-3945-rs.o	= -DIWL=3945
 
 obj-$(CONFIG_IWL4965)	+= iwl4965.o
 iwl4965-objs		= iwl4965-base.o iwl-4965.o iwl-4965-rs.o
-CFLAGS_iwl4965-base.o	= -DIWL=4965
-CFLAGS_iwl-4965.o	= -DIWL=4965
-CFLAGS_iwl-4965-rs.o	= -DIWL=4965
 
 obj-$(CONFIG_RT2X00)		+= rt2x00/
 
diff --git a/drivers/net/wireless/iwl-3945-rs.c b/drivers/net/wireless/iwl-3945-rs.c
index b0d28ae..f4aabcf 100644
--- a/drivers/net/wireless/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwl-3945-rs.c
@@ -40,6 +40,8 @@
 #include <net/mac80211.h>
 #include <linux/wireless.h>
 
+#define IWL 3945
+
 #include "../net/mac80211/ieee80211_rate.h"
 
 #include "iwlwifi.h"
diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index 55f7d89..acb3875 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -40,6 +40,8 @@
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
 
+#define IWL 3945
+
 #include "iwlwifi.h"
 #include "iwl-helpers.h"
 #include "iwl-3945.h"
diff --git a/drivers/net/wireless/iwl-4965-rs.c b/drivers/net/wireless/iwl-4965-rs.c
index 7b74481..bc5e67b 100644
--- a/drivers/net/wireless/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwl-4965-rs.c
@@ -39,6 +39,8 @@
 #include <net/mac80211.h>
 #include <linux/wireless.h>
 
+#define IWL 4965
+
 #include "../net/mac80211/ieee80211_rate.h"
 
 #include "iwlwifi.h"
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index e624f2a..b704fe7 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -39,6 +39,8 @@
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
 
+#define IWL 4965
+
 #include "iwlwifi.h"
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
diff --git a/drivers/net/wireless/iwl3945-base.c b/drivers/net/wireless/iwl3945-base.c
index cc405f4..44f983b 100644
--- a/drivers/net/wireless/iwl3945-base.c
+++ b/drivers/net/wireless/iwl3945-base.c
@@ -58,6 +58,8 @@
 
 #include <asm/div64.h>
 
+#define IWL 3945
+
 #include "iwlwifi.h"
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
diff --git a/drivers/net/wireless/iwl4965-base.c b/drivers/net/wireless/iwl4965-base.c
index 6cea311..61500a2 100644
--- a/drivers/net/wireless/iwl4965-base.c
+++ b/drivers/net/wireless/iwl4965-base.c
@@ -58,6 +58,8 @@
 
 #include <asm/div64.h>
 
+#define IWL 4965
+
 #include "iwlwifi.h"
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
-- 
1.5.1

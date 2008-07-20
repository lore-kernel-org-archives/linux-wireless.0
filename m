Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26186 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbYGTXkX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 19:40:23 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/3] iwlwifi: rename iwl4965-base.c to iwl-agn.c
Date: Mon, 21 Jul 2008 02:40:13 +0300
Message-Id: <1216597215-19708-2-git-send-email-tomas.winkler@intel.com> (sfid-20080721_014026_950444_6BDB437B)
In-Reply-To: <1216597215-19708-1-git-send-email-tomas.winkler@intel.com>
References: <1216597215-19708-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames iwl4965-base.c to iwl-agn.c

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile              |    6 ++----
 .../wireless/iwlwifi/{iwl4965-base.c => iwl-agn.c} |    0 
 2 files changed, 2 insertions(+), 4 deletions(-)
 rename drivers/net/wireless/iwlwifi/{iwl4965-base.c => iwl-agn.c} (100%)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index f50d2f8..6bf3998 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -11,10 +11,8 @@ iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
 iwl3945-$(CONFIG_IWL3945_LEDS) += iwl-3945-led.o
 
 obj-$(CONFIG_IWL4965)	+= iwl4965.o
-iwl4965-objs		:= iwl4965-base.o iwl-4965.o iwl-agn-rs.o
+iwl4965-objs		:= iwl-agn.o iwl-4965.o iwl-agn-rs.o
 
-ifeq ($(CONFIG_IWL5000),y)
-	iwl4965-objs += iwl-5000.o
-endif
+iwl4965-$(CONFIG_IWL5000) += iwl-5000.o
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
similarity index 100%
rename from drivers/net/wireless/iwlwifi/iwl4965-base.c
rename to drivers/net/wireless/iwlwifi/iwl-agn.c
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


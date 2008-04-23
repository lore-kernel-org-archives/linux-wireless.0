Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39154 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbYDWKis (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 06:38:48 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: torvalds@linux-foundation.org, davem@davemloft.net,
	linville@tuxdriver.com--to, yi.zhu@intel.com,
	reinette.chatre@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwlwifi: Fix built-in compilation of iwlcore
Date: Wed, 23 Apr 2008 13:38:41 +0300
Message-Id: <1208947121-22640-1-git-send-email-tomas.winkler@intel.com> (sfid-20080423_123926_954607_0CDCB964)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes problem in Makefile that prevented
built-in compilation of iwlcore

Commit that caused this problem: eadd3c4b

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Yi Zhu <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index e83dd68..e2c05f5 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_IWLCORE)	:= iwlcore.o
+obj-$(CONFIG_IWLCORE)	+= iwlcore.o
 iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


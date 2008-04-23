Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:38503 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbYDWK6x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 06:58:53 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: torvalds@linux-foundation.org, davem@davemloft.net,
	linville@tuxdriver.com, reinette.chatre@intel.com, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwlwifi: Fix built-in compilation of iwlcore
Date: Wed, 23 Apr 2008 13:58:47 +0300
Message-Id: <1208948327-23894-1-git-send-email-tomas.winkler@intel.com> (sfid-20080423_125932_017167_ACF3A8D3)
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
index 4f3e88b..ec6187b 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_IWLCORE)	:= iwlcore.o
+obj-$(CONFIG_IWLCORE)	+= iwlcore.o
 iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o
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


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41783 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444AbYEECYP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:15 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Yi Zhu <yi.zhu@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 10/25] iwlwifi: Fix built-in compilation of iwlcore
Date: Mon,  5 May 2008 10:22:37 +0800
Message-Id: <1209954172-3092-11-git-send-email-yi.zhu@intel.com> (sfid-20080505_042355_996970_4F9489DB)
In-Reply-To: <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes problem in Makefile that prevented
built-in compilation of iwlcore

Commit that caused this problem: eadd3c4b ("iwlwifi: make Makefile
more concise")

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Yi Zhu <yi.zhu@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/wireless/iwlwifi/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 8bed908..c340200 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_IWLCORE)	:= iwlcore.o
+obj-$(CONFIG_IWLCORE)	+= iwlcore.o
 iwlcore-objs 		= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
 iwlcore-objs 		+= iwl-rx.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
-- 
1.5.3.6


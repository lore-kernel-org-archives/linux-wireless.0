Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870AbXHHHhP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:15 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 04/28] iwlwifi: Endianity fix for 4965 rx chain selection
Date: Wed,  8 Aug 2007 15:33:21 +0800
Message-Id: <11865584363863-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584342308-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes endianity for rx chain setting.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965-hw.h |   14 +++++++-------
 drivers/net/wireless/iwl-base.c    |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965-hw.h b/drivers/net/wireless/iwl-4965-hw.h
index fc9f506..106f7c0 100644
--- a/drivers/net/wireless/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwl-4965-hw.h
@@ -244,18 +244,18 @@ struct iwl_channel_switch_notif {
 #define RXON_FLG_CHANNEL_MODE_PURE_40_MSK	0x02000000
 #define RXON_FLG_CHANNEL_MODE_MIXED_MSK		0x04000000
 
-#define RXON_RX_CHAIN_DRIVER_FORCE_MSK		(0x1<<0)
-#define RXON_RX_CHAIN_VALID_MSK			(0x7<<1)
+#define RXON_RX_CHAIN_DRIVER_FORCE_MSK		__constant_cpu_to_le16(0x1<<0)
+#define RXON_RX_CHAIN_VALID_MSK			__constant_cpu_to_le16(0x7<<1)
 #define RXON_RX_CHAIN_VALID_POS			(1)
-#define RXON_RX_CHAIN_FORCE_SEL_MSK		(0x7<<4)
+#define RXON_RX_CHAIN_FORCE_SEL_MSK		__constant_cpu_to_le16(0x7<<4)
 #define RXON_RX_CHAIN_FORCE_SEL_POS		(4)
-#define RXON_RX_CHAIN_FORCE_MIMO_SEL_MSK	(0x7<<7)
+#define RXON_RX_CHAIN_FORCE_MIMO_SEL_MSK	__constant_cpu_to_le16(0x7<<7)
 #define RXON_RX_CHAIN_FORCE_MIMO_SEL_POS	(7)
-#define RXON_RX_CHAIN_CNT_MSK			(0x3<<10)
+#define RXON_RX_CHAIN_CNT_MSK			__constant_cpu_to_le16(0x3<<10)
 #define RXON_RX_CHAIN_CNT_POS			(10)
-#define RXON_RX_CHAIN_MIMO_CNT_MSK		(0x3<<12)
+#define RXON_RX_CHAIN_MIMO_CNT_MSK		__constant_cpu_to_le16(0x3<<12)
 #define RXON_RX_CHAIN_MIMO_CNT_POS		(12)
-#define RXON_RX_CHAIN_MIMO_FORCE_MSK		(0x1<<14)
+#define RXON_RX_CHAIN_MIMO_FORCE_MSK		__constant_cpu_to_le16(0x1<<14)
 #define RXON_RX_CHAIN_MIMO_FORCE_POS		(14)
 
 
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index d082a10..4d73b86 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -7135,9 +7135,9 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	 * Avoid A (0x1) because of its off-channel reception on A-band.
 	 * MIMO is not used here, but value is required to make uCode happy. */
 	scan->rx_chain = RXON_RX_CHAIN_DRIVER_FORCE_MSK |
-			(0x7 << RXON_RX_CHAIN_VALID_POS) |
+			cpu_to_le16((0x7 << RXON_RX_CHAIN_VALID_POS) |
 			(0x6 << RXON_RX_CHAIN_FORCE_SEL_POS) |
-			(0x7 << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS);
+			(0x7 << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS));
 #endif
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR)
-- 
1.5.2

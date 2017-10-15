Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0051.outbound.protection.outlook.com ([104.47.33.51]:36001
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751660AbdJOUxy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Oct 2017 16:53:54 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: [PATCH 5/5] qtnfmac: advertise support of inactivity timeout
Date: Sun, 15 Oct 2017 23:53:27 +0300
Message-Id: <20171015205327.9966-6-sergey.matyukevich.os@quantenna.com> (sfid-20171015_225420_735501_D641876F)
In-Reply-To: <20171015205327.9966-1-sergey.matyukevich.os@quantenna.com>
References: <20171015205327.9966-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Wireless device may implement a logic to kick-out STA due to inactivity
for a certain period of time. This feature needs to be advertised to
higher layers if supported. Timeout value is still taken from
parameters to START_AP command, nothing changes here.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  5 ++++-
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  5 +++--
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 11 ++++++++++-
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index b4c2fa7934fd..b9841c0d952f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -955,7 +955,10 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 
 	ether_addr_copy(wiphy->perm_addr, mac->macaddr);
 
-	if (hw_info->hw_capab & QLINK_HW_SUPPORTS_REG_UPDATE) {
+	if (hw_info->hw_capab & QLINK_HW_CAPAB_STA_INACT_TIMEOUT)
+		wiphy->features |= NL80211_FEATURE_INACTIVITY_TIMER;
+
+	if (hw_info->hw_capab & QLINK_HW_CAPAB_REG_UPDATE) {
 		wiphy->regulatory_flags |= REGULATORY_STRICT_REG |
 			REGULATORY_CUSTOM_REG;
 		wiphy->reg_notifier = qtnf_cfg80211_reg_notifier;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index babdc600c193..b81f81bd1411 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -975,10 +975,11 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 		return -EINVAL;
 	}
 
-	pr_info("fw_version=%d, MACs map %#x, alpha2=\"%c%c\", chains Tx=%u Rx=%u\n",
+	pr_info("fw_version=%d, MACs map %#x, alpha2=\"%c%c\", chains Tx=%u Rx=%u, capab=0x%x\n",
 		hwinfo->fw_ver, hwinfo->mac_bitmap,
 		hwinfo->rd->alpha2[0], hwinfo->rd->alpha2[1],
-		hwinfo->total_tx_chain, hwinfo->total_rx_chain);
+		hwinfo->total_tx_chain, hwinfo->total_rx_chain,
+		hwinfo->hw_capab);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 7b313d38c30b..0f582782682f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -61,8 +61,17 @@ struct qlink_msg_header {
 /* Generic definitions of data and information carried in QLINK messages
  */
 
+/**
+ * enum qlink_hw_capab - device capabilities.
+ *
+ * @QLINK_HW_CAPAB_REG_UPDATE: device can update it's regulatory region.
+ * @QLINK_HW_CAPAB_STA_INACT_TIMEOUT: device implements a logic to kick-out
+ *	associated STAs due to inactivity. Inactivity timeout period is taken
+ *	from QLINK_CMD_START_AP parameters.
+ */
 enum qlink_hw_capab {
-	QLINK_HW_SUPPORTS_REG_UPDATE	= BIT(0),
+	QLINK_HW_CAPAB_REG_UPDATE = BIT(0),
+	QLINK_HW_CAPAB_STA_INACT_TIMEOUT = BIT(1),
 };
 
 enum qlink_phy_mode {
-- 
2.11.0

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23931 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2FRGXD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 02:23:03 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC 03/10] ath9k_hw: Add WoW hardware capability flags
Date: Mon, 18 Jun 2012 11:51:47 +0530
Message-ID: <1340000514-7779-4-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120618_082308_242137_73E9D52C)
In-Reply-To: <1340000514-7779-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1340000514-7779-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

have seperate wow capability flags for
*basic wow support
*device capable of matching exact user defined pattern
or de-authentication/disassoc pattern
*device such AR9280 requires first four bytes for
all sort of patterns

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index d0e14a3..73a1238 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -231,6 +231,23 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_DFS			= BIT(16),
 };
 
+/*
+ * enum ath9k_hw_wow_caps - WoW device capabilities
+ * @ATH9K_HW_WOW_DEVICE_CAPABLE: device revision is capable of WoW.
+ * @ATH9K_HW_WOW_PATTERN_MATCH_EXACT: device is capable of matching
+ * an exact user defined pattern or de-authentication/disassoc pattern.
+ * @ATH9K_HW_WOW_PATTERN_MATCH_DWORD: device requires the first four
+ * bytes of the pattern for user defined pattern, de-authentication and
+ * disassociation patterns for all types of possible frames recieved
+ * of those types.
+ */
+
+enum ath9k_hw_wow_caps {
+	ATH9K_HW_WOW_DEVICE_CAPABLE		= BIT(0),
+	ATH9K_HW_WOW_PATTERN_MATCH_EXACT	= BIT(1),
+	ATH9K_HW_WOW_PATTERN_MATCH_DWORD	= BIT(2),
+};
+
 struct ath9k_hw_capabilities {
 	u32 hw_caps; /* ATH9K_HW_CAP_* from ath9k_hw_caps */
 	u16 rts_aggr_limit;
@@ -246,6 +263,9 @@ struct ath9k_hw_capabilities {
 	u8 txs_len;
 	u16 pcie_lcr_offset;
 	bool pcie_lcr_extsync_en;
+#ifdef	CONFIG_PM_SLEEP
+	enum ath9k_hw_wow_caps wow_caps;
+#endif
 };
 
 struct ath9k_ops_config {
-- 
1.7.0.4


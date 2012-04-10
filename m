Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59964 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759279Ab2DJPOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 11:14:42 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [WIP 03/11] ath9k_hw: Add WoW hardware capability flags
Date: Tue, 10 Apr 2012 20:43:13 +0530
Message-ID: <1334070801-21708-4-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120410_171446_656374_50BBE51A)
In-Reply-To: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

have seperate wow capability flags for
*basic wow support
*device capable of matching exact user defined pattern
or de-authentication/disassoc pattern
*device such AR9280 requires first four bytest for
all sort of patterns

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c061070..ce97b1e 100644
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
@@ -246,6 +263,7 @@ struct ath9k_hw_capabilities {
 	u8 txs_len;
 	u16 pcie_lcr_offset;
 	bool pcie_lcr_extsync_en;
+	enum ath9k_hw_wow_caps wow_caps;
 };
 
 struct ath9k_ops_config {
-- 
1.7.0.4


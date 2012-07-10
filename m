Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50793 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab2GJJZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 05:25:03 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v4 03/10] ath9k_hw: Add WoW hardware capability flags
Date: Tue, 10 Jul 2012 14:54:53 +0530
Message-ID: <1341912293-12049-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120710_112507_940498_1FCB17C0)
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

Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: vadivel@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 912f340..09f6c07 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -243,8 +243,22 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_RTT			= BIT(14),
 	ATH9K_HW_CAP_MCI			= BIT(15),
 	ATH9K_HW_CAP_DFS			= BIT(16),
+	ATH9K_HW_WOW_DEVICE_CAPABLE		= BIT(17),
+	ATH9K_HW_WOW_PATTERN_MATCH_EXACT	= BIT(18),
+	ATH9K_HW_WOW_PATTERN_MATCH_DWORD	= BIT(19),
 };
 
+/*
+ * WoW device capabilities
+ * @ATH9K_HW_WOW_DEVICE_CAPABLE: device revision is capable of WoW.
+ * @ATH9K_HW_WOW_PATTERN_MATCH_EXACT: device is capable of matching
+ * an exact user defined pattern or de-authentication/disassoc pattern.
+ * @ATH9K_HW_WOW_PATTERN_MATCH_DWORD: device requires the first four
+ * bytes of the pattern for user defined pattern, de-authentication and
+ * disassociation patterns for all types of possible frames recieved
+ * of those types.
+ */
+
 struct ath9k_hw_capabilities {
 	u32 hw_caps; /* ATH9K_HW_CAP_* from ath9k_hw_caps */
 	u16 rts_aggr_limit;
-- 
1.7.0.4


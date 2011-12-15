Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46601 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab1LOEQs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 23:16:48 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so2176479iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 20:16:47 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 2/3] ath9k_hw: add DFS testing check
Date: Wed, 14 Dec 2011 20:16:33 -0800
Message-Id: <1323922595-15533-3-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111215_051651_174683_A9F27C43)
In-Reply-To: <1323922595-15533-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1323922595-15533-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zefir Kurtisi <zefir.kurtisi@neratec.com>

In order to enable DFS upstream we want to be sure
DFS has been tested for each chipset. Push for public
documentation of the requirements we want in place and
allow for enabling each chipset through a single upstream
commit.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw-ops.h |    9 +++++++++
 drivers/net/wireless/ath/ath9k/hw.c     |   27 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h     |    1 +
 3 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index e74c233..c4ad0b0 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -212,4 +212,13 @@ static inline int ath9k_hw_fast_chan_change(struct ath_hw *ah,
 	return ath9k_hw_private_ops(ah)->fast_chan_change(ah, chan,
 							  ini_reloaded);
 }
+
+static inline void ath9k_hw_set_radar_params(struct ath_hw *ah)
+{
+	if (!ath9k_hw_private_ops(ah)->set_radar_params)
+		return;
+
+	ath9k_hw_private_ops(ah)->set_radar_params(ah, &ah->radar_conf);
+}
+
 #endif /* ATH9K_HW_OPS_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7f8fc65..080fac4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2277,6 +2277,30 @@ static u8 fixup_chainmask(u8 chip_chainmask, u8 eeprom_chainmask)
 		return chip_chainmask;
 }
 
+/**
+ * ath9k_hw_dfs_tested - checks if DFS has been tested with used chipset
+ * @ah: the atheros hardware data structure
+ *
+ * We enable DFS support upstream on chipsets which have passed a series
+ * of tests. The testing requirements are going to be documented. Desired
+ * test requirements are documented at:
+ *
+ * http://wireless.kernel.org/en/users/Drivers/ath9k/dfs
+ *
+ * Once a new chipset gets properly tested an individual commit can be used
+ * to document the testing for DFS for that chipset.
+ */
+static bool ath9k_hw_dfs_tested(struct ath_hw *ah)
+{
+
+	switch (ah->hw_version.macVersion) {
+	/* AR9580 will likely be our first target to get testing on */
+	case AR_SREV_VERSION_9580:
+	default:
+		return false;
+	}
+}
+
 int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
@@ -2490,6 +2514,9 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->pcie_lcr_offset = 0x80;
 	}
 
+	if (ath9k_hw_dfs_tested(ah))
+		pCap->hw_caps |= ATH9K_HW_CAP_DFS;
+
 	tx_chainmask = pCap->tx_chainmask;
 	rx_chainmask = pCap->rx_chainmask;
 	while (tx_chainmask || rx_chainmask) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 36968c0..aadc792 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -211,6 +211,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_APM			= BIT(15),
 	ATH9K_HW_CAP_RTT			= BIT(16),
 	ATH9K_HW_CAP_MCI			= BIT(17),
+	ATH9K_HW_CAP_DFS			= BIT(18),
 };
 
 struct ath9k_hw_capabilities {
-- 
1.7.4.15.g7811d


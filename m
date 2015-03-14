Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58857 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbbCNFyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 01:54:14 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [PATCH v2 02/11] ath9k: Register private AIC ops
Date: Sat, 14 Mar 2015 11:27:48 +0530
Message-Id: <1426312677-2064-3-git-send-email-sujith@msujith.org> (sfid-20150314_065421_824695_9C2E90AB)
In-Reply-To: <1426312677-2064-1-git-send-email-sujith@msujith.org>
References: <1426312677-2064-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

AIC can be disabled or enabled on a per-card
basis using MCI configuration, so register a function
to check its status.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Makefile     |  3 ++-
 drivers/net/wireless/ath/ath9k/ar9003_aic.c | 37 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_hw.c  |  1 +
 drivers/net/wireless/ath/ath9k/hw-ops.h     |  8 +++++++
 drivers/net/wireless/ath/ath9k/hw.h         |  6 +++++
 5 files changed, 54 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_aic.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 4739722..ecda613 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -46,7 +46,8 @@ ath9k_hw-y:=	\
 ath9k_hw-$(CONFIG_ATH9K_WOW) += ar9003_wow.o
 
 ath9k_hw-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += btcoex.o \
-					   ar9003_mci.o
+					   ar9003_mci.o \
+					   ar9003_aic.o
 
 ath9k_hw-$(CONFIG_ATH9K_PCOEM) += ar9003_rtt.o
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_aic.c b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
new file mode 100644
index 0000000..0cd159d
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
@@ -0,0 +1,37 @@
+/*
+ * Copyright (c) 2015 Qualcomm Atheros Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "hw.h"
+#include "hw-ops.h"
+#include "ar9003_mci.h"
+#include "ar9003_aic.h"
+
+static bool ar9003_hw_is_aic_enabled(struct ath_hw *ah)
+{
+	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
+
+	if (mci_hw->config & ATH_MCI_CONFIG_DISABLE_AIC)
+		return false;
+
+	return true;
+}
+
+void ar9003_hw_attach_aic_ops(struct ath_hw *ah)
+{
+	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+
+	priv_ops->is_aic_enabled = ar9003_hw_is_aic_enabled;
+}
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index df176e6..79fd3b2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -1180,4 +1180,5 @@ void ar9003_hw_attach_ops(struct ath_hw *ah)
 	ar9003_hw_attach_phy_ops(ah);
 	ar9003_hw_attach_calib_ops(ah);
 	ar9003_hw_attach_mac_ops(ah);
+	ar9003_hw_attach_aic_ops(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 88769b6..232339b 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -108,6 +108,14 @@ static inline void ath9k_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
 		ath9k_hw_ops(ah)->set_bt_ant_diversity(ah, enable);
 }
 
+static inline bool ath9k_hw_is_aic_enabled(struct ath_hw *ah)
+{
+	if (ath9k_hw_private_ops(ah)->is_aic_enabled)
+		return ath9k_hw_private_ops(ah)->is_aic_enabled(ah);
+
+	return false;
+}
+
 #endif
 
 /* Private hardware call ops */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 2067cb5..c22edd3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -653,6 +653,10 @@ struct ath_hw_private_ops {
 
 	/* ANI */
 	void (*ani_cache_ini_regs)(struct ath_hw *ah);
+
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+	bool (*is_aic_enabled)(struct ath_hw *ah);
+#endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
 };
 
 /**
@@ -1113,6 +1117,8 @@ void ar9003_hw_attach_calib_ops(struct ath_hw *ah);
 int ar9002_hw_attach_ops(struct ath_hw *ah);
 void ar9003_hw_attach_ops(struct ath_hw *ah);
 
+void ar9003_hw_attach_aic_ops(struct ath_hw *ah);
+
 void ar9002_hw_load_ani_reg(struct ath_hw *ah, struct ath9k_channel *chan);
 
 void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning);
-- 
2.3.1


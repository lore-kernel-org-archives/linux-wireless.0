Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42556 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1KGF1p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 00:27:45 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 08/11] ath6kl: Perform WOW resume in RX path in case of SDIO IRQ wake up
Date: Mon, 7 Nov 2011 10:55:44 +0530
Message-ID: <1320643547-3578-9-git-send-email-rmani@qca.qualcomm.com> (sfid-20111107_062747_474832_04EFF5C0)
In-Reply-To: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
References: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The target triggers sdio data line to wake up the host when
WOW pattern matches. This causes sdio irq handler is being
executed in the host side which internally hits ath6kl's RX path.

WOW resume should happen before start processing any data from
the target. So it's required to perform WOW resume in RX path.

This area needs bit rework to avoid WOW resume in RX path,
As of now it's fine to have this model, rework will be done later.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   28 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 drivers/net/wireless/ath/ath6kl/txrx.c     |    2 ++
 3 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 42dcbea..f524276 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1886,6 +1886,34 @@ static int __ath6kl_cfg80211_resume(struct wiphy *wiphy)
 
 	return ath6kl_hif_resume(ar);
 }
+
+/*
+ * FIXME: WOW suspend mode is selected if the host sdio controller supports
+ * both sdio irq wake up and keep power. The target pulls sdio data line to
+ * wake up the host when WOW pattern matches. This causes sdio irq handler
+ * is being called in the host side which internally hits ath6kl's RX path.
+ *
+ * Since sdio interrupt is not disabled, RX path executes even before
+ * the host executes the actual resume operation from PM module.
+ *
+ * In the current scenario, WOW resume should happen before start processing
+ * any data from the target. So It's required to perform WOW resume in RX path.
+ * Ideally we should perform WOW resume only in the actual platform
+ * resume path. This area needs bit rework to avoid WOW resume in RX path.
+ *
+ * ath6kl_check_wow_status() is called from ath6kl_rx().
+ */
+void ath6kl_check_wow_status(struct ath6kl *ar)
+{
+	if (ar->state == ATH6KL_STATE_WOW)
+		ath6kl_cfg80211_resume(ar);
+}
+
+#else
+
+void ath6kl_check_wow_status(struct ath6kl *ar)
+{
+}
 #endif
 
 static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 9e8b8e3..e7e095e 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -678,5 +678,6 @@ struct ath6kl_vif *ath6kl_vif_first(struct ath6kl *ar);
 void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready);
 int ath6kl_init_hw_start(struct ath6kl *ar);
 int ath6kl_init_hw_stop(struct ath6kl *ar);
+void ath6kl_check_wow_status(struct ath6kl *ar);
 
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 06e4912..6f1de44 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1134,6 +1134,8 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		return;
 	}
 
+	ath6kl_check_wow_status(ar);
+
 	if (ept == ar->ctrl_ep) {
 		ath6kl_wmi_control_rx(ar->wmi, skb);
 		return;
-- 
1.7.1


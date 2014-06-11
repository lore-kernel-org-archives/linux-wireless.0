Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:19495 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbaFKKtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:49:11 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 12/28] ath9k: Add ATH_OP_MULTI_CHANNEL
Date: Wed, 11 Jun 2014 16:18:00 +0530
Message-ID: <1402483696-2498-13-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124916_453748_B37AAFE3)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath.h           |  1 +
 drivers/net/wireless/ath/ath9k/channel.c | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index a889fd6..fd9e530 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -63,6 +63,7 @@ enum ath_op_flags {
 	ATH_OP_PRIM_STA_VIF,
 	ATH_OP_HW_RESET,
 	ATH_OP_SCANNING,
+	ATH_OP_MULTI_CHANNEL,
 };
 
 enum ath_bus_type {
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 0972070..e3127b5 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -150,8 +150,10 @@ ath_chanctx_send_vif_ps_frame(struct ath_softc *sc, struct ath_vif *avp,
 
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp;
 	bool active = false;
+	u8 n_active = 0;
 
 	if (!ctx)
 		return;
@@ -171,6 +173,17 @@ void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
 		}
 	}
 	ctx->active = active;
+
+	ath_for_each_chanctx(sc, ctx) {
+		if (!ctx->assigned || list_empty(&ctx->vifs))
+			continue;
+		n_active++;
+	}
+
+	if (n_active > 1)
+		set_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags);
+	else
+		clear_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags);
 }
 
 static bool
-- 
2.0.0


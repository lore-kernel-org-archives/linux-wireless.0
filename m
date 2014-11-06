Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53871 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbaKFHyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:54:43 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 16/21] ath9k_htc: add ath_ps_ops bindings
Date: Thu,  6 Nov 2014 08:53:33 +0100
Message-Id: <1415260418-14321-17-git-send-email-linux@rempel-privat.de> (sfid-20141106_085448_523949_AE91D272)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 4014c4b..f91b8e6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -53,6 +53,21 @@ static const struct ieee80211_tpt_blink ath9k_htc_tpt_blink[] = {
 };
 #endif
 
+void ath9k_htc_op_ps_wakeup(struct ath_common *common)
+{
+	ath9k_htc_ps_wakeup((struct ath9k_htc_priv *) common->priv);
+}
+
+void ath9k_htc_op_ps_restore(struct ath_common *common)
+{
+	ath9k_htc_ps_restore((struct ath9k_htc_priv *) common->priv);
+}
+
+struct ath_ps_ops ath9k_htc_ps_ops = {
+	.wakeup = ath9k_htc_op_ps_wakeup,
+	.restore = ath9k_htc_op_ps_restore,
+};
+
 static int ath9k_htc_wait_for_target(struct ath9k_htc_priv *priv)
 {
 	int time_left;
@@ -478,6 +493,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 
 	common = ath9k_hw_common(ah);
 	common->ops = &ah->reg_ops;
+	common->ps_ops = &ath9k_htc_ps_ops;
 	common->bus_ops = &ath9k_usb_bus_ops;
 	common->ah = ah;
 	common->hw = priv->hw;
-- 
1.9.1


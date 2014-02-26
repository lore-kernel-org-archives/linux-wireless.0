Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52973 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaBZJE7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 04:04:59 -0500
Received: from ultralex.lan ([93.218.100.117]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0MI5JG-1WFp031CKE-003uFE for
 <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 10:04:57 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linville@tuxdriver.com, sujith@msujith.org,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 3/3] ath9k_htc: add function ath9k_regwrite_multi
Date: Wed, 26 Feb 2014 10:04:44 +0100
Message-Id: <1393405484-16424-1-git-send-email-linux@rempel-privat.de> (sfid-20140226_100510_096610_128C3754)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... to remove duplicate code

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 53 ++++++++++++---------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index a8f30dc..b22fb64 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -256,6 +256,25 @@ static void ath9k_multi_regread(void *hw_priv, u32 *addr,
        }
 }
 
+static void ath9k_regwrite_multi(struct ath_common *common)
+{
+	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) common->priv;
+	u32 rsp_status;
+	int r;
+
+	r = ath9k_wmi_cmd(priv->wmi, WMI_REG_WRITE_CMDID,
+			  (u8 *) &priv->wmi->multi_write,
+			  sizeof(struct register_write) * priv->wmi->multi_write_idx,
+			  (u8 *) &rsp_status, sizeof(rsp_status),
+			  100);
+	if (unlikely(r)) {
+		ath_dbg(common, WMI,
+			"REGISTER WRITE FAILED, multi len: %d\n",
+			priv->wmi->multi_write_idx);
+	}
+	priv->wmi->multi_write_idx = 0;
+}
+
 static void ath9k_regwrite_single(void *hw_priv, u32 val, u32 reg_offset)
 {
 	struct ath_hw *ah = (struct ath_hw *) hw_priv;
@@ -282,8 +301,6 @@ static void ath9k_regwrite_buffer(void *hw_priv, u32 val, u32 reg_offset)
 	struct ath_hw *ah = (struct ath_hw *) hw_priv;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) common->priv;
-	u32 rsp_status;
-	int r;
 
 	mutex_lock(&priv->wmi->multi_write_mutex);
 
@@ -296,19 +313,8 @@ static void ath9k_regwrite_buffer(void *hw_priv, u32 val, u32 reg_offset)
 	priv->wmi->multi_write_idx++;
 
 	/* If the buffer is full, send it out. */
-	if (priv->wmi->multi_write_idx == MAX_CMD_NUMBER) {
-		r = ath9k_wmi_cmd(priv->wmi, WMI_REG_WRITE_CMDID,
-			  (u8 *) &priv->wmi->multi_write,
-			  sizeof(struct register_write) * priv->wmi->multi_write_idx,
-			  (u8 *) &rsp_status, sizeof(rsp_status),
-			  100);
-		if (unlikely(r)) {
-			ath_dbg(common, WMI,
-				"REGISTER WRITE FAILED, multi len: %d\n",
-				priv->wmi->multi_write_idx);
-		}
-		priv->wmi->multi_write_idx = 0;
-	}
+	if (priv->wmi->multi_write_idx == MAX_CMD_NUMBER)
+		ath9k_regwrite_multi(common);
 
 	mutex_unlock(&priv->wmi->multi_write_mutex);
 }
@@ -339,26 +345,13 @@ static void ath9k_regwrite_flush(void *hw_priv)
 	struct ath_hw *ah = (struct ath_hw *) hw_priv;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) common->priv;
-	u32 rsp_status;
-	int r;
 
 	atomic_dec(&priv->wmi->mwrite_cnt);
 
 	mutex_lock(&priv->wmi->multi_write_mutex);
 
-	if (priv->wmi->multi_write_idx) {
-		r = ath9k_wmi_cmd(priv->wmi, WMI_REG_WRITE_CMDID,
-			  (u8 *) &priv->wmi->multi_write,
-			  sizeof(struct register_write) * priv->wmi->multi_write_idx,
-			  (u8 *) &rsp_status, sizeof(rsp_status),
-			  100);
-		if (unlikely(r)) {
-			ath_dbg(common, WMI,
-				"REGISTER WRITE FAILED, multi len: %d\n",
-				priv->wmi->multi_write_idx);
-		}
-		priv->wmi->multi_write_idx = 0;
-	}
+	if (priv->wmi->multi_write_idx)
+		ath9k_regwrite_multi(common);
 
 	mutex_unlock(&priv->wmi->multi_write_mutex);
 }
-- 
1.9.0


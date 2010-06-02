Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57557 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365Ab0FBKWm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 06:22:42 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 03:22:42 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19462.12602.481326.129620@gargle.gargle.HOWL>
Date: Wed, 2 Jun 2010 15:53:54 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 8/8] ath9k_htc: Configure credit size for AR7010
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For non-AR9271 chips, the credit size is different
and has to be configured appropriately.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   30 ++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/htc_hst.c      |    3 +-
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index cda3041..7339439 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -179,7 +179,7 @@ static inline int ath9k_htc_connect_svc(struct ath9k_htc_priv *priv,
 	return htc_connect_service(priv->htc, &req, ep_id);
 }
 
-static int ath9k_init_htc_services(struct ath9k_htc_priv *priv)
+static int ath9k_init_htc_services(struct ath9k_htc_priv *priv, u16 devid)
 {
 	int ret;
 
@@ -237,10 +237,33 @@ static int ath9k_init_htc_services(struct ath9k_htc_priv *priv)
 	if (ret)
 		goto err;
 
+	/*
+	 * Setup required credits before initializing HTC.
+	 * This is a bit hacky, but, since queuing is done in
+	 * the HIF layer, shouldn't matter much.
+	 */
+
+	switch(devid) {
+	case 0x9271:
+	case 0x1006:
+		priv->htc->credits = 33;
+		break;
+	case 0x7010:
+		priv->htc->credits = 45;
+		break;
+	default:
+		dev_err(priv->dev, "ath9k_htc: Unsupported device id: 0x%x\n",
+			devid);
+		goto err;
+	}
+
 	ret = htc_init(priv->htc);
 	if (ret)
 		goto err;
 
+	dev_info(priv->dev, "ath9k_htc: HTC initialized with %d credits\n",
+		 priv->htc->credits);
+
 	return 0;
 
 err:
@@ -842,7 +865,7 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 		goto err_free;
 	}
 
-	ret = ath9k_init_htc_services(priv);
+	ret = ath9k_init_htc_services(priv, devid);
 	if (ret)
 		goto err_init;
 
@@ -885,7 +908,8 @@ int ath9k_htc_resume(struct htc_target *htc_handle)
 	if (ret)
 		return ret;
 
-	ret = ath9k_init_htc_services(htc_handle->drv_priv);
+	ret = ath9k_init_htc_services(htc_handle->drv_priv,
+			      htc_handle->drv_priv->ah->hw_version.devid);
 	return ret;
 }
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 2173196..705c0f3 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -89,7 +89,6 @@ static void htc_process_target_rdy(struct htc_target *target,
 	struct htc_endpoint *endpoint;
 	struct htc_ready_msg *htc_ready_msg = (struct htc_ready_msg *) buf;
 
-	target->credits = be16_to_cpu(htc_ready_msg->credits);
 	target->credit_size = be16_to_cpu(htc_ready_msg->credit_size);
 
 	endpoint = &target->endpoint[ENDPOINT0];
@@ -159,7 +158,7 @@ static int htc_config_pipe_credits(struct htc_target *target)
 
 	cp_msg->message_id = cpu_to_be16(HTC_MSG_CONFIG_PIPE_ID);
 	cp_msg->pipe_id = USB_WLAN_TX_PIPE;
-	cp_msg->credits = 33;
+	cp_msg->credits = target->credits;
 
 	target->htc_flags |= HTC_OP_CONFIG_PIPE_CREDITS;
 
-- 
1.7.1


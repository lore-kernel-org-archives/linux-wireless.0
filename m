Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53743 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbaGYTwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 15:52:33 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so4680063wgh.25
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 12:52:32 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/12] staging: vt6656: rename device_init_registers to vnt_init_registers
Date: Fri, 25 Jul 2014 20:51:46 +0100
Message-Id: <1406317916-21884-2-git-send-email-tvboxspy@gmail.com> (sfid-20140725_215236_898058_5E3CB44E)
In-Reply-To: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
References: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

changing device to vnt

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 7e8551f..51fad26 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -37,7 +37,7 @@
  *   device_free_tx_bufs - free tx buffer function
  *   device_dma0_tx_80211- tx 802.11 frame via dma0
  *   device_dma0_xmit- tx PS buffered frame via dma0
- *   device_init_registers- initial MAC & BBP & RF internal registers.
+ *   vnt_init_registers- initial MAC & BBP & RF internal registers.
  *   device_init_rings- initial tx/rx ring buffer
  *   device_init_defrag_cb- initial & allocate de-fragement buffer.
  *   device_tx_srv- tx interrupt service function
@@ -131,7 +131,7 @@ static void vnt_set_options(struct vnt_private *priv)
 /*
  * initialization of MAC & BBP registers
  */
-static int device_init_registers(struct vnt_private *priv)
+static int vnt_init_registers(struct vnt_private *priv)
 {
 	struct vnt_cmd_card_init *init_cmd = &priv->init_command;
 	struct vnt_rsp_card_init *init_rsp = &priv->init_response;
@@ -553,7 +553,7 @@ static int vnt_start(struct ieee80211_hw *hw)
 
 	clear_bit(DEVICE_FLAGS_DISCONNECTED, &priv->flags);
 
-	if (device_init_registers(priv) == false) {
+	if (vnt_init_registers(priv) == false) {
 		dev_dbg(&priv->usb->dev, " init register fail\n");
 		goto free_all;
 	}
@@ -954,7 +954,7 @@ static const struct ieee80211_ops vnt_mac_ops = {
 int vnt_init(struct vnt_private *priv)
 {
 
-	if (!(device_init_registers(priv)))
+	if (!(vnt_init_registers(priv)))
 		return -EAGAIN;
 
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->permanent_net_addr);
-- 
2.0.1


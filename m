Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49422 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab3DGTK6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 15:10:58 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, adrian@freebsd.org
Subject: [PATCH 3.9] ath9k_htc: accept 1.x firmware newer than 1.3
Date: Sun,  7 Apr 2013 21:10:48 +0200
Message-Id: <1365361848-65831-1-git-send-email-nbd@openwrt.org> (sfid-20130407_211103_094237_4671EB26)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the firmware has been open sourced, the minor version has been
bumped to 1.4 and the API/ABI will stay compatible across further 1.x
releases.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 716058b..a47f5e0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -796,7 +796,7 @@ static int ath9k_init_firmware_version(struct ath9k_htc_priv *priv)
 	 * required version.
 	 */
 	if (priv->fw_version_major != MAJOR_VERSION_REQ ||
-	    priv->fw_version_minor != MINOR_VERSION_REQ) {
+	    priv->fw_version_minor < MINOR_VERSION_REQ) {
 		dev_err(priv->dev, "ath9k_htc: Please upgrade to FW version %d.%d\n",
 			MAJOR_VERSION_REQ, MINOR_VERSION_REQ);
 		return -EINVAL;
-- 
1.8.0.2


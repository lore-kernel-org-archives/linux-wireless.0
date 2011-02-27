Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37708 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab1B0VT0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 16:19:26 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, chunkeey@googlemail.com
Subject: [PATCH] p54: fix a NULL pointer dereference bug
Date: Sun, 27 Feb 2011 22:19:22 +0100
Message-Id: <1298841562-62496-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the RSSI calibration table was not found or not parsed properly,
priv->rssi_db will be NULL, p54_rssi_find needs to be able to deal
with that.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/p54/eeprom.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index f54e15f..13d750d 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -524,10 +524,13 @@ err_data:
 
 struct p54_rssi_db_entry *p54_rssi_find(struct p54_common *priv, const u16 freq)
 {
-	struct p54_rssi_db_entry *entry = (void *)(priv->rssi_db->data +
-						   priv->rssi_db->offset);
+	struct p54_rssi_db_entry *entry;
 	int i, found = -1;
 
+	if (!priv->rssi_db)
+		return &p54_rssi_default;
+
+	entry = (void *)(priv->rssi_db->data + priv->rssi_db->offset);
 	for (i = 0; i < priv->rssi_db->entries; i++) {
 		if (!same_band(freq, entry[i].freq))
 			continue;
-- 
1.7.3.2


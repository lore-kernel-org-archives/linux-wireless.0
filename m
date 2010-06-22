Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36290 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754366Ab0FVOwv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 10:52:51 -0400
From: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
To: kalle.valo@iki.fi
Subject: [PATCH 1/2] at76c50x-usb: Move function at76_join() several lines up
Date: Tue, 22 Jun 2010 16:53:37 +0200
Cc: linux-wireless@vger.kernel.org
References: <201006221651.24853.Sebastian.Smolorz@gmx.de>
In-Reply-To: <201006221651.24853.Sebastian.Smolorz@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201006221653.37825.Sebastian.Smolorz@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch does a simple code move of at76_join() so that
at76_mac80211_tx() follows at76_join() in the driver's source file.

This is a preparatory patch for the following patch where we need
to call at76_join() from at76_mac80211_tx() in order to
authenticate successfully with a bssid.

Signed-off-by: Sebastian Smolorz <sesmo@gmx.net>
---
 drivers/net/wireless/at76c50x-usb.c |   72 +++++++++++++++++-----------------
 1 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 8a2d4af..cb3d4b7 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1649,6 +1649,42 @@ exit:
 		return NULL;
 }
 
+static int at76_join(struct at76_priv *priv)
+{
+	struct at76_req_join join;
+	int ret;
+
+	memset(&join, 0, sizeof(struct at76_req_join));
+	memcpy(join.essid, priv->essid, priv->essid_size);
+	join.essid_size = priv->essid_size;
+	memcpy(join.bssid, priv->bssid, ETH_ALEN);
+	join.bss_type = INFRASTRUCTURE_MODE;
+	join.channel = priv->channel;
+	join.timeout = cpu_to_le16(2000);
+
+	at76_dbg(DBG_MAC80211, "%s: sending CMD_JOIN", __func__);
+	ret = at76_set_card_command(priv->udev, CMD_JOIN, &join,
+				    sizeof(struct at76_req_join));
+
+	if (ret < 0) {
+		printk(KERN_ERR "%s: at76_set_card_command failed: %d\n",
+		       wiphy_name(priv->hw->wiphy), ret);
+		return 0;
+	}
+
+	ret = at76_wait_completion(priv, CMD_JOIN);
+	at76_dbg(DBG_MAC80211, "%s: CMD_JOIN returned: 0x%02x", __func__, ret);
+	if (ret != CMD_STATUS_COMPLETE) {
+		printk(KERN_ERR "%s: at76_wait_completion failed: %d\n",
+		       wiphy_name(priv->hw->wiphy), ret);
+		return 0;
+	}
+
+	at76_set_pm_mode(priv);
+
+	return 0;
+}
+
 static void at76_mac80211_tx_callback(struct urb *urb)
 {
 	struct at76_priv *priv = urb->context;
@@ -1818,42 +1854,6 @@ static void at76_remove_interface(struct ieee80211_hw *hw,
 	at76_dbg(DBG_MAC80211, "%s()", __func__);
 }
 
-static int at76_join(struct at76_priv *priv)
-{
-	struct at76_req_join join;
-	int ret;
-
-	memset(&join, 0, sizeof(struct at76_req_join));
-	memcpy(join.essid, priv->essid, priv->essid_size);
-	join.essid_size = priv->essid_size;
-	memcpy(join.bssid, priv->bssid, ETH_ALEN);
-	join.bss_type = INFRASTRUCTURE_MODE;
-	join.channel = priv->channel;
-	join.timeout = cpu_to_le16(2000);
-
-	at76_dbg(DBG_MAC80211, "%s: sending CMD_JOIN", __func__);
-	ret = at76_set_card_command(priv->udev, CMD_JOIN, &join,
-				    sizeof(struct at76_req_join));
-
-	if (ret < 0) {
-		printk(KERN_ERR "%s: at76_set_card_command failed: %d\n",
-		       wiphy_name(priv->hw->wiphy), ret);
-		return 0;
-	}
-
-	ret = at76_wait_completion(priv, CMD_JOIN);
-	at76_dbg(DBG_MAC80211, "%s: CMD_JOIN returned: 0x%02x", __func__, ret);
-	if (ret != CMD_STATUS_COMPLETE) {
-		printk(KERN_ERR "%s: at76_wait_completion failed: %d\n",
-		       wiphy_name(priv->hw->wiphy), ret);
-		return 0;
-	}
-
-	at76_set_pm_mode(priv);
-
-	return 0;
-}
-
 static void at76_dwork_hw_scan(struct work_struct *work)
 {
 	struct at76_priv *priv = container_of(work, struct at76_priv,
-- 
1.6.4.4


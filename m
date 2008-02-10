Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:53731 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYBJPL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 10:11:56 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 06/12] Add support for monitor mode
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Date: Sun, 10 Feb 2008 17:00:34 +0200
Message-ID: <20080210150034.17592.71617.stgit@tikku> (sfid-20080210_151200_437654_403AD01F)
In-Reply-To: <20080210145733.17592.61729.stgit@tikku>
References: <20080210145733.17592.61729.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76_usb.c |   28 ++++++++++++++++++++++++++--
 drivers/net/wireless/at76_usb.h |    2 ++
 2 files changed, 28 insertions(+), 2 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 6e8a001..0d26086 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -19,7 +19,6 @@
  * Some iw_handler code was taken from airo.c, (C) 1999 Benjamin Reed
  *
  * TODO for the mac80211 port:
- * o monitor mode
  * o adhoc support
  * o hardware wep encryption
  * o RTS/CTS support
@@ -5296,6 +5295,8 @@ static int at76_mac80211_start(struct ieee80211_hw *hw)
 
 	at76_startup_device(priv);
 
+	at76_start_monitor(priv);
+
 error:
 	mutex_unlock(&priv->mtx);
 
@@ -5487,6 +5488,8 @@ static int at76_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 
 	if (is_valid_ether_addr(priv->bssid))
 		at76_join(priv);
+	else
+		at76_start_monitor(priv);
 
 	mutex_unlock(&priv->mtx);
 
@@ -5519,16 +5522,37 @@ static int at76_config_interface(struct ieee80211_hw *hw,
 	return 0;
 }
 
+/* must be atomic */
 static void at76_configure_filter(struct ieee80211_hw *hw,
 				  unsigned int changed_flags,
 				  unsigned int *total_flags, int mc_count,
 				  struct dev_addr_list *mc_list)
 {
+	struct at76_mac80211_priv *m_priv = hw->priv;
+	struct at76_priv *priv = m_priv->at76_priv;
+	int flags;
+
 	at76_dbg(DBG_MAC80211, "%s(): changed_flags=0x%08x "
 		 "total_flags=0x%08x mc_count=%d",
 		 __func__, changed_flags, *total_flags, mc_count);
 
-	*total_flags = 0;
+	flags = changed_flags & AT76_SUPPORTED_FILTERS;
+	*total_flags = AT76_SUPPORTED_FILTERS;
+
+	/* FIXME: access to priv->promisc should be protected with
+	 * priv->mtx, but it's impossible because this function needs to be
+	 * atomic */
+
+	if (flags && !priv->promisc) {
+		/* mac80211 wants us to enable promiscuous mode */
+		priv->promisc = 1;
+	} else if (!flags && priv->promisc) {
+		/* we need to disable promiscuous mode */
+		priv->promisc = 0;
+	} else
+		return;
+
+	queue_work(hw->workqueue, &priv->work_set_promisc);
 }
 
 static const struct ieee80211_ops at76_ops = {
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index 555a948..baa85a5 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -577,6 +577,8 @@ struct at76_rx_radiotap {
 	s8 rt_noise;
 };
 
+#define AT76_SUPPORTED_FILTERS FIF_PROMISC_IN_BSS
+
 #define AT76_RX_RADIOTAP_PRESENT		  \
 	((1 << IEEE80211_RADIOTAP_TSFT)		| \
 	(1 << IEEE80211_RADIOTAP_FLAGS)		| \


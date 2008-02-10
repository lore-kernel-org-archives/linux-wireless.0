Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:47324 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYBJPKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 10:10:38 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 07/12] Add support for WEP
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Date: Sun, 10 Feb 2008 17:00:41 +0200
Message-ID: <20080210150041.17592.23590.stgit@tikku> (sfid-20080210_151045_952169_C86BA86A)
In-Reply-To: <20080210145733.17592.61729.stgit@tikku>
References: <20080210145733.17592.61729.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76_usb.c |   53 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 0d26086..4ffae92 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -20,7 +20,6 @@
  *
  * TODO for the mac80211 port:
  * o adhoc support
- * o hardware wep encryption
  * o RTS/CTS support
  * o Power Save Mode support
  * o support for short/long preambles
@@ -5056,6 +5055,8 @@ static void at76_rx_tasklet(unsigned long param)
 			      priv->rx_skb->len);
 
 		rx_status.ssi = buf->rssi;
+		rx_status.flag |= RX_FLAG_DECRYPTED;
+		rx_status.flag |= RX_FLAG_IV_STRIPPED;
 
 		at76_dbg(DBG_MAC80211, "calling ieee80211_rx_irqsafe(): %d/%d",
 			 priv->rx_skb->len, priv->rx_skb->data_len);
@@ -5555,6 +5556,55 @@ static void at76_configure_filter(struct ieee80211_hw *hw,
 	queue_work(hw->workqueue, &priv->work_set_promisc);
 }
 
+static int at76_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+			const u8 *local_address, const u8 *address,
+			struct ieee80211_key_conf *key)
+{
+	struct at76_mac80211_priv *m_priv = hw->priv;
+	struct at76_priv *priv = m_priv->at76_priv;
+	int i;
+
+	at76_dbg(DBG_MAC80211, "%s(): cmd %d key->alg %d key->keyidx %d "
+		 "key->keylen %d",
+		 __func__, cmd, key->alg, key->keyidx, key->keylen);
+
+	if (key->alg != ALG_WEP)
+		return -EOPNOTSUPP;
+
+	key->hw_key_idx = key->keyidx;
+
+	mutex_lock(&priv->mtx);
+
+	switch (cmd) {
+	case SET_KEY:
+		memcpy(priv->wep_keys[key->keyidx], key->key, key->keylen);
+		priv->wep_keys_len[key->keyidx] = key->keylen;
+
+		/* FIXME: find out how to do this properly */
+		priv->wep_key_id = key->keyidx;
+
+		break;
+	case DISABLE_KEY:
+	default:
+		priv->wep_keys_len[key->keyidx] = 0;
+		break;
+	}
+
+	priv->wep_enabled = 0;
+
+	for (i = 0; i < WEP_KEYS; i++) {
+		if (priv->wep_keys_len[i] != 0)
+			priv->wep_enabled = 1;
+	}
+
+	at76_startup_device(priv);
+
+	mutex_unlock(&priv->mtx);
+
+	return 0;
+}
+
+
 static const struct ieee80211_ops at76_ops = {
 	.tx = at76_mac80211_tx,
 	.add_interface = at76_add_interface,
@@ -5565,6 +5615,7 @@ static const struct ieee80211_ops at76_ops = {
 	.start = at76_mac80211_start,
 	.stop = at76_mac80211_stop,
 	.hw_scan = at76_hw_scan,
+	.set_key = at76_set_key,
 };
 
 /* Allocate network device and initialize private data */


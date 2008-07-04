Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.190]:41101 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbYGDRo0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 13:44:26 -0400
Received: by gv-out-0910.google.com with SMTP id e6so242801gvc.37
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 10:44:24 -0700 (PDT)
From: Milan Plzik <milan.plzik@gmail.com>
Subject: [PATCH 4/7] Some at76-based devices don't include FCS in received
	frames.
To: linux-wireless@vger.kernel.org
Date: Fri, 04 Jul 2008 19:44:20 +0200
Message-ID: <20080704174420.4996.48372.stgit@localhost> (sfid-20080704_194428_907777_A7489550)
In-Reply-To: <20080704174350.4996.72931.stgit@localhost>
References: <20080704174350.4996.72931.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make at76_init_new_device to register device with hwflag
IEEE80211_HW_RX_INCLUDES_FCS only in case when it is not proven otherwise
(with firmware 1.103 and, according to atmelwlandriver, with rfmd, r505 and
r505_2958 devices, the frame doesn't include FCS).

Signed-off-by: Milan Plzik <milan.plzik@gmail.com>
---

 drivers/net/wireless/at76_usb.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index b6d06b8..43ec42c 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -106,6 +106,8 @@
 
 static int at76_debug = DBG_DEFAULTS;
 
+#define FIRMWARE_IS_WPA(ver) ((ver.major == 1) && (ver.minor == 103))
+
 /* Protect against concurrent firmware loading and parsing */
 static struct mutex fw_mutex;
 
@@ -306,6 +308,11 @@ static inline int at76_is_503rfmd(enum board_type board)
 	return (board == BOARD_503 || board == BOARD_503_ACC);
 }
 
+static inline int at76_is_505(enum board_type board)
+{
+	return (board == BOARD_505 || BOARD_505_2958);
+}
+
 static inline int at76_is_505a(enum board_type board)
 {
 	return (board == BOARD_505A || board == BOARD_505AMX);
@@ -1597,7 +1604,7 @@ static void at76_rx_tasklet(unsigned long param)
 
 	skb_trim(priv->rx_skb, le16_to_cpu(buf->wlength) + AT76_RX_HDRLEN);
 	at76_dbg_dump(DBG_RX_DATA, &priv->rx_skb->data[AT76_RX_HDRLEN],
-		      priv->rx_skb->len, "RX: len=%d", priv->rx_skb->len - AT76_RX_HDRLEN);
+		      priv->rx_skb->len, "RX: len=%d", (int)(priv->rx_skb->len - AT76_RX_HDRLEN));
 
 	rx_status.signal = buf->rssi;
 	rx_status.flag |= RX_FLAG_DECRYPTED;
@@ -2277,8 +2284,14 @@ static int at76_init_new_device(struct at76_priv *priv,
 
 	/* mac80211 initialisation */
 	priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &at76_supported_band;
-	priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-			  IEEE80211_HW_SIGNAL_UNSPEC;
+
+	if (FIRMWARE_IS_WPA(priv->fw_version) && 
+		(at76_is_503rfmd(priv->board_type) || 
+		 at76_is_505(priv->board_type)))
+		priv->hw->flags = IEEE80211_HW_SIGNAL_UNSPEC;
+	else
+		priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
+				  IEEE80211_HW_SIGNAL_UNSPEC;
 
 	SET_IEEE80211_DEV(priv->hw, &interface->dev);
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45430 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbXI3Sjp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:39:45 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 10/26] at76_usb: Rename tlv to ie for readability
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:39:42 -0400
Message-ID: <20070930183942.23921.90421.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ie" is the standard abbreviation for "information element".

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   60 ++++++++++++++++++++-------------------
 1 files changed, 30 insertions(+), 30 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index e39ca62..b6f931a 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1627,7 +1627,7 @@ static int at76_assoc_req(struct at76_priv *priv, struct bss_info *bss)
 	struct at76_tx_buffer *tx_buffer;
 	struct ieee80211_hdr_3addr *mgmt;
 	struct ieee80211_assoc_request *req;
-	struct ieee80211_info_element *tlv;
+	struct ieee80211_info_element *ie;
 	char essid[IW_ESSID_MAX_SIZE + 1];
 	int len;
 	u16 capa;
@@ -1640,7 +1640,7 @@ static int at76_assoc_req(struct at76_priv *priv, struct bss_info *bss)
 
 	req = (struct ieee80211_assoc_request *)tx_buffer->packet;
 	mgmt = &req->header;
-	tlv = req->info_element;
+	ie = req->info_element;
 
 	/* make wireless header */
 	mgmt->frame_ctl = cpu_to_le16(IEEE80211_FTYPE_MGMT |
@@ -1667,29 +1667,29 @@ static int at76_assoc_req(struct at76_priv *priv, struct bss_info *bss)
 
 	/* write TLV data elements */
 
-	tlv->id = MFIE_TYPE_SSID;
-	tlv->len = bss->ssid_len;
-	memcpy(tlv->data, bss->ssid, bss->ssid_len);
-	next_ie(&tlv);
+	ie->id = MFIE_TYPE_SSID;
+	ie->len = bss->ssid_len;
+	memcpy(ie->data, bss->ssid, bss->ssid_len);
+	next_ie(&ie);
 
-	tlv->id = MFIE_TYPE_RATES;
-	tlv->len = sizeof(hw_rates);
-	memcpy(tlv->data, hw_rates, sizeof(hw_rates));
-	next_ie(&tlv);		/* tlv points behind the supp_rates field */
+	ie->id = MFIE_TYPE_RATES;
+	ie->len = sizeof(hw_rates);
+	memcpy(ie->data, hw_rates, sizeof(hw_rates));
+	next_ie(&ie);		/* ie points behind the supp_rates field */
 
 	/* init. at76_priv tx header */
-	tx_buffer->wlength = cpu_to_le16((u8 *)tlv - (u8 *)mgmt);
+	tx_buffer->wlength = cpu_to_le16((u8 *)ie - (u8 *)mgmt);
 
-	tlv = req->info_element;
-	len = min_t(int, IW_ESSID_MAX_SIZE, tlv->len);
-	memcpy(essid, tlv->data, len);
+	ie = req->info_element;
+	len = min_t(int, IW_ESSID_MAX_SIZE, ie->len);
+	memcpy(essid, ie->data, len);
 	essid[len] = '\0';
-	next_ie(&tlv);		/* points to IE of rates now */
+	next_ie(&ie);		/* points to IE of rates now */
 	at76_dbg(DBG_TX_MGMT,
 		 "%s: AssocReq bssid %s capa 0x%04x ssid %s rates %s",
 		 priv->netdev->name, mac2str(mgmt->addr3),
 		 le16_to_cpu(req->capability), essid,
-		 hex2str(tlv->data, tlv->len));
+		 hex2str(ie->data, ie->len));
 
 	/* either send immediately (if no data tx is pending
 	   or put it in pending list */
@@ -4258,7 +4258,7 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 	struct bss_info *match;	/* entry matching addr3 with its bssid */
 	int new_entry = 0;
 	int len;
-	struct ieee80211_info_element *tlv;
+	struct ieee80211_info_element *ie;
 	int have_ssid = 0;
 	int have_rates = 0;
 	int have_channel = 0;
@@ -4321,7 +4321,7 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 	at76_dbg(DBG_RX_BEACON, "%s: bssid %s", priv->netdev->name,
 		 mac2str(match->bssid));
 
-	tlv = bdata->info_element;
+	ie = bdata->info_element;
 
 	/* length of var length beacon parameters */
 	varpar_len = min_t(int, le16_to_cpu(buf->wlength) -
@@ -4343,29 +4343,29 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 	 * bytes are useful, hence the have_ssid etc optimizations. */
 
 	while (keep_going &&
-	       ((&tlv->data[tlv->len] - (u8 *)bdata->info_element) <=
+	       ((&ie->data[ie->len] - (u8 *)bdata->info_element) <=
 		varpar_len)) {
 
-		switch (tlv->id) {
+		switch (ie->id) {
 
 		case MFIE_TYPE_SSID:
 			if (have_ssid)
 				break;
 
-			len = min_t(int, IW_ESSID_MAX_SIZE, tlv->len);
+			len = min_t(int, IW_ESSID_MAX_SIZE, ie->len);
 
 			/* we copy only if this is a new entry,
 			   or the incoming SSID is not a hidden SSID. This
 			   will protect us from overwriting a real SSID read
 			   in a ProbeResponse with a hidden one from a
 			   following beacon. */
-			if (!new_entry && at76_is_hidden_ssid(tlv->data, len)) {
+			if (!new_entry && at76_is_hidden_ssid(ie->data, len)) {
 				have_ssid = 1;
 				break;
 			}
 
 			match->ssid_len = len;
-			memcpy(match->ssid, tlv->data, len);
+			memcpy(match->ssid, ie->data, len);
 			match->ssid[len] = '\0';	/* terminate the
 							   string for
 							   printing */
@@ -4379,19 +4379,19 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 				break;
 
 			match->rates_len =
-			    min_t(int, sizeof(match->rates), tlv->len);
-			memcpy(match->rates, tlv->data, match->rates_len);
+			    min_t(int, sizeof(match->rates), ie->len);
+			memcpy(match->rates, ie->data, match->rates_len);
 			have_rates = 1;
 			at76_dbg(DBG_RX_BEACON, "%s: SUPPORTED RATES %s",
 				 priv->netdev->name,
-				 hex2str(tlv->data, tlv->len));
+				 hex2str(ie->data, ie->len));
 			break;
 
 		case MFIE_TYPE_DS_SET:
 			if (have_channel)
 				break;
 
-			match->channel = tlv->data[0];
+			match->channel = ie->data[0];
 			have_channel = 1;
 			at76_dbg(DBG_RX_BEACON, "%s: CHANNEL - %d",
 				 priv->netdev->name, match->channel);
@@ -4402,13 +4402,13 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 		case MFIE_TYPE_IBSS_SET:
 		default:
 			at76_dbg(DBG_RX_BEACON, "%s: beacon IE id %d len %d %s",
-				 priv->netdev->name, tlv->id, tlv->len,
-				 hex2str(tlv->data, tlv->len));
+				 priv->netdev->name, ie->id, ie->len,
+				 hex2str(ie->data, ie->len));
 			break;
 		}
 
 		/* advance to the next informational element */
-		next_ie(&tlv);
+		next_ie(&ie);
 
 		/* Optimization: after all, the bdata->data array is
 		 * varpar_len bytes long, whereas we get all of the useful

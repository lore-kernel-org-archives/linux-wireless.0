Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:6021 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbXI3Sj6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:39:58 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 12/26] at76_usb: Use string precision to avoid line termination
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:39:55 -0400
Message-ID: <20070930183955.23921.26325.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In particular, don't extend ESSID to 33 bytes.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   59 ++++++++++++++-------------------------
 drivers/net/wireless/at76_usb.h |    3 +-
 2 files changed, 22 insertions(+), 40 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 2bb23e8..81fefff 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1062,7 +1062,6 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 	int ret;
 	struct mib_mac_mgmt *m = kmalloc(sizeof(struct mib_mac_mgmt),
 					 GFP_KERNEL);
-	char country_string[4];
 
 	if (!m)
 		return;
@@ -1075,16 +1074,13 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 		goto exit;
 	}
 
-	memcpy(&country_string, m->country_string, 3);
-	country_string[3] = '\0';
-
 	at76_dbg(DBG_MIB, "%s: MIB MAC_MGMT: beacon_period %d CFP_max_duration "
 		 "%d medium_occupancy_limit %d station_id 0x%x ATIM_window %d "
 		 "CFP_mode %d privacy_opt_impl %d DTIM_period %d CFP_period %d "
 		 "current_bssid %s current_essid %s current_bss_type %d "
 		 "pm_mode %d ibss_change %d res %d "
 		 "multi_domain_capability_implemented %d "
-		 "international_roaming %d country_string %s",
+		 "international_roaming %d country_string %.3s",
 		 priv->netdev->name, le16_to_cpu(m->beacon_period),
 		 le16_to_cpu(m->CFP_max_duration),
 		 le16_to_cpu(m->medium_occupancy_limit),
@@ -1094,7 +1090,7 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 		 hex2str(m->current_essid, IW_ESSID_MAX_SIZE),
 		 m->current_bss_type, m->power_mgmt_mode, m->ibss_change,
 		 m->res, m->multi_domain_capability_implemented,
-		 m->multi_domain_capability_enabled, country_string);
+		 m->multi_domain_capability_enabled, m->country_string);
 exit:
 	kfree(m);
 }
@@ -1628,8 +1624,8 @@ static int at76_assoc_req(struct at76_priv *priv, struct bss_info *bss)
 	struct ieee80211_hdr_3addr *mgmt;
 	struct ieee80211_assoc_request *req;
 	struct ieee80211_info_element *ie;
-	char essid[IW_ESSID_MAX_SIZE + 1];
-	int len;
+	char *essid;
+	int essid_len;
 	u16 capa;
 
 	BUG_ON(!bss);
@@ -1681,14 +1677,14 @@ static int at76_assoc_req(struct at76_priv *priv, struct bss_info *bss)
 	tx_buffer->wlength = cpu_to_le16((u8 *)ie - (u8 *)mgmt);
 
 	ie = req->info_element;
-	len = min_t(int, IW_ESSID_MAX_SIZE, ie->len);
-	memcpy(essid, ie->data, len);
-	essid[len] = '\0';
+	essid = ie->data;
+	essid_len = min_t(int, IW_ESSID_MAX_SIZE, ie->len);
+
 	next_ie(&ie);		/* points to IE of rates now */
 	at76_dbg(DBG_TX_MGMT,
-		 "%s: AssocReq bssid %s capa 0x%04x ssid %s rates %s",
+		 "%s: AssocReq bssid %s capa 0x%04x ssid %.*s rates %s",
 		 priv->netdev->name, mac2str(mgmt->addr3),
-		 le16_to_cpu(req->capability), essid,
+		 le16_to_cpu(req->capability), essid_len, essid,
 		 hex2str(ie->data, ie->len));
 
 	/* either send immediately (if no data tx is pending
@@ -1746,13 +1742,12 @@ static void at76_dump_bss_table(struct at76_priv *priv)
 
 	list_for_each(lptr, &priv->bss_list) {
 		ptr = list_entry(lptr, struct bss_info, list);
-		at76_dbg(DBG_BSS_TABLE,
-			 "0x%p: bssid %s channel %d ssid %s (%s)"
-			 " capa 0x%04x rates %s rssi %d link %d noise %d", ptr,
-			 mac2str(ptr->bssid), ptr->channel, ptr->ssid,
-			 hex2str(ptr->ssid, ptr->ssid_len), ptr->capa,
-			 hex2str(ptr->rates, ptr->rates_len), ptr->rssi,
-			 ptr->link_qual, ptr->noise_level);
+		at76_dbg(DBG_BSS_TABLE, "0x%p: bssid %s channel %d ssid %.*s "
+			 "(%s) capa 0x%04x rates %s rssi %d link %d noise %d",
+			 ptr, mac2str(ptr->bssid), ptr->channel, ptr->ssid_len,
+			 ptr->ssid, hex2str(ptr->ssid, ptr->ssid_len),
+			 ptr->capa, hex2str(ptr->rates, ptr->rates_len),
+			 ptr->rssi, ptr->link_qual, ptr->noise_level);
 	}
 	spin_unlock_irqrestore(&priv->bss_list_spinlock, flags);
 }
@@ -2411,8 +2406,6 @@ static int at76_iw_handler_get_essid(struct net_device *netdev,
 		data->flags = 1;
 		data->length = priv->essid_size;
 		memcpy(extra, priv->essid, data->length);
-		extra[data->length] = '\0';
-		data->length += 1;
 	} else {
 		/* the ANY ssid was specified */
 		if (priv->mac_state == MAC_CONNECTED && priv->curr_bss) {
@@ -2420,8 +2413,6 @@ static int at76_iw_handler_get_essid(struct net_device *netdev,
 			data->flags = 1;
 			data->length = priv->curr_bss->ssid_len;
 			memcpy(extra, priv->curr_bss->ssid, data->length);
-			extra[priv->curr_bss->ssid_len] = '\0';
-			data->length += 1;
 		} else {
 			/* report ANY back */
 			data->flags = 0;
@@ -2429,7 +2420,8 @@ static int at76_iw_handler_get_essid(struct net_device *netdev,
 		}
 	}
 
-	at76_dbg(DBG_IOCTL, "%s: SIOCGIWESSID - %s", netdev->name, extra);
+	at76_dbg(DBG_IOCTL, "%s: SIOCGIWESSID - %.*s", netdev->name,
+		 data->length, extra);
 
 	return 0;
 }
@@ -3843,16 +3835,10 @@ static int at76_startup_device(struct at76_priv *priv)
 {
 	struct at76_card_config *ccfg = &priv->card_config;
 	int ret;
-	char ossid[IW_ESSID_MAX_SIZE + 1];
-
-	/* make priv->essid printable */
-	BUG_ON(priv->essid_size > IW_ESSID_MAX_SIZE);
-	memcpy(ossid, priv->essid, priv->essid_size);
-	ossid[priv->essid_size] = '\0';
 
 	at76_dbg(DBG_PARAMS,
-		 "%s param: ssid %s (%s) mode %s ch %d wep %s key %d "
-		 "keylen %d", priv->netdev->name, ossid,
+		 "%s param: ssid %.*s (%s) mode %s ch %d wep %s key %d "
+		 "keylen %d", priv->netdev->name, priv->essid_size, priv->essid,
 		 hex2str(priv->essid, IW_ESSID_MAX_SIZE),
 		 priv->iw_mode == IW_MODE_ADHOC ? "adhoc" : "infra",
 		 priv->channel, priv->wep_enabled ? "enabled" : "disabled",
@@ -4364,11 +4350,8 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 
 			match->ssid_len = len;
 			memcpy(match->ssid, ie->data, len);
-			match->ssid[len] = '\0';	/* terminate the
-							   string for
-							   printing */
-			at76_dbg(DBG_RX_BEACON, "%s: SSID - %s",
-				 priv->netdev->name, match->ssid);
+			at76_dbg(DBG_RX_BEACON, "%s: SSID - %.*s",
+				 priv->netdev->name, len, match->ssid);
 			have_ssid = 1;
 			break;
 
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index 413d12e..2737e85 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -398,8 +398,7 @@ struct bss_info {
 	struct list_head list;
 
 	u8 bssid[ETH_ALEN];	/* bssid */
-	u8 ssid[IW_ESSID_MAX_SIZE + 1];	/* ssid, +1 for trailing \0
-					   to make it printable */
+	u8 ssid[IW_ESSID_MAX_SIZE];	/* essid */
 	u8 ssid_len;		/* length of ssid above */
 	u8 channel;
 	u16 capa;		/* BSS capabilities */

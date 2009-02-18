Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:47727 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbZBRUlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 15:41:03 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 1/2] at76c50x-usb: update to latest mac80211 hw scan api
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 18 Feb 2009 22:40:57 +0200
Message-ID: <20090218204057.19847.51916.stgit@tikku> (sfid-20090218_214112_755918_A5DA4A01)
In-Reply-To: <20090218203830.19847.88862.stgit@tikku>
References: <20090218203830.19847.88862.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jason Andryuk <jandryuk@gmail.com>

With the latest mac80211 stack, the driver needs to be updated for
cfg80211 scanning.  I based the changes off of modifications for
at76_usb found here:

http://johannes.sipsolutions.net/patches/old/all/2008-09-19-13:35/020-cfg80211-scan.patch

The trick was that max_signal also needs to be set to avoid a divide
by zero Oops.  I just guessed and used the value 100 for now.

kvalo: handpicked the change from two different patches

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76c50x-usb.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index e8868ae..df3efc5 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1861,7 +1861,7 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 		goto exit;
 	}
 
-	ieee80211_scan_completed(priv->hw);
+	ieee80211_scan_completed(priv->hw, false);
 
 	if (is_valid_ether_addr(priv->bssid))
 		at76_join(priv);
@@ -1872,14 +1872,15 @@ exit:
 	mutex_unlock(&priv->mtx);
 }
 
-static int at76_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
+static int at76_hw_scan(struct ieee80211_hw *hw,
+			struct cfg80211_scan_request *req)
 {
 	struct at76_priv *priv = hw->priv;
 	struct at76_req_scan scan;
-	int ret;
+	u8 *ssid = NULL;
+	int ret, len = 0;
 
 	at76_dbg(DBG_MAC80211, "%s():", __func__);
-	at76_dbg_dump(DBG_MAC80211, ssid, len, "ssid %zd bytes:", len);
 
 	mutex_lock(&priv->mtx);
 
@@ -1887,11 +1888,20 @@ static int at76_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 
 	memset(&scan, 0, sizeof(struct at76_req_scan));
 	memset(scan.bssid, 0xFF, ETH_ALEN);
-	scan.scan_type = SCAN_TYPE_ACTIVE;
-	if (priv->essid_size > 0) {
+
+	if (req->n_ssids) {
+		scan.scan_type = SCAN_TYPE_ACTIVE;
+		ssid = req->ssids[0].ssid;
+		len = req->ssids[0].ssid_len;
+	} else {
+		scan.scan_type = SCAN_TYPE_PASSIVE;
+	}
+
+	if (len) {
 		memcpy(scan.essid, ssid, len);
 		scan.essid_size = len;
 	}
+
 	scan.min_channel_time = cpu_to_le16(priv->scan_min_time);
 	scan.max_channel_time = cpu_to_le16(priv->scan_max_time);
 	scan.probe_delay = cpu_to_le16(priv->scan_min_time * 1000);
@@ -2217,10 +2227,12 @@ static int at76_init_new_device(struct at76_priv *priv,
 	priv->scan_mode = SCAN_TYPE_ACTIVE;
 
 	/* mac80211 initialisation */
+	priv->hw->wiphy->max_scan_ssids = 1;
 	priv->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &at76_supported_band;
 	priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 			  IEEE80211_HW_SIGNAL_UNSPEC;
+	priv->hw->max_signal = 100;
 
 	SET_IEEE80211_DEV(priv->hw, &interface->dev);
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);


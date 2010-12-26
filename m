Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:47133 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab0LZLY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 06:24:58 -0500
Subject: [RFC PATCH 5/6] zd1211rw: implement beacon fetching and handling
	ieee80211_get_buffered_bc()
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, zd1211-devs@lists.sourceforge.net,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Sun, 26 Dec 2010 13:24:52 +0200
Message-ID: <20101226112452.31775.12810.stgit@fate.lan>
In-Reply-To: <20101226112404.31775.77854.stgit@fate.lan>
References: <20101226112404.31775.77854.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   38 +++++++++++++++++++++++++++++---
 1 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 9f755fc..2489c97 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -951,15 +951,46 @@ static int zd_op_config(struct ieee80211_hw *hw, u32 changed)
 	return zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
 }
 
+static void zd_beacon_done(struct zd_mac *mac)
+{
+	struct sk_buff *skb, *beacon;
+
+	if (mac->vif || mac->vif->type == NL80211_IFTYPE_UNSPECIFIED)
+		return;
+
+	/*
+	 * Send out buffered broad- and multicast frames.
+	 */
+	if (mac->vif->type == NL80211_IFTYPE_AP) {
+		dev_dbg_f_limit(zd_mac_dev(mac), "buffered_bc tx\n");
+		skb = ieee80211_get_buffered_bc(mac->hw, mac->vif);
+		while (skb) {
+			zd_op_tx(mac->hw, skb);
+			skb = ieee80211_get_buffered_bc(mac->hw, mac->vif);
+		}
+	}
+
+	/*
+	 * Fetch next beacon so that tim_count is updated.
+	 */
+	beacon = ieee80211_beacon_get(mac->hw, mac->vif);
+	if (!beacon)
+		return;
+
+	zd_mac_config_beacon(mac->hw, beacon);
+	kfree_skb(beacon);
+}
+
 static void zd_process_intr(struct work_struct *work)
 {
 	u16 int_status;
 	struct zd_mac *mac = container_of(work, struct zd_mac, process_intr);
 
 	int_status = le16_to_cpu(*(__le16 *)(mac->intr_buffer+4));
-	if (int_status & INT_CFG_NEXT_BCN)
+	if (int_status & INT_CFG_NEXT_BCN) {
 		dev_dbg_f_limit(zd_mac_dev(mac), "INT_CFG_NEXT_BCN\n");
-	else
+		zd_beacon_done(mac);
+	} else
 		dev_dbg_f(zd_mac_dev(mac), "Unsupported interrupt\n");
 
 	zd_chip_enable_hwint(&mac->chip);
@@ -1186,7 +1217,8 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &mac->band;
 
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_SIGNAL_UNSPEC;
+		    IEEE80211_HW_SIGNAL_UNSPEC |
+		    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_MESH_POINT) |


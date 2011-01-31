Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:43101 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755820Ab1AaSsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:48:40 -0500
Subject: [PATCH 10/22] zd1211rw: implement beacon fetching and handling
	ieee80211_get_buffered_bc()
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:48:35 +0200
Message-ID: <20110131184835.10044.72951.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   39 +++++++++++++++++++++++++++++---
 1 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 1bd275b..49ab3c3 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -938,6 +938,34 @@ static int zd_op_config(struct ieee80211_hw *hw, u32 changed)
 	return zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
 }
 
+static void zd_beacon_done(struct zd_mac *mac)
+{
+	struct sk_buff *skb, *beacon;
+
+	if (!mac->vif || mac->vif->type != NL80211_IFTYPE_AP)
+		return;
+
+	/*
+	 * Send out buffered broad- and multicast frames.
+	 */
+	while (!ieee80211_queue_stopped(mac->hw, 0)) {
+		skb = ieee80211_get_buffered_bc(mac->hw, mac->vif);
+		if (!skb)
+			break;
+		zd_op_tx(mac->hw, skb);
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
@@ -948,10 +976,12 @@ static void zd_process_intr(struct work_struct *work)
 	int_status = le16_to_cpu(*(__le16 *)(mac->intr_buffer + 4));
 	spin_unlock_irqrestore(&mac->lock, flags);
 
-	if (int_status & INT_CFG_NEXT_BCN)
-		dev_dbg_f_limit(zd_mac_dev(mac), "INT_CFG_NEXT_BCN\n");
-	else
+	if (int_status & INT_CFG_NEXT_BCN) {
+		/*dev_dbg_f_limit(zd_mac_dev(mac), "INT_CFG_NEXT_BCN\n");*/
+		zd_beacon_done(mac);
+	} else {
 		dev_dbg_f(zd_mac_dev(mac), "Unsupported interrupt\n");
+	}
 
 	zd_chip_enable_hwint(&mac->chip);
 }
@@ -1135,7 +1165,8 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &mac->band;
 
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_SIGNAL_UNSPEC;
+		    IEEE80211_HW_SIGNAL_UNSPEC |
+		    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_MESH_POINT) |


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61101 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab0GKKcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:32:05 -0400
Received: by eya25 with SMTP id 25so426234eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:32:04 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/17] rt2x00: Allow beacon update without scheduling a work
Date: Sun, 11 Jul 2010 12:27:26 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111226.13314.IvDoorn@gmail.com> <201007111226.49015.IvDoorn@gmail.com>
In-Reply-To: <201007111226.49015.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111227.27070.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Since all rt2x00 PCI drivers use threaded interrupts now we don't need
to schedule a work just to update the beacon. The only place where the
beacon still gets updated in atomic context is from the set_tim
callback. Hence, move the work scheduling there.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   13 +++++--------
 drivers/net/wireless/rt2x00/rt2x00mac.c |   26 +++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index d3ebb41..e255725 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -181,7 +181,7 @@ static void rt2x00lib_intf_scheduled(struct work_struct *work)
 static void rt2x00lib_beacondone_iter(void *data, u8 *mac,
 				      struct ieee80211_vif *vif)
 {
-	struct rt2x00_intf *intf = vif_to_intf(vif);
+	struct rt2x00_dev *rt2x00dev = data;
 
 	if (vif->type != NL80211_IFTYPE_AP &&
 	    vif->type != NL80211_IFTYPE_ADHOC &&
@@ -189,9 +189,7 @@ static void rt2x00lib_beacondone_iter(void *data, u8 *mac,
 	    vif->type != NL80211_IFTYPE_WDS)
 		return;
 
-	spin_lock(&intf->lock);
-	intf->delayed_flags |= DELAYED_UPDATE_BEACON;
-	spin_unlock(&intf->lock);
+	rt2x00queue_update_beacon(rt2x00dev, vif, true);
 }
 
 void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
@@ -199,11 +197,10 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return;
 
-	ieee80211_iterate_active_interfaces_atomic(rt2x00dev->hw,
-						   rt2x00lib_beacondone_iter,
-						   rt2x00dev);
+	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
+					   rt2x00lib_beacondone_iter,
+					   rt2x00dev);
 
-	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->intf_work);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_beacondone);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index bbce496..4d8d232 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -433,12 +433,36 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_configure_filter);
 
+static void rt2x00mac_set_tim_iter(void *data, u8 *mac,
+				   struct ieee80211_vif *vif)
+{
+	struct rt2x00_intf *intf = vif_to_intf(vif);
+
+	if (vif->type != NL80211_IFTYPE_AP &&
+	    vif->type != NL80211_IFTYPE_ADHOC &&
+	    vif->type != NL80211_IFTYPE_MESH_POINT &&
+	    vif->type != NL80211_IFTYPE_WDS)
+		return;
+
+	spin_lock(&intf->lock);
+	intf->delayed_flags |= DELAYED_UPDATE_BEACON;
+	spin_unlock(&intf->lock);
+}
+
 int rt2x00mac_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		      bool set)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
-	rt2x00lib_beacondone(rt2x00dev);
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		return 0;
+
+	ieee80211_iterate_active_interfaces_atomic(rt2x00dev->hw,
+						   rt2x00mac_set_tim_iter,
+						   rt2x00dev);
+
+	/* queue work to upodate the beacon template */
+	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->intf_work);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_set_tim);
-- 
1.7.1.1


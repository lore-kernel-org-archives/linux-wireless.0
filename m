Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57913 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab0GKKcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:32:05 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so640186ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:32:04 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/17] rt2x00: Implement broad- and multicast buffering
Date: Sun, 11 Jul 2010 12:27:58 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111226.49015.IvDoorn@gmail.com> <201007111227.27070.IvDoorn@gmail.com>
In-Reply-To: <201007111227.27070.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111227.58927.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Although mac80211 buffers broad- and mutlicast frames for us in AP mode
we still have to send them out after a DTIM beacon. Implement this
behavior by sending out the buffered frames when the beacondone
interrupt is processed.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   32 +++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index e255725..ae0adff 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -178,6 +178,28 @@ static void rt2x00lib_intf_scheduled(struct work_struct *work)
 /*
  * Interrupt context handlers.
  */
+static void rt2x00lib_bc_buffer_iter(void *data, u8 *mac,
+				     struct ieee80211_vif *vif)
+{
+	struct rt2x00_dev *rt2x00dev = data;
+	struct sk_buff *skb;
+
+	/*
+	 * Only AP mode interfaces do broad- and multicast buffering
+	 */
+	if (vif->type != NL80211_IFTYPE_AP)
+		return;
+
+	/*
+	 * Send out buffered broad- and multicast frames
+	 */
+	skb = ieee80211_get_buffered_bc(rt2x00dev->hw, vif);
+	while (skb) {
+		rt2x00mac_tx(rt2x00dev->hw, skb);
+		skb = ieee80211_get_buffered_bc(rt2x00dev->hw, vif);
+	}
+}
+
 static void rt2x00lib_beacondone_iter(void *data, u8 *mac,
 				      struct ieee80211_vif *vif)
 {
@@ -197,9 +219,15 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return;
 
+	/* send buffered bc/mc frames out for every bssid */
 	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
-					   rt2x00lib_beacondone_iter,
-					   rt2x00dev);
+					    rt2x00lib_bc_buffer_iter,
+					    rt2x00dev);
+
+	/* fetch next beacon */
+	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
+					    rt2x00lib_beacondone_iter,
+					    rt2x00dev);
 
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_beacondone);
-- 
1.7.1.1


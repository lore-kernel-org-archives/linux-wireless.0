Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44640 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab3I2Tji (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Sep 2013 15:39:38 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.12 2/2] mac80211: update sta->last_rx on acked tx frames
Date: Sun, 29 Sep 2013 21:39:34 +0200
Message-Id: <1380483574-88667-2-git-send-email-nbd@openwrt.org> (sfid-20130929_213945_302959_D8140CE0)
In-Reply-To: <1380483574-88667-1-git-send-email-nbd@openwrt.org>
References: <1380483574-88667-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When clients are idle for too long, hostapd sends nullfunc frames for
probing. When those are acked by the client, the idle time needs to be
updated.

To make this work (and to avoid unnecessary probing), update sta->last_rx
whenever an ACK was received for a tx packet. Only do this if the flag
IEEE80211_HW_REPORTS_TX_ACK_STATUS is set.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/status.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 368837f..78dc2e9 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -180,6 +180,9 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		sta->last_rx = jiffies;
+
 	if (ieee80211_is_data_qos(mgmt->frame_control)) {
 		struct ieee80211_hdr *hdr = (void *) skb->data;
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
-- 
1.8.0.2


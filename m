Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:33124 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab0ALDI2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 22:08:28 -0500
Message-ID: <4B4BE7AA.4060808@openwrt.org>
Date: Tue, 12 Jan 2010 04:08:26 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix WMM AC default for non-QoS data frames
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The WMM AC selection added to the monitor mode selection function 
accidentally assigns non-QoS data frames to the same AC as mgmt frames 
(VO). This is not serious, but should be fixed anyway. This patch 
assigns them to the BE AC instead.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -696,10 +696,14 @@ static u16 ieee80211_monitor_select_queu
 
 	hdr = (void *)((u8 *)skb->data + le16_to_cpu(rtap->it_len));
 
-	if (!ieee80211_is_data_qos(hdr->frame_control)) {
+	if (!ieee80211_is_data(hdr->frame_control)) {
 		skb->priority = 7;
 		return ieee802_1d_to_ac[skb->priority];
 	}
+	if (!ieee80211_is_data_qos(hdr->frame_control)) {
+		skb->priority = 0;
+		return ieee802_1d_to_ac[skb->priority];
+	}
 
 	p = ieee80211_get_qos_ctl(hdr);
 	skb->priority = *p & IEEE80211_QOS_CTL_TAG1D_MASK;

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:53760 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab0AKFrP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 00:47:15 -0500
Message-ID: <4B4ABB54.7030600@openwrt.org>
Date: Mon, 11 Jan 2010 06:47:00 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: mac80211: fix queue selection for data frames on monitor interfaces
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When ieee80211_monitor_select_queue encounters data frames, it selects
the WMM AC based on skb->priority and assumes that skb->priority
contains a valid 802.1d tag. However this assumption is incorrect, since
ieee80211_select_queue has not been called at this point.
If skb->priority > 7, an array overrun occurs, which could lead to
invalid values, resulting in crashes in the tx path.
Fix this by setting skb->priority based on the 802.11 header for QoS
frames and using the default AC for all non-QoS frames.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -685,6 +685,7 @@ static u16 ieee80211_monitor_select_queu
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_radiotap_header *rtap = (void *)skb->data;
+	u8 *p;

 	if (local->hw.queues < 4)
 		return 0;
@@ -695,11 +696,14 @@ static u16 ieee80211_monitor_select_queu

 	hdr = (void *)((u8 *)skb->data + le16_to_cpu(rtap->it_len));

-	if (!ieee80211_is_data(hdr->frame_control)) {
+	if (!ieee80211_is_data_qos(hdr->frame_control)) {
 		skb->priority = 7;
 		return ieee802_1d_to_ac[skb->priority];
 	}

+	p = ieee80211_get_qos_ctl(hdr);
+	skb->priority = *p & IEEE80211_QOS_CTL_TAG1D_MASK;
+
 	return ieee80211_downgrade_queue(local, skb);
 }


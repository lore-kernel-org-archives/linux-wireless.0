Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:55878 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab0BNXhm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 18:37:42 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH 1/2] mac80211: Drop protected data frames that have not been decrypted
Date: Mon, 15 Feb 2010 00:37:32 +0100
Message-Id: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix for the following issue : a STA connected to a WPA2 AP was showing
frames from others STA in tcpdump on wlan0 (promiscuous mode). In fact,
those frames are not decrypted and appears as 802.3 junk. This patch
just drops any protected data frames that have not been decrypted.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/rx.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c9755f3..22ae6ee 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1397,6 +1397,14 @@ ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx, __le16 fc)
 		     ieee80211_is_data(fc) &&
 		     (rx->key || rx->sdata->drop_unencrypted)))
 		return -EACCES;
+	/*
+	 * Drop encrypted frames that have not been decrypted. This
+	 * happens for frames that are sent by an AP to another STA
+	 */
+	if (ieee80211_has_protected(fc) &&
+	    !(status->flag & RX_FLAG_DECRYPTED)) {
+		return -EACCES;
+	}
 	if (rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP)) {
 		if (unlikely(ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
 			     rx->key))
-- 
1.5.6.5


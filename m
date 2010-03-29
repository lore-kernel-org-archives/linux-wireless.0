Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:44701 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754197Ab0C2FcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 01:32:22 -0400
Date: Sun, 28 Mar 2010 22:31:15 -0700
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix drop_unencrypted for MFP with hwaccel
Message-ID: <20100329053115.GB26019@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit bef5d1c70d132145c0fc75b3586a19841a9a82e4 split
ieee80211_drop_unencrypted() into separate functions that are used for
Data and Management frames. However, it did not handle the
RX_FLAG_DECRYPTED correctly for Management frames:
ieee80211_drop_unencrypted() can only return 0 for Management frames,
so there is no point in calling it here. Instead, just check the
status->flag directly.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/mac80211/rx.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-03-28 22:26:33.000000000 -0700
+++ wireless-testing/net/mac80211/rx.c	2010-03-28 22:26:42.000000000 -0700
@@ -1396,12 +1396,15 @@ static int
 ieee80211_drop_unencrypted_mgmt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 	__le16 fc = hdr->frame_control;
-	int res;
 
-	res = ieee80211_drop_unencrypted(rx, fc);
-	if (unlikely(res))
-		return res;
+	/*
+	 * Pass through unencrypted frames if the hardware has
+	 * decrypted them already.
+	 */
+	if (status->flag & RX_FLAG_DECRYPTED)
+		return 0;
 
 	if (rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP)) {
 		if (unlikely(!ieee80211_has_protected(fc) &&

-- 
Jouni Malinen                                            PGP id EFC895FA

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40809 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab2LENg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 08:36:26 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so2917020eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 05:36:25 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Skip radiotap space calculation if no monitor exists
Date: Wed,  5 Dec 2012 14:36:12 +0100
Message-Id: <1354714572-26995-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20121205_143632_351486_F0F38528)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The radiotap header length "needed_headroom" is only required if we're
sending the skb to a monitor interface. Hence, move the calculation a
bit later so the calculation can be skipped if no monitor interface is
present.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/rx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 825f33c..a78afa1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -338,9 +338,6 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	 * the SKB because it has a bad FCS/PLCP checksum.
 	 */
 
-	/* room for the radiotap header based on driver features */
-	needed_headroom = ieee80211_rx_radiotap_space(local, status);
-
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
 		present_fcs_len = FCS_LEN;
 
@@ -359,6 +356,9 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 		return remove_monitor_info(local, origskb);
 	}
 
+	/* room for the radiotap header based on driver features */
+	needed_headroom = ieee80211_rx_radiotap_space(local, status);
+
 	if (should_drop_frame(origskb, present_fcs_len)) {
 		/* only need to expand headroom if necessary */
 		skb = origskb;
-- 
1.7.7


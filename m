Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:57463
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751705AbaKUW3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 17:29:20 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, j@w1.fi
Subject: [PATCH] mac80211: add more missing checks for VHT tx rates
Date: Fri, 21 Nov 2014 23:29:14 +0100
Message-Id: <1416608954-84560-1-git-send-email-nbd@openwrt.org> (sfid-20141121_232923_741132_78E4F841)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes a crash on attempting to calculate the frame duration for a VHT
packet (which needs to be handled by hw/driver instead).

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rate.c | 3 ++-
 net/mac80211/tx.c   | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 08ab7d6..d53355b 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -446,7 +446,8 @@ static void rate_fixup_ratelist(struct ieee80211_vif *vif,
 	 *
 	 * XXX: Should this check all retry rates?
 	 */
-	if (!(rates[0].flags & IEEE80211_TX_RC_MCS)) {
+	if (!(rates[0].flags &
+	      (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_VHT_MCS))) {
 		u32 basic_rates = vif->bss_conf.basic_rates;
 		s8 baserate = basic_rates ? ffs(basic_rates) - 1 : 0;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 66ddbbe..058686a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -60,7 +60,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 	rcu_read_unlock();
 
 	/* assume HW handles this */
-	if (tx->rate.flags & IEEE80211_TX_RC_MCS)
+	if (tx->rate.flags & (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_VHT_MCS))
 		return 0;
 
 	/* uh huh? */
-- 
2.1.2


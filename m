Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:45966 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab1E2UFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 16:05:36 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh07-2.mail.saunalahti.fi (Postfix) with SMTP id 2ABF218CE94
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:05:35 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id 1878E158A65
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:05:33 +0300 (EEST)
Subject: [RFC PATCH 12/27] mac80211: rename ieee80211_rx_flags to
	mac80211_i_rx_flags
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 29 May 2011 23:05:33 +0300
Message-ID: <20110529200533.16479.51520.stgit@localhost6.localdomain6> (sfid-20110529_220546_023886_FD68A379)
In-Reply-To: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
References: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add _i_ because, strangely enough,  mac80211_i.h already has another
definition of mac80211_rx_flags.

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/mac80211_i.h |    6 +++---
 net/mac80211/rx.c         |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index 4ef1594..5f7b684 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -183,15 +183,15 @@ enum mac80211_packet_rx_flags {
 };
 
 /**
- * enum ieee80211_rx_flags - RX data flags
+ * enum mac80211_i_rx_flags - RX data flags
  *
  * @MAC80211_RX_CMNTR: received on cooked monitor already
  *
  * These flags are used across handling multiple interfaces
  * for a single frame.
  */
-enum ieee80211_rx_flags {
-	IEEE80211_RX_CMNTR		= BIT(0),
+enum mac80211_i_rx_flags {
+	MAC80211_RX_CMNTR		= BIT(0),
 };
 
 struct ieee80211_rx_data {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 12086b4..8245813 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2394,9 +2394,9 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 	 * If cooked monitor has been processed already, then
 	 * don't do it again. If not, set the flag.
 	 */
-	if (rx->flags & IEEE80211_RX_CMNTR)
+	if (rx->flags & MAC80211_RX_CMNTR)
 		goto out_free_skb;
-	rx->flags |= IEEE80211_RX_CMNTR;
+	rx->flags |= MAC80211_RX_CMNTR;
 
 	if (skb_headroom(skb) < sizeof(*rthdr) &&
 	    pskb_expand_head(skb, sizeof(*rthdr), 0, GFP_ATOMIC))


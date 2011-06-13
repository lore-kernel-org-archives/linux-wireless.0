Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:39438 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab1FMWg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:36:29 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id D48348C0CF
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:36:27 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh04.mail.saunalahti.fi (Postfix) with ESMTP id C094141BE2
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:36:26 +0300 (EEST)
Subject: [PATCH v2 12/27] mac80211: rename ieee80211_rx_flags to
	mac80211_i_rx_flags
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:36:25 +0300
Message-ID: <20110613223625.10517.59092.stgit@localhost6.localdomain6> (sfid-20110614_005723_408269_0F441D7C)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
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
index 821d432..c33df24 100644
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


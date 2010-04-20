Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coco.cs.washington.edu ([128.208.3.82]:34934 "EHLO
	coco.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab0DTHIA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 03:08:00 -0400
From: Daniel Halperin <dhalperi@cs.washington.edu>
Content-Type: text/plain; charset=us-ascii
Subject: mac80211 and asymmetric 802.11n TX/RX
Date: Tue, 20 Apr 2010 00:07:58 -0700
Message-Id: <48BAD814-F653-4CE3-85E0-A9D82EC31D53@cs.washington.edu>
To: linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1078)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Does anyone know if the 11n standard says that the set of TX rates has to be a subset of the set of RX rates? This seems to be enforced now: when I set up one node to be 2x1, i.e. transmit 2 streams but only able to receive 1, then the mac80211 code only lets it transmit 1 streams (even with a 2-stream-capable receiver at the other end).

A quick diff to net/mac80211/ht.c that fixes this for equal modulation streams is attached; the problem is still there for unequal modulation directly below. Before I send it up I wanted to make sure I'm not crazy.

A second question: my understanding is that if I am a 2x2 node and I associate to a 3x3 AP, the same code will mask out the fact that the AP can receive 3 streams since I can't transmit 3 streams. Is there a way to access this info from the driver if I want it?

Thanks!
Dan

---

From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Tue, 20 Apr 2010 00:00:29 -0700
Subject: [PATCH] mac80211: support devices with more transmit than receive MCS supported

There is an implicit assumption built into mac80211 that an 11n NIC has a
receive MCS set that contains its TX MCS set, even when
IEEE80211_HT_MCS_TX_RX_DIFF is set. Then, a 2x1 node that can transmit 2
streams but only receive 1 will be unable to transmit 2 streams. Fix this for
equal modulation MCS sets by properly handling the IEEE80211_HT_MCS_TX_RX_DIFF
case.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
---
 net/mac80211/ht.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 2ab106a..249805b 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -24,6 +24,7 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 {
 	u8 ampdu_info, tx_mcs_set_cap;
 	int i, max_tx_streams;
+	bool use_rx_mask;
 
 	BUG_ON(!ht_cap);
 
@@ -71,12 +72,15 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 		return;
 
 	/* Counting from 0, therefore +1 */
-	if (tx_mcs_set_cap & IEEE80211_HT_MCS_TX_RX_DIFF)
+	if (tx_mcs_set_cap & IEEE80211_HT_MCS_TX_RX_DIFF) {
 		max_tx_streams =
 			((tx_mcs_set_cap & IEEE80211_HT_MCS_TX_MAX_STREAMS_MASK)
 				>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT) + 1;
-	else
+		use_rx_mask = 0;
+	} else {
 		max_tx_streams = IEEE80211_HT_MCS_TX_MAX_STREAMS;
+		use_rx_mask = 1;
+	}
 
 	/*
 	 * 802.11n D5.0 20.3.5 / 20.6 says:
@@ -87,7 +91,8 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 	 */
 	for (i = 0; i < max_tx_streams; i++)
 		ht_cap->mcs.rx_mask[i] =
-			sband->ht_cap.mcs.rx_mask[i] & ht_cap_ie->mcs.rx_mask[i];
+			(use_rx_mask ? sband->ht_cap.mcs.rx_mask[i] : 0xFF) &
+			ht_cap_ie->mcs.rx_mask[i];
 
 	if (tx_mcs_set_cap & IEEE80211_HT_MCS_TX_UNEQUAL_MODULATION)
 		for (i = IEEE80211_HT_MCS_UNEQUAL_MODULATION_START_BYTE;
-- 
1.5.4.3



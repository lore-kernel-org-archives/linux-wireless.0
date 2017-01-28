Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19548 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbdA1AB6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 19:01:58 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/3] mac80211: fix mesh moving average stuck
Date: Fri, 27 Jan 2017 16:01:46 -0800
Message-ID: <1485561708-31559-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20170128_010212_509842_F5E190CA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As moving average is not considering fractional part after
certain ratio, it will stuck at the same state. For example
with current values, moving average stuck at 96 and it will
not move forward. Fortunately current threshold is matching
against 95%. If thresold is increased more than 96, mesh path
never be deactivated under worst case. Fix failure average
movement by bumping up average at stuck state.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/mesh_hwmp.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index b747c9645e43..f0aa1da15bd0 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -300,6 +300,7 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 {
 	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	u32 fail_avg = sta->mesh->fail_avg;
 	int failed;
 
 	if (!ieee80211_is_data(hdr->frame_control))
@@ -308,8 +309,17 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 	failed = !(txinfo->flags & IEEE80211_TX_STAT_ACK);
 
 	/* moving average, scaled to 100 */
-	sta->mesh->fail_avg =
-		((80 * sta->mesh->fail_avg + 5) / 100 + 20 * failed);
+	fail_avg = ((80 * fail_avg + 5) / 100 + 20 * failed);
+
+	/* bump up fail average since fractional part of average is ignored.
+	 * Otherwise fail average always stuck at the same level and
+	 * never moves forward.
+	 */
+	if (fail_avg && fail_avg == sta->mesh->fail_avg)
+		fail_avg++;
+
+	sta->mesh->fail_avg = fail_avg;
+
 	if (sta->mesh->fail_avg > 95)
 		mesh_plink_broken(sta);
 }
-- 
1.9.1

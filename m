Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:34400 "HELO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750742Ab1LOFOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 00:14:43 -0500
Date: Thu, 15 Dec 2011 10:43:49 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: Fixing sparse warning at sta_info.c
Message-ID: <20111215051343.GA4570@hertz.marvell.com> (sfid-20111215_061447_560335_F13F5F89)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit 42624d4913a00219a8fdbb4bafd634d1d843be85
created following sparse warning
>net/mac80211/sta_info.c:965:24: warning: incorrect type in assignment (different address spaces)
>net/mac80211/sta_info.c:965:24:    expected struct tid_ampdu_tx *tid_tx
>net/mac80211/sta_info.c:965:24:    got struct tid_ampdu_tx [noderef] <asn:4>*<noident>

Making use of rcu_dereference to fix the problem.

Cc: Nishant Sarmukadam <nishants@marvell.com>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 net/mac80211/sta_info.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c6ca9bd..c2d4810 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -960,9 +960,9 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
 	 * http://thread.gmane.org/gmane.linux.kernel.wireless.general/81936
 	 */
 	for (i = 0; i < STA_TID_NUM; i++) {
-		if (!sta->ampdu_mlme.tid_tx[i])
+		tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[i]);
+		if (!tid_tx)
 			continue;
-		tid_tx = sta->ampdu_mlme.tid_tx[i];
 		if (skb_queue_len(&tid_tx->pending)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 			wiphy_debug(local->hw.wiphy, "TX A-MPDU  purging %d "
-- 
1.5.4.1


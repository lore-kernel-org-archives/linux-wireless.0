Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:13205 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab2GDQLp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 12:11:45 -0400
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv3 2/2] mac80211: tx: do not drop non-robust mgmt to non-MFP stas.
Date: Wed,  4 Jul 2012 18:10:08 +0200
Message-Id: <1341418208-28663-2-git-send-email-cavallar@lri.fr> (sfid-20120704_181148_040650_2514DBD1)
In-Reply-To: <1341418208-28663-1-git-send-email-cavallar@lri.fr>
References: <1341408545.12432.10.camel@jlt3.sipsolutions.net>
 <1341418208-28663-1-git-send-email-cavallar@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When drop_unencrypted is enabled and MFP is disabled,
non-robust management frames for not-yet associated STA are dropped.
This isn't visible as many management frames sent from the kernel
have TX_INTFL_DONT_ENCRYPT set and management frames injected
from a monitor vif have TX_CTL_INJECTED so aren't dropped.
But management frames sent from userspace via NL80211_CMD_FRAME
do not have this flag set, so are dropped.

This patch make it always accept non-robust management frames.

Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>

---
changes :
v2->v3 : now depends on johannes's cleanup, even clearer code.
v1->v2 : thinier, clearer, more correct code.  migrated from RFC to PATCH.
---
 net/mac80211/tx.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index cdd4ac6..691aa6c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -552,6 +552,9 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 		 !(ieee80211_is_action(hdr->frame_control) &&
 		  tx->sta && test_sta_flag(tx->sta, WLAN_STA_MFP)))
 		tx->key = NULL;
+	else if (ieee80211_is_mgmt(hdr->frame_control) &&
+		 !ieee80211_is_robust_mgmt_frame(hdr))
+		tx->key = NULL;
 	else {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TX_DROP;
-- 
1.7.10.4


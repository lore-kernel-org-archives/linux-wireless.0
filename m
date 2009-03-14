Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36761 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbZCNOoc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 10:44:32 -0400
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH] mac80211: don't drop null frames during software scan
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Sat, 14 Mar 2009 16:44:06 +0200
Message-ID: <20090314144405.670.16447.stgit@tikku> (sfid-20090314_154443_281934_161662DB)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_tx_h_check_assoc() was dropping everything else than probe
requests during software scan. So the null frame with the power save
bit was dropped and AP never received it. This meant that AP never
buffered any frames for the station during software scan.

Fix this by allowing to transmit both probe request and null frames
during software scan. Tested with stlc45xx.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/tx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c3f0e95..f2494fc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -193,7 +193,8 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 		return TX_CONTINUE;
 
 	if (unlikely(tx->local->sw_scanning) &&
-	    !ieee80211_is_probe_req(hdr->frame_control))
+	    !ieee80211_is_probe_req(hdr->frame_control) &&
+	    !ieee80211_is_nullfunc(hdr->frame_control))
 		return TX_DROP;
 
 	if (tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT)


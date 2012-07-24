Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50863 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab2GXDyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 23:54:36 -0400
Received: by pbbrp8 with SMTP id rp8so11971451pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 20:54:35 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v4] mac80211: add extra checking for RC init upon receiving mesh beacon
Date: Tue, 24 Jul 2012 11:52:35 +0800
Message-Id: <1343101955-16710-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120724_055511_707021_1B20E3D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rate control statistic is flushed whenever the mesh beacon
is received. This may not optimizes the performance of rate
control algorithm. This patch ensures that we return early
from mesh_peer_init if the plink_state is ESTAB. Thus, avoid
calling the rate_control_rate_init again for established mesh
STA.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
v2: simplify the logic checking (Thomas Pedersen)
v3: updating the sta last rx activity (Thomas Pedersen)
v4: avoid duplicate assignment (Thomas Pedersen)

 net/mac80211/mesh_plink.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4256859..dfeb243 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -361,6 +361,11 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 
 	spin_lock_bh(&sta->lock);
 	sta->last_rx = jiffies;
+	if (sta->plink_state == NL80211_PLINK_ESTAB) {
+		spin_unlock_bh(&sta->lock);
+		return sta;
+	}
+
 	sta->sta.supp_rates[band] = rates;
 	if (elems->ht_cap_elem &&
 	    sdata->local->_oper_channel_type != NL80211_CHAN_NO_HT)
-- 
1.7.0.4


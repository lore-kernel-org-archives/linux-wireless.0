Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41444 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab2GXBSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 21:18:00 -0400
Received: by yenl2 with SMTP id l2so6152204yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 18:17:59 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v3] mac80211: add extra checking for RC init upon receiving mesh beacon
Date: Tue, 24 Jul 2012 09:15:54 +0800
Message-Id: <1343092554-17734-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120724_031805_304161_AD9A3265)
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

 net/mac80211/mesh_plink.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4256859..4f5740e 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -360,6 +360,12 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 	}
 
 	spin_lock_bh(&sta->lock);
+	if (sta->plink_state == NL80211_PLINK_ESTAB) {
+		sta->last_rx = jiffies;
+		spin_unlock_bh(&sta->lock);
+		return sta;
+	}
+
 	sta->last_rx = jiffies;
 	sta->sta.supp_rates[band] = rates;
 	if (elems->ht_cap_elem &&
-- 
1.7.0.4


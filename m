Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48501 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab2GWEH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 00:07:59 -0400
Received: by gglu4 with SMTP id u4so5062613ggl.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jul 2012 21:07:59 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2] mac80211: add extra checking for RC init upon receiving mesh beacon
Date: Mon, 23 Jul 2012 12:06:09 +0800
Message-Id: <1343016370-31163-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120723_060803_455883_5F4150DE)
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

 net/mac80211/mesh_plink.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4256859..a73741c 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -359,6 +359,9 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 		insert = true;
 	}
 
+	if (sta->plink_state == NL80211_PLINK_ESTAB)
+		return sta;
+
 	spin_lock_bh(&sta->lock);
 	sta->last_rx = jiffies;
 	sta->sta.supp_rates[band] = rates;
-- 
1.7.0.4


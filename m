Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:36653 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbbFMOQs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2015 10:16:48 -0400
Received: by qcjl8 with SMTP id l8so16764291qcj.3
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2015 07:16:47 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Bob Copeland <me@bobcopeland.com>,
	stable@vger.kernel.org
Subject: [PATCH] mac80211: enable assoc check for mesh interfaces
Date: Sat, 13 Jun 2015 10:16:31 -0400
Message-Id: <1434204991-9579-1-git-send-email-me@bobcopeland.com> (sfid-20150613_161655_040676_550D28E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We already set a station to be associated when peering completes, both
in user space and in the kernel.  Thus we should always have an
associated sta before sending data frames to that station.

Failure to check assoc state can cause crashes in the lower-level driver
due to transmitting unicast data frames before driver sta structures
(e.g. ampdu state in ath9k) are initialized.  This occurred when
forwarding in the presence of fixed mesh paths: frames were transmitted
to stations with whom we hadn't yet completed peering.

Cc: stable@vger.kernel.org
Reported-by: Alexis Green <agreen@cococorp.com>
Tested-by: Jesse Jones <jjones@cococorp.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/tx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8410bb3..d580f86 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -311,9 +311,6 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 	if (tx->sdata->vif.type == NL80211_IFTYPE_WDS)
 		return TX_CONTINUE;
 
-	if (tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
-		return TX_CONTINUE;
-
 	if (tx->flags & IEEE80211_TX_PS_BUFFERED)
 		return TX_CONTINUE;
 
-- 
2.1.4


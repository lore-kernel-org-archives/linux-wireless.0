Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45941 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584AbcFGNKK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 09:10:10 -0400
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
	ath9k-devel@lists.ath9k.org,
	Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH 5/6] ath9k: Use defined constants consistently.
Date: Tue,  7 Jun 2016 15:10:00 +0200
Message-Id: <1465305001-26067-5-git-send-email-benjamin@sipsolutions.net> (sfid-20160607_151015_836558_B526B29A)
In-Reply-To: <1465305001-26067-1-git-send-email-benjamin@sipsolutions.net>
References: <1465305001-26067-1-git-send-email-benjamin@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin.berg@open-mesh.com>

Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f2ebc85..6a81298 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1785,9 +1785,10 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	if ((avp->chanctx == sc->cur_chan) &&
 	    (changed & BSS_CHANGED_ERP_SLOT)) {
 		if (bss_conf->use_short_slot)
-			slottime = 9;
+			slottime = ATH9K_SLOT_TIME_9;
 		else
-			slottime = 20;
+			slottime = ATH9K_SLOT_TIME_20;
+
 		if (vif->type == NL80211_IFTYPE_AP) {
 			/*
 			 * Defer update, so that connected stations can adjust
-- 
2.8.1


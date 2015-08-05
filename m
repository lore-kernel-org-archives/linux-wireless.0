Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhcavuit01.kulnet.kuleuven.be ([134.58.240.129]:58570 "EHLO
	cavuit01.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752162AbbHEOC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 10:02:59 -0400
From: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
Subject: [PATCH 5/5] mac80211: Make OCB mode set BSSID
Date: Wed,  5 Aug 2015 16:02:50 +0200
Message-Id: <1438783370-9442-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be> (sfid-20150805_160302_138181_B791C3D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Perform the BSS_CHANGED_BSSID action when joining an OCB network.
This is required to set the broadcast BSSID in some network drivers.

Signed-off-by: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
---
 net/mac80211/ocb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
index 358d5f9..573b81a 100644
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -179,7 +179,7 @@ int ieee80211_ocb_join(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
-	u32 changed = BSS_CHANGED_OCB;
+	u32 changed = BSS_CHANGED_OCB | BSS_CHANGED_BSSID;
 	int err;
 
 	if (ifocb->joined == true)
-- 
1.9.1


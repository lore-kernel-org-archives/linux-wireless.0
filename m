Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhcavuit01.kulnet.kuleuven.be ([134.58.240.129]:58314 "EHLO
	cavuit01.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753171AbbHEOCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 10:02:36 -0400
From: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
Subject: [PATCH 2/5] mac80211: Set txrc.bss to true for OCB interfaces
Date: Wed,  5 Aug 2015 16:02:28 +0200
Message-Id: <1438783348-1427-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be> (sfid-20150805_160241_166608_F7A83173)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To make mac80211 accept the multicast rate requested by the user the
rate control should be told that it is operating in BSS mode.
Without this, the default rate is selected in rate_control_send_low
(!pubsta and !txrc->bss)

Signed-off-by: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2079d48..84e0e8c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -686,7 +686,8 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 
 	txrc.bss = (tx->sdata->vif.type == NL80211_IFTYPE_AP ||
 		    tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
-		    tx->sdata->vif.type == NL80211_IFTYPE_ADHOC);
+		    tx->sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+		    tx->sdata->vif.type == NL80211_IFTYPE_OCB);
 
 	/* set up RTS protection if desired */
 	if (len > tx->local->hw.wiphy->rts_threshold) {
-- 
1.9.1


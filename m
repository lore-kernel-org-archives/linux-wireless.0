Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhcavuit02.kulnet.kuleuven.be ([134.58.240.130]:46980 "EHLO
	cavuit02.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752123AbbHENi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 09:38:56 -0400
From: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
Subject: [PATCH] mac80211: Fix oops in OCB mode when receiving data when not joined
Date: Wed,  5 Aug 2015 15:38:19 +0200
Message-Id: <1438781899-600-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be> (sfid-20150805_153908_333557_699CC5C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current implementation in ocb.c can cause a kernel oops when the
interface is up, but no ocb has been joined. When data is received
with the broadcast BSSID rx_no_sta is called. This function uses
uninitialized variables because the join function has not yet been used.

Signed-off-by: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
---
 net/mac80211/ocb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
index 573b81a..5da2bd3 100644
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -50,6 +50,9 @@ void ieee80211_ocb_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	int band;
 
+	if (!ifocb->joined)
+		return;
+
 	/* XXX: Consider removing the least recently used entry and
 	 *      allow new one to be added.
 	 */
-- 
1.9.1


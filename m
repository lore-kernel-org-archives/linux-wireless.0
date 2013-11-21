Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:56022 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab3KURUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 12:20:44 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCHv2 5/5] mac80211: don't leak next beacon when csa is aborted
Date: Thu, 21 Nov 2013 18:19:53 +0100
Message-Id: <1385054393-17238-6-git-send-email-sw@simonwunderlich.de> (sfid-20131121_182051_643666_8C9C62F7)
In-Reply-To: <1385054393-17238-1-git-send-email-sw@simonwunderlich.de>
References: <1385054393-17238-1-git-send-email-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
Changes to PATCH:
 * remove the free in do_stop, because stop_ap is guaranteed to
   run when the AP is going down (thanks Johannes)
---
 net/mac80211/cfg.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9f19cde..38d2b6c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1080,6 +1080,9 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	/* abort any running channel switch */
 	sdata->vif.csa_active = false;
+	kfree(sdata->u.ap.next_beacon);
+	sdata->u.ap.next_beacon = NULL;
+
 	cancel_work_sync(&sdata->u.ap.request_smps_work);
 
 	/* turn off carrier for this interface and dependent VLANs */
-- 
1.7.10.4


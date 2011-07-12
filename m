Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:34150 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab1GLNw1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 09:52:27 -0400
From: Sven Neumann <s.neumann@raumfeld.com>
To: libertas-dev@lists.infradead.org
Cc: Sven Neumann <s.neumann@raumfeld.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Mack <daniel@zonque.org>
Subject: [PATCH] cfg80211: really ignore the regulatory request
Date: Tue, 12 Jul 2011 15:52:07 +0200
Message-Id: <1310478727-12099-2-git-send-email-s.neumann@raumfeld.com> (sfid-20110712_155230_447732_48B22B81)
In-Reply-To: <1310399981.11331.4.camel@sven>
References: <1310399981.11331.4.camel@sven>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At the beginning of wiphy_update_regulatory() a check is performed
whether the request is to be ignored. Then the request is sent to
the driver nevertheless. This happens even if last_request points
to NULL, leading to a crash in the driver:

 [<bf01d864>] (lbs_set_11d_domain_info+0x28/0x1e4 [libertas]) from [<c03b714c>] (wiphy_update_regulatory+0x4d0/0x4f4)
 [<c03b714c>] (wiphy_update_regulatory+0x4d0/0x4f4) from [<c03b4008>] (wiphy_register+0x354/0x420)
 [<c03b4008>] (wiphy_register+0x354/0x420) from [<bf01b17c>] (lbs_cfg_register+0x80/0x164 [libertas])
 [<bf01b17c>] (lbs_cfg_register+0x80/0x164 [libertas]) from [<bf020e64>] (lbs_start_card+0x20/0x88 [libertas])
 [<bf020e64>] (lbs_start_card+0x20/0x88 [libertas]) from [<bf02cbd8>] (if_sdio_probe+0x898/0x9c0 [libertas_sdio])

Fix this by returning early. Also remove the out: label as it is
not any longer needed.

Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
Cc: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Daniel Mack <daniel@zonque.org>
---
 net/wireless/reg.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1ad0f39..4453eb7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1125,12 +1125,13 @@ void wiphy_update_regulatory(struct wiphy *wiphy,
 	enum ieee80211_band band;
 
 	if (ignore_reg_update(wiphy, initiator))
-		goto out;
+		return;
+
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
 			handle_band(wiphy, band, initiator);
 	}
-out:
+
 	reg_process_beacons(wiphy);
 	reg_process_ht_flags(wiphy);
 	if (wiphy->reg_notifier)
-- 
1.7.1


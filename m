Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:58291 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaBTOl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 09:41:56 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: allow drivers to request SMPS off
Date: Thu, 20 Feb 2014 16:41:51 +0200
Message-Id: <1392907311-13655-1-git-send-email-luca@coelho.fi> (sfid-20140220_154159_486901_383256EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Previously we were warning and using automatic when a driver sent an
update request with SMPS off.  This patch makes it possible for
drivers to disable SMPS at runtime, for whatever reason.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ht.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index afbe2b2..c150b68 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -482,8 +482,6 @@ void ieee80211_request_smps(struct ieee80211_vif *vif,
 		return;
 
 	if (vif->type == NL80211_IFTYPE_STATION) {
-		if (WARN_ON(smps_mode == IEEE80211_SMPS_OFF))
-			smps_mode = IEEE80211_SMPS_AUTOMATIC;
 		if (sdata->u.mgd.driver_smps_mode == smps_mode)
 			return;
 		sdata->u.mgd.driver_smps_mode = smps_mode;
-- 
1.8.5.3


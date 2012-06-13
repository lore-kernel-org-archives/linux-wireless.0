Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57234 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab2FMGvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 02:51:39 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SehQX-0007eE-HU
	for linux-wireless@vger.kernel.org; Wed, 13 Jun 2012 08:51:37 +0200
Message-ID: <1339570296.4519.7.camel@jlt3.sipsolutions.net> (sfid-20120613_085142_360174_9A201487)
Subject: [PATCH 3.5] mac80211: stop polling in disassociation
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 13 Jun 2012 08:51:36 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Stop connection monitor poll during disassociation.
This clears the polling flags and if a scan was
deferred it will be run.

Without this fix, if a scan was deferred due to
connection monitoring while disassociation happens,
this scan blocks further scan requests until interface
down/up which causes problems connecting to another AP.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Will apply this soon to fix the bug.

 net/mac80211/mlme.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0f45d02..9aefcc3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1329,6 +1329,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	u32 changed = 0;
 	u8 bssid[ETH_ALEN];
 
+	ieee80211_stop_poll(sdata);
+
 	ASSERT_MGD_MTX(ifmgd);
 
 	if (WARN_ON_ONCE(tx && !frame_buf))
@@ -2592,8 +2594,6 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[DEAUTH_DISASSOC_LEN];
 
-	ieee80211_stop_poll(sdata);
-
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH, reason,
 			       false, frame_buf);
 	mutex_unlock(&ifmgd->mtx);
-- 
1.7.10




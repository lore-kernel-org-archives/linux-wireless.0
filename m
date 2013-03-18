Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab3CRVOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 17:14:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: assign CAB queue properly on interface type change
Date: Mon, 18 Mar 2013 22:14:46 +0100
Message-Id: <1363641286-23066-1-git-send-email-johannes@sipsolutions.net> (sfid-20130318_221507_249335_834AA324)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When an interface change type, the CAB queue must be reassigned,
do this in hwsim to avoid warnings/crashes.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 3466f1a..0064d38 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -964,6 +964,12 @@ static int mac80211_hwsim_change_interface(struct ieee80211_hw *hw,
 		    newtype, vif->addr);
 	hwsim_check_magic(vif);
 
+	/*
+	 * interface may change from non-AP to AP in
+	 * which case this needs to be set up again
+	 */
+	vif->cab_queue = 0;
+
 	return 0;
 }
 
-- 
1.8.0


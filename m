Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab3CTNHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 09:07:13 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix potential connection work crash
Date: Wed, 20 Mar 2013 14:07:07 +0100
Message-Id: <1363784827-9103-1-git-send-email-johannes@sipsolutions.net> (sfid-20130320_140718_132458_92550236)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If wpa_supplicant and iw/iwconfig are used together, very
rarely the system crashes. It seems to be related to the
connection parameters not being set up, but it's not all
clear to me how this happens. In any case, checking that
the conn pointer exists here is probably a good idea.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/sme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index bad4c4b..88fc9aa 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -234,7 +234,7 @@ void cfg80211_conn_work(struct work_struct *work)
 			wdev_unlock(wdev);
 			continue;
 		}
-		if (wdev->sme_state != CFG80211_SME_CONNECTING) {
+		if (wdev->sme_state != CFG80211_SME_CONNECTING || !wdev->conn) {
 			wdev_unlock(wdev);
 			continue;
 		}
-- 
1.8.0


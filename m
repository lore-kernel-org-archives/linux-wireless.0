Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab3AZVQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 16:16:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: add SME state to warning in __cfg80211_mlme_disassoc
Date: Sat, 26 Jan 2013 22:17:16 +0100
Message-Id: <1359235036-13086-1-git-send-email-johannes@sipsolutions.net> (sfid-20130126_221701_968936_C1054DCD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The warning here occasionally triggers but we haven't
found the cause yet. It's a valid warning since if it
triggers the SME state got confused, so add the SME
state to it to help narrow it down in the future.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 461e692..fee9bf7 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -514,7 +514,7 @@ static int __cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
 	if (wdev->sme_state != CFG80211_SME_CONNECTED)
 		return -ENOTCONN;
 
-	if (WARN_ON(!wdev->current_bss))
+	if (WARN(!wdev->current_bss, "sme_state=%d\n", wdev->sme_state))
 		return -ENOTCONN;
 
 	memset(&req, 0, sizeof(req));
-- 
1.8.0


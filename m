Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946004Ab2LFQsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:48:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 13/24] regulatory: remove redundant isalpha() check
Date: Thu,  6 Dec 2012 17:47:37 +0100
Message-Id: <1354812468-15709-14-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174855_078879_641470D6)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

toupper() only modifies lower-case letters, so
the isalpha() check is redundant; remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1c19d70..de3cf71 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1615,10 +1615,8 @@ static void reg_todo(struct work_struct *work)
 
 static void queue_regulatory_request(struct regulatory_request *request)
 {
-	if (isalpha(request->alpha2[0]))
-		request->alpha2[0] = toupper(request->alpha2[0]);
-	if (isalpha(request->alpha2[1]))
-		request->alpha2[1] = toupper(request->alpha2[1]);
+	request->alpha2[0] = toupper(request->alpha2[0]);
+	request->alpha2[1] = toupper(request->alpha2[1]);
 
 	spin_lock(&reg_requests_lock);
 	list_add_tail(&request->list, &reg_requests_list);
-- 
1.8.0


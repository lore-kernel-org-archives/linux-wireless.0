Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53198 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945962Ab2LFQr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:47:27 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 01/24] regulatory: don't write past array when intersecting rules
Date: Thu,  6 Dec 2012 17:47:25 +0100
Message-Id: <1354812468-15709-2-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174803_199203_E3EBF5F7)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When intersecting rules, we count first to know how many
rules need to be allocated, and then do the intersection
into the allocated array. However, the code doing this
writes past the end of the array because it attempts to
do all intersections. Make it stop when the right number
of rules has been reached.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b6c7ea6..4197359 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -648,9 +648,9 @@ static struct ieee80211_regdomain *regdom_intersect(
 	if (!rd)
 		return NULL;
 
-	for (x = 0; x < rd1->n_reg_rules; x++) {
+	for (x = 0; x < rd1->n_reg_rules && rule_idx < num_rules; x++) {
 		rule1 = &rd1->reg_rules[x];
-		for (y = 0; y < rd2->n_reg_rules; y++) {
+		for (y = 0; y < rd2->n_reg_rules && rule_idx < num_rules; y++) {
 			rule2 = &rd2->reg_rules[y];
 			/*
 			 * This time around instead of using the stack lets
-- 
1.8.0


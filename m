Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63113 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbaFKGzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 02:55:36 -0400
Received: by mail-wi0-f171.google.com with SMTP id n15so4416673wiw.10
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 23:55:35 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user hints
Date: Wed, 11 Jun 2014 09:55:23 +0300
Message-Id: <1402469724-22358-4-git-send-email-arik@wizery.com> (sfid-20140611_085541_565916_C2078462)
In-Reply-To: <1402469724-22358-1-git-send-email-arik@wizery.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow driver and user hints to set the "world" regulatory domain, and
also allow them to set the same reg-domain. This is useful when sending
an unknown-country ("99") request to a wiphy-specific regulatory source,
requesting it to provide the current alpha2. It may return an updated
regdomain for the "world" alpha2.

Note there's a check for regdom change at the request level, so the case
where the same alpha2 is set repeatedly is still optimized.

Change-Id: Iced65fd43bd10e40f1f446a9aff5d5ea380eecaa
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-on: https://gerrit.rds.intel.com/32267
Tested-by: IWL Jenkins
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c429ec5..d6b83f9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2539,9 +2539,6 @@ static int reg_set_rd_user(const struct ieee80211_regdomain *rd,
 {
 	const struct ieee80211_regdomain *intersected_rd = NULL;
 
-	if (!regdom_changes(rd->alpha2))
-		return -EALREADY;
-
 	if (!is_valid_rd(rd)) {
 		pr_err("Invalid regulatory domain detected:\n");
 		print_regdomain_info(rd);
@@ -2572,12 +2569,6 @@ static int reg_set_rd_driver(const struct ieee80211_regdomain *rd,
 	const struct ieee80211_regdomain *tmp;
 	struct wiphy *request_wiphy;
 
-	if (is_world_regdom(rd->alpha2))
-		return -EINVAL;
-
-	if (!regdom_changes(rd->alpha2))
-		return -EALREADY;
-
 	if (!is_valid_rd(rd)) {
 		pr_err("Invalid regulatory domain detected:\n");
 		print_regdomain_info(rd);
-- 
1.9.1


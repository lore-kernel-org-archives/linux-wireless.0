Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:56508 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab3KERRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:23 -0500
Received: by mail-bk0-f51.google.com with SMTP id my12so1759567bkb.38
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:22 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 05/19] cfg80211: processing core regulatory hints on its own
Date: Tue,  5 Nov 2013 09:18:03 -0800
Message-Id: <1383671897-7746-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181726_594181_3A8985C3)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the code path easier to read for the core case.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index dd2ff68..d242af0 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1337,7 +1337,7 @@ get_reg_request_treatment(struct wiphy *wiphy,
 
 	switch (pending_request->initiator) {
 	case NL80211_REGDOM_SET_BY_CORE:
-		return REG_REQ_OK;
+		return REG_REQ_IGNORE;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		if (reg_request_cell_base(lr)) {
 			/* Trust a Cell base station over the AP's country IE */
@@ -1443,6 +1443,33 @@ static void reg_set_request_processed(void)
 }
 
 /**
+ * reg_process_hint_core - process core regulatory requests
+ * @pending_request: a pending core regulatory request
+ *
+ * The wireless subsystem can use this function to process
+ * a regulatory request issued by the regulatory core.
+ *
+ * Returns one of the different reg request treatment values.
+ */
+static enum reg_request_treatment
+reg_process_hint_core(struct regulatory_request *core_request)
+{
+	struct regulatory_request *lr;
+
+	lr = get_last_request();
+	if (lr != &core_request_world && lr)
+		kfree_rcu(lr, rcu_head);
+
+	core_request->intersect = false;
+	core_request->processed = false;
+	rcu_assign_pointer(last_request, core_request);
+
+	if (call_crda(core_request->alpha2))
+		return REG_REQ_IGNORE;
+	return REG_REQ_OK;
+}
+
+/**
  * __regulatory_hint - hint to the wireless core a regulatory domain
  * @wiphy: if the hint comes from country information from an AP, this
  *	is required to be set to the wiphy that received the information
@@ -1540,6 +1567,7 @@ new_request:
 static void reg_process_hint(struct regulatory_request *reg_request)
 {
 	struct wiphy *wiphy = NULL;
+	enum reg_request_treatment treatment;
 
 	if (WARN_ON(!reg_request->alpha2))
 		return;
@@ -1552,7 +1580,18 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		return;
 	}
 
-	switch (__regulatory_hint(wiphy, reg_request)) {
+	switch (reg_request->initiator) {
+	case NL80211_REGDOM_SET_BY_CORE:
+		reg_process_hint_core(reg_request);
+		return;
+	case NL80211_REGDOM_SET_BY_USER:
+	case NL80211_REGDOM_SET_BY_DRIVER:
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		treatment = __regulatory_hint(wiphy, reg_request);
+		break;
+	}
+
+	switch (treatment) {
 	case REG_REQ_ALREADY_SET:
 		/* This is required so that the orig_* parameters are saved */
 		if (wiphy && wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
-- 
1.8.4.rc3


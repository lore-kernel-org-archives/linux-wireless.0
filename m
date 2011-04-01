Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60058 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab1DATmi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 15:42:38 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 12:42:14 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <gregoryx.alagnou@intel.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 1/2] cfg80211: fix regulatory restore upon user hints
Date: Fri, 1 Apr 2011 12:42:34 -0700
Message-ID: <1301686955-9402-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we restore regulatory settings its possible CRDA
will not reply because of a bogus user entry. In this
case the bogus entry will prevent any further processing
on cfg80211 for regulatory domains even if we restore
regulatory settings.

To prevent this we suck out all pending requests when
restoring regulatory settings and add them back into the
queue after we have queued up the reset work.

The impact of not having this applied is that a user
with privileges can issue a userspace regulatory hint
while we are disasocciating and this would prevent any
further processing of regulatory domains.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

John, since this doesn't kill any kittens I didn't mark this
as stable but I'll leave it to you to decide, I tried to describe
the impact as best as possible. Let me know if you have any
questions.

 net/wireless/reg.c |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3332d5b..e759204 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1744,6 +1744,8 @@ static void restore_regulatory_settings(bool reset_user)
 {
 	char alpha2[2];
 	struct reg_beacon *reg_beacon, *btmp;
+	struct regulatory_request *reg_request, *tmp;
+	static LIST_HEAD(tmp_reg_req_list);
 
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
@@ -1751,6 +1753,25 @@ static void restore_regulatory_settings(bool reset_user)
 	reset_regdomains();
 	restore_alpha2(alpha2, reset_user);
 
+	/*
+	 * If there's any pending requests we simply
+	 * stash them to a temporary pending queue and
+	 * add then after we've restored regulatory
+	 * settings.
+	 */
+	spin_lock(&reg_requests_lock);
+	if (!list_empty(&reg_requests_list)) {
+		list_for_each_entry_safe(reg_request, tmp,
+					 &reg_requests_list, list) {
+			if (reg_request->initiator !=
+			    NL80211_REGDOM_SET_BY_USER)
+				continue;
+			list_del(&reg_request->list);
+			list_add_tail(&reg_request->list, &tmp_reg_req_list);
+		}
+	}
+	spin_unlock(&reg_requests_lock);
+
 	/* Clear beacon hints */
 	spin_lock_bh(&reg_pending_beacons_lock);
 	if (!list_empty(&reg_pending_beacons)) {
@@ -1785,8 +1806,31 @@ static void restore_regulatory_settings(bool reset_user)
 	 */
 	if (is_an_alpha2(alpha2))
 		regulatory_hint_user(user_alpha2);
-}
 
+	if (list_empty(&tmp_reg_req_list))
+		return;
+
+	mutex_lock(&cfg80211_mutex);
+	mutex_lock(&reg_mutex);
+
+	spin_lock(&reg_requests_lock);
+	list_for_each_entry_safe(reg_request, tmp, &tmp_reg_req_list, list) {
+		REG_DBG_PRINT("Adding request for country %c%c back "
+			      "into the queue\n",
+			      reg_request->alpha2[0],
+			      reg_request->alpha2[1]);
+		list_del(&reg_request->list);
+		list_add_tail(&reg_request->list, &reg_requests_list);
+	}
+	spin_unlock(&reg_requests_lock);
+
+	mutex_unlock(&reg_mutex);
+	mutex_unlock(&cfg80211_mutex);
+
+	REG_DBG_PRINT("Kicking the queue\n");
+
+	schedule_work(&reg_work);
+}
 
 void regulatory_hint_disconnect(void)
 {
-- 
1.7.4.15.g7811d


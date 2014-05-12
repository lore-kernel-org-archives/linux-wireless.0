Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:31478 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaELSeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 14:34:22 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Sachin Ahuja <sahuja@codeaurora.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v3] cfg80211: avoid restoring the regulatory during disconnect
Date: Tue, 13 May 2014 00:04:49 +0530
Message-ID: <1399919689-31742-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140512_203425_725775_92A136DA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sachin Ahuja <sahuja@codeaurora.org>

When STA disconnects, cfg80211 restores the regulatory setting
to world domain. For the drivers that ignore country ie, cfg80211
should remain in the default country code which is configured
at driver load and should do not be restored to world reg domain.

Signed-off-by: Sachin Ahuja <sahuja@codeaurora.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
v2: Removed is_all_countryie_ignore
v3: Removed wdev_lock
 net/wireless/sme.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 4bc21a2..031ab4c 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -558,10 +558,23 @@ static bool cfg80211_is_all_idle(void)
 	return is_all_idle;
 }
 
+static bool cfg80211_is_all_countryie_ignore(void)
+{
+	struct cfg80211_registered_device *rdev;
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		if (!(rdev->wiphy.regulatory_flags &
+		      REGULATORY_COUNTRY_IE_IGNORE))
+			return false;
+	}
+	return true;
+}
+
 static void disconnect_work(struct work_struct *work)
 {
 	rtnl_lock();
-	if (cfg80211_is_all_idle())
+	if (cfg80211_is_all_idle() &&
+	    !cfg80211_is_all_countryie_ignore())
 		regulatory_hint_disconnect();
 	rtnl_unlock();
 }
-- 
1.9.2


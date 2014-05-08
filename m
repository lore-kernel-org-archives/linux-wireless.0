Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37631 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbaEHSzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 14:55:01 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Sachin Ahuja <sahuja@codeaurora.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] cfg80211: avoid restoring the regulatory during disconnect
Date: Fri, 9 May 2014 00:25:24 +0530
Message-ID: <1399575324-19539-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140508_205507_004493_067B3491)
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
 net/wireless/sme.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 4bc21a2..1319dd1 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -558,10 +558,33 @@ static bool cfg80211_is_all_idle(void)
 	return is_all_idle;
 }
 
+static bool cfg80211_is_all_countryie_ignore(void)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	bool is_all_countryie_ignore = true;
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		list_for_each_entry(wdev, &rdev->wdev_list, list) {
+			wdev_lock(wdev);
+			if (!(wdev->wiphy->regulatory_flags &
+			      REGULATORY_COUNTRY_IE_IGNORE)) {
+				is_all_countryie_ignore = false;
+				wdev_unlock(wdev);
+				goto out;
+			}
+			wdev_unlock(wdev);
+		}
+	}
+out:
+	return is_all_countryie_ignore;
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


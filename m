Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46799 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaEIK2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 06:28:25 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Sachin Ahuja <sahuja@codeaurora.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2] cfg80211: avoid restoring the regulatory during disconnect
Date: Fri, 9 May 2014 15:58:47 +0530
Message-ID: <1399631327-23379-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140509_122831_947693_02A0612A)
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
 net/wireless/sme.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 4bc21a2..1b771a8 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -558,10 +558,30 @@ static bool cfg80211_is_all_idle(void)
 	return is_all_idle;
 }
 
+static bool cfg80211_is_all_countryie_ignore(void)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		list_for_each_entry(wdev, &rdev->wdev_list, list) {
+			wdev_lock(wdev);
+			if (!(wdev->wiphy->regulatory_flags &
+			      REGULATORY_COUNTRY_IE_IGNORE)) {
+				wdev_unlock(wdev);
+				return false;
+			}
+			wdev_unlock(wdev);
+		}
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


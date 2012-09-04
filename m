Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61674 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab2IDOom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 10:44:42 -0400
Received: by weyx8 with SMTP id x8so3623926wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2012 07:44:41 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: clear bssid on auth/assoc failure
Date: Tue,  4 Sep 2012 17:44:45 +0300
Message-Id: <1346769885-4001-1-git-send-email-eliad@wizery.com> (sfid-20120904_164446_849603_F4E77D58)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ifmgd->bssid wasn't cleared properly in some
auth/assoc failure cases, causing mac80211 and
the low-level driver to go out of sync.

Clear ifmgd->bssid on failure, and notify the driver.

Cc: stable@kernel.org # 3.4+
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: handle assoc failures as well (thanks Johannes!)

net/mac80211/mlme.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 03cd188..21c9687 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3296,6 +3296,8 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	goto out_unlock;
 
  err_clear:
+	memset(ifmgd->bssid, 0, ETH_ALEN);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 	ifmgd->auth_data = NULL;
  err_free:
 	kfree(auth_data);
@@ -3487,6 +3489,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	err = 0;
 	goto out;
  err_clear:
+	memset(ifmgd->bssid, 0, ETH_ALEN);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 	ifmgd->assoc_data = NULL;
  err_free:
 	kfree(assoc_data);
-- 
1.7.6.401.g6a319


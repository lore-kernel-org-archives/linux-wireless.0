Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11029 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756984AbZAPANY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 19:13:24 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 16:13:24 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 11/13] cfg80211: move check for ignore_reg_update() on wiphy_update_regulatory()
Date: Thu, 15 Jan 2009 16:12:24 -0800
Message-ID: <1232064746-17134-12-git-send-email-lrodriguez@atheros.com> (sfid-20090116_011332_615838_0C715966)
In-Reply-To: <1232064746-17134-11-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-9-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-10-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-11-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This ensures that the initial REGDOM_SET_BY_CORE upon wiphy registration
respects the wiphy->custom_regulatory setting. Without this and if OLD_REG
is disabled (which will be default soon as we remove it) the
wiphy->custom_regulatory is simply ignored.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6c45832..271b54a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1017,13 +1017,15 @@ static void update_all_wiphy_regulatory(enum reg_set_by setby)
 	struct cfg80211_registered_device *drv;
 
 	list_for_each_entry(drv, &cfg80211_drv_list, list)
-		if (!ignore_reg_update(&drv->wiphy, setby))
-			wiphy_update_regulatory(&drv->wiphy, setby);
+		wiphy_update_regulatory(&drv->wiphy, setby);
 }
 
 void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
 {
 	enum ieee80211_band band;
+
+	if (ignore_reg_update(wiphy, setby))
+		return;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
 			handle_band(wiphy, band);
-- 
1.6.1.rc3.51.g5832d


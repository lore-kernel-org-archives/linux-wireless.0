Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11026 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757365AbZAPANW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 19:13:22 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 16:13:22 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 10/13] cfg80211: remove check for last_request on ignore_reg_update()
Date: Thu, 15 Jan 2009 16:12:23 -0800
Message-ID: <1232064746-17134-11-git-send-email-lrodriguez@atheros.com> (sfid-20090116_011330_404330_7B4DE725)
In-Reply-To: <1232064746-17134-10-git-send-email-lrodriguez@atheros.com>
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
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to check for last_request as the callers of
update_all_wiphy_regulatory() ensure its present.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8bf999d..6c45832 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1006,8 +1006,6 @@ static void handle_band_custom(struct wiphy *wiphy, enum ieee80211_band band,
 
 static bool ignore_reg_update(struct wiphy *wiphy, enum reg_set_by setby)
 {
-	if (!last_request)
-		return true;
 	if (setby == REGDOM_SET_BY_CORE &&
 		  wiphy->custom_regulatory)
 		return true;
-- 
1.6.1.rc3.51.g5832d


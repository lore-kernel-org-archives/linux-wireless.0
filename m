Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:57923 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab3KLSdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 13:33:24 -0500
Received: by mail-wg0-f53.google.com with SMTP id b13so2891218wgh.20
        for <linux-wireless@vger.kernel.org>; Tue, 12 Nov 2013 10:33:23 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] ath: fix dynamic user regulatory settings
Date: Tue, 12 Nov 2013 19:33:20 +0100
Message-Id: <1384281200-20454-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131112_193327_900157_DBC5A377)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A world regulatory domain check was in place that
prevents user dynamic regulatory hints from being
processed. This was there for historical reasons
as this was only possible previously for world
roaming cards and dynamic regulatory settings was
only possible for country IEs. Fix this by enforcing
the world regulatory domain check only for when the
initiator is a country IE. Support for dynamic user
regulatory support is already checked.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 3480201..40f9e4e 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -461,7 +461,8 @@ static int __ath_reg_dyn_country(struct wiphy *wiphy,
 {
 	u16 country_code;
 
-	if (!ath_is_world_regd(reg))
+	if (request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	    !ath_is_world_regd(reg))
 		return -EINVAL;
 
 	country_code = ath_regd_find_country_by_name(request->alpha2);
-- 
1.8.4.rc3


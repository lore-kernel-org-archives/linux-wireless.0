Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ye0-f181.google.com ([209.85.213.181]:45947 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3ISQSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Sep 2013 12:18:32 -0400
Received: by mail-ye0-f181.google.com with SMTP id r14so3446233yen.40
        for <linux-wireless@vger.kernel.org>; Thu, 19 Sep 2013 09:18:31 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 3/4] ath: split user and driver reguluatory hint parsing
Date: Thu, 19 Sep 2013 11:18:09 -0500
Message-Id: <1379607490-18972-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20130919_181835_053631_CE601EFA)
In-Reply-To: <1379607490-18972-1-git-send-email-mcgrof@do-not-panic.com>
References: <1379607490-18972-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

On the regulatory notifier split up the parsing of the
hints coming from drivers or user. We'll treat these
separately.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 8373650..7222eeb 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -422,6 +422,7 @@ void ath_reg_notifier_apply(struct wiphy *wiphy,
 		       sizeof(struct ath_regulatory));
 		break;
 	case NL80211_REGDOM_SET_BY_DRIVER:
+		break;
 	case NL80211_REGDOM_SET_BY_USER:
 		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-- 
1.7.10.4


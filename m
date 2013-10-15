Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39519 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3JOAmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 20:42:31 -0400
Received: by mail-pd0-f178.google.com with SMTP id w10so8149152pde.9
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 17:42:31 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 3/6] ath: split user and driver reguluatory hint parsing
Date: Mon, 14 Oct 2013 17:42:08 -0700
Message-Id: <1381797731-2454-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131015_024234_026627_53B531F3)
In-Reply-To: <1381797731-2454-1-git-send-email-mcgrof@do-not-panic.com>
References: <1381797731-2454-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On the regulatory notifier split up the parsing of the
hints coming from drivers or user. We'll treat these
separately.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 1 +
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
1.8.4.rc3


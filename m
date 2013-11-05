Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:33404 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3KERRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:39 -0500
Received: by mail-bk0-f52.google.com with SMTP id u14so2747018bkz.11
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:38 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 13/19] cfg80211: allow only the core to request to update the world regdom
Date: Tue,  5 Nov 2013 09:18:11 -0800
Message-Id: <1383671897-7746-14-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181751_301129_0D8B932E)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems some out of tree drivers were using a regulatory_hint("00")
to trigger off the wiphy regulatory notifier, for those cases just
setting the WIPHY_FLAG_CUSTOM_REGULATORY would suffice to call
the reg_notifier() for a world regulatory domain update. If drivers
find other needs for calling the reg_notifier() a proper implemenation
is preferred.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4619c74..a5b3b40 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2197,6 +2197,8 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		return -EINVAL;
 
 	if (is_world_regdom(rd->alpha2)) {
+		if (lr->initiator != NL80211_REGDOM_SET_BY_CORE)
+			return -EINVAL;
 		update_world_regdomain(rd);
 		return 0;
 	}
-- 
1.8.4.rc3


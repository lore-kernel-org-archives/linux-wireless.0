Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41654 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbZAHBn5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 20:43:57 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 17:43:57 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/6] cfg80211: call reg_notifier() once
Date: Wed, 7 Jan 2009 17:43:32 -0800
Message-ID: <1231379017-28363-2-git-send-email-lrodriguez@atheros.com> (sfid-20090108_024403_243569_7BA47AC1)
In-Reply-To: <1231379017-28363-1-git-send-email-lrodriguez@atheros.com>
References: <1231379017-28363-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are calling the reg_notifier() callback per band, this is
not necessary, just call it once.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4f87753..2f2ba92 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -841,9 +841,9 @@ void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
 			handle_band(wiphy->bands[band]);
-		if (wiphy->reg_notifier)
-			wiphy->reg_notifier(wiphy, setby);
 	}
+	if (wiphy->reg_notifier)
+		wiphy->reg_notifier(wiphy, setby);
 }
 
 /* Return value which can be used by ignore_request() to indicate
-- 
1.6.1.rc3.51.g5832d


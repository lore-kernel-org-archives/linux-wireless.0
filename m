Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64274 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbYKECuQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 21:50:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2008 18:50:16 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 6/7] cfg80211: initialize last_request
Date: Tue, 4 Nov 2008 18:50:05 -0800
Message-ID: <1225853406-16322-7-git-send-email-lrodriguez@atheros.com> (sfid-20081105_035025_253820_B6DD0143)
In-Reply-To: <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

last_request was not being initialized. By initializing it
we don't fix a bug as we are not checking for it before prior
to a regulatory hint however we may do so at a later time.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f062b8b..3754d0d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -899,6 +899,8 @@ int regulatory_init(void)
 	if (IS_ERR(reg_pdev))
 		return PTR_ERR(reg_pdev);
 
+	last_request = NULL;
+
 #ifdef CONFIG_WIRELESS_OLD_REGULATORY
 	cfg80211_regdomain = static_regdom(ieee80211_regdom);
 
-- 
1.5.6.3


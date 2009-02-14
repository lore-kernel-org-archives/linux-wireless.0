Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32512 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbZBNGm3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2009 01:42:29 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 22:42:29 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] cfg80211: add assert_cfg80211_lock() to regdom_changed
Date: Fri, 13 Feb 2009 22:41:41 -0800
Message-ID: <1234593702-19750-3-git-send-email-lrodriguez@atheros.com> (sfid-20090214_074234_833488_63F3036E)
In-Reply-To: <1234593702-19750-1-git-send-email-lrodriguez@atheros.com>
References: <1234593702-19750-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 95f8298..b32ee15 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -302,6 +302,8 @@ static bool alpha2_equal(const char *alpha2_x, const char *alpha2_y)
 
 static bool regdom_changed(const char *alpha2)
 {
+	assert_cfg80211_lock();
+
 	if (!cfg80211_regdomain)
 		return true;
 	if (alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
-- 
1.6.1.2.253.ga34a


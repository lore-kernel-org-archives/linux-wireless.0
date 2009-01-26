Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17350 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbZAZRBb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 12:01:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 09:01:31 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: do not pass -EALREADY to userspace on regdomain change request
Date: Mon, 26 Jan 2009 09:00:51 -0800
Message-ID: <1232989251-21311-1-git-send-email-lrodriguez@atheros.com> (sfid-20090126_180147_306455_D40E7737)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the regulatory domain is already set it is technically not an error
so do not pass an errno to userspace.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/nl80211.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 09a5d0f..4baa875 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1908,6 +1908,11 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 	mutex_lock(&cfg80211_drv_mutex);
 	r = __regulatory_hint(NULL, REGDOM_SET_BY_USER, data, 0, ENVIRON_ANY);
 	mutex_unlock(&cfg80211_drv_mutex);
+	/* This means the regulatory domain was already set, however
+	 * we don't want to confuse userspace with a "successfull error"
+	 * message so lets just treat it as a success */
+	if (r == -EALREADY)
+		r = 0;
 	return r;
 }
 
-- 
1.5.6.4


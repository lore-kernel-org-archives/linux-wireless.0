Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65498 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901AbZG3Aqg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 20:46:36 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 17:46:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/2] cfg80211: use goto out on 11d reg hint failure
Date: Wed, 29 Jul 2009 17:46:31 -0700
Message-ID: <1248914792-6010-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248914792-6010-1-git-send-email-lrodriguez@atheros.com>
References: <1248914792-6010-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This does not change functionality.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index fb40428..2d1d183 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1774,10 +1774,8 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 
 	mutex_lock(&cfg80211_mutex);
 
-	if (unlikely(!last_request)) {
-		mutex_unlock(&cfg80211_mutex);
-		return;
-	}
+	if (unlikely(!last_request))
+		goto out;
 
 	/* IE len must be evenly divisible by 2 */
 	if (country_ie_len & 0x01)
-- 
1.6.0.4


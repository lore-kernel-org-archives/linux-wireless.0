Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:64522 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752434AbdLMRvb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 12:51:31 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Srinivas Dasari <dasaris@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 2/2] nl80211: Allow SAE Authentication for NL80211_CMD_CONNECT
Date: Wed, 13 Dec 2017 19:50:38 +0200
Message-ID: <1513187438-23967-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20171213_185135_655398_1E6B026A)
In-Reply-To: <1513187438-23967-1-git-send-email-jouni@qca.qualcomm.com>
References: <1513187438-23967-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Srinivas Dasari <dasaris@qti.qualcomm.com>

This commit allows SAE Authentication for NL80211_CMD_CONNECT
interface, provided this is supported by the host driver.

Signed-off-by: Srinivas Dasari <dasaris@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 72ec615..e920c3a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3916,7 +3916,8 @@ static bool nl80211_valid_auth_type(struct cfg80211_registered_device *rdev,
 		return true;
 	case NL80211_CMD_CONNECT:
 		/* SAE not supported yet */
-		if (auth_type == NL80211_AUTHTYPE_SAE)
+		if (!(rdev->wiphy.features & NL80211_FEATURE_SAE) &&
+		    auth_type == NL80211_AUTHTYPE_SAE)
 			return false;
 		/* FILS with SK PFS or PK not supported yet */
 		if (auth_type == NL80211_AUTHTYPE_FILS_SK_PFS ||
-- 
2.7.4

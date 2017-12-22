Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:28818 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752871AbdLVQeY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 11:34:24 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Srinivas Dasari <dasaris@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 2/3] nl80211: Allow SAE Authentication for NL80211_CMD_CONNECT
Date: Fri, 22 Dec 2017 18:33:38 +0200
Message-ID: <1513960419-24780-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20171222_173427_454434_20035843)
In-Reply-To: <1513960419-24780-1-git-send-email-jouni@qca.qualcomm.com>
References: <1513960419-24780-1-git-send-email-jouni@qca.qualcomm.com>
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

v2:
- no changes; just rebased and included in the full patch series

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 41a0373..ea36514 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3917,7 +3917,8 @@ static bool nl80211_valid_auth_type(struct cfg80211_registered_device *rdev,
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

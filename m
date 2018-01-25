Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:11453 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751775AbeAYPOk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 10:14:40 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Srinivas Dasari <dasaris@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v3 3/3] nl80211: Allow SAE Authentication for NL80211_CMD_CONNECT
Date: Thu, 25 Jan 2018 17:13:39 +0200
Message-ID: <1516893219-30243-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20180125_161445_674885_23446110)
In-Reply-To: <1516893219-30243-1-git-send-email-jouni@qca.qualcomm.com>
References: <1516893219-30243-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Srinivas Dasari <dasaris@qti.qualcomm.com>

This commit allows SAE Authentication for NL80211_CMD_CONNECT
interface, provided host driver advertises the support.

Host drivers offload the SAE authentication to user space
through NL80211_CMD_EXTERNAL_AUTH interface and thus expect
the user space to advertise support to handle offload through
NL80211_ATTR_EXTERNAL_AUTH_SUPPORT in NL80211_CMD_CONNECT
request. Such drivers should reject the connect request on no
offload support from user space.

Signed-off-by: Srinivas Dasari <dasaris@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/nl80211.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

v3:
- clarified commit message to cover NL80211_ATTR_EXTERNAL_AUTH_SUPPORT
  in NL80211_CMD_CONNECT and potential need to reject the command with
  missing support

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8b10598..7478a6d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3918,9 +3918,10 @@ static bool nl80211_valid_auth_type(struct cfg80211_registered_device *rdev,
 			return false;
 		return true;
 	case NL80211_CMD_CONNECT:
-		/* SAE not supported yet */
-		if (auth_type == NL80211_AUTHTYPE_SAE)
+		if (!(rdev->wiphy.features & NL80211_FEATURE_SAE) &&
+		    auth_type == NL80211_AUTHTYPE_SAE)
 			return false;
+
 		/* FILS with SK PFS or PK not supported yet */
 		if (auth_type == NL80211_AUTHTYPE_FILS_SK_PFS ||
 		    auth_type == NL80211_AUTHTYPE_FILS_PK)
-- 
2.7.4

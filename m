Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:22819 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752056AbdGFWoM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 18:44:12 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Srinivas Dasari <dasaris@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 1/4] cfg80211: Check if PMKID attribute is of expected size
Date: Fri, 7 Jul 2017 01:43:39 +0300
Message-ID: <1499381022-5389-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20170707_004415_208951_ECDD2734)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Srinivas Dasari <dasaris@qti.qualcomm.com>

nla policy checks for only maximum length of the attribute data
when the attribute type is NLA_BINARY. If userspace sends less
data than specified, the wireless drivers may access illegal
memory. When type is NLA_UNSPEC, nla policy check ensures that
userspace sends minimum specified length number of bytes.

Remove type assignment to NLA_BINARY from nla_policy of
NL80211_ATTR_PMKID to make this NLA_UNSPEC and to make sure minimum
WLAN_PMKID_LEN bytes are received from userspace with
NL80211_ATTR_PMKID.

Fixes: 67fbb16be69d ("nl80211: PMKSA caching support")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Dasari <dasaris@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/nl80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5487cd7..364291c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -291,8 +291,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
 	[NL80211_ATTR_PID] = { .type = NLA_U32 },
 	[NL80211_ATTR_4ADDR] = { .type = NLA_U8 },
-	[NL80211_ATTR_PMKID] = { .type = NLA_BINARY,
-				 .len = WLAN_PMKID_LEN },
+	[NL80211_ATTR_PMKID] = { .len = WLAN_PMKID_LEN },
 	[NL80211_ATTR_DURATION] = { .type = NLA_U32 },
 	[NL80211_ATTR_COOKIE] = { .type = NLA_U64 },
 	[NL80211_ATTR_TX_RATES] = { .type = NLA_NESTED },
-- 
2.7.4

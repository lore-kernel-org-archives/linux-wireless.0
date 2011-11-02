Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22310 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab1KBVgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 17:36:45 -0400
Date: Wed, 2 Nov 2011 23:36:31 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] nl80211: Increase maximum NL80211_ATTR_KEY_SEQ length to 16
Message-ID: <20111102213631.GA21477@jouni.qca.qualcomm.com> (sfid-20111102_223647_966534_77AEE22A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WPI-SMS4 uses 16-octet PN field, so we need to allow longer key
sequence values to be configured.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/nl80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 48260c2..09fe0bf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -98,7 +98,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_KEY_IDX] = { .type = NLA_U8 },
 	[NL80211_ATTR_KEY_CIPHER] = { .type = NLA_U32 },
 	[NL80211_ATTR_KEY_DEFAULT] = { .type = NLA_FLAG },
-	[NL80211_ATTR_KEY_SEQ] = { .type = NLA_BINARY, .len = 8 },
+	[NL80211_ATTR_KEY_SEQ] = { .type = NLA_BINARY, .len = 16 },
 	[NL80211_ATTR_KEY_TYPE] = { .type = NLA_U32 },
 
 	[NL80211_ATTR_BEACON_INTERVAL] = { .type = NLA_U32 },
@@ -204,7 +204,7 @@ static const struct nla_policy nl80211_key_policy[NL80211_KEY_MAX + 1] = {
 	[NL80211_KEY_DATA] = { .type = NLA_BINARY, .len = WLAN_MAX_KEY_LEN },
 	[NL80211_KEY_IDX] = { .type = NLA_U8 },
 	[NL80211_KEY_CIPHER] = { .type = NLA_U32 },
-	[NL80211_KEY_SEQ] = { .type = NLA_BINARY, .len = 8 },
+	[NL80211_KEY_SEQ] = { .type = NLA_BINARY, .len = 16 },
 	[NL80211_KEY_DEFAULT] = { .type = NLA_FLAG },
 	[NL80211_KEY_DEFAULT_MGMT] = { .type = NLA_FLAG },
 	[NL80211_KEY_TYPE] = { .type = NLA_U32 },
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA

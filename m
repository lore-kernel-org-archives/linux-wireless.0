Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38177 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab1KXQN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 11:13:27 -0500
Received: by faas1 with SMTP id s1so1719456faa.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 08:13:26 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] nl80211: fix MAC address validation
Date: Thu, 24 Nov 2011 18:13:56 +0200
Message-Id: <1322151236-5960-1-git-send-email-eliad@wizery.com> (sfid-20111124_171331_035630_642AE6AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MAC addresses have a fixed length. The current
policy allows passing < ETH_ALEN bytes, which
might result in reading beyond the buffer.

Cc: stable@vger.kernel.org
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
NL80211_ATTR_REG_ALPHA2 also seems to have a similar issue.
however, it seems that we currently can't set NLA_STRING
type with exact length?

 net/wireless/nl80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b3a476f..ffafda5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -89,8 +89,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFNAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ-1 },
 
-	[NL80211_ATTR_MAC] = { .type = NLA_BINARY, .len = ETH_ALEN },
-	[NL80211_ATTR_PREV_BSSID] = { .type = NLA_BINARY, .len = ETH_ALEN },
+	[NL80211_ATTR_MAC] = { .len = ETH_ALEN },
+	[NL80211_ATTR_PREV_BSSID] = { .len = ETH_ALEN },
 
 	[NL80211_ATTR_KEY] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_KEY_DATA] = { .type = NLA_BINARY,
-- 
1.7.6.401.g6a319


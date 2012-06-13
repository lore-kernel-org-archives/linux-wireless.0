Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:52668 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab2FMP5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 11:57:01 -0400
Message-ID: <4FD8B5D4.8060305@opentechinstitute.org> (sfid-20120613_175709_471115_3C85BD4F)
Date: Wed, 13 Jun 2012 11:46:28 -0400
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: add support for userspace to handle auth frames
 on adhoc ifaces
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all!

This patch allows userspace applications to use nl80211 to register for
AUTH frames received on adhoc interfaces.

Thanks,
Will

Signed-off-by: Will Hawkins <hawkinsw@opentechinstitute.org>
---
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d81c178..4467162 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -455,7 +455,9 @@ static const struct ieee80211_txrx_stypes
 ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
        [NL80211_IFTYPE_ADHOC] = {
                .tx = 0xffff,
-               .rx = BIT(IEEE80211_STYPE_ACTION >> 4),
+               .rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+                       BIT(IEEE80211_STYPE_AUTH >> 4) |
+                       BIT(IEEE80211_STYPE_DEAUTH >> 4),
        },
        [NL80211_IFTYPE_STATION] = {
                .tx = 0xffff,

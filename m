Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15909 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbZCFFUG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 00:20:06 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 21:20:05 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] cfg80211: fix max tx power for world regdom on 5 GHz to 20dBm
Date: Thu, 5 Mar 2009 21:19:22 -0800
Message-ID: <1236316762-10348-2-git-send-email-lrodriguez@atheros.com> (sfid-20090306_062010_643556_4AFE9C2B)
In-Reply-To: <1236316762-10348-1-git-send-email-lrodriguez@atheros.com>
References: <1236316762-10348-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the lowest value amongst countries which do enable 5 GHz operation.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3f438fb..4519219 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -103,14 +103,14 @@ static const struct ieee80211_regdomain world_regdom = {
 			NL80211_RRF_NO_IBSS |
 			NL80211_RRF_NO_OFDM),
 		/* IEEE 802.11a, channel 36..48 */
-		REG_RULE(5180-10, 5240+10, 40, 6, 23,
+		REG_RULE(5180-10, 5240+10, 40, 6, 20,
                         NL80211_RRF_PASSIVE_SCAN |
                         NL80211_RRF_NO_IBSS),
 
 		/* NB: 5260 MHz - 5700 MHz requies DFS */
 
 		/* IEEE 802.11a, channel 149..165 */
-		REG_RULE(5745-10, 5825+10, 40, 6, 23,
+		REG_RULE(5745-10, 5825+10, 40, 6, 20,
 			NL80211_RRF_PASSIVE_SCAN |
 			NL80211_RRF_NO_IBSS),
 	}
-- 
1.6.1.2.253.ga34a


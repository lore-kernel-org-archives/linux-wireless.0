Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33291 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab1BZBdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 20:33:21 -0500
Received: by gyh20 with SMTP id 20so933722gyh.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 17:33:20 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>
Subject: [PATCH 2/5] mac80211: Let user space receive and send mesh auth/deauth frames
Date: Fri, 25 Feb 2011 17:32:37 -0800
Message-Id: <1298683960-20835-3-git-send-email-thomas@cozybit.com>
In-Reply-To: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
References: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

---
 net/mac80211/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c155c0b..299e8e3 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -529,7 +529,9 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	},
 	[NL80211_IFTYPE_MESH_POINT] = {
 		.tx = 0xffff,
-		.rx = BIT(IEEE80211_STYPE_ACTION >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+			BIT(IEEE80211_STYPE_AUTH >> 4) |
+			BIT(IEEE80211_STYPE_DEAUTH >> 4),
 	},
 };
 
-- 
1.7.0.4


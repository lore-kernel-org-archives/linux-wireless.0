Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35910 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760060Ab1CEBZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 20:25:30 -0500
Received: by pvg12 with SMTP id 12so418081pvg.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 17:25:29 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/4 v2] mac80211: Let user space receive and send mesh auth/deauth frames
Date: Fri,  4 Mar 2011 17:24:10 -0800
Message-Id: <1299288252-28314-3-git-send-email-thomas@cozybit.com>
In-Reply-To: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>


Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2543e48..bff7237 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -542,7 +542,9 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
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
1.7.1


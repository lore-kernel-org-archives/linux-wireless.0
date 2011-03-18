Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59323 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab1CRUXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 16:23:06 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so4370073iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 13:23:06 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/5 v4] mac80211: Let user space receive and send mesh auth/deauth frames
Date: Fri, 18 Mar 2011 13:22:09 -0700
Message-Id: <1300479732-25920-3-git-send-email-javier@cozybit.com>
In-Reply-To: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 562d298..0ae9b22 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -545,7 +545,9 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
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


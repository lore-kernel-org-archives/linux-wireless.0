Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60360 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758523Ab1CDDLx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 22:11:53 -0500
Received: by gxk8 with SMTP id 8so626037gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 19:11:53 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Javier Cardona <javier@cozybit.com>
Subject: [PATCH 3/7] mac80211: Let user space receive and send mesh auth/deauth frames
Date: Thu,  3 Mar 2011 19:11:43 -0800
Message-Id: <1299208307-9428-4-git-send-email-thomas@cozybit.com>
In-Reply-To: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
Tested-by: Thomas Pedersen <thomas@cozybit.com>
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
1.7.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58157 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933093Ab1KGRt4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 12:49:56 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] iw: fix regression in tx power validation
Date: Mon,  7 Nov 2011 18:49:51 +0100
Message-Id: <1320688191-24689-1-git-send-email-nbd@openwrt.org> (sfid-20111107_185001_434020_8689C5B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only bail out if the last character is *not* \0
---
 phy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/phy.c b/phy.c
index 91042b4..d9090fd 100644
--- a/phy.c
+++ b/phy.c
@@ -293,7 +293,7 @@ static int handle_txpower(struct nl80211_state *state,
 		}
 
 		mbm = strtol(argv[1], &endptr, 10);
-		if (!*endptr)
+		if (*endptr)
 			return 2;
 		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_TX_POWER_LEVEL, mbm);
 	} else if (argc != 1)
-- 
1.7.3.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:47170 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751004AbbAMOTc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 09:19:32 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Jan 2015 16:19:15 +0200
Message-Id: <1421158755-23411-1-git-send-email-luca@coelho.fi> (sfid-20150113_151934_852550_2C0F9279)
Subject: [PATCH iw] Read number of supported net-detect matches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Instead of just printing whether netdetect is supported, parse the
attribute and report the maximum number of matchsets the driver
supports.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 info.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/info.c b/info.c
index 6e21e45..1df503f 100644
--- a/info.c
+++ b/info.c
@@ -455,7 +455,7 @@ broken_combination:
 			[NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST] = { .type = NLA_FLAG },
 			[NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE] = { .type = NLA_FLAG },
 			[NL80211_WOWLAN_TRIG_RFKILL_RELEASE] = { .type = NLA_FLAG },
-			[NL80211_WOWLAN_TRIG_NET_DETECT] = { .type = NLA_FLAG },
+			[NL80211_WOWLAN_TRIG_NET_DETECT] = { .type = NLA_U32 },
 			[NL80211_WOWLAN_TRIG_TCP_CONNECTION] = { .type = NLA_NESTED },
 		};
 		struct nl80211_pattern_support *pat;
@@ -494,7 +494,8 @@ broken_combination:
 			if (tb_wowlan[NL80211_WOWLAN_TRIG_RFKILL_RELEASE])
 				printf("\t\t * wake up on rfkill release\n");
 			if (tb_wowlan[NL80211_WOWLAN_TRIG_NET_DETECT])
-				printf("\t\t * wake up on network detection\n");
+				printf("\t\t * wake up on network detection, up to %d match sets\n",
+				       nla_get_u32(tb_wowlan[NL80211_WOWLAN_TRIG_NET_DETECT]));
 			if (tb_wowlan[NL80211_WOWLAN_TRIG_TCP_CONNECTION])
 				printf("\t\t * wake up on TCP connection\n");
 		}
-- 
2.1.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33845 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbcGSL0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 07:26:10 -0400
Received: by mail-pf0-f196.google.com with SMTP id g202so1239072pfb.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 04:26:10 -0700 (PDT)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com,
	Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH] nl80211: Expand max value of NL80211_MESHCONF_HT_OPMODE command
Date: Tue, 19 Jul 2016 20:25:56 +0900
Message-Id: <1468927556-4703-1-git-send-email-masashi.honma@gmail.com> (sfid-20160719_132613_968696_23246E93)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, the max value of NL80211_MESHCONF_HT_OPMODE was 16.
But it causes EINVAL when IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED
and IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT bit is enabled.
So this patch expands the max value.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/wireless/nl80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 46417f9..8a00e50 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5471,7 +5471,10 @@ do {									    \
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold, -255, 0,
 				  mask, NL80211_MESHCONF_RSSI_THRESHOLD,
 				  nl80211_check_s32);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode, 0, 16,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode, 0,
+				  IEEE80211_HT_OP_MODE_PROTECTION |
+				  IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT |
+				  IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT,
 				  mask, NL80211_MESHCONF_HT_OPMODE,
 				  nl80211_check_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathToRootTimeout,
-- 
2.7.4


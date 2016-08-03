Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35690 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbcHCBUB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 21:20:01 -0400
Received: by mail-pf0-f194.google.com with SMTP id h186so13486252pfg.2
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2016 18:19:24 -0700 (PDT)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com,
	Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH v3] nl80211: Receive correct value for NL80211_MESHCONF_HT_OPMODE command
Date: Wed,  3 Aug 2016 10:07:44 +0900
Message-Id: <1470186464-4224-1-git-send-email-masashi.honma@gmail.com> (sfid-20160803_032008_113318_CCADDFF7)
In-Reply-To: <1468927556-4703-1-git-send-email-masashi.honma@gmail.com>
References: <1468927556-4703-1-git-send-email-masashi.honma@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, NL80211_MESHCONF_HT_OPMODE rejected correct flag
combination, ex) IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED |
IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT.

This was caused by simple comparison with value 16. This causes setting
non-existent flag (like 0x08) and invalid flag combinations. So this
commit implements some checks based on IEEE 802.11 2012 8.4.2.59 HT
Operation element.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/wireless/nl80211.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 46417f9..7b7530d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5380,6 +5380,7 @@ static int nl80211_parse_mesh_config(struct genl_info *info,
 {
 	struct nlattr *tb[NL80211_MESHCONF_ATTR_MAX + 1];
 	u32 mask = 0;
+	u16 ht_opmode;
 
 #define FILL_IN_MESH_PARAM_IF_SET(tb, cfg, param, min, max, mask, attr, fn) \
 do {									    \
@@ -5471,9 +5472,44 @@ do {									    \
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold, -255, 0,
 				  mask, NL80211_MESHCONF_RSSI_THRESHOLD,
 				  nl80211_check_s32);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode, 0, 16,
-				  mask, NL80211_MESHCONF_HT_OPMODE,
-				  nl80211_check_u16);
+	/*
+	 * Check HT operation mode based on
+	 * IEEE 802.11 2012 8.4.2.59 HT Operation element.
+	 */
+	if (tb[NL80211_MESHCONF_HT_OPMODE]) {
+		ht_opmode = nla_get_u16(tb[NL80211_MESHCONF_HT_OPMODE]);
+
+		if (ht_opmode & (~(IEEE80211_HT_OP_MODE_PROTECTION |
+		    IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT |
+		    IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT)))
+			return -EINVAL;
+
+		if ((ht_opmode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT) &&
+		    (ht_opmode & IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT))
+			return -EINVAL;
+
+		switch (ht_opmode & IEEE80211_HT_OP_MODE_PROTECTION) {
+		case IEEE80211_HT_OP_MODE_PROTECTION_NONE:
+			if (ht_opmode & IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT)
+				return -EINVAL;
+			break;
+		case IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER:
+			if (!(ht_opmode &
+			    IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT))
+				return -EINVAL;
+			break;
+		case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
+			if (ht_opmode & IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT)
+				return -EINVAL;
+			break;
+		case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
+			if (!(ht_opmode &
+			    IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT))
+				return -EINVAL;
+			break;
+		}
+		cfg->ht_opmode = ht_opmode;
+	}
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathToRootTimeout,
 				  1, 65535, mask,
 				  NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
-- 
2.7.4


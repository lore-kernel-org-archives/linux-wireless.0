Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33675 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965004AbcHBMet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:34:49 -0400
Received: by mail-pa0-f65.google.com with SMTP id q2so11914021pap.0
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2016 05:33:14 -0700 (PDT)
From: Masashi Honma <masashi.honma@gmail.com>
To: honma@masap.sakura.ne.jp, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com,
	Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH v2] nl80211: Receive correct value for NL80211_MESHCONF_HT_OPMODE command
Date: Tue,  2 Aug 2016 20:41:29 +0900
Message-Id: <1470138089-6864-1-git-send-email-masashi.honma@gmail.com> (sfid-20160802_143507_374183_5A0CE0CD)
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
 net/wireless/nl80211.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 46417f9..b2af600 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5471,9 +5471,49 @@ do {									    \
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
+	if (tb[NL80211_MESHCONF_HT_OPMODE]) {
+		/*
+		 * Check HT operation mode based on IEEE 802.11 2012 8.4.2.59
+		 * HT Operation element.
+		 */
+		if (cfg->ht_opmode & (~(IEEE80211_HT_OP_MODE_PROTECTION |
+		    IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT |
+		    IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT)))
+			return -EINVAL;
+
+		if ((cfg->ht_opmode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT) &&
+		    (cfg->ht_opmode & IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT))
+			return -EINVAL;
+
+		switch (cfg->ht_opmode & IEEE80211_HT_OP_MODE_PROTECTION) {
+		case IEEE80211_HT_OP_MODE_PROTECTION_NONE:
+			if (cfg->ht_opmode &
+			    IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT)
+				return -EINVAL;
+			break;
+		case IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER:
+			if (!(cfg->ht_opmode &
+			    IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT))
+				return -EINVAL;
+			break;
+		case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
+			if (cfg->ht_opmode &
+			    IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT)
+				return -EINVAL;
+			break;
+		case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
+			if (!(cfg->ht_opmode &
+			    IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT))
+				return -EINVAL;
+			break;
+		}
+	}
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathToRootTimeout,
 				  1, 65535, mask,
 				  NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
-- 
2.7.4


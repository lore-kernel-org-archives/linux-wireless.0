Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26601 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab2GYK5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 06:57:08 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v1] cfg80211: unify IE search
Date: Wed, 25 Jul 2012 13:56:53 +0300
Message-ID: <1343213813-29568-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120725_125713_653916_A3D5DBE7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove ah-hock IE search code found in the ieee80211_bss_get_ie()
Use cfg80211_find_ie() instead.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 net/wireless/util.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 26f8cd3..ce393dd 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -684,22 +684,10 @@ EXPORT_SYMBOL(cfg80211_classify8021d);
 
 const u8 *ieee80211_bss_get_ie(struct cfg80211_bss *bss, u8 ie)
 {
-	u8 *end, *pos;
-
-	pos = bss->information_elements;
-	if (pos == NULL)
+	if (bss->information_elements == NULL)
 		return NULL;
-	end = pos + bss->len_information_elements;
-
-	while (pos + 1 < end) {
-		if (pos + 2 + pos[1] > end)
-			break;
-		if (pos[0] == ie)
-			return pos;
-		pos += 2 + pos[1];
-	}
-
-	return NULL;
+	return cfg80211_find_ie(ie, bss->information_elements,
+				 bss->len_information_elements);
 }
 EXPORT_SYMBOL(ieee80211_bss_get_ie);
 
-- 
1.7.9.5


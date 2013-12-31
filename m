Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:46077 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab3L3WAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Dec 2013 17:00:35 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so5249387eak.2
        for <linux-wireless@vger.kernel.org>; Mon, 30 Dec 2013 14:00:34 -0800 (PST)
From: Bogdan Radulescu <bogdan@nimblex.net>
To: torvalds@linux-foundation.org
Cc: Bogdan Radulescu <bogdan@nimblex.net>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] Add STA mode support for devices based on Ralink RT5350
Date: Tue, 31 Dec 2013 02:00:16 +0200
Message-Id: <1388448016-10210-1-git-send-email-bogdan@nimblex.net> (sfid-20131230_230039_428786_6E6C0DA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bogdan Radulescu <bogdan@nimblex.net>

---
 drivers/net/wireless/rt2x00/rt2x00dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 9dd92a7..606e968 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1236,7 +1236,7 @@ static inline void rt2x00lib_set_if_combinations(struct rt2x00_dev *rt2x00dev)
 	 */
 	if_limit = &rt2x00dev->if_limits_ap;
 	if_limit->max = rt2x00dev->ops->max_ap_intf;
-	if_limit->types = BIT(NL80211_IFTYPE_AP);
+	if_limit->types = BIT(NL80211_IFTYPE_AP) | BIT(NL80211_IFTYPE_STATION);
 #ifdef CONFIG_MAC80211_MESH
 	if_limit->types |= BIT(NL80211_IFTYPE_MESH_POINT);
 #endif
-- 
1.8.4


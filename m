Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:39635 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab3AYFOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 00:14:18 -0500
Received: by mail-pb0-f52.google.com with SMTP id uo5so968632pbc.39
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2013 21:14:18 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, IvDoorn@gmail.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com, users@rt2x00.serialmonkey.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] rt2x00: allow AP and mesh mode to operate simultaneously
Date: Fri, 25 Jan 2013 12:47:50 +0800
Message-Id: <1359089270-29702-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130125_061423_130398_76C729B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow AP and Mesh mode to operate concurrently using
single radio. Verify this using fonera 2.0n featuring
RT3052 chipset and also TP-LINK TL-WN727N featuring
RT5370 chipset.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b40a538..f3c83f4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1236,7 +1236,8 @@ static inline void rt2x00lib_set_if_combinations(struct rt2x00_dev *rt2x00dev)
 	 */
 	if_limit = &rt2x00dev->if_limits_ap;
 	if_limit->max = rt2x00dev->ops->max_ap_intf;
-	if_limit->types = BIT(NL80211_IFTYPE_AP);
+	if_limit->types = BIT(NL80211_IFTYPE_AP) |
+			BIT(NL80211_IFTYPE_MESH_POINT);
 
 	/*
 	 * Build up AP interface combinations structure.
-- 
1.7.0.4


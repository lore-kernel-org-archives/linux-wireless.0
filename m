Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48335 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab3LDKrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 05:47:31 -0500
Received: by mail-pd0-f171.google.com with SMTP id z10so22139160pdj.30
        for <linux-wireless@vger.kernel.org>; Wed, 04 Dec 2013 02:47:31 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath9k: enable dfs for mesh mode
Date: Wed,  4 Dec 2013 18:46:54 +0800
Message-Id: <1386154014-24054-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131204_114746_095855_73DBFFEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 8f4c167..5a0b7e8 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -856,6 +856,9 @@ static const struct ieee80211_iface_limit if_limits[] = {
 
 static const struct ieee80211_iface_limit if_dfs_limits[] = {
 	{ .max = 1,	.types = BIT(NL80211_IFTYPE_AP) |
+#ifdef CONFIG_MAC80211_MESH
+				 BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
 				 BIT(NL80211_IFTYPE_ADHOC) },
 };
 
-- 
1.7.9.5


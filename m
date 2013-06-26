Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:59750 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3FZWJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 18:09:41 -0400
Received: by mail-pd0-f179.google.com with SMTP id q10so3839pdj.38
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jun 2013 15:09:41 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: ath9k <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux@rempel-privat.de, Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] ath9k_htc: ifdef out IFTYPE_MESH advertisement
Date: Wed, 26 Jun 2013 15:06:58 -0700
Message-Id: <1372284419-13945-1-git-send-email-thomas@cozybit.com> (sfid-20130627_000944_562338_ECFEAF34)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed so the interface combination can still be
validated when CONFIG_MAC80211_MESH is not enabled.
Otherwise wiphy registration fails.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index bb0ba9e..07ca932 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -701,8 +701,10 @@ static const struct ieee80211_iface_limit if_limits[] = {
 	{ .max = 2,	.types = BIT(NL80211_IFTYPE_STATION) |
 				 BIT(NL80211_IFTYPE_P2P_CLIENT) },
 	{ .max = 2,	.types = BIT(NL80211_IFTYPE_AP) |
-				 BIT(NL80211_IFTYPE_P2P_GO) |
-				 BIT(NL80211_IFTYPE_MESH_POINT) },
+#ifdef CONFIG_MAC80211_MESH
+				 BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+				 BIT(NL80211_IFTYPE_P2P_GO) },
 };
 
 static const struct ieee80211_iface_combination if_comb = {
-- 
1.7.10.4


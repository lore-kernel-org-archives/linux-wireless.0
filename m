Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62387 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab1DMFym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:54:42 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so275754iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:54:42 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.15154.818312.300907@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:27:06 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 40/40] ath9k_htc: Enable AP and P2P modes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 0aec259..22736eb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -752,7 +752,10 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
+		BIT(NL80211_IFTYPE_ADHOC) |
+		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_P2P_GO) |
+		BIT(NL80211_IFTYPE_P2P_CLIENT);
 
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
-- 
1.7.4.4


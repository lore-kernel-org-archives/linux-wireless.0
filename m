Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43591 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1BUCUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:20:00 -0500
Received: by mail-gx0-f174.google.com with SMTP id 8so301890gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:19:59 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52162.358774.683966@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:49:46 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 16/23] ath9k_htc: Disable powersave if an AP interface is present
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f384b35..4779bb1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1393,7 +1393,8 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_PS) {
+	if ((priv->ah->opmode != NL80211_IFTYPE_AP) &&
+	    (changed & IEEE80211_CONF_CHANGE_PS)) {
 		if (conf->flags & IEEE80211_CONF_PS) {
 			ath9k_htc_setpower(priv, ATH9K_PM_NETWORK_SLEEP);
 			priv->ps_enabled = true;
-- 
1.7.4.1


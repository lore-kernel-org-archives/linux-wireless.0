Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56613 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab1AUDCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:02:20 -0500
Received: by pwj3 with SMTP id 3so226880pwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:02:19 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63246.349398.390204@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:31:34 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 16/33] ath9k_htc: Disable powersave if an AP interface is present
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f986d93..b98749e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1375,7 +1375,8 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_PS) {
+	if ((priv->ah->opmode != NL80211_IFTYPE_AP) &&
+	    (changed & IEEE80211_CONF_CHANGE_PS)) {
 		if (conf->flags & IEEE80211_CONF_PS) {
 			ath9k_htc_setpower(priv, ATH9K_PM_NETWORK_SLEEP);
 			priv->ps_enabled = true;
-- 
1.7.3.5


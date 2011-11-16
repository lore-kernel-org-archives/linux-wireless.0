Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44529 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388Ab1KPMIy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 07:08:54 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 4/4] ath9k: cancel all workqueue activity when going idle
Date: Wed, 16 Nov 2011 13:08:43 +0100
Message-Id: <1321445323-71774-4-git-send-email-nbd@openwrt.org> (sfid-20111116_130858_381407_FE63DD2C)
In-Reply-To: <1321445323-71774-3-git-send-email-nbd@openwrt.org>
References: <1321445323-71774-1-git-send-email-nbd@openwrt.org>
 <1321445323-71774-2-git-send-email-nbd@openwrt.org>
 <1321445323-71774-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a7f7926..edee011 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1588,8 +1588,11 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	 * of the changes. Likewise we must only disable the radio towards
 	 * the end.
 	 */
-	if (changed & IEEE80211_CONF_CHANGE_IDLE)
+	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
 		sc->ps_idle = !!(conf->flags & IEEE80211_CONF_IDLE);
+		if (sc->ps_idle)
+			ath_cancel_work(sc);
+	}
 
 	/*
 	 * We just prepare to enable PS. We have to wait until our AP has
-- 
1.7.3.2


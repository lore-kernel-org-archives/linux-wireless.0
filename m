Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:41846
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751987AbaK3U6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2014 15:58:34 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH v2 2/3] ath9k: set ATH_OP_INVALID before disabling hardware
Date: Sun, 30 Nov 2014 21:58:31 +0100
Message-Id: <1417381112-33402-2-git-send-email-nbd@openwrt.org> (sfid-20141130_215837_193684_E8BC979C)
In-Reply-To: <1417381112-33402-1-git-send-email-nbd@openwrt.org>
References: <1417381112-33402-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Closes another small IRQ handler race

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ebbbfc7..9437365 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -887,6 +887,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 						    &sc->cur_chan->chandef);
 
 	ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
+
+	set_bit(ATH_OP_INVALID, &common->op_flags);
+
 	ath9k_hw_phy_disable(ah);
 
 	ath9k_hw_configpcipowersave(ah, true);
@@ -895,7 +898,6 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	ath9k_ps_restore(sc);
 
-	set_bit(ATH_OP_INVALID, &common->op_flags);
 	sc->ps_idle = prev_idle;
 
 	mutex_unlock(&sc->mutex);
-- 
2.1.2


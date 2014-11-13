Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:52398
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933525AbaKMReL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 12:34:11 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.18 2/3] ath9k: set ATH_OP_INVALID before disabling hardware
Date: Thu, 13 Nov 2014 18:34:04 +0100
Message-Id: <1415900045-49093-2-git-send-email-nbd@openwrt.org> (sfid-20141113_183419_350972_71F3C04C)
In-Reply-To: <1415900045-49093-1-git-send-email-nbd@openwrt.org>
References: <1415900045-49093-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Closes another small IRQ handler race

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 644552c..ee67956 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -885,6 +885,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 						    &sc->cur_chan->chandef);
 
 	ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
+
+	set_bit(ATH_OP_INVALID, &common->op_flags);
+
 	ath9k_hw_phy_disable(ah);
 
 	ath9k_hw_configpcipowersave(ah, true);
@@ -893,7 +896,6 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	ath9k_ps_restore(sc);
 
-	set_bit(ATH_OP_INVALID, &common->op_flags);
 	sc->ps_idle = prev_idle;
 
 	mutex_unlock(&sc->mutex);
-- 
2.1.2


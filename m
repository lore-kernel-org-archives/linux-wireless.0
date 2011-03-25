Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55339 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab1CYQns (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 12:43:48 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2.6.39] ath9k: fix a chip wakeup related crash in ath9k_start
Date: Fri, 25 Mar 2011 17:43:41 +0100
Message-Id: <1301071421-29205-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the chip is still asleep when ath9k_start is called,
ath9k_hw_configpcipowersave can trigger a data bus error.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3c5de73..6a41302 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1048,6 +1048,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 		"Starting driver with initial channel: %d MHz\n",
 		curchan->center_freq);
 
+	ath9k_ps_wakeup(sc);
+
 	mutex_lock(&sc->mutex);
 
 	/* setup initial channel */
@@ -1143,6 +1145,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
 
+	ath9k_ps_restore(sc);
+
 	return r;
 }
 
-- 
1.7.3.2


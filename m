Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54174 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757805Ab3AIMnQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 07:43:16 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 3.8 3/5] ath9k: remove the WARN_ON that triggers if generating a beacon fails
Date: Wed,  9 Jan 2013 13:43:11 +0100
Message-Id: <1357735393-93564-3-git-send-email-nbd@openwrt.org> (sfid-20130109_134323_103566_882B527E)
In-Reply-To: <1357735393-93564-2-git-send-email-nbd@openwrt.org>
References: <1357735393-93564-1-git-send-email-nbd@openwrt.org>
 <1357735393-93564-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During teardown, mac80211 will not return a new beacon. This is normal and
handled properly in the driver, so there's no need to spam the user with a kernel
warning here.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 4eb269d..2ca355e 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -360,7 +360,6 @@ void ath9k_beacon_tasklet(unsigned long data)
 		return;
 
 	bf = ath9k_beacon_generate(sc->hw, vif);
-	WARN_ON(!bf);
 
 	if (sc->beacon.bmisscnt != 0) {
 		ath_dbg(common, BSTUCK, "resume beacon xmit after %u misses\n",
-- 
1.8.0.2


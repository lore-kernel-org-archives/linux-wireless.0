Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29657 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933767AbbCDGvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 01:51:32 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 1/2] ath10k: fix rts profile for second rate series
Date: Wed, 4 Mar 2015 12:20:46 +0530
Message-ID: <1425451847-14505-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150304_075205_210953_50920E21)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By default rts protection is enabled in firmware for the second
rateset. Currently ath10k selects RTS profile (only for software
retries), when legacy stations are associated or asked by mac80211.
On congested environment, when AP is running in HT/VHT mode and
there are no legacy clients associated, this will impact the
robustness. Also enabling RTS protection only for second rateset will
not impact performance on clear environment. Fix that.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 84a243e..37141b3 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -798,12 +798,14 @@ static int ath10k_recalc_rtscts_prot(struct ath10k_vif *arvif)
 
 	vdev_param = ar->wmi.vdev_param->enable_rtscts;
 
-	if (arvif->use_cts_prot || arvif->num_legacy_stations > 0)
-		rts_cts |= SM(WMI_RTSCTS_ENABLED, WMI_RTSCTS_SET);
+	rts_cts |= SM(WMI_RTSCTS_ENABLED, WMI_RTSCTS_SET);
 
 	if (arvif->num_legacy_stations > 0)
 		rts_cts |= SM(WMI_RTSCTS_ACROSS_SW_RETRIES,
 			      WMI_RTSCTS_PROFILE);
+	else
+		rts_cts |= SM(WMI_RTSCTS_FOR_SECOND_RATESERIES,
+			      WMI_RTSCTS_PROFILE);
 
 	return ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 					 rts_cts);
-- 
2.3.1


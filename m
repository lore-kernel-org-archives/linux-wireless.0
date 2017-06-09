Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:33085 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751558AbdFILIJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 07:08:09 -0400
Received: by mail-wr0-f180.google.com with SMTP id v104so29127161wrb.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jun 2017 04:08:08 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH v2 3/3] ath10k: Set rxnss_override for QCA9888
Date: Fri,  9 Jun 2017 13:07:50 +0200
Message-Id: <20170609110750.14950-3-sven.eckelmann@openmesh.com> (sfid-20170609_130811_866949_3CF5EA84)
In-Reply-To: <20170609110750.14950-1-sven.eckelmann@openmesh.com>
References: <20170609110750.14950-1-sven.eckelmann@openmesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

QCA9888 supports VHT80 with 2x2. But it only support 1x1 with VHT160 or
VHT80+80. Inform userspace and the the QCA firmware about that limitation
whenever VHT80+80 or VHT160 is configured.

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
v2:
 - new patch

 drivers/net/wireless/ath/ath10k/mac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0752cf351b4a..75e90adc8fb4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4436,6 +4436,14 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 			vht_cap.vht_mcs.rx_highest = 1560;
 			vht_cap.vht_mcs.tx_highest = 1560;
 			break;
+		case QCA9888_2_0_DEVICE_ID:
+			/* Can do only 1x1 VHT160 or 80+80.
+			 * 780Mbps is 2x2 80Mhz or 1x1 160Mhz,
+			 * long-guard-interval
+			 */
+			vht_cap.vht_mcs.rx_highest = 780;
+			vht_cap.vht_mcs.tx_highest = 780;
+			break;
 		}
 	}
 
-- 
2.11.0

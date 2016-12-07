Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:33908 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932453AbcLGRIN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 12:08:13 -0500
Received: by mail-wm0-f49.google.com with SMTP id u144so36517560wmu.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 09:08:13 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 3/5] ath10k: decrease num of peers support
Date: Wed,  7 Dec 2016 18:07:32 +0100
Message-Id: <1481130454-27244-3-git-send-email-bartosz.markowski@tieto.com> (sfid-20161207_180820_779682_BE8CA838)
In-Reply-To: <1481130454-27244-1-git-send-email-bartosz.markowski@tieto.com>
References: <1481130454-27244-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The correct number for QCA9377 chip is 33 VDEVs.
This impacts also QCA6174 chip and it's max VDEV number.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 883547f3347c..7feffec531cc 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -512,7 +512,7 @@ ath10k_rx_desc_get_l3_pad_bytes(struct ath10k_hw_params *hw,
 /* Target specific defines for WMI-TLV firmware */
 #define TARGET_TLV_NUM_VDEVS			4
 #define TARGET_TLV_NUM_STATIONS			32
-#define TARGET_TLV_NUM_PEERS			35
+#define TARGET_TLV_NUM_PEERS			33
 #define TARGET_TLV_NUM_TDLS_VDEVS		1
 #define TARGET_TLV_NUM_TIDS			((TARGET_TLV_NUM_PEERS) * 2)
 #define TARGET_TLV_NUM_MSDU_DESC		(1024 + 32)
-- 
2.1.2

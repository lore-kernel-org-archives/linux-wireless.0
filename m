Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:27053 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729903AbeGSGqE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:04 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 05/23] staging: wilc1000: rename goto to avoid leading '_' in label name
Date: Thu, 19 Jul 2018 04:15:01 +0530
Message-ID: <1531953919-20804-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080442_192994_5AF1787D)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to avoid use of leading '_' in goto label name. Also used
proper string for lable names.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 drivers/staging/wilc1000/wilc_wlan.c              | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f90b9b6..73606c3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2196,11 +2196,11 @@ static struct wireless_dev *wilc_wfi_cfg_alloc(void)
 
 	wdev = kzalloc(sizeof(*wdev), GFP_KERNEL);
 	if (!wdev)
-		goto _fail_;
+		goto out;
 
 	wdev->wiphy = wiphy_new(&wilc_cfg80211_ops, sizeof(struct wilc_priv));
 	if (!wdev->wiphy)
-		goto _fail_mem_;
+		goto free_mem;
 
 	wilc_band_2ghz.ht_cap.ht_supported = 1;
 	wilc_band_2ghz.ht_cap.cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
@@ -2212,9 +2212,9 @@ static struct wireless_dev *wilc_wfi_cfg_alloc(void)
 
 	return wdev;
 
-_fail_mem_:
+free_mem:
 	kfree(wdev);
-_fail_:
+out:
 	return NULL;
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 85af365..8e71c28 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -850,13 +850,13 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 		if (wilc->rx_buffer)
 			buffer = &wilc->rx_buffer[offset];
 		else
-			goto _end_;
+			goto end;
 
 		wilc->hif_func->hif_clear_int_ext(wilc,
 					      DATA_INT_CLR | ENABLE_RX_VMM);
 		ret = wilc->hif_func->hif_block_rx_ext(wilc, 0, buffer, size);
 
-_end_:
+end:
 		if (ret) {
 			offset += size;
 			wilc->rx_buffer_offset = offset;
-- 
2.7.4

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:37685 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaHSLcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 07:32:23 -0400
Received: by mail-la0-f45.google.com with SMTP id ty20so5779414lab.18
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2014 04:32:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix wmi service bitmap
Date: Tue, 19 Aug 2014 13:22:32 +0200
Message-Id: <1408447352-28688-1-git-send-email-michal.kazior@tieto.com> (sfid-20140819_133227_263226_40516361)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Service mapping for main firmware branch was
incorrectly used for 10.x firmware and vice-versa.
This caused wmi_services in debugfs to print wrong
values.

This actually fixes a problem with the previous
wmi service bitmap patch itself. For some reason
there was either a conflict that wasn't resolved
properly or git had a bad day.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 23acbad..ec3bf4e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2194,7 +2194,7 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 	ar->ath_common.regulatory.current_rd =
 		__le32_to_cpu(ev->hal_reg_capabilities.eeprom_rd);
 
-	wmi_10x_svc_map(ev->wmi_service_bitmap, svc_bmap);
+	wmi_main_svc_map(ev->wmi_service_bitmap, svc_bmap);
 	ath10k_debug_read_service_map(ar, svc_bmap, sizeof(svc_bmap));
 	ath10k_dbg_dump(ATH10K_DBG_WMI, NULL, "ath10k: wmi svc: ",
 			ev->wmi_service_bitmap, sizeof(ev->wmi_service_bitmap));
@@ -2264,7 +2264,7 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 	ar->ath_common.regulatory.current_rd =
 		__le32_to_cpu(ev->hal_reg_capabilities.eeprom_rd);
 
-	wmi_main_svc_map(ev->wmi_service_bitmap, svc_bmap);
+	wmi_10x_svc_map(ev->wmi_service_bitmap, svc_bmap);
 	ath10k_debug_read_service_map(ar, svc_bmap, sizeof(svc_bmap));
 	ath10k_dbg_dump(ATH10K_DBG_WMI, NULL, "ath10k: wmi svc: ",
 			ev->wmi_service_bitmap, sizeof(ev->wmi_service_bitmap));
-- 
1.8.5.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34928 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbcAEOHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 09:07:04 -0500
Received: by mail-pf0-f177.google.com with SMTP id 78so223446432pfw.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 06:07:03 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/13] staging: wilc1000: fix return type of wilc_scan
Date: Tue,  5 Jan 2016 23:06:45 +0900
Message-Id: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160105_150708_081207_D38283CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_scan from s32 to int.
The result variable gets return value from wilc_mq_send that has data
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 27e18c9..7581c8f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3672,12 +3672,12 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 	return result;
 }
 
-s32 wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
+int wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
 	      u8 *pu8ChnlFreqList, u8 u8ChnlListLen, const u8 *pu8IEs,
 	      size_t IEsLen, wilc_scan_result ScanResult, void *pvUserArg,
 	      struct hidden_network *pstrHiddenNetwork)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 8541d16..4ff6b4f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -335,7 +335,7 @@ int wilc_flush_join_req(struct wilc_vif *vif);
 int wilc_disconnect(struct wilc_vif *vif, u16 reason_code);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level);
-s32 wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
+int wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
 	      u8 *pu8ChnlFreqList, u8 u8ChnlListLen, const u8 *pu8IEs,
 	      size_t IEsLen, wilc_scan_result ScanResult, void *pvUserArg,
 	      struct hidden_network *pstrHiddenNetwork);
-- 
2.6.4


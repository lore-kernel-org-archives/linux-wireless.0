Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50711 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759773Ab3ICMZO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 08:25:14 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 2/2] ath10k: remove obsolete INIT STATUS definitions
Date: Tue, 3 Sep 2013 14:24:03 +0200
Message-ID: <1378211043-20299-2-git-send-email-bartosz.markowski@tieto.com> (sfid-20130903_142520_945919_55DA8391)
In-Reply-To: <1378211043-20299-1-git-send-email-bartosz.markowski@tieto.com>
References: <1378211043-20299-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no functional changes. Just a small cleanup.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 08860c4..40fcf05 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -763,14 +763,6 @@ struct wmi_service_ready_event {
 	struct wlan_host_mem_req mem_reqs[1];
 } __packed;
 
-/*
- * status consists of  upper 16 bits fo int status and lower 16 bits of
- * module ID that retuned status
- */
-#define WLAN_INIT_STATUS_SUCCESS   0x0
-#define WLAN_GET_INIT_STATUS_REASON(status)    ((status) & 0xffff)
-#define WLAN_GET_INIT_STATUS_MODULE_ID(status) (((status) >> 16) & 0xffff)
-
 #define WMI_SERVICE_READY_TIMEOUT_HZ (5*HZ)
 #define WMI_UNIFIED_READY_TIMEOUT_HZ (5*HZ)
 
-- 
1.7.10


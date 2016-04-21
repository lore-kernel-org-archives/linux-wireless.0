Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34650 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbcDUVJp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 17:09:45 -0400
Received: by mail-pa0-f48.google.com with SMTP id r5so29464433pag.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2016 14:09:45 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: [PATCH] wcn36xx: Set SMD timeout to 10 seconds
Date: Thu, 21 Apr 2016 14:09:42 -0700
Message-Id: <1461272982-7233-1-git-send-email-bjorn.andersson@linaro.org> (sfid-20160421_231016_658316_511D0F64)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After booting the wireless subsystem and uploading the NV blob to the
WCNSS_CTRL service the remote continues to do things and will not start
servicing wlan-requests for another 2-5 seconds (measured).

The downstream code does not have any special handling for this case,
but has a timeout of 10 seconds for the communication layer. By
extending the wcn36xx timeout to match this we follows the same flow for
the boot procedure and can successfully configure WiFi as wlan0 is
registered.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.h b/drivers/net/wireless/ath/wcn36xx/smd.h
index e6aadd273c46..6310560901f0 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.h
+++ b/drivers/net/wireless/ath/wcn36xx/smd.h
@@ -24,7 +24,7 @@
 
 #define WCN36XX_HAL_BUF_SIZE				4096
 
-#define HAL_MSG_TIMEOUT 500
+#define HAL_MSG_TIMEOUT 10000
 #define WCN36XX_SMSM_WLAN_TX_ENABLE			0x00000400
 #define WCN36XX_SMSM_WLAN_TX_RINGS_EMPTY		0x00000200
 /* The PNO version info be contained in the rsp msg */
-- 
2.5.0


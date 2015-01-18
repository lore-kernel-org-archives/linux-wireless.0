Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50117 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbbARFKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 00:10:49 -0500
Subject: [PATCH 1/7] net: wireless: wcn36xx: add wcn3620 chip type definition
From: Andy Green <andy.green@linaro.org>
To: Kalle Valo <kvalo@codeaurora.org>,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Sun, 18 Jan 2015 13:10:43 +0800
Message-ID: <20150118051043.31866.53087.stgit@114-36-241-182.dynamic.hinet.net> (sfid-20150118_061057_372044_57461993)
In-Reply-To: <20150118050741.31866.36490.stgit@114-36-241-182.dynamic.hinet.net>
References: <20150118050741.31866.36490.stgit@114-36-241-182.dynamic.hinet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert the list of chip types to an enum, add the default
UNKNOWN type and a type for WCN3620 chip

Signed-off-by: Andy Green <andy.green@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index f0fb81d..a5366b6 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -93,6 +93,13 @@ struct nv_data {
 	u8	table;
 };
 
+enum wcn36xx_chip_type {
+	WCN36XX_CHIP_UNKNOWN,
+	WCN36XX_CHIP_3660,
+	WCN36XX_CHIP_3680,
+	WCN36XX_CHIP_3620,
+};
+
 /* Interface for platform control path
  *
  * @open: hook must be called when wcn36xx wants to open control channel.
@@ -179,7 +186,7 @@ struct wcn36xx {
 	u8			fw_minor;
 	u8			fw_major;
 	u32			fw_feat_caps[WCN36XX_HAL_CAPS_SIZE];
-	u32			chip_version;
+	enum wcn36xx_chip_type	chip_version;
 
 	/* extra byte for the NULL termination */
 	u8			crm_version[WCN36XX_HAL_VERSION_LENGTH + 1];
@@ -227,9 +234,6 @@ struct wcn36xx {
 
 };
 
-#define WCN36XX_CHIP_3660	0
-#define WCN36XX_CHIP_3680	1
-
 static inline bool wcn36xx_is_fw_version(struct wcn36xx *wcn,
 					 u8 major,
 					 u8 minor,


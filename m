Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43695 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab1JYKN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:13:58 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 27/34] ath6kl: Configure inteface information for multi vif support
Date: Tue, 25 Oct 2011 15:40:23 +0530
Message-ID: <1319537430-12459-28-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_121740_014376_8ED1CE1D)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Virtual interface information need to be configured during
init time to the target. Currently maximum of 3 vifs (STA, P2P dev
and P2P go/client).

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c   |   33 +++++++++++++++++++++++------
 drivers/net/wireless/ath/ath6kl/target.h |    3 ++
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index acd4455..1197ab6 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -429,10 +429,31 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
 int ath6kl_configure_target(struct ath6kl *ar)
 {
 	u32 param, ram_reserved_size;
-	u8 fw_iftype;
+	u8 fw_iftype, fw_mode = 0, fw_submode;
+	int i;
 
+	/*
+	 * Note: Even though the firmware interface type is
+	 * chosen as BSS_STA for all three interfaces, can
+	 * be configured to IBSS/AP as long as the fw submode
+	 * remains normal mode (0 - AP, STA and IBSS).
+	 */
 	fw_iftype = HI_OPTION_FW_MODE_BSS_STA;
 
+	for (i = 0; i < MAX_NUM_VIF; i++)
+		fw_mode |= fw_iftype << (i * HI_OPTION_FW_MODE_BITS);
+
+	/*
+	 * submodes : vif[0] - AP/STA/IBSS
+	 *	      vif[1] - "P2P dev"/"P2P GO"/"P2P Client"
+	 *	      vif[2] - "P2P dev"/"P2P GO"/"P2P Client"
+	 */
+	fw_submode = HI_OPTION_FW_SUBMODE_NONE |
+		     (HI_OPTION_FW_SUBMODE_P2PDEV <<
+		      (1 * HI_OPTION_FW_SUBMODE_BITS)) |
+		      (HI_OPTION_FW_SUBMODE_P2PDEV <<
+		      (2 * HI_OPTION_FW_SUBMODE_BITS));
+
 	/* Tell target which HTC version it is used*/
 	param = HTC_PROTOCOL_VERSION;
 	if (ath6kl_bmi_write(ar,
@@ -454,12 +475,10 @@ int ath6kl_configure_target(struct ath6kl *ar)
 		return -EIO;
 	}
 
-	param |= (1 << HI_OPTION_NUM_DEV_SHIFT);
-	param |= (fw_iftype << HI_OPTION_FW_MODE_SHIFT);
-	if (ar->p2p && fw_iftype == HI_OPTION_FW_MODE_BSS_STA) {
-		param |= HI_OPTION_FW_SUBMODE_P2PDEV <<
-			HI_OPTION_FW_SUBMODE_SHIFT;
-	}
+	param |= (MAX_NUM_VIF << HI_OPTION_NUM_DEV_SHIFT);
+	param |= fw_mode << HI_OPTION_FW_MODE_SHIFT;
+	param |= fw_submode << HI_OPTION_FW_SUBMODE_SHIFT;
+
 	param |= (0 << HI_OPTION_MAC_ADDR_METHOD_SHIFT);
 	param |= (0 << HI_OPTION_FW_BRIDGE_SHIFT);
 
diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index c9a7605..687e2b3 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -320,7 +320,10 @@ struct host_interest {
 |   (2)   |   (2)   |   (2)   |   (2)   |   (2)   |   (2)   |   (2)   |   (2)
 |------------------------------------------------------------------------------|
 */
+#define HI_OPTION_FW_MODE_BITS	       0x2
 #define HI_OPTION_FW_MODE_SHIFT        0xC
+
+#define HI_OPTION_FW_SUBMODE_BITS      0x2
 #define HI_OPTION_FW_SUBMODE_SHIFT     0x14
 
 /* Convert a Target virtual address into a Target physical address */
-- 
1.7.0.4


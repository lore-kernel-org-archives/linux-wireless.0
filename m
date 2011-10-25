Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25573 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413Ab1JYOEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:04:35 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 04/31] ath6kl: Cleanup fw interface type setting
Date: Tue, 25 Oct 2011 19:33:59 +0530
Message-ID: <1319551466-29070-5-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160439_462749_507EB4AE)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not necessary to use ath6kl_get_fw_iftype() to find out the
firmware interface type during initialization because the type
of the initial interface in INFRA_NETWORK. Hardcode the fw interface
type corresponding to INFRA_BSS instead of using ath6kl_get_fw_iftype().

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 6bbfe6f..7720177 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -91,21 +91,6 @@ void ath6kl_init_profile_info(struct ath6kl *ar)
 	ar->nw_type = ar->next_mode = INFRA_NETWORK;
 }
 
-static u8 ath6kl_get_fw_iftype(struct ath6kl *ar)
-{
-	switch (ar->nw_type) {
-	case INFRA_NETWORK:
-		return HI_OPTION_FW_MODE_BSS_STA;
-	case ADHOC_NETWORK:
-		return HI_OPTION_FW_MODE_IBSS;
-	case AP_NETWORK:
-		return HI_OPTION_FW_MODE_AP;
-	default:
-		ath6kl_err("Unsupported interface type :%d\n", ar->nw_type);
-		return 0xff;
-	}
-}
-
 static int ath6kl_set_host_app_area(struct ath6kl *ar)
 {
 	u32 address, data;
@@ -446,9 +431,7 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	u32 param, ram_reserved_size;
 	u8 fw_iftype;
 
-	fw_iftype = ath6kl_get_fw_iftype(ar);
-	if (fw_iftype == 0xff)
-		return -EINVAL;
+	fw_iftype = HI_OPTION_FW_MODE_BSS_STA;
 
 	/* Tell target which HTC version it is used*/
 	param = HTC_PROTOCOL_VERSION;
-- 
1.7.0.4


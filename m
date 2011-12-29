Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61838 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1L2Kig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Dec 2011 05:38:36 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 3/3] ath6kl: Remove few deadcode in main.c
Date: Thu, 29 Dec 2011 16:05:39 +0530
Message-ID: <1325154939-6986-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111229_113839_870033_515C78F1)
In-Reply-To: <1325154939-6986-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1325154939-6986-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1. In ath6kl_add_new_sta(), if (ielen <= ATH6KL_MAX_IE) is going to be
always true due to ielen being u8 and is checked against 256.

2. In ath6kl_reset_device(), since control can never reach switch..case
when the target_type is neither TARGET_TYPE_AR6003 nor TARGET_TYPE_AR6004,
remove the default option of switch statement.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index eea3c74..ff447b0 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -62,8 +62,7 @@ static void ath6kl_add_new_sta(struct ath6kl *ar, u8 *mac, u16 aid, u8 *wpaie,
 
 	sta = &ar->sta_list[free_slot];
 	memcpy(sta->mac, mac, ETH_ALEN);
-	if (ielen <= ATH6KL_MAX_IE)
-		memcpy(sta->wpa_ie, wpaie, ielen);
+	memcpy(sta->wpa_ie, wpaie, ielen);
 	sta->aid = aid;
 	sta->keymgmt = keymgmt;
 	sta->ucipher = ucipher;
@@ -347,9 +346,6 @@ void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
 	case TARGET_TYPE_AR6004:
 		address = AR6004_RESET_CONTROL_ADDRESS;
 		break;
-	default:
-		address = AR6003_RESET_CONTROL_ADDRESS;
-		break;
 	}
 
 	status = ath6kl_diag_write32(ar, address, data);
-- 
1.7.0.4


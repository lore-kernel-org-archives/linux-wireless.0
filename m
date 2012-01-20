Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53288 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab2ATPwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 10:52:32 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 4/6] ath6kl: Pass vif instead of ar to ath6kl_add_new_sta()
Date: Fri, 20 Jan 2012 21:22:00 +0530
Message-ID: <1327074722-3492-4-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120120_165235_401464_50426280)
In-Reply-To: <1327074722-3492-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1327074722-3492-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be used when initializing station specific aggregation
information.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 3a3b2cc..acb4acb 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -52,10 +52,11 @@ struct ath6kl_sta *ath6kl_find_sta_by_aid(struct ath6kl *ar, u8 aid)
 	return conn;
 }
 
-static void ath6kl_add_new_sta(struct ath6kl *ar, u8 *mac, u16 aid, u8 *wpaie,
-			       size_t ielen, u8 keymgmt, u8 ucipher, u8 auth,
-			       u8 apsd_info)
+static void ath6kl_add_new_sta(struct ath6kl_vif *vif, u8 *mac, u16 aid,
+			       u8 *wpaie, size_t ielen, u8 keymgmt,
+			       u8 ucipher, u8 auth, u8 apsd_info)
 {
+	struct ath6kl *ar = vif->ar;
 	struct ath6kl_sta *sta;
 	u8 free_slot;
 
@@ -430,7 +431,6 @@ void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 				u8 keymgmt, u8 ucipher, u8 auth,
 				u8 assoc_req_len, u8 *assoc_info, u8 apsd_info)
 {
-	struct ath6kl *ar = vif->ar;
 	u8 *ies = NULL, *wpa_ie = NULL, *pos;
 	size_t ies_len = 0;
 	struct station_info sinfo;
@@ -484,7 +484,7 @@ void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 		pos += 2 + pos[1];
 	}
 
-	ath6kl_add_new_sta(ar, mac_addr, aid, wpa_ie,
+	ath6kl_add_new_sta(vif, mac_addr, aid, wpa_ie,
 			   wpa_ie ? 2 + wpa_ie[1] : 0,
 			   keymgmt, ucipher, auth, apsd_info);
 
-- 
1.7.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:43967 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab1KNRbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 12:31:42 -0500
Subject: [PATCH 10/10] ath6kl: add firmware IE for maximum number of vifs
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Nov 2011 19:31:38 +0200
Message-ID: <20111114173138.29925.77938.stgit@localhost6.localdomain6> (sfid-20111114_183145_534130_9EAFCFC0)
In-Reply-To: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
References: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not all firmwares support multiple vifs and we need to read the limit from
the firmware image.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    3 ++-
 drivers/net/wireless/ath/ath6kl/init.c |   11 +++++++++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 6fdaaf7..b185564 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -71,6 +71,7 @@ enum ath6kl_fw_ie_type {
 	ATH6KL_FW_IE_CAPABILITIES = 6,
 	ATH6KL_FW_IE_PATCH_ADDR = 7,
 	ATH6KL_FW_IE_BOARD_ADDR = 8,
+	ATH6KL_FW_IE_VIF_MAX = 9,
 };
 
 enum ath6kl_fw_capability {
@@ -502,7 +503,7 @@ struct ath6kl {
 	/* Lock to avoid race in vif_list entries among add/del/traverse */
 	spinlock_t list_lock;
 	u8 num_vif;
-	int vif_max;
+	unsigned int vif_max;
 	u8 max_norm_iface;
 	u8 avail_idx_map;
 	spinlock_t lock;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 0f72461..6c4f6a9 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -963,6 +963,17 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 				   "found board address ie 0x%x\n",
 				   ar->hw.board_addr);
 			break;
+		case ATH6KL_FW_IE_VIF_MAX:
+			if (ie_len != sizeof(*val))
+				break;
+
+			val = (__le32 *) data;
+			ar->vif_max = min_t(unsigned int, le32_to_cpup(val),
+					    ATH6KL_VIF_MAX);
+
+			ath6kl_dbg(ATH6KL_DBG_BOOT,
+				   "found vif max ie %d\n", ar->vif_max);
+			break;
 		default:
 			ath6kl_dbg(ATH6KL_DBG_BOOT, "Unknown fw ie: %u\n",
 				   le32_to_cpup(&hdr->id));


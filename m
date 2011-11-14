Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:50559 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1KNRav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 12:30:51 -0500
Subject: [PATCH 04/10] ath6kl: add firmware IE for board data address
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Nov 2011 19:30:47 +0200
Message-ID: <20111114173047.29925.52760.stgit@localhost6.localdomain6> (sfid-20111114_183053_347109_BFACBF72)
In-Reply-To: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
References: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Board data address can change between firmwares so we need to read that
from the firmware image.

Also fix debug log for the patch address to print the address in hex.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 +
 drivers/net/wireless/ath/ath6kl/init.c |   13 ++++++++++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 83167be..6227f11 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -70,6 +70,7 @@ enum ath6kl_fw_ie_type {
 	ATH6KL_FW_IE_RESERVED_RAM_SIZE = 5,
 	ATH6KL_FW_IE_CAPABILITIES = 6,
 	ATH6KL_FW_IE_PATCH_ADDR = 7,
+	ATH6KL_FW_IE_BOARD_ADDR = 8,
 };
 
 enum ath6kl_fw_capability {
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index bed468d..0b0ae5e 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -976,9 +976,20 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 			ar->hw.dataset_patch_addr = le32_to_cpup(val);
 
 			ath6kl_dbg(ATH6KL_DBG_BOOT,
-				   "found patch address ie 0x%d\n",
+				   "found patch address ie 0x%x\n",
 				   ar->hw.dataset_patch_addr);
 			break;
+		case ATH6KL_FW_IE_BOARD_ADDR:
+			if (ie_len != sizeof(*val))
+				break;
+
+			val = (__le32 *) data;
+			ar->hw.board_addr = le32_to_cpup(val);
+
+			ath6kl_dbg(ATH6KL_DBG_BOOT,
+				   "found board address ie 0x%x\n",
+				   ar->hw.board_addr);
+			break;
 		default:
 			ath6kl_dbg(ATH6KL_DBG_BOOT, "Unknown fw ie: %u\n",
 				   le32_to_cpup(&hdr->id));


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:46820 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1I0IFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 04:05:31 -0400
Subject: [PATCH] ath6kl: allow firmware to override firmware patch address
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Sep 2011 11:05:26 +0300
Message-ID: <20110927080526.29124.97405.stgit@localhost6.localdomain6> (sfid-20110927_100536_870175_A31B0F0A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some firmware versions their patch address has changed. If the firmware
provides one, use it to override the default address.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 +
 drivers/net/wireless/ath/ath6kl/init.c |    7 +++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 82be42f..9ecf22b 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -69,6 +69,7 @@ enum ath6kl_fw_ie_type {
 	ATH6KL_FW_IE_PATCH_IMAGE = 4,
 	ATH6KL_FW_IE_RESERVED_RAM_SIZE = 5,
 	ATH6KL_FW_IE_CAPABILITIES = 6,
+	ATH6KL_FW_IE_PATCH_ADDR = 7,
 };
 
 enum ath6kl_fw_capability {
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 80c532d..e9785fe 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1000,6 +1000,13 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 					__set_bit(i, ar->fw_capabilities);
 			}
 			break;
+		case ATH6KL_FW_IE_PATCH_ADDR:
+			if (ie_len != sizeof(*val))
+				break;
+
+			val = (__le32 *) data;
+			ar->hw.dataset_patch_addr = le32_to_cpup(val);
+			break;
 		default:
 			ath6kl_dbg(ATH6KL_DBG_TRC, "Unknown fw ie: %u\n",
 				   le32_to_cpup(&hdr->id));


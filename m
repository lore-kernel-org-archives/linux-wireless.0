Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:49077 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab1ILLNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 07:13:10 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh07-2.mail.saunalahti.fi (Postfix) with SMTP id AB1B518CFD0
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:13:09 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh05.mail.saunalahti.fi (Postfix) with ESMTP id 8FBDE27D85
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:13:08 +0300 (EEST)
Subject: [PATCH 9/9] ath6kl: add firmware capabilities support
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Mon, 12 Sep 2011 14:13:08 +0300
Message-ID: <20110912111308.16921.94633.stgit@localhost6.localdomain6> (sfid-20110912_131313_336353_95383426)
In-Reply-To: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
References: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new firmware format includes capability bits which make it
possible to check what features the firmware supports. Add infrastructure
to read the capabilities. For now it only provides
ATH6KL_FW_CAPABILITY_HOST_P2P which is not even used anywhere yet, but that
will be added later.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |   12 ++++++++++++
 drivers/net/wireless/ath/ath6kl/init.c |   11 ++++++++++-
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index abb4aaf..0fb82e9 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -68,8 +68,18 @@ enum ath6kl_fw_ie_type {
 	ATH6KL_FW_IE_FW_IMAGE = 3,
 	ATH6KL_FW_IE_PATCH_IMAGE = 4,
 	ATH6KL_FW_IE_RESERVED_RAM_SIZE = 5,
+	ATH6KL_FW_IE_CAPABILITIES = 6,
 };
 
+enum ath6kl_fw_capability {
+	ATH6KL_FW_CAPABILITY_HOST_P2P = 0,
+
+	/* this needs to be last */
+	ATH6KL_FW_CAPABILITY_MAX,
+};
+
+#define ATH6KL_CAPABILITY_LEN (ALIGN(ATH6KL_FW_CAPABILITY_MAX, 32) / 32)
+
 struct ath6kl_fw_ie {
 	__le32 id;
 	__le32 len;
@@ -491,6 +501,8 @@ struct ath6kl {
 	u8 *fw_patch;
 	size_t fw_patch_len;
 
+	unsigned long fw_capabilities[ATH6KL_CAPABILITY_LEN];
+
 	struct workqueue_struct *ath6kl_wq;
 
 	struct ath6kl_node_table scan_table;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index e2a29b2..b9b13a0 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -901,7 +901,7 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 	struct ath6kl_fw_ie *hdr;
 	const char *filename;
 	const u8 *data;
-	int ret, ie_id;
+	int ret, ie_id, i, index, bit;
 	__le32 *val;
 
 	switch (ar->version.target_ver) {
@@ -992,6 +992,15 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 			val = (__le32 *) data;
 			ar->hw.reserved_ram_size = le32_to_cpup(val);
 			break;
+		case ATH6KL_FW_IE_CAPABILITIES:
+			for (i = 0; i < ATH6KL_FW_CAPABILITY_MAX; i++) {
+				index = ALIGN(i, 8) / 8;
+				bit = i % 8;
+
+				if (data[index] & (1 << bit))
+					__set_bit(i, ar->fw_capabilities);
+			}
+			break;
 		default:
 			ath6kl_dbg(ATH6KL_DBG_TRC, "Unknown fw ie: %u\n",
 				   le32_to_cpup(&hdr->id));


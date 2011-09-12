Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:38677 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab1ILLNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 07:13:05 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh04-2.mail.saunalahti.fi (Postfix) with SMTP id 20E3313BB1E
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:13:03 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id 09273158A68
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:13:01 +0300 (EEST)
Subject: [PATCH 8/9] ath6kl: read reserved ram size from firmware file
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Mon, 12 Sep 2011 14:13:01 +0300
Message-ID: <20110912111301.16921.52795.stgit@localhost6.localdomain6> (sfid-20110912_131308_623400_75312CEE)
In-Reply-To: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
References: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A new version of firmware needs different reserved ram size so read that
from the firmware image.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 +
 drivers/net/wireless/ath/ath6kl/init.c |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 3365dc8..abb4aaf 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -67,6 +67,7 @@ enum ath6kl_fw_ie_type {
 	ATH6KL_FW_IE_OTP_IMAGE = 2,
 	ATH6KL_FW_IE_FW_IMAGE = 3,
 	ATH6KL_FW_IE_PATCH_IMAGE = 4,
+	ATH6KL_FW_IE_RESERVED_RAM_SIZE = 5,
 };
 
 struct ath6kl_fw_ie {
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 5865466..e2a29b2 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -902,6 +902,7 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 	const char *filename;
 	const u8 *data;
 	int ret, ie_id;
+	__le32 *val;
 
 	switch (ar->version.target_ver) {
 	case AR6003_REV2_VERSION:
@@ -987,6 +988,10 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 
 			ar->fw_patch_len = ie_len;
 			break;
+		case ATH6KL_FW_IE_RESERVED_RAM_SIZE:
+			val = (__le32 *) data;
+			ar->hw.reserved_ram_size = le32_to_cpup(val);
+			break;
 		default:
 			ath6kl_dbg(ATH6KL_DBG_TRC, "Unknown fw ie: %u\n",
 				   le32_to_cpup(&hdr->id));


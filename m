Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:56732 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1KKKS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 05:18:26 -0500
Subject: [PATCH 07/10] ath6kl: add hif_type
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 Nov 2011 12:18:22 +0200
Message-ID: <20111111101822.12075.30682.stgit@localhost6.localdomain6> (sfid-20111111_111829_509521_38C3A735)
In-Reply-To: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
References: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some rare cases core code needs to know what hif type is used. Add
a field to struct ath6kl to denote that. Hopefully this is just a
temporary solution.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    6 ++++++
 drivers/net/wireless/ath/ath6kl/sdio.c |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 415fa00..03e378d 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -391,6 +391,11 @@ struct ath6kl_req_key {
 	u8 key_len;
 };
 
+enum ath6kl_hif_type {
+	ATH6KL_HIF_TYPE_SDIO,
+	ATH6KL_HIF_TYPE_USB,
+};
+
 #define MAX_NUM_VIF	1
 
 /* vif flags info */
@@ -484,6 +489,7 @@ struct ath6kl {
 	int tx_pending[ENDPOINT_MAX];
 	int total_tx_data_pend;
 	struct htc_target *htc_target;
+	enum ath6kl_hif_type hif_type;
 	void *hif_priv;
 	struct list_head vif_list;
 	/* Lock to avoid race in vif_list entries among add/del/traverse */
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 3ae7582..2fbe5f4 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1238,6 +1238,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 	}
 
 	ar_sdio->ar = ar;
+	ar->hif_type = ATH6KL_HIF_TYPE_SDIO;
 	ar->hif_priv = ar_sdio;
 	ar->hif_ops = &ath6kl_sdio_ops;
 	ar->bmi.max_data_size = 256;


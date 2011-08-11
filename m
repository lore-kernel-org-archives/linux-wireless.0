Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23187 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1HKGtM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 02:49:12 -0400
From: Kevin Fang <chienf@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	Kevin Fang <chienf@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 3/7] ath6kl: Add hif type field to identify target hif type
Date: Thu, 11 Aug 2011 14:48:11 +0800
Message-ID: <1313045295-16202-3-git-send-email-kevin.fang@qca.qualcomm.com> (sfid-20110811_084914_906805_4F273599)
In-Reply-To: <1313045295-16202-1-git-send-email-kevin.fang@qca.qualcomm.com>
References: <1313045295-16202-1-git-send-email-kevin.fang@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a hif type field on the ath6kl structure to
distinguish between sdio or usb interface.

Signed-off-by: Kevin Fang <kevin.fang@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    6 ++++++
 drivers/net/wireless/ath/ath6kl/sdio.c |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 0f7b0c0..768c349 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -369,6 +369,11 @@ struct ath6kl_req_key {
 #define SKIP_SCAN	     11
 #define WLAN_ENABLED	     12
 
+enum hif_type {
+	HIF_TYPE_SDIO,
+	HIF_TYPE_USB
+};
+
 struct ath6kl {
 	struct device *dev;
 	struct net_device *net_dev;
@@ -378,6 +383,7 @@ struct ath6kl {
 	int tx_pending[ENDPOINT_MAX];
 	int total_tx_data_pend;
 	struct htc_target *htc_target;
+	enum hif_type hif_type;
 	void *hif_priv;
 	spinlock_t lock;
 	struct semaphore sem;
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 0fb06fc..e5a5563 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -884,6 +884,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 
 	ar_sdio->ar = ar;
 	ar->hif_priv = ar_sdio;
+	ar->hif_type = HIF_TYPE_SDIO;
 	ar->hif_ops = &ath6kl_sdio_ops;
 
 	ath6kl_sdio_set_mbox_info(ar);
-- 
1.7.0.4


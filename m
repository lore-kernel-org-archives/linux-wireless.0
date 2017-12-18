Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57706 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752603AbdLRPDy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 10:03:54 -0500
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath10k: wmi: remove redundant integer fc
Date: Mon, 18 Dec 2017 15:02:45 +0000
Message-Id: <20171218150245.9073-1-colin.king@canonical.com> (sfid-20171218_160423_393127_98C1DC9D)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Variable fc is being assigned but never used, so remove it. Cleans
up the clang warning:

warning: Value stored to 'fc' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 8d53063bd503..06fde53aa679 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2494,7 +2494,6 @@ ath10k_wmi_tlv_op_gen_mgmt_tx(struct ath10k *ar, struct sk_buff *msdu)
 	void *ptr;
 	int len;
 	u32 buf_len = msdu->len;
-	u16 fc;
 	struct ath10k_vif *arvif;
 	dma_addr_t mgmt_frame_dma;
 	u32 vdev_id;
@@ -2503,7 +2502,6 @@ ath10k_wmi_tlv_op_gen_mgmt_tx(struct ath10k *ar, struct sk_buff *msdu)
 		return ERR_PTR(-EINVAL);
 
 	hdr = (struct ieee80211_hdr *)msdu->data;
-	fc = le16_to_cpu(hdr->frame_control);
 	arvif = (void *)cb->vif->drv_priv;
 	vdev_id = arvif->vdev_id;
 
-- 
2.14.1

Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E88EB64D9
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Jul 2023 10:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbjGGKww (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Jul 2023 06:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjGGKwt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2023 06:52:49 -0400
Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [178.154.239.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9241994
        for <linux-wireless@vger.kernel.org>; Fri,  7 Jul 2023 03:52:47 -0700 (PDT)
Received: from mail-nwsmtp-smtp-production-main-18.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-18.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:5f1d:0:640:49bf:0])
        by forward100a.mail.yandex.net (Yandex) with ESMTP id CCF2C46CD9;
        Fri,  7 Jul 2023 13:52:45 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-18.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id jqS2XrLDX0U0-DPymzbai;
        Fri, 07 Jul 2023 13:52:45 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1688727165;
        bh=X03PZEGyOlJUStvc5FVgbUoZ8zqRvoqEPTPhNtvXIPU=;
        h=Message-ID:Date:Cc:Subject:To:From;
        b=Tz95Xu3Kl2n0FSApJv9YUvCd1UDS53uG4w5UjNNu4DV4GazDc8b6SujiT/eVwKMrw
         iddfR51g0Go2X3PBv/qpObF7EaXdDVOrpeRvsIy2qYtI69+eRljR+gxu1ZyRTUf6Co
         q02CVZt1cxDlE8JapUVQPy1GGUndT9+4/auVblh4=
Authentication-Results: mail-nwsmtp-smtp-production-main-18.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From:   Dmitry Antipov <dmantipov@yandex.ru>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Rakesh Pillai <quic_pillair@quicinc.com>,
        linux-wireless@vger.kernel.org,
        Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] wifi: ath10k: fix memory leak in WMI management
Date:   Fri,  7 Jul 2023 13:52:26 +0300
Message-ID: <20230707105243.22824-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since 'mgmt_pending_tx' of 'struct ath10k_wmi' contains pointers
to dynamically allocated 'struct ath10k_mgmt_tx_pkt_addr' objects,
these objects should be explicitly freed when removing from idr
or when the whole idr is destroyed.

Fixes: dc405152bb64 ("ath10k: handle mgmt tx completion event")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 11 +++++++++--
 drivers/net/wireless/ath/ath10k/wmi.c     |  5 +++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 6b6aa3c36744..45a445c5f1df 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3038,11 +3038,18 @@ ath10k_wmi_tlv_op_cleanup_mgmt_tx_send(struct ath10k *ar,
 				       struct sk_buff *msdu)
 {
 	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(msdu);
+	struct ath10k_mgmt_tx_pkt_addr *pkt_addr;
 	struct ath10k_wmi *wmi = &ar->wmi;
 
-	idr_remove(&wmi->mgmt_pending_tx, cb->msdu_id);
+	pkt_addr = idr_find(&wmi->mgmt_pending_tx, cb->msdu_id);
+	if (pkt_addr) {
+		idr_remove(&wmi->mgmt_pending_tx, cb->msdu_id);
+		kfree(pkt_addr);
+		return 0;
+	}
 
-	return 0;
+	ath10k_warn(ar, "invalid msdu_id: %d\n", cb->msdu_id);
+	return -ENOENT;
 }
 
 static int
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 05fa7d4c0e1a..20534a7d6551 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2433,9 +2433,9 @@ wmi_process_mgmt_tx_comp(struct ath10k *ar, struct mgmt_tx_compl_params *param)
 	ieee80211_tx_status_irqsafe(ar->hw, msdu);
 
 	ret = 0;
-
-out:
 	idr_remove(&wmi->mgmt_pending_tx, param->desc_id);
+	kfree(pkt_addr);
+out:
 	spin_unlock_bh(&ar->data_lock);
 	return ret;
 }
@@ -9539,6 +9539,7 @@ static int ath10k_wmi_mgmt_tx_clean_up_pending(int msdu_id, void *ptr,
 	dma_unmap_single(ar->dev, pkt_addr->paddr,
 			 msdu->len, DMA_TO_DEVICE);
 	ieee80211_free_txskb(ar->hw, msdu);
+	kfree(pkt_addr);
 
 	return 0;
 }
-- 
2.41.0


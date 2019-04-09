Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9512AC10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CE762084F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H0Au3SmX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfDITNN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 15:13:13 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39132 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfDITNM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 15:13:12 -0400
Received: by mail-lf1-f65.google.com with SMTP id z9so4642037lfh.6
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 12:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6MzNwas+kmvZBqXFHalYjmibG7bDEawjRv+w+Gt/Y+4=;
        b=H0Au3SmX5gAs+c5l4QrTplUbRGj0r3VxLcYT/wYK9n+ecLK65XKTMBHrME5Ne7gUXi
         LgYUs/sETeTfAcVvv0+1fTR0CWF97bJhXD3VOsFoBncz1bOO292Li9d6QJ4H6MMC/aDh
         ht6Q2NnC7p3S44p2d/Iu87BARAKCnp93abCsuAmLo36SjOpvVQ1LPOcg8ohlUejLo8bq
         OCbV7xMDArjJgb/V0ZEtM6wQf9jBpK6OvDAr35TYMxceDOBMQsKwltBUkIHUo/8EIbNf
         Pi41JMAkU+xRNkK1uFkICnEuQ6ebbyMqGDTIHGj+MjLf6dzP0oOqOY28f2xui3afxt+9
         UAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6MzNwas+kmvZBqXFHalYjmibG7bDEawjRv+w+Gt/Y+4=;
        b=Mx6c3Qgx39M7cFgPucVUHf2LKwbBFCsqeW6arLYZCqlDD6RfyMap3/9gLQI5RYgVLN
         HlDd6YyJLjSBmrTASRDmhwglYELpn7tmHDF/17Fx+H6w3lkc3YdFDa2EB4wiCmlk8Xli
         aSzMbY3xfzewfhvxQ0Pdp16ZNIKmIPaB+0Rxhl+GNXMrI5QNTh8bMxzTHqBG01Nz1gs5
         Mt3Z+ovvzDjkWj1IWy7ZSii6I+P88CPNS8sLzBkQnphWhewHqsZhouPQnYCTtlZmA4Fi
         dPy1Vcb9cDxReiFETWsfSR8vrJHPOP5t1dMROhKXqevcvvVq+TA3efb40qe3EAJ3fRsd
         8owg==
X-Gm-Message-State: APjAAAWpJybI9Wx217E5k1cwf2Zt0AQFZ6NVs2kh1VDuQ543ASkJPMN7
        OvibwA+sq6/YEwDSvVGc51A=
X-Google-Smtp-Source: APXvYqxU2XfwiOpjOnQOzw3phiopNazl9V+ZaRz5pCJUVcc2xDtcHLAGIH/8CSgWMYwx36wFYkVDDQ==
X-Received: by 2002:a19:e30b:: with SMTP id a11mr9039046lfh.4.1554837191052;
        Tue, 09 Apr 2019 12:13:11 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id q64sm6807848ljq.76.2019.04.09.12.13.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2019 12:13:10 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Alagu Sankar <alagusankar@silex-india.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 4/6] ath10k: sdio: add MSDU ID allocation in HTT TX path
Date:   Tue,  9 Apr 2019 21:08:49 +0200
Message-Id: <20190409190851.4557-5-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190409190851.4557-1-erik.stromdahl@gmail.com>
References: <20190409190851.4557-1-erik.stromdahl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alagu Sankar <alagusankar@silex-india.com>

This makes the SDIO HTT TX path more similar to PCIe.
Transmit completion for SDIO is similar to PCIe, via the T2H message
HTT_T2H_MSG_TYPE_TX_COMPL_IND. This means that we will create a unique
MSDU ID for each transmitted frame just as we do in the PCIe case.

As a result of this, the TX skb will be freed when we receive the
HTT_T2H_MSG_TYPE_TX_COMPL_IND message. Thus, we must not free the skb in
the HTT ep_tx_complete handler in the SDIO case.

Co-developed-by: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |  4 +++-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 16 ++++++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a20ea270d519..6e3331b96c0f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2277,7 +2277,9 @@ static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
 		 *  Note that with only one concurrent reader and one concurrent
 		 *  writer, you don't need extra locking to use these macro.
 		 */
-		if (!kfifo_put(&htt->txdone_fifo, tx_done)) {
+		if (ar->hif.bus == ATH10K_BUS_SDIO) {
+			ath10k_txrx_tx_unref(htt, &tx_done);
+		} else if (!kfifo_put(&htt->txdone_fifo, tx_done)) {
 			ath10k_warn(ar, "txdone fifo overrun, msdu_id %d status %d\n",
 				    tx_done.msdu_id, tx_done.status);
 			ath10k_txrx_tx_unref(htt, &tx_done);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 619c2b87b8bb..e5e6e206a52f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -543,7 +543,8 @@ void ath10k_htt_tx_free(struct ath10k_htt *htt)
 
 void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
 {
-	dev_kfree_skb_any(skb);
+	if (!(ar->hif.bus == ATH10K_BUS_SDIO))
+		dev_kfree_skb_any(skb);
 }
 
 void ath10k_htt_hif_tx_complete(struct ath10k *ar, struct sk_buff *skb)
@@ -1244,6 +1245,7 @@ static int ath10k_htt_tx_hl(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txm
 	u8 tid = ath10k_htt_tx_get_tid(msdu, is_eth);
 	u8 flags0 = 0;
 	u16 flags1 = 0;
+	u16 msdu_id = 0;
 
 	data_len = msdu->len;
 
@@ -1291,6 +1293,16 @@ static int ath10k_htt_tx_hl(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txm
 		}
 	}
 
+	if (ar->hif.bus == ATH10K_BUS_SDIO) {
+		flags1 |= HTT_DATA_TX_DESC_FLAGS1_POSTPONED;
+		res = ath10k_htt_tx_alloc_msdu_id(htt, msdu);
+		if (res < 0) {
+			ath10k_err(ar, "msdu_id allocation failed %d\n", res);
+			goto out;
+		}
+		msdu_id = res;
+	}
+
 	skb_push(msdu, sizeof(*cmd_hdr));
 	skb_push(msdu, sizeof(*tx_desc));
 	cmd_hdr = (struct htt_cmd_hdr *)msdu->data;
@@ -1300,7 +1312,7 @@ static int ath10k_htt_tx_hl(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txm
 	tx_desc->flags0 = flags0;
 	tx_desc->flags1 = __cpu_to_le16(flags1);
 	tx_desc->len = __cpu_to_le16(data_len);
-	tx_desc->id = 0;
+	tx_desc->id = __cpu_to_le16(msdu_id);
 	tx_desc->frags_paddr = 0; /* always zero */
 	/* Initialize peer_id to INVALID_PEER because this is NOT
 	 * Reinjection path
-- 
2.19.1


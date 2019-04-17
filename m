Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7975BC282DF
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 19:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B4F52073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 19:15:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hx5YmAFe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733308AbfDQTPc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 15:15:32 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43296 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733091AbfDQTPb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 15:15:31 -0400
Received: by mail-lf1-f66.google.com with SMTP id i68so8800233lfi.10
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 12:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jZ6xJSFXrr32q23CdgPPoHM1qKrQGi5+H6/8J0uQwE8=;
        b=Hx5YmAFetfno0GzwrgYrz62duOq7uF2hzvp2bvyGH7u8xYK6PFpNC5cf6wvf4XHsbn
         b2+uWybG8sgckIIcmnK1KAuTyIgU8ylnPooKo+oMiOAZl1ZdaVB/t18//N+OsfPDBKaH
         fmvJOqhaumXMekMeuERq2dd6jRKpZzRP1jNzSSIBmlRkhuCy2KXC2DJZJaYh3f1Wjbck
         xR2o6TmQQ/5aXHGA/A9o2ZxcLvbAnl+WB1zRcDrYfyd9S5qW/VC2HCMD3IDrYuuT+v8Z
         gLqFLk2o3nLh9gYLWZagoN9MgWduNyaS0Ng1xVtX9uhWSHgHAqzFOcwxgCkuw4BrBPjN
         eHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jZ6xJSFXrr32q23CdgPPoHM1qKrQGi5+H6/8J0uQwE8=;
        b=roqYFNu06EwBdFjcy4IuaG5s0fpQ4Ht8GC1YPDu9j6lIIntGXxMh7xiNn5RnNErm4p
         rwTUW5S+9mrrFSBVOSvAV/tCfWWSPh6qXlZB9blq9965NIkg1k9+Pr+9frvnShPstab0
         zU/YoPnQF+lxi6Egn47CcPD+4Kgb49dysRaMRjfwpESLZsS9sqSpYAM1qxvMnrixA0v4
         YS9cyVIaoZQh/TWCjaG4rQD1Z+2ApKsddV78XXJaWZoY3RSD88gdypqHQOM9ZhQ6j2xI
         huxf7v6MDHB7eB5W4iHjojXPs7GHdcFjINL8lHKv5U1Urh8vaLR0xu0j3+RpDj6kpf3V
         uTvw==
X-Gm-Message-State: APjAAAVsSyr7EhPttesrD0NDLDIMfPe4sYZXePgrbzFAXXpeijwBv9DR
        mXdrsvla+otO/VfUVEABolWuimpf
X-Google-Smtp-Source: APXvYqy5TjJWEO6DvmONVda7/RFQRd5RtyJSEn5o8ZE2/ROrf1kKkZbx08moLLi9x3QJsfNgqPrRSQ==
X-Received: by 2002:ac2:446b:: with SMTP id y11mr774792lfl.155.1555528528579;
        Wed, 17 Apr 2019 12:15:28 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id j27sm11387203lfk.97.2019.04.17.12.15.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 12:15:28 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Alagu Sankar <alagusankar@silex-india.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH v2 3/5] ath10k: sdio: read RX packets in bundles
Date:   Wed, 17 Apr 2019 21:15:01 +0200
Message-Id: <20190417191503.18814-4-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190417191503.18814-1-erik.stromdahl@gmail.com>
References: <20190417191503.18814-1-erik.stromdahl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alagu Sankar <alagusankar@silex-india.com>

The existing implementation of initiating multiple sdio transfers for
receive bundling is slowing down the receive speed.

Instead of having one sdio transfer for each packet in the bundle, we
read all packets in one sdio transfer.

This results in significant performance improvement on some targets.

On an imx6dl together with a QCA9377 SDIO device, the following
performance increase was obtained with iperf:

Before:

[  3]  0.0- 1.0 sec  3.38 MBytes  28.3 Mbits/sec

After:

[  3]  0.0- 1.0 sec  7.12 MBytes  59.8 Mbits/sec

Co-developed-by: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 71 +++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/sdio.h |  2 +
 2 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index d5073fac9509..b89732aad97c 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -24,6 +24,8 @@
 #include "trace.h"
 #include "sdio.h"
 
+#define ATH10K_SDIO_READ_BUF_SIZE	(32 * 1024)
+
 /* inlined helper functions */
 
 static inline int ath10k_sdio_calc_txrx_padded_len(struct ath10k_sdio *ar_sdio,
@@ -618,41 +620,73 @@ static int ath10k_sdio_mbox_rx_alloc(struct ath10k *ar,
 	return ret;
 }
 
-static int ath10k_sdio_mbox_rx_packet(struct ath10k *ar,
-				      struct ath10k_sdio_rx_data *pkt)
+static int ath10k_sdio_mbox_rx_fetch(struct ath10k *ar)
 {
 	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
+	struct ath10k_sdio_rx_data *pkt = &ar_sdio->rx_pkts[0];
 	struct sk_buff *skb = pkt->skb;
 	int ret;
 
-	ret = ath10k_sdio_readsb(ar, ar_sdio->mbox_info.htc_addr,
-				 skb->data, pkt->alloc_len);
+	ret = ath10k_sdio_read(ar, ar_sdio->mbox_info.htc_addr,
+			       skb->data, pkt->alloc_len);
+	if (ret) {
+		ath10k_warn(ar, "sdio_read error %d\n", ret);
+		goto err;
+	}
+
 	pkt->status = ret;
-	if (!ret)
-		skb_put(skb, pkt->act_len);
+	skb_put(skb, pkt->act_len);
 
+	return 0;
+
+err:
+	ar_sdio->n_rx_pkts = 0;
+	ath10k_sdio_mbox_free_rx_pkt(pkt);
 	return ret;
 }
 
-static int ath10k_sdio_mbox_rx_fetch(struct ath10k *ar)
+static int ath10k_sdio_mbox_rx_fetch_bundle(struct ath10k *ar)
 {
 	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
+	struct ath10k_sdio_rx_data *pkt;
 	int ret, i;
+	u32 pkt_offset = 0, pkt_bundle_len = 0;
+
+	for (i = 0; i < ar_sdio->n_rx_pkts; i++)
+		pkt_bundle_len += ar_sdio->rx_pkts[i].alloc_len;
+
+	if (pkt_bundle_len > ATH10K_SDIO_READ_BUF_SIZE) {
+		ret = -ENOSPC;
+		ath10k_warn(ar, "bundle size (%d) exceeding limit %d\n",
+			    pkt_bundle_len, ATH10K_SDIO_READ_BUF_SIZE);
+		goto err;
+	}
+
+	ret = ath10k_sdio_readsb(ar, ar_sdio->mbox_info.htc_addr,
+				 ar_sdio->sdio_read_buf, pkt_bundle_len);
+	if (ret)
+		goto err;
 
 	for (i = 0; i < ar_sdio->n_rx_pkts; i++) {
-		ret = ath10k_sdio_mbox_rx_packet(ar,
-						 &ar_sdio->rx_pkts[i]);
-		if (ret)
-			goto err;
+		struct sk_buff *skb = ar_sdio->rx_pkts[i].skb;
+
+		pkt = &ar_sdio->rx_pkts[i];
+		skb_put(skb, pkt->act_len);
+		memcpy(skb->data, ar_sdio->sdio_read_buf + pkt_offset,
+		       pkt->alloc_len);
+		pkt->status = 0;
+		pkt_offset += pkt->alloc_len;
 	}
 
 	return 0;
 
 err:
 	/* Free all packets that was not successfully fetched. */
-	for (; i < ar_sdio->n_rx_pkts; i++)
+	for (i = 0; i < ar_sdio->n_rx_pkts; i++)
 		ath10k_sdio_mbox_free_rx_pkt(&ar_sdio->rx_pkts[i]);
 
+	ar_sdio->n_rx_pkts = 0;
+
 	return ret;
 }
 
@@ -695,7 +729,10 @@ static int ath10k_sdio_mbox_rxmsg_pending_handler(struct ath10k *ar,
 			 */
 			*done = false;
 
-		ret = ath10k_sdio_mbox_rx_fetch(ar);
+		if (ar_sdio->n_rx_pkts > 1)
+			ret = ath10k_sdio_mbox_rx_fetch_bundle(ar);
+		else
+			ret = ath10k_sdio_mbox_rx_fetch(ar);
 
 		/* Process fetched packets. This will potentially update
 		 * n_lookaheads depending on if the packets contain lookahead
@@ -2001,6 +2038,14 @@ static int ath10k_sdio_probe(struct sdio_func *func,
 		goto err_core_destroy;
 	}
 
+	ar_sdio->sdio_read_buf = devm_kzalloc(ar->dev,
+					      ATH10K_SDIO_READ_BUF_SIZE,
+					      GFP_KERNEL);
+	if (!ar_sdio->sdio_read_buf) {
+		ret = -ENOMEM;
+		goto err_core_destroy;
+	}
+
 	ar_sdio->func = func;
 	sdio_set_drvdata(func, ar_sdio);
 
diff --git a/drivers/net/wireless/ath/ath10k/sdio.h b/drivers/net/wireless/ath/ath10k/sdio.h
index b8c7ac0330bd..07e2cc6a3bd8 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.h
+++ b/drivers/net/wireless/ath/ath10k/sdio.h
@@ -196,6 +196,8 @@ struct ath10k_sdio {
 	struct ath10k *ar;
 	struct ath10k_sdio_irq_data irq_data;
 
+	u8 *sdio_read_buf;
+
 	/* temporary buffer for BMI requests */
 	u8 *bmi_buf;
 
-- 
2.19.1


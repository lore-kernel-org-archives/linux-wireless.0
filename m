Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97AF3C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66DDF2084F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ozvv9Ucm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfDITNN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 15:13:13 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42061 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfDITNN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 15:13:13 -0400
Received: by mail-lj1-f196.google.com with SMTP id v22so15496006lje.9
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 12:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JYMoKVrYtQm5gciQWqLuKoh7pCSY8jTg6gPbHA/ChgE=;
        b=ozvv9UcmdeY2INPMjJwr8BZ+YjylxjPAmnwG6rI+nxxP1ZKB5ilWhScrfp9hN9G9xp
         aIfqtTDfJyn9N0dwVJJnwyAC1x2yih1gRhoDZyLjdwjqB+B08AGKow+pkmWwpx3+3qOK
         cNYUROiYvumwc/dhstShlGhQIddFYekMlXu9FrtUmXnLPJxsTG3jJSW4txG7tm0/i8FQ
         GMQujR1ObMtalSTCIKJ1ZrL8bXpGMyQf8dCx0+b4XtcVqCG2vA70enofVFLiLrrjw8Kl
         8Bans6z6Sc+fu73lLVgztH6rSKkL8bv/oEfoBEFy3TR2bHOUPwPUHr/RKFo7J+ww1W8h
         aNFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JYMoKVrYtQm5gciQWqLuKoh7pCSY8jTg6gPbHA/ChgE=;
        b=oS0HDCJk9dQlgMp+QrdEzIwebCyWAeOjaxvmOs+ffuU2pvBR6YdNnLZcprVIlG7st7
         5HaCJcCHdOmYVZFRG/WL3++3DkLmz25HmrJwDAujc5UUXOFNqy2W0PFVPvqdg99j8vbq
         m1MAf86BLGRsY7uIOA9GifPsAfX7fdM1e45RU5lKAiCTUzYZyStlt+eZy7eZRQ0BQviT
         tqalqVYzyQgHWt/neaBAX1ztGeoKRJMqe0Mql+3dABPoO596n+jlB0E3XJ8FWUDXnF9q
         PIEVh4fe1Q/JUtK5ukEQwV9275FMdBNItf4Cog1bTgCXo7gmSSWJZVa3A0OZbyotKzm7
         tSrQ==
X-Gm-Message-State: APjAAAWGGGGy+chmmInr5R/8YgQBj+RYVluZ3/ck3/Tl5jR0U4lNA7oO
        ksjG20WR8p9XB0Cm6AUdyt4=
X-Google-Smtp-Source: APXvYqzz9A2cPp9mok38/b0qWhdNrdRbotf8rKouYY6tJJTQTZ/t584ZG+69YhSbFPvXVGlgYXVTqw==
X-Received: by 2002:a2e:9597:: with SMTP id w23mr14736366ljh.111.1554837189881;
        Tue, 09 Apr 2019 12:13:09 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id q64sm6807848ljq.76.2019.04.09.12.13.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2019 12:13:09 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Alagu Sankar <alagusankar@silex-india.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 3/6] ath10k: sdio: read RX packets in bundles
Date:   Tue,  9 Apr 2019 21:08:48 +0200
Message-Id: <20190409190851.4557-4-erik.stromdahl@gmail.com>
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

The existing implementation of initiating multiple sdio transfers for
receive bundling is slowing down the receive speed.

Instead of having one sdio transfer for each packet in the bundle, we
read all packets in one sdio transfer.

This results in significant performance improvement on some targets.

Co-developed-by: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 66 +++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/sdio.h |  2 +
 2 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index fae56c67766f..295e1e7ec3b0 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -24,6 +24,8 @@
 #include "trace.h"
 #include "sdio.h"
 
+#define ATH10K_SDIO_READ_BUF_SIZE	(32 * 1024)
+
 /* inlined helper functions */
 
 static inline int ath10k_sdio_calc_txrx_padded_len(struct ath10k_sdio *ar_sdio,
@@ -618,41 +620,68 @@ static int ath10k_sdio_mbox_rx_alloc(struct ath10k *ar,
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
-	pkt->status = ret;
-	if (!ret)
+	ret = ath10k_sdio_read(ar, ar_sdio->mbox_info.htc_addr,
+			       skb->data, pkt->alloc_len);
+	if (ret) {
+		ar_sdio->n_rx_pkts = 0;
+		ath10k_sdio_mbox_free_rx_pkt(pkt);
+	} else {
+		pkt->status = ret;
 		skb_put(skb, pkt->act_len);
+	}
 
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
+		ret = -ENOMEM;
+		ath10k_err(ar, "bundle size (%d) exceeding limit %d\n",
+			   pkt_bundle_len, ATH10K_SDIO_READ_BUF_SIZE);
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
+		memcpy(skb->data, ar_sdio->sdio_read_buf + pkt_offset,
+		       pkt->alloc_len);
+		pkt->status = 0;
+		skb_put(skb, pkt->act_len);
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
 
@@ -695,7 +724,10 @@ static int ath10k_sdio_mbox_rxmsg_pending_handler(struct ath10k *ar,
 			 */
 			*done = false;
 
-		ret = ath10k_sdio_mbox_rx_fetch(ar);
+		if (ar_sdio->n_rx_pkts > 1)
+			ret = ath10k_sdio_mbox_rx_fetch_bundle(ar);
+		else
+			ret = ath10k_sdio_mbox_rx_fetch(ar);
 
 		/* Process fetched packets. This will potentially update
 		 * n_lookaheads depending on if the packets contain lookahead
@@ -2001,6 +2033,14 @@ static int ath10k_sdio_probe(struct sdio_func *func,
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


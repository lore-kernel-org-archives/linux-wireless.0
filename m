Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34219C282DC
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 19:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA42C2073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 19:15:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ipeoyJLU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732858AbfDQTPe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 15:15:34 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39662 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfDQTPd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 15:15:33 -0400
Received: by mail-lf1-f67.google.com with SMTP id d12so3139476lfk.6
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 12:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bW57d87UKSeqIsF8dbOx4NI+/s5uPkAlrYgKadNV5CU=;
        b=ipeoyJLUSK1sgKEIGYNZc7AtuOTanB0QLIg82Pxv6xHgUAFsOBPcxWqvc5a0U/TRdP
         xpVSuWa6K0ni39eqUWbUu3Kr9VasrS7w9MmmRhschM0irJXSMpCYt2A6Xolk6cvoXaYj
         RzYCXo6JNgNl6BjeOmXrdd40MpJXz0k+hsG1KdkVad6cAmRKkFcPVRH4sbNyP6Iyk9Ix
         9uKoZ1pZubGjkZk6Anu8c9/5wuI4gJ9+gb/u7/5b5KbTEcdUMRmoJDVkzsxdmWoGdR8E
         eLHush5B6Esrv9sotiDkcBTks11oVWlf9vIqPcTDVp1+w4k36UpZd5vHJKxeqeKxfvqe
         l5kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bW57d87UKSeqIsF8dbOx4NI+/s5uPkAlrYgKadNV5CU=;
        b=GdBOMRx1xcBrlsS1DDONSRf7in1maYc8UeHDaD+jBc5/Yx72mLY3qzVdXG9QMl2KP8
         aPm718neQvIVe3bg/+Dxqxdo/8KYqDpburrHGPGsg9KTcEoNhekqGWYt/W60M31QMtlw
         mwowLqVhWKwVtUXhQmmmijDzZA4iu8276CQdm/CnW53UGanSnzfIc8Kjm5K5qLvcA2Z4
         sCrI3tNgDDfwGv0xG+4CRZinH85cMpxYOvHi8LibQ9NXM9Xx+53mKw51Izay7cCyU4i9
         PBdVVwtO0jOJ6S/ldx1KvZcHNdySi8HJ/bgAd6Bgw4uGQOvK1nZfk9/tldXxYHInDcpj
         bFIA==
X-Gm-Message-State: APjAAAWk0KYlerhKsP42UPMPAJDFID3r1hLTrMnwwA2szcqjp/b87Phw
        6trjk4JugWjX2DhbDgN8e50=
X-Google-Smtp-Source: APXvYqwt2YzwEQJL9qpjMFhkzMgeb0xAgnsFJgQoyNqCUFu+PJSZAgHrnK7eeL+AseZOvbEcdjJUQQ==
X-Received: by 2002:ac2:5326:: with SMTP id f6mr27181776lfh.100.1555528530172;
        Wed, 17 Apr 2019 12:15:30 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id j27sm11387203lfk.97.2019.04.17.12.15.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 12:15:29 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH v2 5/5] ath10k: sdio: remove skb_trim in TX path
Date:   Wed, 17 Apr 2019 21:15:03 +0200
Message-Id: <20190417191503.18814-6-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190417191503.18814-1-erik.stromdahl@gmail.com>
References: <20190417191503.18814-1-erik.stromdahl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch fixes a bug with padding of the skb data buffer.
Since skb_trim can only be used to reduce the skb len, it is useless when
we pad (increase the length of) the skb. Instead we allocate a new
buffer with enough space to contain both the TX data and padding.

Since some skb's have multiple references, we can't use skb_put_padto()
to extend and pad skb->data (since it causes a panic if there is more
than one reference).

Also, in order to avoid the following possible deadlock issue (reported by
lockdep):

[   26.508508]  Possible interrupt unsafe locking scenario:
[   26.508508]
[   26.515314]        CPU0                    CPU1
[   26.519862]        ----                    ----
[   26.524408]   lock(fs_reclaim);
[   26.527573]                                local_irq_disable();
[   26.533508]                                lock(_xmit_ETHER#2);
[   26.539453]                                lock(fs_reclaim);
[   26.545135]   <Interrupt>
[   26.547769]     lock(_xmit_ETHER#2);
[   26.551370]
[   26.551370]  *** DEADLOCK ***

... we use the GFP_NOFS flag with kzalloc()

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 27 ++++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/sdio.h |  2 ++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index b8b3059721ee..68d8e2d1b2ed 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1279,6 +1279,7 @@ static void ath10k_sdio_free_bus_req(struct ath10k *ar,
 {
 	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
 
+	kfree(bus_req->buf);
 	memset(bus_req, 0, sizeof(*bus_req));
 
 	spin_lock_bh(&ar_sdio->lock);
@@ -1294,7 +1295,7 @@ static void __ath10k_sdio_write_async(struct ath10k *ar,
 	int ret;
 
 	skb = req->skb;
-	ret = ath10k_sdio_write(ar, req->address, skb->data, skb->len);
+	ret = ath10k_sdio_write(ar, req->address, req->buf, req->buf_len);
 	if (ret)
 		ath10k_warn(ar, "failed to write skb to 0x%x asynchronously: %d",
 			    req->address, ret);
@@ -1330,6 +1331,7 @@ static void ath10k_sdio_write_async_work(struct work_struct *work)
 
 static int ath10k_sdio_prep_async_req(struct ath10k *ar, u32 addr,
 				      struct sk_buff *skb,
+				      size_t alloc_len,
 				      struct completion *comp,
 				      bool htc_msg, enum ath10k_htc_ep_id eid)
 {
@@ -1343,9 +1345,17 @@ static int ath10k_sdio_prep_async_req(struct ath10k *ar, u32 addr,
 	if (!bus_req) {
 		ath10k_warn(ar,
 			    "unable to allocate bus request for async request\n");
-		return -ENOMEM;
+		goto err;
 	}
 
+	bus_req->buf_len = alloc_len;
+	bus_req->buf = kzalloc(alloc_len, GFP_NOFS);
+	if (!bus_req->buf) {
+		ath10k_warn(ar,
+			    "unable to allocate data buffer for bus request\n");
+		goto err_free_bus_req;
+	}
+	memcpy(bus_req->buf, skb->data, skb->len);
 	bus_req->skb = skb;
 	bus_req->eid = eid;
 	bus_req->address = addr;
@@ -1357,6 +1367,11 @@ static int ath10k_sdio_prep_async_req(struct ath10k *ar, u32 addr,
 	spin_unlock_bh(&ar_sdio->wr_async_lock);
 
 	return 0;
+
+err_free_bus_req:
+	ath10k_sdio_free_bus_req(ar, bus_req);
+err:
+	return -ENOMEM;
 }
 
 /* IRQ handler */
@@ -1501,12 +1516,11 @@ static int ath10k_sdio_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
 		skb = items[i].transfer_context;
 		padded_len = ath10k_sdio_calc_txrx_padded_len(ar_sdio,
 							      skb->len);
-		skb_trim(skb, padded_len);
 
 		/* Write TX data to the end of the mbox address space */
 		address = ar_sdio->mbox_addr[eid] + ar_sdio->mbox_size[eid] -
-			  skb->len;
-		ret = ath10k_sdio_prep_async_req(ar, address, skb,
+			  padded_len;
+		ret = ath10k_sdio_prep_async_req(ar, address, skb, padded_len,
 						 NULL, true, eid);
 		if (ret)
 			return ret;
@@ -1761,7 +1775,8 @@ static void ath10k_sdio_irq_disable(struct ath10k *ar)
 
 	init_completion(&irqs_disabled_comp);
 	ret = ath10k_sdio_prep_async_req(ar, MBOX_INT_STATUS_ENABLE_ADDRESS,
-					 skb, &irqs_disabled_comp, false, 0);
+					 skb, skb->len, &irqs_disabled_comp,
+					 false, 0);
 	if (ret)
 		goto out;
 
diff --git a/drivers/net/wireless/ath/ath10k/sdio.h b/drivers/net/wireless/ath/ath10k/sdio.h
index 07e2cc6a3bd8..5a727993fbda 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.h
+++ b/drivers/net/wireless/ath/ath10k/sdio.h
@@ -105,6 +105,8 @@ struct ath10k_sdio_bus_request {
 	u32 address;
 
 	struct sk_buff *skb;
+	u8 *buf;
+	size_t buf_len;
 	enum ath10k_htc_ep_id eid;
 	int status;
 	/* Specifies if the current request is an HTC message.
-- 
2.19.1


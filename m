Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDCAC282DA
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B00092084F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H3bCQx3e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfDITNR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 15:13:17 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43869 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfDITNP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 15:13:15 -0400
Received: by mail-lj1-f196.google.com with SMTP id f18so15484700lja.10
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 12:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ZgmwsOUvL4cKbF6D9YKv0p4xEXY9j80R7avVYQ6UI0=;
        b=H3bCQx3exrZ0HBPbVbu6n0uCFMuB4H1sYutNKjDZRNIHpagZwfeNWuKhhpWwto2BzQ
         hjbj2h0o71K148CKobrgRqK9mGNcgBQi9NcnABFC9z97q38X4J0PuSjWoJ0ZREKIi53L
         kAhue8PlIXsDE3XL8Fy9MbBHTKbpBrq+32PkS+nrhlhhBIzcZ8bB+SoYMVltRLkjosC/
         +hgYwxjycmayVB/TERuDbZ02RNPZrrSzF+2sJ26PDE6pWRsCr+BixIhniG2Sh7rBWxpa
         UV6fA1ntEtJPRhHuCptxnV7BVZC2SYysrjzR/L94FHDmjy5ixFnrRKYfk+prCCvwGsrw
         I4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ZgmwsOUvL4cKbF6D9YKv0p4xEXY9j80R7avVYQ6UI0=;
        b=C/a1CVz/6UaFoOnke/CD2QEuK2tB1H6u4eWL+EBvjhHLKoy0+0ArNBYxAp/yUFL3NF
         I7rjzRHe+230dZ9Sm8FgHkyjkGckw0GtiO+bdL8qIOkNyMY55J0e5k603LSjiDNQbWhc
         48sOPXfpfsbiTfxGsh3q9N3HNrfI8JAgfiWuOzYmSxD+VRoAcnI/gPYPDEKY2lesqJkv
         Jq2j4YK+OrejAQAR3+ByyS/QNi/ZY3eOQmE0fOfW1Afku88O8griTLOxmki7Z2qKabZg
         IkMBGp2t01TtXrqfHZpdT+XoQbh3UsckIKjKenz32EJ0TqkEz+3kiovdc2TDZdtWq5Uh
         Ktzw==
X-Gm-Message-State: APjAAAXy6bAKoyedHzj89G0BzKq5+D/Ln45nFAoK8mP5xOuQmqe2QXX3
        llzniYLI9V6cZAL33ds7jPm8ca3k
X-Google-Smtp-Source: APXvYqx9staw3h/hQ7QTrkRRwaxoH0Z/0nyV6Zy3AFumUaN7lcxZe9XrFEsKhHGoSWGnlNA8HgkOCA==
X-Received: by 2002:a2e:998d:: with SMTP id w13mr20579638lji.110.1554837192973;
        Tue, 09 Apr 2019 12:13:12 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id q64sm6807848ljq.76.2019.04.09.12.13.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2019 12:13:12 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 6/6] ath10k: sdio: replace skb_trim with explicit set of skb->len
Date:   Tue,  9 Apr 2019 21:08:51 +0200
Message-Id: <20190409190851.4557-7-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190409190851.4557-1-erik.stromdahl@gmail.com>
References: <20190409190851.4557-1-erik.stromdahl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch fixes a bug with padding of the skb data buffer.
Since skb_trim can only be used to reduce the skb len, it is useless when
we pad (increase the length of) the skb. Instead we must set skb->len
directly.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 3eb241cb8a25..989e3f563f3d 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1496,7 +1496,12 @@ static int ath10k_sdio_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
 		skb = items[i].transfer_context;
 		padded_len = ath10k_sdio_calc_txrx_padded_len(ar_sdio,
 							      skb->len);
-		skb_trim(skb, padded_len);
+		/* FIXME: unsure if just extending the skb len is the right
+		 * thing to do since we might read outside the skb->data
+		 * buffer. But we really don't want to realloc the skb just to
+		 * pad the length.
+		 */
+		skb->len = padded_len;
 
 		/* Write TX data to the end of the mbox address space */
 		address = ar_sdio->mbox_addr[eid] + ar_sdio->mbox_size[eid] -
-- 
2.19.1


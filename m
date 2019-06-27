Return-Path: <SRS0=XE1e=U2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C0BBC48BD7
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Jun 2019 17:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76C782146E
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Jun 2019 17:45:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jf7n5fH2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfF0Rph (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Jun 2019 13:45:37 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46980 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727338AbfF0Rpg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jun 2019 13:45:36 -0400
Received: by mail-pl1-f193.google.com with SMTP id e5so1661158pls.13;
        Thu, 27 Jun 2019 10:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YcrOIML8x2OsusC75WoEHjxhMdfGqgM3ZNHf/dMTePc=;
        b=jf7n5fH2A5HNpS8PTM3S811DsWred9JfeFur4PDK5+BudkEiGv0uONGRk5LPBKX5G1
         igwiiPl5vGHIZPuIqoEe5l0Qs+cin2RFFIMudj7GJPW0mPr66sKSrbwTUKz249EJoPSn
         8Hs7tWuLze0yhunJHSGizmLFFeiJw1o1IfQxO04RFUiW4KlfMkSZlJD6Z6L4W7C9ei4U
         X1li4zYSgq37mTn1irKNa1ka/hTFpj0qgHUsNHsiM9uMWD1hSSpiGrnJ9rOHWYQwnOeh
         B1pYgzlYTDmPbk2zt7ht/oTG6uJ34b/ldweUXOBJXiIDRBLwMqAA0fdEwR8lwPbU8Q7o
         /IZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YcrOIML8x2OsusC75WoEHjxhMdfGqgM3ZNHf/dMTePc=;
        b=pk1oU4DNJxScnN9bfqKfiPypsK1CFN4daa0K4N5CVizhGtXnNaiwqDrq3f4E1DYiJh
         Ll61wgyuRzIYGOuKP7Ef2evnUPTPdZn69/F9+nqFIUoBsPxU0EMOMK1G+WdfQsoG1ai/
         GHk3msa/X+75yoSccD/88EwcVWw+QR0kAqnjFHizLnMvcdvOtPsP/4onCfH3laYija4x
         VszOu9g/NFZDFS8/iBH7aSazWaDQADVDqa0e5kWOjky307NzgS7Sj/2Te9rRt1IyxrNF
         bHppZXZwWa03x5gWbxSCXeimaA3+j1t+1z1tJyfDiSAQ85QeBA0kzAM7oZz13WytwdSz
         ZYtA==
X-Gm-Message-State: APjAAAXXqHgWHffws9dxtVcnYPdbxanNaU4zhPxhAJPtl1i/GEVuvNHC
        p4AEn9Ks72Ui2F5ae9E4Src=
X-Google-Smtp-Source: APXvYqzbE72vwOnzbiDPERLuny3jJnLY2gpyWJh7MxzsMwmFnRrKeXVhleKt5228V1zkdGf43LmBdw==
X-Received: by 2002:a17:902:110b:: with SMTP id d11mr6279856pla.213.1561657535820;
        Thu, 27 Jun 2019 10:45:35 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id t7sm4641393pjq.15.2019.06.27.10.45.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:45:35 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 78/87] wireless: ath10k: remove memset after dma_alloc_coherent
Date:   Fri, 28 Jun 2019 01:45:27 +0800
Message-Id: <20190627174527.5987-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/wireless/ath/ath10k/ce.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index eca87f7c5b6c..294fbc1e89ab 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1704,9 +1704,6 @@ ath10k_ce_alloc_dest_ring_64(struct ath10k *ar, unsigned int ce_id,
 	/* Correctly initialize memory to 0 to prevent garbage
 	 * data crashing system when download firmware
 	 */
-	memset(dest_ring->base_addr_owner_space_unaligned, 0,
-	       nentries * sizeof(struct ce_desc_64) + CE_DESC_RING_ALIGN);
-
 	dest_ring->base_addr_owner_space =
 			PTR_ALIGN(dest_ring->base_addr_owner_space_unaligned,
 				  CE_DESC_RING_ALIGN);
@@ -2019,8 +2016,6 @@ void ath10k_ce_alloc_rri(struct ath10k *ar)
 		value |= ar->hw_ce_regs->upd->mask;
 		ath10k_ce_write32(ar, ce_base_addr + ctrl1_regs, value);
 	}
-
-	memset(ce->vaddr_rri, 0, CE_COUNT * sizeof(u32));
 }
 EXPORT_SYMBOL(ath10k_ce_alloc_rri);
 
-- 
2.11.0


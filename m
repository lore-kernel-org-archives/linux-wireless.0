Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F013C282DD
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 19:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF8972073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 19:15:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FUnjRqLA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733244AbfDQTPc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 15:15:32 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37255 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732634AbfDQTPb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 15:15:31 -0400
Received: by mail-lf1-f68.google.com with SMTP id o19so15383329lfl.4
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 12:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yZlYdkbsnuWRekasQAPicgHhW2O1in5TKogUwhEyeAY=;
        b=FUnjRqLAipT9GC80FeDYkIRkseovEPOjV56eFccMEEMB+GDfG9VdpNpCIGdH/bTFgi
         8FzlrnAKp2/ST3mEAY5wCTwGMR4GuP9qjVts6Ik+/ngMv9Nlvmq9KGnHPGrR53S92bk1
         HMK+q4UI7uTbn4SdtKtJZ+SXV5NXP0VsRRNGWLQOgws1wgR35bdezlnNrDAji+NykDF4
         UqKauuD3c7GJuD7hhOq7UBqsK8kiYzCXOp6J45w8YdWu9hLR1fVKLA8KaATNqkEBrwlY
         SmpVd2SGCS2H+5i/eKK9T7RPLyKm6EvdkvZoSZQFNEEU0WhCKfl3bVth6YdBAUz9jegR
         eygQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yZlYdkbsnuWRekasQAPicgHhW2O1in5TKogUwhEyeAY=;
        b=oswiubyG2AExm5QDPDm2Y8d+JV1NeAEsC9bRMQTFc+nj4OnkySuaKu68s6n4X6QeK2
         ArsUEHv2ZoLnlt5yYIVROUG7GQN3qYkLTbt5rEav6Ht9t+vBIHogPY3klH3p+MYhjuTp
         gkZxhUhSvj9aRwhzsFQu4HjXvW6R//gPSJc3mVWypBQXSHi1UBCrgw4eiydSk5r1ka7r
         mKpaeBMjcEdEvHNfDi84eZiX09oTAungZpdDhKK7LNGPtcI0gN7syimjWErXDeYBNGIr
         PeIsoP2bqoNqB42DmmUFvu9PJE27R6V/qrtIbKSOUfE83rNQtIBJl7kDdbshRO5QAgvG
         7gUw==
X-Gm-Message-State: APjAAAXZbKCHD0xvfgX/CNT15AWVuWyiBcmWtm14rwZDL5uqrlyyRI2l
        wZEBgkTr/jk/3V2AG8Z3daQezCnB
X-Google-Smtp-Source: APXvYqw1rKENYOyuvxq1zMqprYZEcR4yonZJjzg6pue8q26TahnEg2jB1QPrP+JgNrBT0M8A/vLu9Q==
X-Received: by 2002:ac2:4551:: with SMTP id j17mr19496154lfm.141.1555528529381;
        Wed, 17 Apr 2019 12:15:29 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id j27sm11387203lfk.97.2019.04.17.12.15.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 12:15:28 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH v2 4/5] ath10k: sdio: add missing error check
Date:   Wed, 17 Apr 2019 21:15:02 +0200
Message-Id: <20190417191503.18814-5-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190417191503.18814-1-erik.stromdahl@gmail.com>
References: <20190417191503.18814-1-erik.stromdahl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Although not likely, the bundle allocation might fail.
Add proper error check and warning print.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index b89732aad97c..b8b3059721ee 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -586,6 +586,11 @@ static int ath10k_sdio_mbox_rx_alloc(struct ath10k *ar,
 								act_len,
 								&bndl_cnt);
 
+			if (ret) {
+				ath10k_warn(ar, "alloc_bundle error %d\n", ret);
+				goto err;
+			}
+
 			n_lookaheads += bndl_cnt;
 			i += bndl_cnt;
 			/*Next buffer will be the last in the bundle */
-- 
2.19.1


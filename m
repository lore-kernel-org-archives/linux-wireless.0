Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D2BC282C5
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 16:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96F722085A
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 16:32:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UxalKpTY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbfAVQcm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:32:42 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41707 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728798AbfAVQcm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 11:32:42 -0500
Received: by mail-pf1-f195.google.com with SMTP id b7so12008372pfi.8;
        Tue, 22 Jan 2019 08:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5+cC03VS8pB3zKL5KqcKqAN/zKjczD0HsDLVvlVCCLs=;
        b=UxalKpTY7XZr1ncT8zbOrIVbtsHMssl+pEwiuXOGEFjT2BO0+HRaI8twYCTZCnllxf
         8TvTyZO00E60FaAlD23MOBa0WMLuSB93CS9x3KkGMQGjC6Zvr1Yz/4Vr92UVzjSw2PJq
         sm4mK9Mb2dXyGFGLmg4ZUuM9pJyly/46jadVp0nVv6YXZdkn5Sn88JWM9ECzq1hF+P1s
         ORAmXIjw/i61acfDaoWIb+NASenxJ2MOR5buMiBTnQBAdwziekohsH9g7zYABy2GVrsf
         biBERcvbAAhzN4L4VUcYrs6iAHBnhCVxbnqSaj6T+uCLdDS03ObhoUoo0gQ7fLppMTQ0
         0kHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5+cC03VS8pB3zKL5KqcKqAN/zKjczD0HsDLVvlVCCLs=;
        b=mFVhi//yZhKFzXCOIBpTJXHr3LQ3Od5XMdOABIR2mlltiZGewwNqnOf2IFFTAWMTGN
         atA8mZylttyOS3ag2v66NpxIftjkoiAmgb+oe1h66NKJc2kP8XuE1O7AsILVAmQRALpS
         iEFDjP2LEqx3lxOF9ve6GCGH/xiiUwQY3Tes3MD3mWsRCvyd4rmt2t3OqDXMiCz/0+Zv
         t4ptRkhqNPFqP2QSA3tJnGFmC/F++wfFMgLtRwg0pULA32e4J4vbLfTPF0aXQ9bjX9mx
         /5CChtWu6cMnVYbgd12amHo+O8aJNPS129EuXKfL+mJSl3LZ0BHWXU426xZ3UXPxOqg/
         xPAA==
X-Gm-Message-State: AJcUukezroYOwkMPhNd8f1i9MlDRdF4E5XraB/nzl1AsF4FcgEm+sv2w
        fn8KT2EHZeZ/jq1mdPpk23w=
X-Google-Smtp-Source: ALg8bN50n97j8KXCToZ3NNg8Iz3FEH+ZqhGtDZhT9uQQYRpRtys32GEcDtoROgnWPR+DLZIW1QTxkA==
X-Received: by 2002:a63:902:: with SMTP id 2mr30645679pgj.219.1548174761146;
        Tue, 22 Jan 2019 08:32:41 -0800 (PST)
Received: from localhost.localdomain ([222.129.236.86])
        by smtp.gmail.com with ESMTPSA id k24sm23497393pfj.13.2019.01.22.08.32.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 22 Jan 2019 08:32:40 -0800 (PST)
From:   Zhiwei Jiang <qq282012236@gmail.com>
To:     qq282012236@gmail.com
Cc:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath: move spin_lock_bh to spin_lock in tasklet
Date:   Wed, 23 Jan 2019 00:30:33 +0800
Message-Id: <20190122163033.51095-1-qq282012236@gmail.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

as you are already in a tasklet, it is unnecessary to call
spin_lock_bh, because softirq already disable BH.

Signed-off-by: Zhiwei Jiang <qq282012236@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 799010ed04e0..4e8e80ac8341 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -574,12 +574,12 @@ void ath9k_tx_failed_tasklet(unsigned long data)
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
 
-	spin_lock_bh(&priv->tx.tx_lock);
+	spin_lock(&priv->tx.tx_lock);
 	if (priv->tx.flags & ATH9K_HTC_OP_TX_DRAIN) {
-		spin_unlock_bh(&priv->tx.tx_lock);
+		spin_unlock(&priv->tx.tx_lock);
 		return;
 	}
-	spin_unlock_bh(&priv->tx.tx_lock);
+	spin_unlock(&priv->tx.tx_lock);
 
 	ath9k_htc_tx_drainq(priv, &priv->tx.tx_failed);
 }
-- 
2.19.0


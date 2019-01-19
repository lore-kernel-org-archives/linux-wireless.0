Return-Path: <SRS0=bfUd=P3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55265C6369F
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Jan 2019 10:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2332820821
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Jan 2019 10:55:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rweXwSQo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfASKzu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 19 Jan 2019 05:55:50 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34595 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbfASKzt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Jan 2019 05:55:49 -0500
Received: by mail-pg1-f195.google.com with SMTP id j10so7301219pga.1;
        Sat, 19 Jan 2019 02:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ehdoWmb4wUTdXYiPCKCbzVf4sdIz4O4H7YapYpem6e0=;
        b=rweXwSQoQMP7Hn2lBkL7d/UezLSv46E6ppA4md1Rh2fHvjX5s+2AkmolT5q9kU/LEM
         t0flIipyPYU0x2DsWf6mo2fSFL+bCVU37sNMXcWkDUKT2rGhLv2TxkDXD9s7MALkheoG
         lfMxOUacGIC87Ab4lZ0sh592zWmhqHajzRFyR68XIuY39b7ah84ufgbWECjnA6jPzDhn
         0CFWfVsjOyCIPcTf37sDPOkztnfZaz4YQbCr/2AZzagVrQ4soUGnX/V2q+1W0lV7a/Xo
         CEJd5v+KDPhxHdXYl1je/MnlweGwLqjU1qRMBPE9vsdzwGQhA4cQRXiuiDSBzNzQbAY+
         IXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ehdoWmb4wUTdXYiPCKCbzVf4sdIz4O4H7YapYpem6e0=;
        b=ecLO4GEuHbqAFiEMuiTKoJf69qKkc91sClB0qvOSezGolxHxUKfirv6ZZGGuZF+AqR
         +rhX5flJnEJUTpxEcxVIdnXE1NeUKWjK5heTG0vB2zn3B7yfqb6UORqtiiXE3Z2oIBWC
         o4hzc8DczrY4YnLhRtTVTYcxHmh6ljGIPJd/4I3IV3PlejaTDSlVQK3rUNWH2JFS2ueK
         IBtFsCn1MXK6/uw2EiSsvBDLvBnMX02iGsAToSx41rGcUIY4hIEszpTBCqtrz5dSA0N4
         onDCWqmbqWjxKpO7X/Foy8oB8uvls/llGzeEenFYl3zI0nuMPWarJTIsKGO3I/OKwHIw
         gvSQ==
X-Gm-Message-State: AJcUukf1CCTIDO9kVj2onOEkB6tCQBsyJAmjmL9MyEKG2ksVct+/4UJ6
        DWf8Xj8536cVS4Zh/4mnyiM=
X-Google-Smtp-Source: ALg8bN7Kw9tpWMN0KEisK8dfpiAomxC1Y76le4QSQGc+PquvY0EEkzLDd/3kWcNjtrnKwC7soIKjqQ==
X-Received: by 2002:a62:220d:: with SMTP id i13mr22783293pfi.162.1547895348603;
        Sat, 19 Jan 2019 02:55:48 -0800 (PST)
Received: from localhost.localdomain ([222.129.236.86])
        by smtp.gmail.com with ESMTPSA id 125sm11168135pfg.39.2019.01.19.02.55.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 19 Jan 2019 02:55:47 -0800 (PST)
From:   Zhiwei Jiang <qq282012236@gmail.com>
To:     qq282012236@gmail.com
Cc:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath: move spin_lock_bh to spin_lock in tasklet
Date:   Sat, 19 Jan 2019 18:55:30 +0800
Message-Id: <20190119105530.6079-1-qq282012236@gmail.com>
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
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 799010ed04e0..4e38276ed0d3 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -574,12 +574,12 @@ void ath9k_tx_failed_tasklet(unsigned long data)
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
 
-	spin_lock_bh(&priv->tx.tx_lock);
+	spin_lock(&priv->tx.tx_lock);
 	if (priv->tx.flags & ATH9K_HTC_OP_TX_DRAIN) {
 		spin_unlock_bh(&priv->tx.tx_lock);
 		return;
 	}
-	spin_unlock_bh(&priv->tx.tx_lock);
+	spin_unlock(&priv->tx.tx_lock);
 
 	ath9k_htc_tx_drainq(priv, &priv->tx.tx_failed);
 }
-- 
2.19.0


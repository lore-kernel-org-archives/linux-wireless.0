Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B00C67876
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 196AB20882
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:57:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 196AB20882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbeJGREM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 13:04:12 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39161 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbeJGREM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 13:04:12 -0400
Received: by mail-wm1-f65.google.com with SMTP id y144-v6so1064529wmd.4
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2018 02:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dYEDlKcnTTxiCcUvEZJZVgR42o7bpXSHL/9yk854Ak0=;
        b=ckPGn1PaqB+ez0HC8Z6q72aGcU2doTJnkkk/MW0b8DvlV75LSMTr4xzdQ12yyQRpoK
         kO+5/Z72FnKTCf+2fmhpNKSMsOx5OwDpha8UJP0UMWplVEjG0c5QdDX7GZpn4jgbmkDo
         MGx5HOTVUE/dAc0rIIwdiJKcnCiBqsW5JN0huFWu0PzDt56LhNT3Ukj1TB9va4tCFvWW
         B1o4lMRz3gy1ExatdYVlt8LvDAWKOcW+9KBXYtW9F09HMkmq5VnzqEveNImI2IAkXEoC
         CeV8NOnK7HMM5WGz27v8hMlKpf7otGFjkDdO0nrBxTBwD+9dmVqWr8NakUf8RN660SUj
         PVuw==
X-Gm-Message-State: ABuFfohZ2uNi+INv5Px7/+Xcw4vg0QHEb8F8bUhFPb6X9YvmtN6827yt
        K8fnGJdHVWvmuH4ioB4N0d2Jjggri8w=
X-Google-Smtp-Source: ACcGV62EA8CQ7E61mVSeNVztUwTBd+rC6hS9uTiyythk+lvfcMi2fkOKppAs39AnB7ZS8RVxke8NOQ==
X-Received: by 2002:a1c:b0b:: with SMTP id 11-v6mr11329187wml.25.1538906246146;
        Sun, 07 Oct 2018 02:57:26 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id a5-v6sm6404631wmh.8.2018.10.07.02.57.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Oct 2018 02:57:25 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mt76x0: pci: add missing mac80211 callbacks
Date:   Sun,  7 Oct 2018 11:57:20 +0200
Message-Id: <20181007095722.13577-2-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add missing mac80211 callbacks in mt76x0e_ops data structure

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index f1a1c70c4263..ab91a22b4f05 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -71,10 +71,19 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.tx = mt76x02_tx,
 	.start = mt76x0e_start,
 	.stop = mt76x0e_stop,
-	.config = mt76x0_config,
 	.add_interface = mt76x02_add_interface,
 	.remove_interface = mt76x02_remove_interface,
+	.config = mt76x0_config,
 	.configure_filter = mt76x02_configure_filter,
+	.sta_add = mt76x02_sta_add,
+	.sta_remove = mt76x02_sta_remove,
+	.set_key = mt76x02_set_key,
+	.conf_tx = mt76x02_conf_tx,
+	.sw_scan_start = mt76x0_sw_scan,
+	.sw_scan_complete = mt76x0_sw_scan_complete,
+	.ampdu_action = mt76x02_ampdu_action,
+	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
+	.wake_tx_queue = mt76_wake_tx_queue,
 };
 
 static int mt76x0e_register_device(struct mt76x02_dev *dev)
-- 
2.19.0


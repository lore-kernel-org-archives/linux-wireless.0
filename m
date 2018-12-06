Return-Path: <SRS0=7mY+=OP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D223C64EB1
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 18:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 700E420868
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 18:12:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 700E420868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbeLFSMu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Dec 2018 13:12:50 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46518 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbeLFSMu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Dec 2018 13:12:50 -0500
Received: by mail-wr1-f67.google.com with SMTP id l9so1377253wrt.13
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2018 10:12:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RmjcCUpZcDYpxpLd4aP0l0xxHrzHC0PB78XLepLJTss=;
        b=qCGXIWdpkdkDimMxr0seitSb96ac678vEcKyaFimXuudgnaxEA/XYiatMFgtzpME7u
         JVNEKDFGxUb992J5olk9Ge8AwuUMTJCfnKblN4q+ldrmUd3UbPNYUys32/2Y/sluR1W/
         UT9vJ0jRfD2YEltK98tkZpqlDTbRidWY1KwBC7K7M6mLkUMuPIZ+CHMBrtPh5jhwcw+1
         6GqoY11lPqaIeHXiHZkG1z4BsX8WePvpYYmSjzHw5FCt08VQgLf3tu0BBnsx/2kvJ87u
         cg2gz18iZPQlEj/Q2UR5yojJa6RI8ZWX0w7cJFPtCQ4hDMWHasfGH9EWtKsVypHyU/kk
         RjeQ==
X-Gm-Message-State: AA+aEWbC4qWls71vAu4DDlZRMxRkco1SeF/01SVodbApMeDNUgJjuAF+
        DgLf6I/CLGCe9U+3sgP1qHPbIcb69rE=
X-Google-Smtp-Source: AFSGD/U2PDrFAI+rn82xYcgZHLzMZkB9QBpsqFexjvmOKEJPgxwnVqO8cZv7k+Aq4Qmze8cAJdrCHg==
X-Received: by 2002:adf:a4d9:: with SMTP id h25mr24603716wrb.167.1544119968577;
        Thu, 06 Dec 2018 10:12:48 -0800 (PST)
Received: from localhost.lan ([151.66.31.17])
        by smtp.gmail.com with ESMTPSA id b18sm1619677wrr.43.2018.12.06.10.12.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Dec 2018 10:12:47 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: usb: avoid queue/status spinlocks while passing tx status to mac80211
Date:   Thu,  6 Dec 2018 19:11:55 +0100
Message-Id: <609b3532b5424fae1f82cea4ea4bb9688d943bf5.1544119660.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.1544119660.git.lorenzo.bianconi@redhat.com>
References: <cover.1544119660.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

As already done for pcie code in commit 79d1c94c9c78 ("mt76: avoid
queue/status spinlocks while passing tx status to mac80211") make sure
that no tx related spinlocks are taken during the ieee80211_tx_status call

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 14ff06c5764e..6a2507524c6c 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -583,6 +583,7 @@ static void mt76u_stop_rx(struct mt76_dev *dev)
 static void mt76u_tx_tasklet(unsigned long data)
 {
 	struct mt76_dev *dev = (struct mt76_dev *)data;
+	struct mt76_queue_entry entry;
 	struct mt76u_buf *buf;
 	struct mt76_queue *q;
 	bool wake;
@@ -597,17 +598,18 @@ static void mt76u_tx_tasklet(unsigned long data)
 			if (!buf->done || !q->queued)
 				break;
 
-			dev->drv->tx_complete_skb(dev, q,
-						  &q->entry[q->head],
-						  false);
-
 			if (q->entry[q->head].schedule) {
 				q->entry[q->head].schedule = false;
 				q->swq_queued--;
 			}
 
+			entry = q->entry[q->head];
 			q->head = (q->head + 1) % q->ndesc;
 			q->queued--;
+
+			spin_unlock_bh(&q->lock);
+			dev->drv->tx_complete_skb(dev, q, &entry, false);
+			spin_lock_bh(&q->lock);
 		}
 		mt76_txq_schedule(dev, q);
 		wake = i < IEEE80211_NUM_ACS && q->queued < q->ndesc - 8;
-- 
2.19.2


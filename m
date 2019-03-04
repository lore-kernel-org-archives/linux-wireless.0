Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76C2C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 13:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF9C520835
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 13:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551704406;
	bh=L30hQIbLwt9oWznlITAJ8HcQTffhpCXnWKp4fFVOaKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FtQ71clZN50dCMKJbBZljDai+fuXBtoE2eI5wPvjSZ7HeoMS/RDcMRAyQeVHdSEUA
	 zPkOiGFF10Ln6kmiCkFLUxTQpl4M83FjTSHoC5oGCYKys8EwZGuZV7BldZ0y0MoxU7
	 tl7Bz3xFGlehS9ohQ/KzDTYBVwphPa2yyC5cT0/8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfCDNAG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 08:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfCDNAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 08:00:05 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2096E2075B;
        Mon,  4 Mar 2019 13:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551704405;
        bh=L30hQIbLwt9oWznlITAJ8HcQTffhpCXnWKp4fFVOaKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WA+VOg/JHdV89vsWC5e4zlz2P+xxpU+bB8QY/r2VWQSkkZJTxxgNAYt0vw9Byq7yI
         iJjyi4zu64mEg2lSrQpqYg/BV35ggTbDIjQANKXLqW0A+0bqjNVaWsY3ovSDeYVZ3z
         xHjF0RjvF6zBUkuMSBzGDwlBVv65swepK2E65b4c=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, joe@perches.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v2] mt76: usb: reduce code indentation in mt76u_alloc_tx
Date:   Mon,  4 Mar 2019 13:59:49 +0100
Message-Id: <f17ee2ae87708b9e70cea5116d8fa41852adbcff.1551703530.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551703530.git.lorenzo@kernel.org>
References: <cover.1551703530.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Improve code readability reducing code indentation in
mt76u_alloc_tx

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- use devm_kcalloc instead of devm_kzalloc and get rid of size
---
 drivers/net/wireless/mediatek/mt76/usb.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 4c1abd492405..508931101178 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -810,15 +810,14 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 			if (!buf->urb)
 				return -ENOMEM;
 
-			if (dev->usb.sg_en) {
-				size_t size = MT_SG_MAX_SIZE *
-					      sizeof(struct scatterlist);
-
-				buf->urb->sg = devm_kzalloc(dev->dev, size,
-							    GFP_KERNEL);
-				if (!buf->urb->sg)
-					return -ENOMEM;
-			}
+			if (!dev->usb.sg_en)
+				continue;
+
+			buf->urb->sg = devm_kcalloc(dev->dev, MT_SG_MAX_SIZE,
+						    sizeof(struct scatterlist),
+						    GFP_KERNEL);
+			if (!buf->urb->sg)
+				return -ENOMEM;
 		}
 	}
 	return 0;
-- 
2.20.1


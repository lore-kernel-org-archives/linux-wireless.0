Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB170C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 07:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A92A22087F
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 07:05:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="UTRPgSdd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfAHHFm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 02:05:42 -0500
Received: from m12-12.163.com ([220.181.12.12]:39861 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727435AbfAHHFl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 02:05:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=dnt+lEkM4qUxeXELPt
        yNtc9tBbvuc3ElsgZSfjdQa+I=; b=UTRPgSddjUbVY/8BGkQQW6VjBPnI3h4Oe6
        I+fziQEfqM7xePd95RjLe023aX684arMWBVCMKRjMrzSe9BdxjGGV29pGQnEZ8bN
        bbjN9nwMmGFeT9FGL7txBrAzHvpShOPGNAI1UUuZaj2bBkLpEtTfNW/15AWAfAEP
        7SyyqZlIE=
Received: from localhost.localdomain (unknown [222.212.97.202])
        by smtp8 (Coremail) with SMTP id DMCowAA3hrDASzRcRVU+JA--.51699S2;
        Tue, 08 Jan 2019 15:05:36 +0800 (CST)
From:   wangbo <wdjjwb@163.com>
To:     linux-kernel@vger.kernel.org
Cc:     sameo@linux.intel.com, linux-wireless@vger.kernel.org,
        wang.bo116@zte.com.cn, wangbo <wdjjwb@163.com>
Subject: [PATCH] NFC: fdp: Use signed max_size to catch fail
Date:   Tue,  8 Jan 2019 15:05:33 +0800
Message-Id: <1546931133-27462-1-git-send-email-wdjjwb@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: DMCowAA3hrDASzRcRVU+JA--.51699S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKF47ur18Cw47tw1fCw1ftFb_yoW3WrcEkr
        y5Wr13Wr1YkFnavry7Wryavryj9r17XFs5WF1YgasrAayDAF43uF4qvryfWr1fW340v3W3
        KwnrJr4rAr4qgjkaLaAFLSUrUUUUxb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5cvtJUUUUU==
X-Originating-IP: [222.212.97.202]
X-CM-SenderInfo: xzgmy4re6rljoofrz/xtbBEgE2GVZX-qQLEAAAs8
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The variable max_size's type is unsigned char,can not catch error number,
change it to signed int.

Signed-off-by: wangbo <wang.bo116@zte.com.cn>
---
 drivers/nfc/fdp/fdp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index d5784a4..ba32a59 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -192,8 +192,9 @@ static int fdp_nci_send_patch(struct nci_dev *ndev, u8 conn_id, u8 type)
 	const struct firmware *fw;
 	struct sk_buff *skb;
 	unsigned long len;
-	u8 max_size, payload_size;
+	u8  payload_size;
 	int rc = 0;
+	int max_size = 0;
 
 	if ((type == NCI_PATCH_TYPE_OTP && !info->otp_patch) ||
 	    (type == NCI_PATCH_TYPE_RAM && !info->ram_patch))
-- 
2.7.4



Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB79C2F420
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 14:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E281C20861
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 14:52:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="f6kzsU6P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbfAUOwd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 09:52:33 -0500
Received: from m12-14.163.com ([220.181.12.14]:36196 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729072AbfAUOwd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 09:52:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=WuBlvYMhMiur2qOtqv
        X5oPcBVaaFHxgo1cnuvtXrZKs=; b=f6kzsU6PW2Kkj2I0i736SvPHSX5URXGtFC
        fbuMW+wzDU5NG9eE9GbScDSzBu0ZUmNUxwrj4IAnxGvEUmEHw6BucH+p1mXzDS9U
        oj8yE1y/4dFrNKFxGTvuJNk8uTwHcWGaiHi4l3S2b/uIn3RYBdHb9rchQn51kptN
        9lkN15o2U=
Received: from yangwei-T440.lan (unknown [171.223.99.184])
        by smtp10 (Coremail) with SMTP id DsCowAA3ChCO3EVcT0sICg--.5277S3;
        Mon, 21 Jan 2019 22:51:59 +0800 (CST)
From:   Yang Wei <albin_yang@163.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     sameo@linux.intel.com, davem@davemloft.net, yang.wei9@zte.com.cn,
        Yang Wei <albin_yang@163.com>
Subject: [PATCH] nfc: fix potential illegal memory access
Date:   Mon, 21 Jan 2019 22:51:57 +0800
Message-Id: <1548082317-6029-1-git-send-email-albin_yang@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: DsCowAA3ChCO3EVcT0sICg--.5277S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw15WrWkJry5Kw1UtryxZrb_yoWfJrg_Zr
        yFv3WUK398u3s7Cw4Skrs8GFyxGayIgF1v9rWIqa1Iv343JrnxGrWvqr93ur4Uu3y2kFnx
        Gr4UArZ5Ar18GjkaLaAFLSUrUUUUYb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUeQJ55UUUUU==
X-Originating-IP: [171.223.99.184]
X-CM-SenderInfo: pdoex0xb1d0wi6rwjhhfrp/xtbBEQ9DolaD2Q1AbAAAsS
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The frags_q is used before __skb_queue_head_init when conn_info is
NULL. It may result in illegal memory access.

Signed-off-by: Yang Wei <yang.wei9@zte.com.cn>
---
 net/nfc/nci/data.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 908f25e..8948341 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -116,14 +116,14 @@ static int nci_queue_tx_data_frags(struct nci_dev *ndev,
 
 	pr_debug("conn_id 0x%x, total_len %d\n", conn_id, total_len);
 
+	__skb_queue_head_init(&frags_q);
+
 	conn_info = nci_get_conn_info_by_conn_id(ndev, conn_id);
 	if (!conn_info) {
 		rc = -EPROTO;
 		goto free_exit;
 	}
 
-	__skb_queue_head_init(&frags_q);
-
 	while (total_len) {
 		frag_len =
 			min_t(int, total_len, conn_info->max_pkt_payload_len);
-- 
2.7.4



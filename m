Return-Path: <SRS0=Otg8=OG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F4DC43441
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Nov 2018 07:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C4CB20873
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Nov 2018 07:55:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="X4vl2QUM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C4CB20873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=163.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbeK0SwR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 27 Nov 2018 13:52:17 -0500
Received: from m12-11.163.com ([220.181.12.11]:51536 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728977AbeK0SwQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Nov 2018 13:52:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=i2bcApeV8atCnz4/Q7
        5l4r8++FCD2b8hoWXfmw7d/fg=; b=X4vl2QUMuSk7R134sT6PcuVYTTYghdSNI2
        Fqj7PHHEX3CIA32bRMRIke2pOStDAr8xh1pSD8wr8MyrXv7+v5z2yEL2aH7ji00M
        DGZLqwkksY4XxjJN6z4pH7M1QM1PGDkFXELSOLq8b13KWmDgwxaQE7HSQnDnaBp5
        JlhLe+WnU=
Received: from bp.localdomain (unknown [106.120.213.96])
        by smtp7 (Coremail) with SMTP id C8CowAC3GPw8+PxboYqRCA--.739S3;
        Tue, 27 Nov 2018 15:54:49 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH] NFC: netlink: remove unexpected nfc_put_device
Date:   Tue, 27 Nov 2018 15:54:35 +0800
Message-Id: <1543305275-23051-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: C8CowAC3GPw8+PxboYqRCA--.739S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7XryfJw1rJrW5JrWUKr17Wrg_yoWDArgEyw
        1rtr48Wrs5X3s3JF42kr4UAF92kF42gF4xG3WxKr4rAa45Xay5ZFWkAw4fAr17uw43CFW7
        X3WkKFWkJry7XjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0oUDJUUUUU==
X-Originating-IP: [106.120.213.96]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/1tbiVAIMclUMGLObWgAAsb
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The functions nfc_genl_llc_set_params and nfc_genl_llc_sdreq drops the
reference to dev via nfc_put_device on the error branch that no local
device is found. However, the error handling block reads dev's field and
then put dev again. This may result in use-after-free bugs. The patch
removes the unexpected call to nfc_put_device.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 net/nfc/netlink.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 376181c..e1f2057 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1107,7 +1107,6 @@ static int nfc_genl_llc_set_params(struct sk_buff *skb, struct genl_info *info)
 
 	local = nfc_llcp_find_local(dev);
 	if (!local) {
-		nfc_put_device(dev);
 		rc = -ENODEV;
 		goto exit;
 	}
@@ -1167,7 +1166,6 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
 
 	local = nfc_llcp_find_local(dev);
 	if (!local) {
-		nfc_put_device(dev);
 		rc = -ENODEV;
 		goto exit;
 	}
-- 
2.7.4



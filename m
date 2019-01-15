Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FBCC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 16:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FDA420657
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 16:34:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="YEdNG76t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731606AbfAOQeJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 11:34:09 -0500
Received: from nbd.name ([46.4.11.11]:32926 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731602AbfAOQeJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 11:34:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EfeAfA5K6/H5yoKOwi2KESRncc5EFxNAehcIhx6FYG4=; b=YEdNG76tkhLoXuu5Uz7efNEVIJ
        /qx5TQdd0iumNL0xSr9+Jz/YVUfZcF8EXNwwM7iE5MFSYKkCZpDo0DSVVD0sA4a/8YatwrHEgvrpY
        Q+zJUwPVODMTCm+gMVdDS0g04jkZRJdDgkdIqX2hyjRIY7Jmb36HZGT3GO8bxfsrvvXk=;
Received: by maeck.lan (Postfix, from userid 501)
        id 9EA3C4C1CA48; Tue, 15 Jan 2019 17:34:06 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     seth.forshee@canonical.com
Subject: [PATCH] wireless-regdb: Sync IN with G.S.R. 1048(E), October 2018
Date:   Tue, 15 Jan 2019 17:34:06 +0100
Message-Id: <20190115163406.86855-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Felix Fietkau <felix@wiowireless.com>

Add new frequency ranges, increase power, as documented in:
http://wpc.dot.gov.in/WriteReadData/userfiles/License%20Exemption%20in%205%20GHz%20G_S_R_1048(E)%20dated%2022nd%20October,%202018.pdf

Signed-off-by: Felix Fietkau <felix@wiowireless.com>
---
 db.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index fa5c0e0..1dd630f 100644
--- a/db.txt
+++ b/db.txt
@@ -617,8 +617,10 @@ country IL: DFS-ETSI
 
 country IN:
 	(2402 - 2482 @ 40), (20)
-	(5150 - 5350 @ 160), (23)
-	(5725 - 5875 @ 80), (23)
+	(5150 - 5250 @ 160), (30)
+	(5250 - 5350 @ 160), (24)
+	(5470 - 5725 @ 160), (24)
+	(5725 - 5875 @ 80), (30)
 
 country IR: DFS-JP
 	(2402 - 2482 @ 40), (20)
-- 
2.17.0


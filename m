Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD6EC282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 10:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CC0221773
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 10:19:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="QlVlEUxZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfBIKTu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 05:19:50 -0500
Received: from nbd.name ([46.4.11.11]:42960 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbfBIKTu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 05:19:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fErx4YEgFNmtwltHu/SDamHyr2Q1d/dWGRNVqJiJzFg=; b=QlVlEUxZoShtnUB75hPqvKq1nA
        uqUYweR3yWLVQ/9Lm/XX5odm7lORkr7Z39Ws0pQ1sgntkWGA2TOyTh9V/5rMCH+M8DJOcr7wIST5n
        OKp0FiPjfaYoWwRBhcwCVSbKNmp0sSenFGKlrDmrGWD/VwawPelOelXUD9E8OrQUutXg=;
Received: by maeck.lan (Postfix, from userid 501)
        id 3C4234F17D0D; Sat,  9 Feb 2019 11:19:47 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     seth.forshee@canonical.com, Felix Fietkau <felix@wiowireless.com>
Subject: [PATCH v2] wireless-regdb: Sync IN with G.S.R. 1048(E), October 2018
Date:   Sat,  9 Feb 2019 11:19:47 +0100
Message-Id: <20190209101947.4876-1-nbd@nbd.name>
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
index 66751f0..b8f3faa 100644
--- a/db.txt
+++ b/db.txt
@@ -617,8 +617,10 @@ country IL: DFS-ETSI
 
 country IN:
 	(2402 - 2482 @ 40), (20)
-	(5150 - 5350 @ 160), (23)
-	(5725 - 5875 @ 80), (23)
+	(5150 - 5250 @ 80), (30)
+	(5250 - 5350 @ 80), (24)
+	(5470 - 5725 @ 160), (24)
+	(5725 - 5875 @ 80), (30)
 
 country IR: DFS-JP
 	(2402 - 2482 @ 40), (20)
-- 
2.17.0


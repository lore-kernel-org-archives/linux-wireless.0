Return-Path: <SRS0=d+R+=CQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C33FC43461
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Sep 2020 06:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB96F206E7
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Sep 2020 06:35:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PzJ7uNek";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="DkBGHJnp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgIGGfh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Sep 2020 02:35:37 -0400
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:52944
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726286AbgIGGff (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Sep 2020 02:35:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599460534;
        h=From:To:Cc:Subject:Date:Message-Id;
        bh=Sya4sUBNbti70tyyqyKZBQo+UEfIFO2YYYfxkiow54E=;
        b=PzJ7uNekPJZtNL+Vu4GBSfeTvsB7G4C+xwwMX9owbaZM1SK/z3x0g1QmGBUipEr2
        nWFCCSDcCt17cZUeieyJtf84tPHGV//qStX69kfot0R2YSAAgi6w2+L3+m0Zk0cj2Hw
        PoDB4/bIBKQDi189k10QWRRNvZy68bmeC8LS5NGo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599460534;
        h=From:To:Cc:Subject:Date:Message-Id:Feedback-ID;
        bh=Sya4sUBNbti70tyyqyKZBQo+UEfIFO2YYYfxkiow54E=;
        b=DkBGHJnpczxkxsOv4ELweWHyMnXevu30jhFcZtjn2vQQzjvePN83SkhXyKK51U35
        IaiVzfof2eCLUP19x5eVfAaT5d9YGdo8ydMeHVZEcsa/kzi7G3C+UXQ5jYG60rqkdhD
        q4dRfiPcdu0IlwB7G2th5JXLtlJ6p9b3KaFYUpgI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 17360C43442
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh Chelvam <tamizhr@codeaurora.org>
Subject: [PATCH] iw: fix tid config help entries
Date:   Mon, 7 Sep 2020 06:35:34 +0000
Message-ID: <010101746746e7dc-fddbd674-90f6-42f7-9bb7-d41d524c6477-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 2.7.4
X-SES-Outgoing: 2020.09.07-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Tamizh Chelvam <tamizhr@codeaurora.org>

Fix help entries for TID config command by adding
"set tidconf" command info in that.

Signed-off-by: Tamizh Chelvam <tamizhr@codeaurora.org>
---
 interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/interface.c b/interface.c
index df96bed..c9da4b4 100644
--- a/interface.c
+++ b/interface.c
@@ -951,8 +951,8 @@ COMMAND(set, tidconf, "[peer <MAC address>] tids <mask> [override] [sretry <num>
 	"If MAC address is not specified, then supplied TID configuration\n"
 	"applied to all the peers.\n"
 	"Examples:\n"
-	"  $ iw dev wlan0 tids 0x1 ampdu off\n"
-	"  $ iw dev wlan0 tids 0x5 ampdu off amsdu off rtscts on\n"
-	"  $ iw dev wlan0 tids 0x3 override ampdu on noack on rtscts on\n"
-	"  $ iw dev wlan0 peer xx:xx:xx:xx:xx:xx tids 0x1 ampdu off tids 0x3 amsdu off rtscts on\n"
+	"  $ iw dev wlan0 set tidconf tids 0x1 ampdu off\n"
+	"  $ iw dev wlan0 set tidconf tids 0x5 ampdu off amsdu off rtscts on\n"
+	"  $ iw dev wlan0 set tidconf tids 0x3 override ampdu on noack on rtscts on\n"
+	"  $ iw dev wlan0 set tidconf peer xx:xx:xx:xx:xx:xx tids 0x1 ampdu off tids 0x3 amsdu off rtscts on\n"
 	);
-- 
1.9.1


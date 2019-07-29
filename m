Return-Path: <SRS0=PVbi=V2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F01C76186
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Jul 2019 19:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5555D206DD
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Jul 2019 19:01:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jCmb8f42"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbfG2TBT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Jul 2019 15:01:19 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33660 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfG2TBT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jul 2019 15:01:19 -0400
Received: by mail-lf1-f68.google.com with SMTP id x3so42921738lfc.0
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jul 2019 12:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f7vDMG/9SCpPW3zmkoq8GdvzJ3cq2Be8bwboqnhnU9g=;
        b=jCmb8f427PV3qj1uWfaSJXL5rAFWcKQemXCsb+vy3UPYc9C3eqBBCGwjDKuuZmL6ix
         Vb1dMN3EVn9qKSFzGOz7wq8b/fVTAwl3kBrBV2R6kdgxyLy7GnHilLnIFFy4pMKSQqC7
         KKxfvgTeqVWyUNSZpgCHJaexajWg+HrxO+xvL2c7c2VE3nnV5UyDZMCoBi8FfZF/V6Lm
         cEaL09A03fwBHzEpS7RX3YgFo0/LcMazoddlz8oHxnMhnjPcRYUTIWfuSt57oWadK6LY
         p8+8vcbmlD25w38E6X/eFPsY6uGS0ZXX68mVycATH/djkQve1Sjeq6s7b6TVYYgpcmrZ
         kYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f7vDMG/9SCpPW3zmkoq8GdvzJ3cq2Be8bwboqnhnU9g=;
        b=Glm91/C+8nOja34adO9eutWLa/ivtixS84va9/KBvpSaS6biNaJ/nz+kHOMXatQEkR
         q5ZkCuxiuOIvnG+rtkhv3vL9CVeyQ4a40CvQkL4gAaWlBKhcJIXPN/Yci9YuknuLVpDp
         mHNEIShRChjfdowqHbNEuUY3CP3Foru/3yv80FHnPXQWT45E0GZekRxemPy4kA2FJQ1F
         Kucm2JTSnb+DjvjJkcGJEB4aLCDGglsp0PiUE3ROrPn3y4IDWUpNnp5RWDvMWyOQythO
         X4m18O6UH5y+JQHRSM9v1Z2srNCJCFDoKpyhPVYf97h9EXB4xS4V9DEYIqSHZ9wVTnkt
         8DnA==
X-Gm-Message-State: APjAAAVynbQ6fpKExpd0Gmp+DHghKkKS+O80ED18nqa1jUnLFcAnKsv0
        emEoldTAPbkOBSQG357Sy5I=
X-Google-Smtp-Source: APXvYqzi6PTPDCGo9UbHeihDxg2gPfPmiVoZZ5d9cMcE9SO1bnrgayV3eHEWVGHj4lExc+RlIsU5sg==
X-Received: by 2002:a19:4a50:: with SMTP id x77mr8380672lfa.91.1564426877453;
        Mon, 29 Jul 2019 12:01:17 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:dc6e:0:c4ca:724:d773:277d])
        by smtp.gmail.com with ESMTPSA id q22sm13151367lje.75.2019.07.29.12.01.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Jul 2019 12:01:16 -0700 (PDT)
From:   Dmitry Tunin <hanipouspilot@gmail.com>
To:     Seth Forshee <seth.forshee@canonical.com>
Cc:     wireless-regdb@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Dmitry Tunin <hanipouspilot@gmail.com>
Subject: [PATCH v2] wireless-regdb: update regulatory rules for Russia (RU) on 5GHz
Date:   Mon, 29 Jul 2019 22:01:09 +0300
Message-Id: <1564426869-25218-1-git-send-email-hanipouspilot@gmail.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Russian entry is incorrect. According to the last regulations document of Feb 29, 2016,
160 MHz channels and 802.11ad are allowed.

http://rfs-rf.ru/upload/medialibrary/c1a/prilozhenie-1-k-resheniyu-gkrch-_-16_36_03.pdf

Note that there was never a DFS requirement in Russia, but always was
NO-OUTDOOR on 5GHz.
Maximum power is 200mW that is ~23dBm on all 5GHz channels.
Also Russia has never been regulated by ETSI.

Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>
---
 db.txt | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/db.txt b/db.txt
index 37393e6..068fb5a 100644
--- a/db.txt
+++ b/db.txt
@@ -1097,14 +1097,12 @@ country RS: DFS-ETSI
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
-country RU: DFS-ETSI
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5650 - 5730 @ 80), (30), DFS
-	(5735 - 5835 @ 80), (30)
-	# 60 GHz band channels 1-4, ref: Changes to NLA 124_Order №129_22042015.pdf
-	(57000 - 66000 @ 2160), (40)
+country RU:
+(2402 - 2482 @ 40), (20)
+(5170 - 5350 @ 160), (23), NO-OUTDOOR
+(5650 - 5850 @ 160), (23), NO-OUTDOOR
+# 60 GHz band channels 1-4, ref: Changes to NLA 124_Order №129_22042015.pdf
+(57000 - 66000 @ 2160), (40), NO-OUTDOOR
 
 country RW: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
2.7.4


Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB87BC43610
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 18:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CAA121104
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 18:01:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="jVY4TZQ9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CAA121104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732101AbeKTE0T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 23:26:19 -0500
Received: from plaes.org ([188.166.43.21]:48080 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731749AbeKTE0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 23:26:18 -0500
Received: from localhost (85.253.196.132.cable.starman.ee [85.253.196.132])
        by plaes.org (Postfix) with ESMTPSA id 57E9041D87;
        Mon, 19 Nov 2018 18:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1542650502; bh=X4EuyfFCuCcGJxvlQkhxQGJ8ADHNoLNT7nr7JVqLAqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jVY4TZQ9jTkp81XUILMg8FBId7RY/jnPAQ2nZAPhhdgpEjfFVBHijjjH4eOQIZ18V
         THdl4T0b/7//CXZ+TKFgIOhLKrPvgwlzxorxQCg/ZXYV4ZKFtrDZtIaVibW+Hp717+
         Jt7LCiteYwYnZtUjqQYFPlXE5YQ9FhyokSy17eM5EcZEvPG/P8EhnmsZnKgBN8/wMd
         XAkPAaEKk5A3++zT1c9jikSEmQNZP+pcggKsAJ1Rm0QKAPU+QfjhE3qvqaP8HQe23H
         IS3YxTJNB764ruNg0I9A6fmeh7SAF1OyyP9ex3uGSSWiuNcLSdbZLaw6nFc9x8gP6o
         bEdzIRel3VOcA==
From:   Priit Laes <plaes@plaes.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Priit Laes <plaes@plaes.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH 3/4] b43: Fix error in cordic routine
Date:   Mon, 19 Nov 2018 20:01:24 +0200
Message-Id: <9a75ef344436e3e4cb676a3dec7baac63bf476c8.1542649316.git-series.plaes@plaes.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.87f16ede7954f8d9cde4ecae5f050bf8f4008dd8.1542649316.git-series.plaes@plaes.org>
References: <cover.87f16ede7954f8d9cde4ecae5f050bf8f4008dd8.1542649316.git-series.plaes@plaes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

The cordic routine for calculating sines and cosines that was added in
commit 6f98e62a9f1b ("b43: update cordic code to match current specs")
contains an error whereby a quantity declared u32 can in fact go negative.

This problem was detected by Priit Laes who is switching b43 to use the
routine in the library functions of the kernel.

Fixes: 986504540306 ("b43: make cordic common (LP-PHY and N-PHY need it)")
Reported-by: Priit Laes <plaes@plaes.org>
Cc: Rafał Miłecki <zajec5@gmail.com>
Cc: Stable <stable@vger.kernel.org> # 2.6.34
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/net/wireless/broadcom/b43/phy_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_common.c b/drivers/net/wireless/broadcom/b43/phy_common.c
index 85f2ca9..ef3ffa5 100644
--- a/drivers/net/wireless/broadcom/b43/phy_common.c
+++ b/drivers/net/wireless/broadcom/b43/phy_common.c
@@ -616,7 +616,7 @@ struct b43_c32 b43_cordic(int theta)
 	u8 i;
 	s32 tmp;
 	s8 signx = 1;
-	u32 angle = 0;
+	s32 angle = 0;
 	struct b43_c32 ret = { .i = 39797, .q = 0, };
 
 	while (theta > (180 << 16))
-- 
git-series 0.9.1

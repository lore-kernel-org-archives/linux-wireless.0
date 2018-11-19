Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3902C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 18:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F77F21104
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 18:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="XZGiKwIj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F77F21104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732066AbeKTE0R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 23:26:17 -0500
Received: from plaes.org ([188.166.43.21]:48044 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731493AbeKTE0R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 23:26:17 -0500
Received: from localhost (85.253.196.132.cable.starman.ee [85.253.196.132])
        by plaes.org (Postfix) with ESMTPSA id 1F3D540717;
        Mon, 19 Nov 2018 18:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1542650501; bh=ihZKLRanXwtAPkeZZ0ztYQHLsrnqMv1YvZeqoutHMFs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XZGiKwIjUcFnvE4XAC6OBEO1GDZlpfqp9NBSg5FMikCTccSb27TYffbGYBn8lfzjt
         TMk6V61qXRi4hkj29aNPUQFnJtGNsVdperlf2oB7D6vlpR0gESI6O1kHEhRFye5Jg1
         wdwO991N1ULVFmxTjQDIP4JhIlHKVYzQoDDBrjof/P2kuNRHFTa9C9E0x0bvT9wxol
         RDnGEyWJXjvGY3ijWM4jUqLWV0IUalnhtZZKam9jzZlpuMi877VozlZrHm5yKABHIU
         BG0SUCRZUtdBaVJHDOKMTY5bLK0XyxpsJvn1/ypUxFuYCcy7FhS5MX5TEb4Q6P3WzH
         K00rrNkq83k/Q==
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
Subject: [PATCH 1/4] lib: cordic: Move cordic macros and defines to header file
Date:   Mon, 19 Nov 2018 20:01:22 +0200
Message-Id: <f8fe8791a325686cafa8d0b841951e27f68e29d6.1542649316.git-series.plaes@plaes.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.87f16ede7954f8d9cde4ecae5f050bf8f4008dd8.1542649316.git-series.plaes@plaes.org>
References: <cover.87f16ede7954f8d9cde4ecae5f050bf8f4008dd8.1542649316.git-series.plaes@plaes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Now that these macros are in header file, we can eventually
clean up the duplicate macros present in the drivers that
utilize the same cordic algorithm implementation.

Also add CORDIC_ prefix to nonprefixed macros.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Priit Laes <plaes@plaes.org>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 include/linux/cordic.h |  9 +++++++++
 lib/cordic.c           | 23 +++++++----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/cordic.h b/include/linux/cordic.h
index cf68ca4..3d656f5 100644
--- a/include/linux/cordic.h
+++ b/include/linux/cordic.h
@@ -18,6 +18,15 @@
 
 #include <linux/types.h>
 
+#define CORDIC_ANGLE_GEN	39797
+#define CORDIC_PRECISION_SHIFT	16
+#define CORDIC_NUM_ITER	(CORDIC_PRECISION_SHIFT + 2)
+
+#define CORDIC_FIXED(X)	((s32)((X) << CORDIC_PRECISION_SHIFT))
+#define CORDIC_FLOAT(X)	(((X) >= 0) \
+		? ((((X) >> (CORDIC_PRECISION_SHIFT - 1)) + 1) >> 1) \
+		: -((((-(X)) >> (CORDIC_PRECISION_SHIFT - 1)) + 1) >> 1))
+
 /**
  * struct cordic_iq - i/q coordinate.
  *
diff --git a/lib/cordic.c b/lib/cordic.c
index 6cf4778..8ef27c1 100644
--- a/lib/cordic.c
+++ b/lib/cordic.c
@@ -16,15 +16,6 @@
 #include <linux/module.h>
 #include <linux/cordic.h>
 
-#define CORDIC_ANGLE_GEN	39797
-#define CORDIC_PRECISION_SHIFT	16
-#define	CORDIC_NUM_ITER		(CORDIC_PRECISION_SHIFT + 2)
-
-#define	FIXED(X)	((s32)((X) << CORDIC_PRECISION_SHIFT))
-#define	FLOAT(X)	(((X) >= 0) \
-		? ((((X) >> (CORDIC_PRECISION_SHIFT - 1)) + 1) >> 1) \
-		: -((((-(X)) >> (CORDIC_PRECISION_SHIFT - 1)) + 1) >> 1))
-
 static const s32 arctan_table[] = {
 	2949120,
 	1740967,
@@ -64,16 +55,16 @@ struct cordic_iq cordic_calc_iq(s32 theta)
 	coord.q = 0;
 	angle = 0;
 
-	theta = FIXED(theta);
+	theta = CORDIC_FIXED(theta);
 	signtheta = (theta < 0) ? -1 : 1;
-	theta = ((theta + FIXED(180) * signtheta) % FIXED(360)) -
-		FIXED(180) * signtheta;
+	theta = ((theta + CORDIC_FIXED(180) * signtheta) % CORDIC_FIXED(360)) -
+		CORDIC_FIXED(180) * signtheta;
 
-	if (FLOAT(theta) > 90) {
-		theta -= FIXED(180);
+	if (CORDIC_FLOAT(theta) > 90) {
+		theta -= CORDIC_FIXED(180);
 		signx = -1;
-	} else if (FLOAT(theta) < -90) {
-		theta += FIXED(180);
+	} else if (CORDIC_FLOAT(theta) < -90) {
+		theta += CORDIC_FIXED(180);
 		signx = -1;
 	}
 
-- 
git-series 0.9.1

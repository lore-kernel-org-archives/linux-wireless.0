Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31395C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 18:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 029AC223DD
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 18:28:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="e/YqReKJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 029AC223DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732702AbeKOEcT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 23:32:19 -0500
Received: from plaes.org ([188.166.43.21]:55056 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727736AbeKOEcT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 23:32:19 -0500
Received: from localhost (85.253.196.132.cable.starman.ee [85.253.196.132])
        by plaes.org (Postfix) with ESMTPSA id 0BB4440622;
        Wed, 14 Nov 2018 18:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1542220078; bh=RJwUHvr9Ne1mH2Zgg/JQJSJDjz2ApvYY1EYoN0gJaY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/YqReKJZSgzVAgrkObaruIfzOtUhU4Aa4sJGMzyWIkfbJbZck4TUByli8Kt7rRLX
         ITaKdWs9zBpYYSfkEEQoV1KIfzbcv3eFbPQ6/mlBsdx0AkZewZ7sMnPepiolSLxNnr
         8Zfg4n+rKankElaB97nJ0gKrQxUy0CIc6KUuwtFxvIEAAnHuIcPOsFJpQk417nth+V
         FHpDnENdgQUeg9LM/iLfUqlx49FJtycJ/RLeBO1DtqRkb5M0qZ95MzHkC/UJ2qzof6
         TJRziR2ZK2foYaSuxWn8ttXkbY63SYK6oyo7U0ei5y84QWU5ZzbOsjl/4px7kBV/sh
         DQ+anUwe2iSpA==
From:   Priit Laes <plaes@plaes.org>
To:     Kees Cook <keescook@chromium.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     Priit Laes <plaes@plaes.org>
Subject: [PATCH v3 1/3] lib: cordic: Move cordic macros and defines to header file
Date:   Wed, 14 Nov 2018 20:27:50 +0200
Message-Id: <83271554b8c5e02c9379ce5ed9b7f3e00bf31111.1542219596.git-series.plaes@plaes.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.c0b1738f3f06bbf87f4ad3200ece93322a5f135f.1542219596.git-series.plaes@plaes.org>
References: <cover.c0b1738f3f06bbf87f4ad3200ece93322a5f135f.1542219596.git-series.plaes@plaes.org>
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

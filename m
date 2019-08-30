Return-Path: <SRS0=jb13=W2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10F8C3A59B
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 16:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE9CC2342F
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 16:56:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nkQ4Em09"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfH3Q4u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Aug 2019 12:56:50 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43825 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfH3Q4t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Aug 2019 12:56:49 -0400
Received: by mail-lj1-f196.google.com with SMTP id h15so7083993ljg.10
        for <linux-wireless@vger.kernel.org>; Fri, 30 Aug 2019 09:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LqizBXax0mkO4gxIZRPwBrd4VcJG7zs6D6D/3vSkVdo=;
        b=nkQ4Em09M/EJ1BWGTo3sxQANyOOs8LboG1LQh66nOapSCQ1YakZhv/IbA8g9ZaPHBg
         sYucTURCONeFJakGGyFcE7repjibY04K7FVtdOdhB8N04pMERv8eyKJPAI/8SwLzLYGn
         1fv/fYzgOiPpLPNswHMoMIb03fuNaaMy0PRUU6nhZjgHzhmwmAjZxBzVzyBmxniWKrqu
         JTBg43qyBex+QkAusLI/KVD8qf1qJMvBYCvmREiLDxIkQ72OgjtZ2cVXPZZKrTUi9+Re
         SOUVNg8DVETR/Z3U2mEcgdSM4RbEeS8FTxU8dfQ5RWbVDrOt98l0RsY1frDtU9lUFFJp
         MO7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LqizBXax0mkO4gxIZRPwBrd4VcJG7zs6D6D/3vSkVdo=;
        b=FfwON8s9mT7Z7l4p2fSuxV7MQYGqOCmNk1GJ/yV+LBZL/dlcF8fEK8n4Oprdge63NA
         +x2yK/8mXawgWhOYmvSXWiypouJDmTrdL0+fhgSNMb2DAsw7XU559azUlCjZxTJb32Dw
         6YSr9UHBFxdyHPz6uuIsAZE8q3omfWm6RQ1Pf5cV2rhBi/uOl/PBraC5bBbBf+QsdnVe
         biuUb12SJFF1PrcW26YHaWrg8e6yVl7rPUdOSqMvIK1PtGLlReS1YMjhCZLyEoTEOlvr
         Co8OzlLxcWifSw0cbamG4Fu+z6Oecx1+jWZ8fZCbyE9OBmmDctJyEc7aC1jJoRiokVWo
         CvEQ==
X-Gm-Message-State: APjAAAUOsTewuE1EibKo1LUaGPuQ4Pww8MQepcmF12jSFmTY7/vHmeNX
        RWxedAqtik8yGQcQNH+vfyY=
X-Google-Smtp-Source: APXvYqwmJLM91wWs1FSSXYmou50YeFpjAtM6iVh+Iymrriiq2OQq57EiGlQXlnKQIQZ8rjahhF8RMg==
X-Received: by 2002:a05:651c:104a:: with SMTP id x10mr8730610ljm.238.1567184208119;
        Fri, 30 Aug 2019 09:56:48 -0700 (PDT)
Received: from natasha-samsung.lan ([31.173.80.208])
        by smtp.gmail.com with ESMTPSA id s21sm925348ljm.28.2019.08.30.09.56.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 30 Aug 2019 09:56:47 -0700 (PDT)
From:   Dmitry Tunin <hanipouspilot@gmail.com>
To:     seth.forshee@canonical.com
Cc:     wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
        Dmitry Tunin <hanipouspilot@gmail.com>
Subject: [PATCH] =?UTF-8?q?wireless-regdb:=20update=20regulatory=20rulez?= =?UTF-8?q?=20for=20Kazak=D1=80stan=20(KZ)?=
Date:   Fri, 30 Aug 2019 19:56:35 +0300
Message-Id: <1567184195-24992-1-git-send-email-hanipouspilot@gmail.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Update according to the regulatory rule of January 21, 2015

http://egov.kz/cms/ru/law/list/V1500010730
https://tengrinews.kz/zakon/pravitelstvo_respubliki_kazahstan_premer_ministr_rk/svyaz/id-V1500010730/

No DFS or TPC is mentioned in the document. Neither is 80 MHz channel width.

Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>
---
 db.txt | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/db.txt b/db.txt
index 37393e6..491598e 100644
--- a/db.txt
+++ b/db.txt
@@ -717,13 +717,13 @@ country KY: DFS-FCC
 	(5735 - 5835 @ 80), (30)
 
 # Source:
-# http://mic.gov.kz/sites/default/files/pages/pravila_prisvoeniya_polos_chastot_no34.pdf
-# http://adilet.zan.kz/rus/docs/P000001379_
-country KZ: DFS-ETSI
-	(2402 - 2482 @ 40), (20)
-	(5150 - 5250 @ 80), (20), NO-OUTDOOR, AUTO-BW
-	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
-	(5470 - 5725 @ 80), (20), NO-OUTDOOR, DFS
+# http://egov.kz/cms/ru/law/list/V1500010730
+# https://tengrinews.kz/zakon/pravitelstvo_respubliki_kazahstan_premer_ministr_rk/svyaz/id-V1500010730/
+country KZ:
+	(2400 - 2483.5 @ 40), (20)
+	(5150 - 5350 @ 160), (23), NO-OUTDOOR
+	(5470 - 5850 @ 160), (20), NO-OUTDOOR
+	(57000 - 66000 @ 2160), (40), NO-OUTDOOR
 
 country LB: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
2.7.4


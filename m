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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA74C3A59B
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 18:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1255B23428
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 18:24:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OOq1vsLw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfH3SY6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Aug 2019 14:24:58 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42357 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbfH3SY6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Aug 2019 14:24:58 -0400
Received: by mail-lf1-f67.google.com with SMTP id u13so6033013lfm.9
        for <linux-wireless@vger.kernel.org>; Fri, 30 Aug 2019 11:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LqizBXax0mkO4gxIZRPwBrd4VcJG7zs6D6D/3vSkVdo=;
        b=OOq1vsLwa1a9i5o5V0tpumZkGA0sCFcj1LWj0yEkSAb4HA83qFOg7UWZHyvv5eJ2vb
         lgSXy3Jb5rsM31PBYmbNQAqASqqodRziCInWPXTs5wB8wee4K9QkN1sbmJwLO8kkl9pd
         lPDLC6bZLtwjqXyN3sF+9e678dZL23DahU1ZbOeZpthGiEZemYjgc6yZjGvqLY5DUJhp
         AC56G+nMIUgKdO+WYrOeEnrffuLyjywDgQwt9ZGyCcinRkZxVs5/ZNf5sqgJNBoK2pWg
         W95/GWYauCNB83WiDHqhpvZdOLzul4fuLOVRH1Jp9e0pJ8A6wsQHbikkkpXarl/uBWwn
         6BTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LqizBXax0mkO4gxIZRPwBrd4VcJG7zs6D6D/3vSkVdo=;
        b=c6JLtundtbRRFtJQWgF4F8Gnk7wLqp5qke3j70CcV49XNVvQR7NadIgoBqY9/P+vTi
         V0QLcv4klGQUpq5WbOYJUPfPkNL8IaqmEigCZGk82HqELiOMx0gzTwW9IBPPka6PvJE9
         rmvPDcmFJkSm8DruBZUx9AcW+QUf9TqBCpL+TFQYDHh8mt3zhvHE+s2j6QFdhECF8L1I
         E4mWo8i2DFeLftMhYwbFUH1+YODJIhm0dFKlclYxew8rRXDCUGffBb0FP6LE/xOJaUTJ
         Z9wjG/50Ll3AqR8ifBjZItmQZGV2IbpCc5uWEwvv/pP+yeXA2vzsVYxU13uAmQkLz4Av
         zwrQ==
X-Gm-Message-State: APjAAAUfCYdpB6Vh0YyNcffjEN+mMiHjF4LCc/fhfYAFmGtnv9Ayn9SP
        iLpi7WanHuqaJ8gg+1yyxGM=
X-Google-Smtp-Source: APXvYqwcHbqBm+luFzKpYkIk0xlapT+rt17AOkOKtFazI0wG4OO/rIQHWREf6QUSzpCDPsZKaJEH5w==
X-Received: by 2002:ac2:46d8:: with SMTP id p24mr9921281lfo.58.1567189496132;
        Fri, 30 Aug 2019 11:24:56 -0700 (PDT)
Received: from natasha-samsung.lan ([31.173.80.208])
        by smtp.gmail.com with ESMTPSA id o10sm968399ljd.53.2019.08.30.11.24.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 30 Aug 2019 11:24:55 -0700 (PDT)
From:   Dmitry Tunin <hanipouspilot@gmail.com>
To:     seth.forshee@canonical.com
Cc:     wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
        Dmitry Tunin <hanipouspilot@gmail.com>
Subject: [PATCH v2] wireless-regdb: update regulatory rules for Kazakhstan (KZ)
Date:   Fri, 30 Aug 2019 21:24:44 +0300
Message-Id: <1567189484-27536-1-git-send-email-hanipouspilot@gmail.com>
X-Mailer: git-send-email 2.7.4
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


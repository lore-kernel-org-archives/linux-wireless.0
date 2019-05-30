Return-Path: <SRS0=3DzK=T6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CCDFC28CC0
	for <linux-wireless@archiver.kernel.org>; Thu, 30 May 2019 11:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12179257AC
	for <linux-wireless@archiver.kernel.org>; Thu, 30 May 2019 11:00:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KiaAOaDv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfE3LAw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 May 2019 07:00:52 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:45279 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfE3LAw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 May 2019 07:00:52 -0400
Received: by mail-wr1-f50.google.com with SMTP id b18so3875772wrq.12
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2019 04:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MGPVSvsyKkN6sDIhHTrpeJlzh0x/CzT2w7QlXH6Xvy0=;
        b=KiaAOaDvOsiPSwH83Hpw+7stZDBgTmT5AgqYI9ExYk2RVu3jpecfhZ2PW9wf0qGP8G
         9TltfC/MM1+heZMb9OkVRTcX7SzJuTpkldF0zgSyXiIzcEptIGN8fpZHW4QB/3GPT7h7
         mGuHJuGwfWn1VZ+mFAVDdlhqjdsfkjilKxr4CbGLUM21uhgZaO0kEsJsVqQ3GPO7CEpH
         oxEx3piaksfnb5c/zkJVvElpSesTQWVkH3oHjb445r01grjfY7WrbqYRnmLUkIayQgcG
         3T698YqHEznrelnfEBGHj7RIc0z2jV5elKZNISsPtNsL9XKIbwVatdrP4p/HKkr8GXwb
         L3og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MGPVSvsyKkN6sDIhHTrpeJlzh0x/CzT2w7QlXH6Xvy0=;
        b=bpGQTg2YLL+/61Fay69wIn5ue7/tBJoYnChlzYu7jzUzyr9eVUKsGDYm2kRn5fMc4a
         AaL8UXn/AhmpOSLgNdKClJI4cMG/lcO28ljItDrfuM2vOgWKKb7KtOlcjAQb1mdYte7U
         EXIMG1nUIX3pZsYVUMpguGXmB61EKKcrx8oOqC+Zf87WrEcy8G5w6rRD6O/I0rLXeaWY
         x+x+H4fUwEnMSg0hRC1/eEiKJjeLbLK4Vv1Q9YPBHbQUnsbeF8Bd4JXQm3xs3RVQWdfC
         aIjNpMKmTiPLMyJT2d4tB8nl+BVhg+gjX7ykfWT120r6qdC5hpK2tTNOoNQ9QcogwPNk
         EfBg==
X-Gm-Message-State: APjAAAV1YWVNMOkdX56KhLg7FLThR8AlLlcLx4AbRv0ID0T/3ZN4v4jC
        0h5uQEvThCXc4m2qqGimmw==
X-Google-Smtp-Source: APXvYqzj8Mzt2UCrtly1Zq1k+Ayl3WykmdVC77eZ8UoUaO4RYLV1qY5dREXs6UegIIJpA5tP97vHUA==
X-Received: by 2002:adf:f250:: with SMTP id b16mr2241237wrp.24.1559214050549;
        Thu, 30 May 2019 04:00:50 -0700 (PDT)
Received: from localhost (118.red-88-12-24.staticip.rima-tde.net. [88.12.24.118])
        by smtp.gmail.com with ESMTPSA id u205sm2841767wmu.47.2019.05.30.04.00.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 04:00:49 -0700 (PDT)
From:   Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc:     Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        WIRELESS ML <linux-wireless@vger.kernel.org>,
        REGDB ML <wireless-regdb@lists.infradead.org>
Subject: [PATCH] wireless-regdb: update source of information for CU
Date:   Thu, 30 May 2019 13:00:47 +0200
Message-Id: <20190530110047.3449-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: WIRELESS ML <linux-wireless@vger.kernel.org>
Cc: REGDB ML <wireless-regdb@lists.infradead.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 db.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 6b65312..3bdc7c0 100644
--- a/db.txt
+++ b/db.txt
@@ -316,7 +316,7 @@ country CR: DFS-FCC
 	(5735 - 5835 @ 20), (30)
 
 # Source:
-# http://www.mincom.gob.cu/?q=marcoregulatorio
+# https://www.mincom.gob.cu/es/marco-legal
 # - Redes Informáticas
 # Resolución 127- 2011 Reglamento de Banda de frecuencias de 2,4 GHz.
 country CU: DFS-FCC
-- 
2.21.0


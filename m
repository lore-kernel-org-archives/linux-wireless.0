Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA5BC4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C6AD21B18
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:36:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QZCKOWXE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503414AbfBNWgw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 17:36:52 -0500
Received: from mail-ot1-f51.google.com ([209.85.210.51]:43509 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405500AbfBNWgv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 17:36:51 -0500
Received: by mail-ot1-f51.google.com with SMTP id n71so13349041ota.10
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 14:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eGi9/eJljIeQYXiYfKWLNKcQS6LcAfC2vcmSTbnEN/g=;
        b=QZCKOWXEJNEPj4+QbABR86Ai/QFUvzWP2pbp0IODRJxVmcjPyUX+K8YWfIiherD5cH
         gX2o0JA6X9KZCj2uvhi6Si7pE/FnNbr62ktV0Q4m/83BGJEIbN5MfrJ0xVFvXB1vo8cQ
         I2eVbUvIwTUV87hfj06npPOoon/LcfzFbUDWZ2EHdrXJteb1xXBFWWvjz5DwGR+gHjYb
         /iJLwWbYJ0GYFFWNDSZbFDR3Xxv/fFVqpMTxjr6zkuWwu1WK1I3OmWbbs9H7GOPfblJ6
         OiJky7GUeACglG19X1/XOMMaojop17c6LKi1NRBxD1XSjnTAzd0qrItY/YUX9sJvFabf
         7g6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=eGi9/eJljIeQYXiYfKWLNKcQS6LcAfC2vcmSTbnEN/g=;
        b=mOg/n3QVGu4Q6JuOX4ZDhAdVjCKRgozzIrDsenhhx0RjgojAgN/F1AcZ4tPPg683N2
         SHw5KgQZyH/H2++A2CKGz6RnVtei5YZuHQ8dcFv1Oal2XNoN+677Da83HqR5zMZjUMep
         SEBZQXrhAUJqP4+LMrefa45x62ezWnk1jfDP6KzCiJ/6v+q6DBB8cxZOPNSL+dp5yShF
         oVGYpu7dUml8RMwv7SrcqxrVBUdcP3qWirPdcNCZFddb0LLBG8mhh2bm3D/ijS49P/I1
         gGK30RKtTpj/3//18B/NC+QJZXX0KQnIaS7dVD+4mKBhmQ3D+S62JflQAsqjgij9FjZg
         SyZw==
X-Gm-Message-State: AHQUAuZHnTIzvDNXknICbuDeYeVI9baDJ4EvwXIZchsUzo9gGvkL4LaU
        CgTfrIWOTq1eB/XXPrH6zxk=
X-Google-Smtp-Source: AHgI3IZR+e2UyynBZ33Xoq1N5vblAxmlzWC1vl9rhwiV/FrNoKzf8+Mj0fd2dcBlfPnEbQQTdIlHBA==
X-Received: by 2002:a9d:2c5:: with SMTP id 63mr3855861otl.271.1550183811182;
        Thu, 14 Feb 2019 14:36:51 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id h1sm1463938otm.0.2019.02.14.14.36.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 14:36:50 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3/8] rtlwifi: rtl8188ee: Remove CamelCase variable
Date:   Thu, 14 Feb 2019 16:36:39 -0600
Message-Id: <20190214223644.8035-4-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
References: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This driver contains one instance of a CamelCase variable, namely
IS_81xxC_VENDOR_UMC_A_CUT. This macro is never used, thus it is deleted.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h
index 0d856c82a622..e5a28b16b367 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h
@@ -101,9 +101,6 @@
 
 #define IS_92C_SERIAL(version)						\
 	((IS_81XXC(version) && IS_2T2R(version)) ? true : false)
-#define IS_81xxC_VENDOR_UMC_A_CUT(version)				\
-	(IS_81XXC(version) ? ((IS_CHIP_VENDOR_UMC(version)) ?		\
-	 ((GET_CVID_CUT_VERSION(version)) ? false : true) : false) : false)
 #define IS_81XXC_VENDOR_UMC_B_CUT(version)				\
 	(IS_81XXC(version) ? (IS_CHIP_VENDOR_UMC(version) ?		\
 	((GET_CVID_CUT_VERSION(version) == B_CUT_VERSION) ? true	\
-- 
2.20.1


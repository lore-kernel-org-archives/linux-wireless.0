Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLACK,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB52C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DB2F21B18
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:36:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pLvoAqw+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503410AbfBNWgv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 17:36:51 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46438 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405500AbfBNWgu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 17:36:50 -0500
Received: by mail-ot1-f68.google.com with SMTP id w25so13314152otm.13
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 14:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9VH3tfNrw9dHJ7LEJ7Xwmdua3GtyTj8ggL1H9eXNMxo=;
        b=pLvoAqw+2rIkOCbhAzD0zeIzFdf2up8XmmeoARjCy2vSOxEwNf7UkEyr/bEWa0Kz5M
         jzavwlmywqdRMbGKOj5i4xV5b8Ji+a6Yy+jGMEEkGVfifIbS7g9vj9n6WN8NS4H8exn3
         2odRs+aA1x3F70I6gahc05KUDenk6zVbFjwE9xV550kSPTHum4S6skY/FdOBrnCz8Bnh
         2x57uzoraTpdd8+OHYZg3ezvxAKpFJMuY32J92NA4R+9WITJbT2WS9AnYRtaaNKCfkVB
         jTF+U2CdogWi1lhAy8+G3DA6raPuAL1eNh+Exp8qZvOm++8brA4xelwRQjdTVWLzlfKF
         eWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=9VH3tfNrw9dHJ7LEJ7Xwmdua3GtyTj8ggL1H9eXNMxo=;
        b=DQowu+K41QOXlLLkVoP5z+JanB2hM9i/AIZJRP2yONS0fJNwOTp5X+mku9LGd6xvN1
         7c6ruYNMtZVcKihYboLtHygFMefmwktb8SN7hdWkctexbW9FUfU4qsTy14s2chCOkgJi
         P9l5Z34DzCnw5M3TutJuTFlfc02VNAW6WuX2zE/ugG8T6r9+eN8eStswidDBnFQ6YruN
         q/aeORVnySJL9+0IB5tevBQbScO2RrZlzJeSqDOdMAiumzUKFhPJrG0wdHfOsKG3zX8b
         o73WfS8z4p7Mu2Jvaz6ORqCqdb4TRgkDfX0DUgLlklegLeWskZ4/mxzr412kvXWkKgtl
         sfHw==
X-Gm-Message-State: AHQUAuaeanCU9fgSh8r8y7XnE8np2NUjtHwfrtO/oAsnRE9/TGBzxYSA
        noZhQkbzASFV3s2voilQei99WJ6S
X-Google-Smtp-Source: AHgI3IbryWRH4SkGCTDGiPlNyDqje7GnCL5UMKOybnMPUyv5jcLTgpclcpCR2CWdjlrmMkhmQbt9pA==
X-Received: by 2002:aca:2803:: with SMTP id 3mr4014024oix.85.1550183810113;
        Thu, 14 Feb 2019 14:36:50 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id h1sm1463938otm.0.2019.02.14.14.36.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 14:36:49 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/8] rtlwifi: btcoexist: Remove CamelCase variable
Date:   Thu, 14 Feb 2019 16:36:38 -0600
Message-Id: <20190214223644.8035-3-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
References: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

File halbt_precomp.h contains the only CamelCase value, namely
GetDefaultAdapter, but that macro is never used, thus it is deleted.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
index 8705c85c2693..d191044976d0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
@@ -28,8 +28,6 @@
 #include "halbtc8821a2ant.h"
 #include "halbtc8821a1ant.h"
 
-#define GetDefaultAdapter(padapter)	padapter
-
 #define BIT0	0x00000001
 #define BIT1	0x00000002
 #define BIT2	0x00000004
-- 
2.20.1


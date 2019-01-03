Return-Path: <SRS0=/Gk3=PL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A653BC43444
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 16:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77701208E3
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 16:17:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vRZSGYA+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbfACQRm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Jan 2019 11:17:42 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54451 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730643AbfACQRl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Jan 2019 11:17:41 -0500
Received: by mail-wm1-f66.google.com with SMTP id a62so29738230wmh.4;
        Thu, 03 Jan 2019 08:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NgVoBB3rcE4w9cV8qoZp5uAmJgYcYDUWRIoHDLWeIeA=;
        b=vRZSGYA+7TxdT8R8EC+Y43ZkHCxFkqt2/f01MJUaTXfrRrb4+hlYTEmY10ko9IDZTa
         B9lYyauNQMEh7LtSQkQKZDesWFdGjio7tU+kRPRZfiGX2DbF/eCkcU4jbCIznkQiAcwO
         NkKuo+Uyeqw61XBlIMr4AwaYjRlqSh3+iUTCYYApQcgsLjx/IydrRHU26PKZsg5f5kU7
         1fvvIcHok468lBHMInyMVG2KPcVUCUV+s8RUZD7IOFifBR8Odo3FAp+GkqMUmugkPoA7
         zG0HxF3tPCuHrHDkO6csjo86uvseBCZTVWiX+El5ovEfz/lZAI+3bG4oHujRl5Avi/P7
         nloA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NgVoBB3rcE4w9cV8qoZp5uAmJgYcYDUWRIoHDLWeIeA=;
        b=pZTywGIeJ2fgHaSlW0HjrC9T5QrH6znNb+xpmnkLWwD09Pt7YLCUx/2lS/jdLKR6ui
         TPMryi2neaMKAv+K251q/hDJO88kuUjpG4arIL7jlp/2K2MLR1CR7V04NrwGYBL5Tj9Q
         yyXnZWrRYQaurLNBMV9R/eMoHzqMWD2jKRv5cut+5GxCFnVVegcCYlNny0B8s7XFxv+l
         yUSDtDagnD42sfXlUNpcgKO3WDmL/ukKGpwjLjhMjBXo8c1oHzl7jHRCkP2bTzcpAWLd
         4WAU/piXt5/ssY76O9WVAtKy/Y9UCK2nD0sgtqtG96OgO4ej6T3lU8e9dW8HL3n6dyQg
         CAnQ==
X-Gm-Message-State: AA+aEWb9y/2DavP6bd0u0oPatNrJigm7n1/kA6L3CRFFURpkyX3QOYBS
        DTM7DCq3jkc3pEd6Aa1WGkp67Y9e
X-Google-Smtp-Source: AFSGD/WQBp1epbKM+OeZcSSikjfSMaKzlVUWshuUi1IKNbh7XR0+jzDyIDgCPdChaavHMAa7owCjxQ==
X-Received: by 2002:a1c:c10f:: with SMTP id r15mr39317835wmf.27.1546532258570;
        Thu, 03 Jan 2019 08:17:38 -0800 (PST)
Received: from localhost.localdomain ([80.30.9.98])
        by smtp.gmail.com with ESMTPSA id a17sm39121952wma.15.2019.01.03.08.17.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 03 Jan 2019 08:17:37 -0800 (PST)
From:   Juan Manuel Torres Palma <j.m.torrespalma@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, ajay.kathat@microchip.com,
        adham.abozaeid@microchip.com, j.m.torrespalma@gmail.com
Subject: [PATCH] staging: wilc1000: define wilc_get_stats_async as static
Date:   Thu,  3 Jan 2019 17:18:05 +0100
Message-Id: <20190103161805.4581-1-j.m.torrespalma@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Declare wilc_get_stats_async as static since it's only
used within the definition file scope.

Signed-off-by: Juan Manuel Torres Palma <j.m.torrespalma@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 70c854d939ce..5dae6e7155d3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1992,7 +1992,7 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 	return result;
 }
 
-int wilc_get_stats_async(struct wilc_vif *vif, struct rf_info *stats)
+static int wilc_get_stats_async(struct wilc_vif *vif, struct rf_info *stats)
 {
 	int result;
 	struct host_if_msg *msg;
-- 
2.20.1


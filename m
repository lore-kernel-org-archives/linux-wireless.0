Return-Path: <SRS0=rB3s=VV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45550C76191
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 11:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 153342190F
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 11:28:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GWconWTC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfGXL2B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Jul 2019 07:28:01 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39261 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbfGXL2A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jul 2019 07:28:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id f17so16812834pfn.6;
        Wed, 24 Jul 2019 04:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RUZd1L/tbuG5frd+itzwjf88FkNkecv/3GnnUpUlJiE=;
        b=GWconWTCQVo9h09maZtvF0R68K/35Cbtr5RXbwCJZAL7DZSwg7Rfy0ZksTPyMS+Z/M
         Nz5JOTnFXc/ORVg5cJgFXFRF+cs/Aldn2dSsl6k+9kZIMmGSA6f0nKSA7/0b3vH+b5xe
         03PuCT1XFSbhgbGnE1IxMql7pUAHkfbkOBygfn1VVVa7MguyVATIpivcr/aOye3WsTjm
         1rpVlklwkGp3fBVhzN/ULYLqpYGVAkiuMrCpxq1OgvfFQpalQwuvI3q9ljYm0sZMlOE9
         dR4EGTY6WEe9jC3m+3h4Cl427UaJS1KlOzQFCrGiXuDxTI4WOXxIFL0He8oGt+OEPwoj
         YURA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RUZd1L/tbuG5frd+itzwjf88FkNkecv/3GnnUpUlJiE=;
        b=nbCbu61mY/D4Sj0EieyHY1sakKhTxbn1MLPkpuQcw/vOk6T/x5kU14qPps0rGV4lA3
         edQ7QldS2l9IlrddePAKY1GvWtuDa+uR+JTMUDGuxpAlMcuePKChPTKWM4vU+fsojtNC
         5dHdApXjg9lyXw7D0uHk5C7EiRHzn8/qCs4I9tVQzO783trMpF7aub5ko9TNbzwQXENt
         da1Mw40dXtkqYMfx6LA6YuDel/E638l/FbPWZ+1RPCJJRCpjebtcxEyl8O6d+rq1cQNE
         NUIlz60rO7MOIgLySSnWisvgh/YPeKGBet9N5O64np1r6dbWxElFb+ehucgUfY6WsP2y
         YZ4Q==
X-Gm-Message-State: APjAAAXGAaekZbfiCzUdjDaVMaF0xF/JVMWnXwL5GoIACPhs+eHHqCQI
        jdHpFWp/eIETQ3y4o8UWCYGwRrpGwfU=
X-Google-Smtp-Source: APXvYqxo0lOBXSCRpv9wkIh28rqDgDAlKJ3W9UaDu+8quoBa8sWPbh6npjASONC4F6ZmSB66I29bCg==
X-Received: by 2002:a17:90a:37e9:: with SMTP id v96mr85412477pjb.10.1563967680108;
        Wed, 24 Jul 2019 04:28:00 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id d17sm48731195pgl.66.2019.07.24.04.27.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 04:27:59 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next 09/10] qtnfmac_pcie: Use dev_get_drvdata
Date:   Wed, 24 Jul 2019 19:27:53 +0800
Message-Id: <20190724112753.13566-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Instead of using to_pci_dev + pci_get_drvdata,
use dev_get_drvdata to make code simpler.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
index e4e9344b6982..8ae318b5fe54 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -430,7 +430,7 @@ static int qtnf_pcie_suspend(struct device *dev)
 	struct qtnf_pcie_bus_priv *priv;
 	struct qtnf_bus *bus;
 
-	bus = pci_get_drvdata(to_pci_dev(dev));
+	bus = dev_get_drvdata(dev);
 	if (!bus)
 		return -EFAULT;
 
@@ -443,7 +443,7 @@ static int qtnf_pcie_resume(struct device *dev)
 	struct qtnf_pcie_bus_priv *priv;
 	struct qtnf_bus *bus;
 
-	bus = pci_get_drvdata(to_pci_dev(dev));
+	bus = dev_get_drvdata(dev);
 	if (!bus)
 		return -EFAULT;
 
-- 
2.20.1


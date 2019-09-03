Return-Path: <SRS0=FCSK=W6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28931C3A5A5
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 16:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9E392343A
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Sep 2019 16:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567528236;
	bh=eDSMTHcpK8ENZugZPnl/ekUkYEnn0M31kzXWhMcwrno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lzklA1y34gG+RAXVJD/sC6X6QUoWPhOPR5+rGKfUzNUljtUEL3Q4MEnC+B5MUOz46
	 XIcugCfxkqlWSnsFUK3vXKgjdiBuhaecAosHb6h9GFa9ynJS+2FgWSoxGVAB/StIm9
	 a+05P2oaQh6/3iMFHwy5edtorltaCnGGLgpcbSII=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730355AbfICQab (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730234AbfICQ2x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 915EA238D1;
        Tue,  3 Sep 2019 16:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528132;
        bh=eDSMTHcpK8ENZugZPnl/ekUkYEnn0M31kzXWhMcwrno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfN0AI7ej2knUp4KgDhxoRotgfKaCab5By7F6IKfiogWczWfhw6m0GYZscIf4sY5E
         GMuGjKS/fdcPdAKxLRmrymyKvG6uawQ0WtKRJFky53CGOpftdwCVbqqcJGehuVRHfV
         NFQ+9WzdEtzRJcDAoerGZ7HHgECyXWl/Qkoyk9lQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.19 127/167] staging: wilc1000: fix error path cleanup in wilc_wlan_initialize()
Date:   Tue,  3 Sep 2019 12:24:39 -0400
Message-Id: <20190903162519.7136-127-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

[ Upstream commit 6419f818ababebc1116fb2d0e220bd4fe835d0e3 ]

For the error path in wilc_wlan_initialize(), the resources are not
cleanup in the correct order. Reverted the previous changes and use the
correct order to free during error condition.

Fixes: b46d68825c2d ("staging: wilc1000: remove COMPLEMENT_BOOT")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wilc1000/linux_wlan.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 649caae2b6033..25798119426b3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -649,17 +649,17 @@ static int wilc_wlan_initialize(struct net_device *dev, struct wilc_vif *vif)
 			goto fail_locks;
 		}
 
-		if (wl->gpio_irq && init_irq(dev)) {
-			ret = -EIO;
-			goto fail_locks;
-		}
-
 		ret = wlan_initialize_threads(dev);
 		if (ret < 0) {
 			ret = -EIO;
 			goto fail_wilc_wlan;
 		}
 
+		if (wl->gpio_irq && init_irq(dev)) {
+			ret = -EIO;
+			goto fail_threads;
+		}
+
 		if (!wl->dev_irq_num &&
 		    wl->hif_func->enable_interrupt &&
 		    wl->hif_func->enable_interrupt(wl)) {
@@ -715,7 +715,7 @@ static int wilc_wlan_initialize(struct net_device *dev, struct wilc_vif *vif)
 fail_irq_init:
 		if (wl->dev_irq_num)
 			deinit_irq(dev);
-
+fail_threads:
 		wlan_deinitialize_threads(dev);
 fail_wilc_wlan:
 		wilc_wlan_cleanup(dev);
-- 
2.20.1


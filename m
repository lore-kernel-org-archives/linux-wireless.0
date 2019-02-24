Return-Path: <SRS0=tIsG=Q7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B47C4360F
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 14:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 797CD206B6
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 14:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbfBXOFU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Feb 2019 09:05:20 -0500
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:52520 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbfBXOFT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Feb 2019 09:05:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3950E16A3;
        Sun, 24 Feb 2019 06:05:19 -0800 (PST)
Received: from why.lan (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AF9E3F690;
        Sun, 24 Feb 2019 06:05:15 -0800 (PST)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/4] mwifiex: Flag wake-up interrupt as IRQ_NOAUTOEN rather than disabling it too late
Date:   Sun, 24 Feb 2019 14:04:25 +0000
Message-Id: <20190224140426.3267-4-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190224140426.3267-1-marc.zyngier@arm.com>
References: <20190224140426.3267-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The mwifiex driver makes unsafe assumptions about the state of the
wake-up interrupt. It requests it and only then disable it. Of
course, the interrupt may be screaming for whatever reason at that
time, and the handler will then be called without the interrupt
having been registered with the PM/wakeup subsystem. Oops.

The right way to handle this kind of situation is to flag the
interrupt with IRQ_NOAUTOEN before requesting it. It will then
stay disabled until someone (the wake-up subsystem) enables it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 2105c2b7c627..82cf35e50579 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1610,6 +1610,7 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
 			 "wake-up interrupt outside 'wake-up' subnode of %pOF\n",
 			 adapter->dt_node);
 
+	irq_set_status_flags(adapter->irq_wakeup, IRQ_NOAUTOEN);
 	ret = devm_request_irq(dev, adapter->irq_wakeup,
 			       mwifiex_irq_wakeup_handler, IRQF_TRIGGER_LOW,
 			       "wifi_wake", adapter);
@@ -1619,7 +1620,6 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
 		goto err_exit;
 	}
 
-	disable_irq(adapter->irq_wakeup);
 	if (device_init_wakeup(dev, true)) {
 		dev_err(dev, "fail to init wakeup for mwifiex\n");
 		goto err_exit;
-- 
2.20.1


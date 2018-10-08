Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAA9C65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 20:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FECB20C0A
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 20:04:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FECB20C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zonque.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbeJIDRb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 23:17:31 -0400
Received: from mail.bugwerft.de ([46.23.86.59]:47372 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbeJIDRb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 23:17:31 -0400
Received: from localhost.localdomain (pD95EF15C.dip0.t-ipconnect.de [217.94.241.92])
        by mail.bugwerft.de (Postfix) with ESMTPSA id 4FB342A159D;
        Mon,  8 Oct 2018 20:02:16 +0000 (UTC)
From:   Daniel Mack <daniel@zonque.org>
To:     ulf.hansson@linaro.org
Cc:     chris@printf.net, linux-mmc@vger.kernel.org,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH] libertas: call into generic suspend code before turning off power
Date:   Mon,  8 Oct 2018 22:03:57 +0200
Message-Id: <20181008200357.10819-1-daniel@zonque.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When powering down a SDIO connected card during suspend, make sure to call
into the generic lbs_suspend() function before pulling the plug. This will
make sure the card is successfully deregistered from the system to avoid
communication to the card starving out.

Fixes: 7444a8092906 ("libertas: fix suspend and resume for SDIO connected cards")
Signed-off-by: Daniel Mack <daniel@zonque.org>
---
If possible, this should go in for 4.19.

 drivers/net/wireless/marvell/libertas/if_sdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/if_sdio.c b/drivers/net/wireless/marvell/libertas/if_sdio.c
index 43743c26c071..39bf85d0ade0 100644
--- a/drivers/net/wireless/marvell/libertas/if_sdio.c
+++ b/drivers/net/wireless/marvell/libertas/if_sdio.c
@@ -1317,6 +1317,10 @@ static int if_sdio_suspend(struct device *dev)
 	if (priv->wol_criteria == EHS_REMOVE_WAKEUP) {
 		dev_info(dev, "Suspend without wake params -- powering down card\n");
 		if (priv->fw_ready) {
+			ret = lbs_suspend(priv);
+			if (ret)
+				return ret;
+
 			priv->power_up_on_resume = true;
 			if_sdio_power_off(card);
 		}
-- 
2.17.1


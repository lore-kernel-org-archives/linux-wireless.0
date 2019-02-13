Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E60C282CA
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 10:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2EB5207E0
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 10:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388128AbfBMKJZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 05:09:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51330 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727580AbfBMKJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 05:09:24 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ABF6781F18;
        Wed, 13 Feb 2019 10:09:24 +0000 (UTC)
Received: from localhost (unknown [10.40.205.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E13819747;
        Wed, 13 Feb 2019 10:09:24 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH v5 4/5] rt2800: enable TX_PIN_CFG_RFRX_EN only for MT7620
Date:   Wed, 13 Feb 2019 11:09:15 +0100
Message-Id: <1550052556-7158-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1550052556-7158-1-git-send-email-sgruszka@redhat.com>
References: <1550052556-7158-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 13 Feb 2019 10:09:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The TX_PIN_CFG_RFRX_EN bit was not set on other devices than MT7620,
restore old behavaviour since setting this bit maight not be
correct for older devices.

Fixes: 41977e86c984 ("rt2x00: add support for MT7620")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 0c956a7f7a71..6886e09c0b27 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3858,10 +3858,12 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00_rt(rt2x00dev, RT3572))
 		rt2800_rfcsr_write(rt2x00dev, 8, 0);
 
-	if (rt2x00_rt(rt2x00dev, RT6352))
+	if (rt2x00_rt(rt2x00dev, RT6352)) {
 		tx_pin = rt2800_register_read(rt2x00dev, TX_PIN_CFG);
-	else
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_RFRX_EN, 1);
+	} else {
 		tx_pin = 0;
+	}
 
 	switch (rt2x00dev->default_ant.tx_chain_num) {
 	case 3:
@@ -3916,7 +3918,6 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_RFTR_EN, 1);
 	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_TRSW_EN, 1);
-	rt2x00_set_field32(&tx_pin, TX_PIN_CFG_RFRX_EN, 1); /* mt7620 */
 
 	rt2800_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
 
-- 
2.7.5


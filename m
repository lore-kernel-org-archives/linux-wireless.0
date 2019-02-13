Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403CEC282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 10:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 120E0207E0
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 10:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388106AbfBMKJX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 05:09:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727580AbfBMKJW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 05:09:22 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D2F9FC04AC56;
        Wed, 13 Feb 2019 10:09:22 +0000 (UTC)
Received: from localhost (unknown [10.40.205.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6502560856;
        Wed, 13 Feb 2019 10:09:22 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH v5 3/5] rt2800: enable TX_PIN_CFG_LNA_PE_ bits per band
Date:   Wed, 13 Feb 2019 11:09:14 +0100
Message-Id: <1550052556-7158-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1550052556-7158-1-git-send-email-sgruszka@redhat.com>
References: <1550052556-7158-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 13 Feb 2019 10:09:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not enable TX_PIN_CFG_LNA_PE_A* bits for 2.4GHz band and
vice versa TX_PIN_CFG_LNA_PE_G* bits for 5GHz.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index f420b6af1f2a..0c956a7f7a71 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3893,18 +3893,24 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	switch (rt2x00dev->default_ant.rx_chain_num) {
 	case 3:
 		/* Turn on tertiary LNAs */
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A2_EN, 1);
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G2_EN, 1);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A2_EN,
+				   rf->channel > 14);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G2_EN,
+				   rf->channel <= 14);
 		/* fall-through */
 	case 2:
 		/* Turn on secondary LNAs */
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A1_EN, 1);
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G1_EN, 1);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A1_EN,
+				   rf->channel > 14);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G1_EN,
+				   rf->channel <= 14);
 		/* fall-through */
 	case 1:
 		/* Turn on primary LNAs */
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A0_EN, 1);
-		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G0_EN, 1);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A0_EN,
+				   rf->channel > 14);
+		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G0_EN,
+				   rf->channel <= 14);
 		break;
 	}
 
-- 
2.7.5


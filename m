Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6FCBC6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF11120835
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 08:56:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF11120835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbeJLQ2H (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:28:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727705AbeJLQ2H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 12:28:07 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8417A3099F9E;
        Fri, 12 Oct 2018 08:56:42 +0000 (UTC)
Received: from localhost (unknown [10.40.205.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11C7078901;
        Fri, 12 Oct 2018 08:56:41 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
Subject: [PATCH v4 5/8] rt2800: enable TX_PIN_CFG_LNA_PE_ bits per band
Date:   Fri, 12 Oct 2018 10:56:28 +0200
Message-Id: <1539334591-9965-6-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
References: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 12 Oct 2018 08:56:42 +0000 (UTC)
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
index 16d6d99b1d44..bf0d12c5b2db 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3891,18 +3891,24 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
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


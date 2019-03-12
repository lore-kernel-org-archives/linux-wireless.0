Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38142C10F00
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 12:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3EAB214AE
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 12:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfCLMcQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 08:32:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59714 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbfCLMcP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 08:32:15 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8458630832F4;
        Tue, 12 Mar 2019 12:32:15 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E69C1001E6A;
        Tue, 12 Mar 2019 12:32:11 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 5.1] mt76x02: do not enable RTS/CTS by default
Date:   Tue, 12 Mar 2019 13:32:07 +0100
Message-Id: <1552393927-26634-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 12 Mar 2019 12:32:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

My commit 26a7b5473191 ("mt76x02: set protection according to ht
operation element") enabled by default RTS/CTS protection for OFDM
and CCK traffic, because MT_TX_RTS_CFG_THRESH is configured to non
0xffff by initvals and .set_rts_threshold callback is not called by
mac80211 on initialization, only on user request or during
ieee80211_reconfig() (suspend/resuem or restart_hw).

Enabling RTS/CTS cause some problems when sending probe request
frames by hcxdumptool penetration tool, but I expect it can cause
other issues on different scenarios.
 
Restore previous setting of RTS/CTS being disabled by default for
OFDM/CCK by changing MT_TX_RTS_CFG_THRESH initvals to 0xffff.

Fixes: 26a7b5473191 ("mt76x02: set protection according to ht operation element")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c     | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c  | 1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
index 0290ba5869a5..736f81752b5b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
@@ -46,7 +46,7 @@
 	{ MT_MM20_PROT_CFG,		0x01742004 },
 	{ MT_MM40_PROT_CFG,		0x03f42084 },
 	{ MT_TXOP_CTRL_CFG,		0x0000583f },
-	{ MT_TX_RTS_CFG,		0x00092b20 },
+	{ MT_TX_RTS_CFG,		0x00ffff20 },
 	{ MT_EXP_ACK_TIME,		0x002400ca },
 	{ MT_TXOP_HLDR_ET,		0x00000002 },
 	{ MT_XIFS_TIME_CFG,		0x33a41010 },
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
index f8534362e2c8..a30ef2c5a9db 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
@@ -106,7 +106,7 @@ void mt76_write_mac_initvals(struct mt76x02_dev *dev)
 		{ MT_TX_SW_CFG1,		0x00010000 },
 		{ MT_TX_SW_CFG2,		0x00000000 },
 		{ MT_TXOP_CTRL_CFG,		0x0400583f },
-		{ MT_TX_RTS_CFG,		0x00100020 },
+		{ MT_TX_RTS_CFG,		0x00ffff20 },
 		{ MT_TX_TIMEOUT_CFG,		0x000a2290 },
 		{ MT_TX_RETRY_CFG,		0x47f01f0f },
 		{ MT_EXP_ACK_TIME,		0x002c00dc },
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
index 5e84b4535cb1..3b82345756ea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
@@ -93,7 +93,6 @@ int mt76x2u_mac_reset(struct mt76x02_dev *dev)
 	mt76_wr(dev, MT_TX_LINK_CFG, 0x1020);
 	mt76_wr(dev, MT_AUTO_RSP_CFG, 0x13);
 	mt76_wr(dev, MT_MAX_LEN_CFG, 0x2f00);
-	mt76_wr(dev, MT_TX_RTS_CFG, 0x92b20);
 
 	mt76_wr(dev, MT_WMM_AIFSN, 0x2273);
 	mt76_wr(dev, MT_WMM_CWMIN, 0x2344);
-- 
1.9.3


Return-Path: <SRS0=QwMV=ZX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA65BC43215
	for <linux-wireless@archiver.kernel.org>; Sun,  1 Dec 2019 18:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6CDF20716
	for <linux-wireless@archiver.kernel.org>; Sun,  1 Dec 2019 18:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfLAS0U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 1 Dec 2019 13:26:20 -0500
Received: from mail2.sp2max.com.br ([138.185.4.9]:56924 "EHLO
        mail2.sp2max.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727167AbfLAS0U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Dec 2019 13:26:20 -0500
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Dec 2019 13:26:18 EST
Received: from pgsop.sopnet.com.ar (unknown [179.40.38.12])
        (Authenticated sender: pablo@fliagreco.com.ar)
        by mail2.sp2max.com.br (Postfix) with ESMTPA id 5618C7B30BD;
        Sun,  1 Dec 2019 15:17:40 -0300 (-03)
From:   Pablo Greco <pgreco@centosproject.org>
Cc:     Pablo Greco <pgreco@centosproject.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] mt76: mt7615: Fix build with older compilers
Date:   Sun,  1 Dec 2019 15:17:10 -0300
Message-Id: <20191201181716.61892-1-pgreco@centosproject.org>
X-Mailer: git-send-email 2.18.1
X-SP2Max-MailScanner-Information: Please contact the ISP for more information
X-SP2Max-MailScanner-ID: 5618C7B30BD.A1C61
X-SP2Max-MailScanner: Sem Virus encontrado
X-SP2Max-MailScanner-SpamCheck: nao spam, SpamAssassin (not cached,
        escore=-2.9, requerido 6, autolearn=not spam, ALL_TRUSTED -1.00,
        BAYES_00 -1.90)
X-SP2Max-MailScanner-From: pgreco@centosproject.org
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Some compilers (tested with 4.8.5 from CentOS 7) fail properly process
FIELD_GET inside an inline function, which ends up in a BUILD_BUG_ON.
Convert inline function to a macro.

Fixes commit bf92e7685100 ("mt76: mt7615: add support for per-chain
signal strength reporting")
Reported in https://lkml.org/lkml/2019/9/21/146

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Pablo Greco <pgreco@centosproject.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index c77adc5d2552..77e395ca2c6a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -13,10 +13,7 @@
 #include "../dma.h"
 #include "mac.h"
 
-static inline s8 to_rssi(u32 field, u32 rxv)
-{
-	return (FIELD_GET(field, rxv) - 220) / 2;
-}
+#define to_rssi(field, rxv)		((FIELD_GET(field, rxv) - 220) / 2)
 
 static struct mt76_wcid *mt7615_rx_get_wcid(struct mt7615_dev *dev,
 					    u8 idx, bool unicast)
-- 
2.18.1


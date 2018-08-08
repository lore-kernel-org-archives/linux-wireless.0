Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound.smtp.vt.edu ([198.82.183.121]:46298 "EHLO
        omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730110AbeHHWiS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 18:38:18 -0400
Received: from mr4.cc.vt.edu (smtp.ipv6.vt.edu [IPv6:2607:b400:92:9:0:9d:8fcb:4116])
        by omr1.cc.vt.edu (8.14.4/8.14.4) with ESMTP id w78KH2xV012034
        for <linux-wireless@vger.kernel.org>; Wed, 8 Aug 2018 16:17:02 -0400
Received: from mail-qt0-f197.google.com (mail-qt0-f197.google.com [209.85.216.197])
        by mr4.cc.vt.edu (8.14.7/8.14.7) with ESMTP id w78KGuJi023026
        for <linux-wireless@vger.kernel.org>; Wed, 8 Aug 2018 16:17:01 -0400
Received: by mail-qt0-f197.google.com with SMTP id o18-v6so2684510qtm.11
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2018 13:17:01 -0700 (PDT)
From: valdis.kletnieks@vt.edu
To: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH] fix build for MediaTek MT7610U USB wireless dongle
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 08 Aug 2018 16:16:54 -0400
Message-ID: <145751.1533759414@turing-police.cc.vt.edu> (sfid-20180808_221712_828881_7DBA1929)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mt76x0 driver requires the mt76 core driver to actually function.
So add a 'select' to avoid embarrassing 'symbol unknown' errors
when attempting to modprobe it in a module tree that doesn't
include mt76.ko

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
---
Still need to figure out why it totally fails to see the 5gz band,
it works find on 2.4 but ends up locked at 72mbits/sec. Works
OK otherwise...

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index 850611ad347a..b6c5f17dca30 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -11,6 +11,7 @@ config MT76x2_COMMON
 
 config MT76x0U
 	tristate "MediaTek MT76x0U (USB) support"
+	select MT76_CORE
 	depends on MAC80211
 	depends on USB
 	help

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound.smtp.vt.edu ([198.82.183.121]:49792 "EHLO
        omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725986AbeIGXum (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Sep 2018 19:50:42 -0400
Received: from mr6.cc.vt.edu (mr6.cc.ipv6.vt.edu [IPv6:2607:b400:92:8500:0:af:2d00:4488])
        by omr1.cc.vt.edu (8.14.4/8.14.4) with ESMTP id w87J8Nxx031743
        for <linux-wireless@vger.kernel.org>; Fri, 7 Sep 2018 15:08:23 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        by mr6.cc.vt.edu (8.14.7/8.14.7) with ESMTP id w87J8IEd016901
        for <linux-wireless@vger.kernel.org>; Fri, 7 Sep 2018 15:08:23 -0400
Received: by mail-qk1-f197.google.com with SMTP id z17-v6so11484867qka.9
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2018 12:08:23 -0700 (PDT)
From: valdis.kletnieks@vt.edu
To: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: another missing 'select' in Kconfig
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 07 Sep 2018 15:08:13 -0400
Message-ID: <30971.1536347293@turing-police.cc.vt.edu> (sfid-20180907_210845_119291_617CB9F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit b40b15e1521f7764ea8c68d5a00ecc971b673d21
Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Tue Jul 31 10:09:19 2018 +0200

    mt76: add usb support to mt76 layer

add a new mt76-usb.c for MT76x2U USB devices, but failed to wire
it up for MT76x0U USB devices.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
---
diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index 6a270e759006..cec977b81305 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -17,6 +17,7 @@ config MT76x2_COMMON
 config MT76x0U
 	tristate "MediaTek MT76x0U (USB) support"
 	select MT76_CORE
+	select MT76_USB
 	depends on MAC80211
 	depends on USB
 	select MT76x02_LIB

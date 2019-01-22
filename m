Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36367C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1035620855
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbfAVMr5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 07:47:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbfAVMr5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 07:47:57 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D60E588E4A;
        Tue, 22 Jan 2019 12:47:56 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37DC96013E;
        Tue, 22 Jan 2019 12:47:56 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Michael <ZeroBeat@gmx.de>
Subject: [PATCH] mt7601u: bump supported EEPROM version
Date:   Tue, 22 Jan 2019 13:47:54 +0100
Message-Id: <1548161274-3335-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 22 Jan 2019 12:47:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

As reported by Michael eeprom 0d is supported and work with the driver.

Dump of /sys/kernel/debug/ieee80211/phy1/mt7601u/eeprom_param
with 0d EEPORM looks like this:

RSSI offset: 0 0
Reference temp: f9
LNA gain: 8
Reg channels: 1-14
Per rate power:
	 raw:05 bw20:05 bw40:05
	 raw:05 bw20:05 bw40:05
	 raw:03 bw20:03 bw40:03
	 raw:03 bw20:03 bw40:03
	 raw:04 bw20:04 bw40:04
	 raw:00 bw20:00 bw40:00
	 raw:00 bw20:00 bw40:00
	 raw:00 bw20:00 bw40:00
	 raw:02 bw20:02 bw40:02
	 raw:00 bw20:00 bw40:00
Per channel power:
	 tx_power  ch1:09 ch2:09
	 tx_power  ch3:0a ch4:0a
	 tx_power  ch5:0a ch6:0a
	 tx_power  ch7:0b ch8:0b
	 tx_power  ch9:0b ch10:0b
	 tx_power  ch11:0b ch12:0b
	 tx_power  ch13:0b ch14:0b

Reported-and-tested-by: Michael <ZeroBeat@gmx.de>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/eeprom.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.h b/drivers/net/wireless/mediatek/mt7601u/eeprom.h
index 662d12703b69..57b503ae63f1 100644
--- a/drivers/net/wireless/mediatek/mt7601u/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.h
@@ -17,7 +17,7 @@
 
 struct mt7601u_dev;
 
-#define MT7601U_EE_MAX_VER			0x0c
+#define MT7601U_EE_MAX_VER			0x0d
 #define MT7601U_EEPROM_SIZE			256
 
 #define MT7601U_DEFAULT_TX_POWER		6
-- 
1.9.3


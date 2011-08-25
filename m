Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39180 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1HYTdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 15:33:52 -0400
Received: by wyg24 with SMTP id 24so1938203wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 12:33:51 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org
Subject: [PATCH] ath9k: add missing AR9340 in ath_mac_bb_names
Date: Thu, 25 Aug 2011 21:33:48 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201108252133.48605.florian@openwrt.org> (sfid-20110825_213355_748324_74720355)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9340 is not listed in ath_mac_bb_names, which leads to such a message:
ieee80211 phy0: Atheros AR???? Rev:0 mem=0xb8100000, irq=2

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 88100cc..18394d1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2753,6 +2753,7 @@ static struct {
 	{ AR_SREV_VERSION_9271,         "9271" },
 	{ AR_SREV_VERSION_9300,         "9300" },
 	{ AR_SREV_VERSION_9330,         "9330" },
+	{ AR_SREV_VERSION_9340,		"9340" },
 	{ AR_SREV_VERSION_9485,         "9485" },
 };
 
-- 
1.7.4.1


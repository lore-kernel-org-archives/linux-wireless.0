Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56965 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab1H2Lj6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 07:39:58 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 2/2] ath9k_hw: fix the last register write for ar5416 addac
Date: Mon, 29 Aug 2011 13:39:47 +0200
Message-Id: <1314617987-23278-2-git-send-email-nbd@openwrt.org> (sfid-20110829_134001_719906_9CC952CB)
In-Reply-To: <1314617987-23278-1-git-send-email-nbd@openwrt.org>
References: <1314617987-23278-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous register used in these initvals was probably accidentally
copied over from the AR9100 values.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
index 68b0561..f81e7fc 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
@@ -669,6 +669,6 @@ static const u32 ar5416Addac[][2] = {
 	{0x0000989c, 0x00000000},
 	{0x0000989c, 0x00000000},
 	{0x0000989c, 0x00000000},
-	{0x000098cc, 0x00000000},
+	{0x000098c4, 0x00000000},
 };
 
-- 
1.7.3.2


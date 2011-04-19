Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57277 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab1DSN7s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 09:59:48 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 06:59:22 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH V2 22/22] ath9k_hw: Enable AR9340 support
Date: Tue, 19 Apr 2011 19:29:20 +0530
Message-ID: <1303221560-25139-23-git-send-email-vasanth@atheros.com>
In-Reply-To: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
References: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9340 is a AR9003 family built-in 2x2 wmac of ar934x SOCs. It is single band
in ar9341 SOC and dual band in ar9344/ar9342 SOCs.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b780f6f..2bf487b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -552,6 +552,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	case AR_SREV_VERSION_9271:
 	case AR_SREV_VERSION_9300:
 	case AR_SREV_VERSION_9485:
+	case AR_SREV_VERSION_9340:
 		break;
 	default:
 		ath_err(common,
@@ -629,6 +630,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	case AR2427_DEVID_PCIE:
 	case AR9300_DEVID_PCIE:
 	case AR9300_DEVID_AR9485_PCIE:
+	case AR9300_DEVID_AR9340:
 		break;
 	default:
 		if (common->bus_ops->ath_bus_type == ATH_USB)
-- 
1.7.0.4


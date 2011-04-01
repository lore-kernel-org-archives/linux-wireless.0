Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30192 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab1DALqr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 07:46:47 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 04:46:22 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH] ath9k: Fix phy info print message with AR9485 chipset.
Date: Fri, 1 Apr 2011 17:16:33 +0530
Message-ID: <1301658393-2636-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The phy information print during driver init time doesn't show
the numeric part of the chip name properly for AR9485. This patch
addresses this issue by adding the string to the respective array.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8b86568..e7f4a0d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2566,6 +2566,7 @@ static struct {
 	{ AR_SREV_VERSION_9287,         "9287" },
 	{ AR_SREV_VERSION_9271,         "9271" },
 	{ AR_SREV_VERSION_9300,         "9300" },
+	{ AR_SREV_VERSION_9485,         "9485" },
 };
 
 /* For devices with external radios */
-- 
1.7.4.1


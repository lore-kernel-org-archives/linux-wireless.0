Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10628 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2GHHVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 03:21:53 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: remove debugging masks from AR_MCI_INTERRUPT_RX_MSG_DEFAULT
Date: Sun, 8 Jul 2012 12:53:16 +0530
Message-ID: <1341732196-2869-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120708_092234_517130_A7002362)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the CONT_* and LNA_* messages from
AR_MCI_INTERRUPT_RX_MSG_DEFAULT. Those MCI rx messages only
meant for debugging purpose. Including them in default rx_msg
series could raise huge amount of MCI interrupts when BT traffic
is going on. And also it increases power consumption when WLAN
is scanning.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/reg.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 22d2413..6592c07 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -2081,12 +2081,6 @@ enum {
 					 AR_MCI_INTERRUPT_RX_MSG_REMOTE_RESET| \
 					 AR_MCI_INTERRUPT_RX_MSG_SYS_WAKING  | \
 					 AR_MCI_INTERRUPT_RX_MSG_SYS_SLEEPING| \
-					 AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO   | \
-					 AR_MCI_INTERRUPT_RX_MSG_LNA_CONTROL | \
-					 AR_MCI_INTERRUPT_RX_MSG_LNA_INFO    | \
-					 AR_MCI_INTERRUPT_RX_MSG_CONT_NACK   | \
-					 AR_MCI_INTERRUPT_RX_MSG_CONT_INFO   | \
-					 AR_MCI_INTERRUPT_RX_MSG_CONT_RST    | \
 					 AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE)
 
 #define AR_MCI_CPU_INT					0x1840
-- 
1.7.11.1


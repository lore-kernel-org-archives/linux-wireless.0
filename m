Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55262 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752413AbeEGSlG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 14:41:06 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: increase TX threashold to avoid TX timeout during ED MAC test
Date: Tue, 8 May 2018 00:10:58 +0530
Message-ID: <1525718458-5299-1-git-send-email-gbhat@marvell.com> (sfid-20180507_204110_252717_7CC872C2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While carrying energy detection(ED) tests, the chip will stop
transmission upon detecting an energy in the connected channel.
As a feedback, driver will stop dequeuing TX packets and due to
which wmm_tx_pending keep incremeting. Once wmm_tx_pending
reaches 100, driver calls netif_tx_stop_queue(). If TX ques is
not restarted within 5(watchdog_timeo) seconds, it will result in
TX timeout.

The ED test is carried out for one minute and the current
threshold of 100 is easily overcome by the traffic, cuasing TX
timeouts. To fix this increase the threshold to 400.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index b2a94b8..c5478c8 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -84,8 +84,8 @@ enum {
 #define MWIFIEX_TIMER_10S			10000
 #define MWIFIEX_TIMER_1S			1000
 
-#define MAX_TX_PENDING      100
-#define LOW_TX_PENDING      80
+#define MAX_TX_PENDING      400
+#define LOW_TX_PENDING      380
 
 #define HIGH_RX_PENDING     50
 #define LOW_RX_PENDING      20
-- 
1.9.1

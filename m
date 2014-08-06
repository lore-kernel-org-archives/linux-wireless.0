Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:39187 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbaHFHc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2014 03:32:29 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH v2 05/13] wil6210: wait longer for hardware reset completion
Date: Wed, 6 Aug 2014 10:31:53 +0300
Message-ID: <1407310322-22568-6-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140806_093234_052079_D619442E)
In-Reply-To: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Typical time for hardware reset, as measured, is about 200..250 msec.
Adjust sleeping to use more relaxed msleep, increase sleep interval
and increase total sleep time to be about 1sec

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 5a99342..b69d90f 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -25,6 +25,9 @@ static bool no_fw_recovery;
 module_param(no_fw_recovery, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(no_fw_recovery, " disable FW error recovery");
 
+#define RST_DELAY (20) /* msec, for loop in @wil_target_reset */
+#define RST_COUNT (1 + 1000/RST_DELAY) /* round up to be above 1 sec total */
+
 /*
  * Due to a hardware issue,
  * one has to read/write to/from NIC in 32-bit chunks;
@@ -388,11 +391,11 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
 	wmb(); /* order is important here */
 
-	/* wait until device ready */
+	/* wait until device ready. typical time is 200..250 msec */
 	do {
-		msleep(1);
+		msleep(RST_DELAY);
 		hw_state = R(RGF_USER_HW_MACHINE_STATE);
-		if (delay++ > 100) {
+		if (delay++ > RST_COUNT) {
 			wil_err(wil, "Reset not completed, hw_state 0x%08x\n",
 				hw_state);
 			return -ETIME;
@@ -406,7 +409,7 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	C(RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_RST_PWGD);
 	wmb(); /* order is important here */
 
-	wil_dbg_misc(wil, "Reset completed in %d ms\n", delay);
+	wil_dbg_misc(wil, "Reset completed in %d ms\n", delay * RST_DELAY);
 	return 0;
 
 #undef R
-- 
1.8.5.2


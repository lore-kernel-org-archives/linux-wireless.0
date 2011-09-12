Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:48811 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab1ILLMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 07:12:30 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh07-2.mail.saunalahti.fi (Postfix) with SMTP id 6A2DA18D279
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:12:28 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh04.mail.saunalahti.fi (Postfix) with ESMTP id 4A70041BE7
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:12:25 +0300 (EEST)
Subject: [PATCH 3/9] ath6kl: fix busy loop in ath6kl_bmi_get_rx_lkahd()
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Mon, 12 Sep 2011 14:12:25 +0300
Message-ID: <20110912111224.16921.8172.stgit@localhost6.localdomain6> (sfid-20110912_131233_076198_3551B000)
In-Reply-To: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
References: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brent reported that ath6kl busy loops if firmware doesn't boot for some
reason (in this case he was using an older firmware which wasn't supported
by ath6kl).

Investigation revealed that this was even on purpose,
ath6kl_bmi_get_rx_lkahd() had a parameter to disable the timeout check,
which is extremely evil. I didn't find any reason why the timeout needs
to be disabled so I just removed the feature. The function already busyloops
a maximum of one second if it doesn't get an answer, even that's too long.
If something takes longer than that a more friendly approach is needed.

Reported-by: Brent Taylor <btaylor1@motorolasolutions.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/bmi.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
index 8467669..c5d11cc 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.c
+++ b/drivers/net/wireless/ath/ath6kl/bmi.c
@@ -62,14 +62,14 @@ static int ath6kl_get_bmi_cmd_credits(struct ath6kl *ar)
 	return 0;
 }
 
-static int ath6kl_bmi_get_rx_lkahd(struct ath6kl *ar, bool need_timeout)
+static int ath6kl_bmi_get_rx_lkahd(struct ath6kl *ar)
 {
 	unsigned long timeout;
 	u32 rx_word = 0;
 	int ret = 0;
 
 	timeout = jiffies + msecs_to_jiffies(BMI_COMMUNICATION_TIMEOUT);
-	while ((!need_timeout || time_before(jiffies, timeout)) && !rx_word) {
+	while (time_before(jiffies, timeout) && !rx_word) {
 		ret = hif_read_write_sync(ar, RX_LOOKAHEAD_VALID_ADDRESS,
 					  (u8 *)&rx_word, sizeof(rx_word),
 					  HIF_RD_SYNC_BYTE_INC);
@@ -109,8 +109,7 @@ static int ath6kl_bmi_send_buf(struct ath6kl *ar, u8 *buf, u32 len)
 	return ret;
 }
 
-static int ath6kl_bmi_recv_buf(struct ath6kl *ar,
-			u8 *buf, u32 len, bool want_timeout)
+static int ath6kl_bmi_recv_buf(struct ath6kl *ar, u8 *buf, u32 len)
 {
 	int ret;
 	u32 addr;
@@ -162,7 +161,7 @@ static int ath6kl_bmi_recv_buf(struct ath6kl *ar,
 	 * a function of Host processor speed.
 	 */
 	if (len >= 4) { /* NB: Currently, always true */
-		ret = ath6kl_bmi_get_rx_lkahd(ar, want_timeout);
+		ret = ath6kl_bmi_get_rx_lkahd(ar);
 		if (ret)
 			return ret;
 	}
@@ -220,7 +219,7 @@ int ath6kl_bmi_get_target_info(struct ath6kl *ar,
 	}
 
 	ret = ath6kl_bmi_recv_buf(ar, (u8 *)&targ_info->version,
-			sizeof(targ_info->version), true);
+				  sizeof(targ_info->version));
 	if (ret) {
 		ath6kl_err("Unable to recv target info: %d\n", ret);
 		return ret;
@@ -230,8 +229,7 @@ int ath6kl_bmi_get_target_info(struct ath6kl *ar,
 		/* Determine how many bytes are in the Target's targ_info */
 		ret = ath6kl_bmi_recv_buf(ar,
 				   (u8 *)&targ_info->byte_count,
-				   sizeof(targ_info->byte_count),
-				   true);
+				   sizeof(targ_info->byte_count));
 		if (ret) {
 			ath6kl_err("unable to read target info byte count: %d\n",
 				   ret);
@@ -252,8 +250,7 @@ int ath6kl_bmi_get_target_info(struct ath6kl *ar,
 				   ((u8 *)targ_info) +
 				   sizeof(targ_info->byte_count),
 				   sizeof(*targ_info) -
-				   sizeof(targ_info->byte_count),
-				   true);
+				   sizeof(targ_info->byte_count));
 
 		if (ret) {
 			ath6kl_err("Unable to read target info (%d bytes): %d\n",
@@ -311,7 +308,7 @@ int ath6kl_bmi_read(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 				   ret);
 			return ret;
 		}
-		ret = ath6kl_bmi_recv_buf(ar, ar->bmi.cmd_buf, rx_len, true);
+		ret = ath6kl_bmi_recv_buf(ar, ar->bmi.cmd_buf, rx_len);
 		if (ret) {
 			ath6kl_err("Unable to read from the device: %d\n",
 				   ret);
@@ -424,7 +421,7 @@ int ath6kl_bmi_execute(struct ath6kl *ar, u32 addr, u32 *param)
 		return ret;
 	}
 
-	ret = ath6kl_bmi_recv_buf(ar, ar->bmi.cmd_buf, sizeof(*param), false);
+	ret = ath6kl_bmi_recv_buf(ar, ar->bmi.cmd_buf, sizeof(*param));
 	if (ret) {
 		ath6kl_err("Unable to read from the device: %d\n", ret);
 		return ret;
@@ -504,7 +501,7 @@ int ath6kl_bmi_reg_read(struct ath6kl *ar, u32 addr, u32 *param)
 		return ret;
 	}
 
-	ret = ath6kl_bmi_recv_buf(ar, ar->bmi.cmd_buf, sizeof(*param), true);
+	ret = ath6kl_bmi_recv_buf(ar, ar->bmi.cmd_buf, sizeof(*param));
 	if (ret) {
 		ath6kl_err("Unable to read from the device: %d\n", ret);
 		return ret;


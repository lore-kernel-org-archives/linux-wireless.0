Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54222 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbcEZI1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2016 04:27:17 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>,
	Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix error while writing 'simulate_fw_crash' debugfs
Date: Thu, 26 May 2016 13:57:42 +0530
Message-ID: <1464251262-4889-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160526_102738_908864_FF0DD11C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Fix invalid argument error while writing 'simulate_fw_crash',
though the funcionality is working fine we get an error 'invalid
argument' because 'count' value is not returned properly
(no reason to reduce the count value for removing the newline)

Fixes the below write error:

/sys/kernel/debug/ieee80211/phy0/ath10k# echo hw-restart >
simulate_fw_crash
-bash: echo: write error: Invalid argument

Also move the 'conf_mutex' as it is really not required for
fetching the userspace buffer.

Reported-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index e251155..54cb629 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -609,25 +609,23 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 	char buf[32];
 	int ret;
 
-	mutex_lock(&ar->conf_mutex);
-
 	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
 
 	/* make sure that buf is null terminated */
 	buf[sizeof(buf) - 1] = 0;
 
+	/* drop the possible '\n' from the end */
+	if (buf[count - 1] == '\n')
+		buf[count - 1] = 0;
+
+	mutex_lock(&ar->conf_mutex);
+
 	if (ar->state != ATH10K_STATE_ON &&
 	    ar->state != ATH10K_STATE_RESTARTED) {
 		ret = -ENETDOWN;
 		goto exit;
 	}
 
-	/* drop the possible '\n' from the end */
-	if (buf[count - 1] == '\n') {
-		buf[count - 1] = 0;
-		count--;
-	}
-
 	if (!strcmp(buf, "soft")) {
 		ath10k_info(ar, "simulating soft firmware crash\n");
 		ret = ath10k_wmi_force_fw_hang(ar, WMI_FORCE_FW_HANG_ASSERT, 0);
-- 
1.7.9.5


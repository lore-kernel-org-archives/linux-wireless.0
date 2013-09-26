Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50992 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab3IZPrf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 11:47:35 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v3 03/13] ath10k: warn if give WMI command is not supported
Date: Thu, 26 Sep 2013 17:47:07 +0200
Message-ID: <1380210437-4391-4-git-send-email-bartosz.markowski@tieto.com> (sfid-20130926_174740_307047_3C7C9959)
In-Reply-To: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will show and make it easier to track the API
differences in the new AP firmware.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index cfb2082..8386050 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -390,6 +390,12 @@ static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
 {
 	int ret = -EINVAL;
 
+	if (cmd_id == WMI_CMD_UNDEFINED) {
+		ath10k_warn("wmi command %d is not supported by firmware\n",
+			    cmd_id);
+		return ret;
+	}
+
 	wait_event_timeout(ar->wmi.tx_credits_wq, ({
 		/* try to send pending beacons first. they take priority */
 		ath10k_wmi_tx_beacons_nowait(ar);
-- 
1.7.10


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:61615 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab3IZJaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 05:30:02 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v2 03/13] ath10k: warn if give WMI command is not supported
Date: Thu, 26 Sep 2013 11:29:42 +0200
Message-ID: <1380187792-25626-4-git-send-email-bartosz.markowski@tieto.com> (sfid-20130926_113014_886305_8F4167DD)
In-Reply-To: <1380187792-25626-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380187792-25626-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will show and make it easier to track the API
differences in the new AP firmware.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index cfb2082..fe55360 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -390,6 +390,11 @@ static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
 {
 	int ret = -EINVAL;
 
+	if (cmd_id == WMI_CMD_UNDEFINED) {
+		ath10k_warn("command not supported by given firmware\n");
+		return ret;
+	}
+
 	wait_event_timeout(ar->wmi.tx_credits_wq, ({
 		/* try to send pending beacons first. they take priority */
 		ath10k_wmi_tx_beacons_nowait(ar);
-- 
1.7.10


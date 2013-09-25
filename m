Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:61761 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab3IYJi1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 05:38:27 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 03/13] ath10k: warn if give WMI command is not supported
Date: Wed, 25 Sep 2013 11:38:01 +0200
Message-ID: <1380101891-18312-4-git-send-email-bartosz.markowski@tieto.com> (sfid-20130925_113832_734132_8802263D)
In-Reply-To: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
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
index dd490b4..ed137b8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -399,6 +399,11 @@ static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
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


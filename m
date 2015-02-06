Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:40933 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbbBFMGv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 07:06:51 -0500
Received: by mail-wg0-f52.google.com with SMTP id y19so13083277wgg.11
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2015 04:06:50 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, malaakso@elisanet.fi,
	greearb@candelatech.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFT] ath10k: restart fw on tx-credit timeout
Date: Fri,  6 Feb 2015 13:05:54 +0100
Message-Id: <1423224354-24955-1-git-send-email-michal.kazior@tieto.com> (sfid-20150206_130701_163834_82A6B8B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It makes little sense to continue and let
firmware-host state become inconsistent if a WMI
command can't be submitted to firmware.

This effectively prevents after-affects of
tx-credit starvation bug which include spurious
sta kickout events and inability to associate new
stations after some time when acting as AP.

This should also speed up recovery/teardown in
some cases when firmware stops responding for some
reason.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index aeea1c7..776b257 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1045,9 +1045,15 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 		(ret != -EAGAIN);
 	}), 3*HZ);
 
-	if (ret)
+	if (ret) {
 		dev_kfree_skb_any(skb);
 
+		if (ret == -EAGAIN) {
+			ath10k_warn(ar, "firmware unresponsive, restarting..\n");
+			queue_work(ar->workqueue, &ar->restart_work);
+		}
+	}
+
 	return ret;
 }
 
-- 
1.8.5.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12249 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab1IAIgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 04:36:17 -0400
Date: Thu, 1 Sep 2011 11:33:20 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Do not enable Probe Request reporting by default
Message-ID: <20110901083320.GA2007@jouni.qca.qualcomm.com> (sfid-20110901_103621_906948_9CC635AC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Probe Request reporting will be needed for P2P and WPS, but some
firmware builds do not seem to like this when P2P is not enabled.
Since we do not yet enable P2P, the safest option here is to just
remove this call for now and bring it back as a more dynamic version
once ath6kl starts advertising support for P2P.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index f348357..96953be 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -473,13 +473,6 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
 			   ret);
 	}
 
-	/* Enable Probe Request reporting for P2P */
-	ret = ath6kl_wmi_probe_report_req_cmd(ar->wmi, true);
-	if (ret) {
-		ath6kl_dbg(ATH6KL_DBG_TRC, "failed to enable Probe Request "
-			   "reporting (%d)\n", ret);
-	}
-
 	return status;
 }
 
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA

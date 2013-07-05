Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:41608 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363Ab3GENPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 09/16] ath10k: provide errno if bmi read/write fails
Date: Fri,  5 Jul 2013 16:15:10 +0300
Message-Id: <1373030117-18077-10-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_151531_052431_4ADB4027)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/bmi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.c b/drivers/net/wireless/ath/ath10k/bmi.c
index 1a2ef51..aeae029 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.c
+++ b/drivers/net/wireless/ath/ath10k/bmi.c
@@ -105,7 +105,8 @@ int ath10k_bmi_read_memory(struct ath10k *ar,
 		ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, cmdlen,
 						  &resp, &rxlen);
 		if (ret) {
-			ath10k_warn("unable to read from the device\n");
+			ath10k_warn("unable to read from the device (%d)\n",
+				    ret);
 			return ret;
 		}
 
@@ -149,7 +150,8 @@ int ath10k_bmi_write_memory(struct ath10k *ar,
 		ret = ath10k_hif_exchange_bmi_msg(ar, &cmd, hdrlen + txlen,
 						  NULL, NULL);
 		if (ret) {
-			ath10k_warn("unable to write to the device\n");
+			ath10k_warn("unable to write to the device (%d)\n",
+				    ret);
 			return ret;
 		}
 
-- 
1.7.9.5


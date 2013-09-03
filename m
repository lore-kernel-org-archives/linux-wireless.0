Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50711 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab3ICMZN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 08:25:13 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 1/2] ath10k: set the UART baud rate to 19200
Date: Tue, 3 Sep 2013 14:24:02 +0200
Message-ID: <1378211043-20299-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20130903_142518_078701_12BA4906)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When configuring the host_interests over BMI, set the UART
baud rate to 19200. This is valid for QCA988X_2.0 devices.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2dd39a8..2c1d2d7 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -435,6 +435,13 @@ static int ath10k_init_uart(struct ath10k *ar)
 		return ret;
 	}
 
+	/* Set the UART baud rate to 19200. */
+	ret = ath10k_bmi_write32(ar, hi_desired_baud_rate, 19200);
+	if (ret) {
+		ath10k_warn("could not set the baud rate (%d)\n", ret);
+		return ret;
+	}
+
 	ath10k_info("UART prints enabled\n");
 	return 0;
 }
-- 
1.7.10


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34366 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbeC2O1t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 10:27:49 -0400
Received: by mail-pf0-f195.google.com with SMTP id q9so3348551pff.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2018 07:27:49 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 RESEND 3/4] rsi: enable 80MHz clock by default
Date: Thu, 29 Mar 2018 19:44:51 +0530
Message-Id: <1522332892-5251-4-git-send-email-amitkarwar@gmail.com> (sfid-20180329_162752_518198_CE1CCB28)
In-Reply-To: <1522332892-5251-1-git-send-email-amitkarwar@gmail.com>
References: <1522332892-5251-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

80MHz clock for device should be enabled by default in
TX command frame radio capabilities.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index c21fca7..9207da0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -325,8 +325,8 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 	radio_caps->channel_num = common->channel;
 	radio_caps->rf_model = RSI_RF_TYPE;
 
+	radio_caps->radio_cfg_info = RSI_LMAC_CLOCK_80MHZ;
 	if (common->channel_width == BW_40MHZ) {
-		radio_caps->radio_cfg_info = RSI_LMAC_CLOCK_80MHZ;
 		radio_caps->radio_cfg_info |= RSI_ENABLE_40MHZ;
 
 		if (common->fsm_state == FSM_MAC_INIT_DONE) {
-- 
2.7.4

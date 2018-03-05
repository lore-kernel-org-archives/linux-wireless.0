Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:41787 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751679AbeCEOtD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 09:49:03 -0500
Received: by mail-pl0-f67.google.com with SMTP id d9-v6so2275309plo.8
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2018 06:49:03 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 04/10] rsi: enable 80MHz clock by default
Date: Mon,  5 Mar 2018 20:06:54 +0530
Message-Id: <1520260620-4694-5-git-send-email-amitkarwar@gmail.com> (sfid-20180305_154912_103369_33132115)
In-Reply-To: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

80MHz clock for device should be enabled by default in
TX command frame radio capabilities.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 0bcf841..6f995d5a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -338,8 +338,8 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 	radio_caps->channel_num = common->channel;
 	radio_caps->rf_model = RSI_RF_TYPE;
 
+	radio_caps->radio_cfg_info = RSI_LMAC_CLOCK_80MHZ;
 	if (common->channel_width == BW_40MHZ) {
-		radio_caps->radio_cfg_info = RSI_LMAC_CLOCK_80MHZ;
 		radio_caps->radio_cfg_info |= RSI_ENABLE_40MHZ;
 
 		if (common->fsm_state == FSM_MAC_INIT_DONE) {
-- 
2.7.4

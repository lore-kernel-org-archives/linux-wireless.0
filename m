Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35913 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753988AbeGEM7r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 08:59:47 -0400
Received: by mail-pf0-f196.google.com with SMTP id u16-v6so5365338pfh.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2018 05:59:47 -0700 (PDT)
From: Sushant Kumar Mishra <sushant2k1513@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sajay.konduri@redpinesignals.com>,
        Ganapathi Raju <ganapathi.kondraju@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
Subject: [PATCH 2/4] rsi: fix for 40MHZ connection issue.
Date: Thu,  5 Jul 2018 18:08:20 +0530
Message-Id: <1530794302-8833-3-git-send-email-sushant2k1513@gmail.com> (sfid-20180705_145950_939577_A9CB47DC)
In-Reply-To: <1530794302-8833-1-git-send-email-sushant2k1513@gmail.com>
References: <1530794302-8833-1-git-send-email-sushant2k1513@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ganapathi Raju <ganapathi.kondraju@redpinesignals.com>

Radio capabilities packet is not prepared properly for 40MHZ case,
ppe_ack_rate is a two byte variable which is initialized wrongly,
hence we are unable to connect, resolved by assigning it properly.

Signed-off-by: Ganapathi Raju <ganapathi.kondraju@redpinesignals.com>
Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index d0e5937..8280f32 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -334,20 +334,17 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 			struct ieee80211_conf *conf = &hw->conf;
 
 			if (conf_is_ht40_plus(conf)) {
-				radio_caps->radio_cfg_info =
-					RSI_CMDDESC_LOWER_20_ENABLE;
-				radio_caps->radio_info =
-					RSI_CMDDESC_LOWER_20_ENABLE;
+				radio_caps->ppe_ack_rate =
+					cpu_to_le16(LOWER_20_ENABLE |
+						    (LOWER_20_ENABLE >> 12));
 			} else if (conf_is_ht40_minus(conf)) {
-				radio_caps->radio_cfg_info =
-					RSI_CMDDESC_UPPER_20_ENABLE;
-				radio_caps->radio_info =
-					RSI_CMDDESC_UPPER_20_ENABLE;
+				radio_caps->ppe_ack_rate =
+					cpu_to_le16(UPPER_20_ENABLE |
+						    (UPPER_20_ENABLE >> 12));
 			} else {
-				radio_caps->radio_cfg_info =
-					RSI_CMDDESC_40MHZ;
-				radio_caps->radio_info =
-					RSI_CMDDESC_FULL_40_ENABLE;
+				radio_caps->ppe_ack_rate =
+					cpu_to_le16((BW_40MHZ << 12) |
+						    FULL40M_ENABLE);
 			}
 		}
 	}
-- 
2.5.5

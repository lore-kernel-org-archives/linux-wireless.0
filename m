Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:57705 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759245Ab3BNXHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 18:07:51 -0500
Received: by mail-ee0-f53.google.com with SMTP id e53so1580639eek.40
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2013 15:07:50 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] mac80211_hwsim: ask mac80211 to reserve space for chanctx.drv_priv
Date: Fri, 15 Feb 2013 00:03:14 +0100
Message-Id: <1360882994-13250-1-git-send-email-karl@eleaks.org> (sfid-20130215_000755_381127_1DBABC17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Otherwise memory corruption occurs when using channel contexts (ATM when
param 'channel' > 1).

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b73e497..cffdf4f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2247,6 +2247,7 @@ static int __init init_mac80211_hwsim(void)
 		/* ask mac80211 to reserve space for magic */
 		hw->vif_data_size = sizeof(struct hwsim_vif_priv);
 		hw->sta_data_size = sizeof(struct hwsim_sta_priv);
+		hw->chanctx_data_size = sizeof(struct hwsim_chanctx_priv);
 
 		memcpy(data->channels_2ghz, hwsim_channels_2ghz,
 			sizeof(hwsim_channels_2ghz));
-- 
1.7.10.GIT



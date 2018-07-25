Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35829 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbeGYUDC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jul 2018 16:03:02 -0400
From: Varsha Rao <rvarsha016@gmail.com>
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH] net: wireless: ath6kl: Remove unnecessary parentheses
Date: Wed, 25 Jul 2018 20:49:48 +0200
Message-Id: <20180725184949.4032-1-rvarsha016@gmail.com> (sfid-20180725_205018_377485_B84E8BC1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove extra parentheses to fix the clang warning of extraneous
parentheses.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 808fb30be9ad..451297441532 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -639,7 +639,7 @@ void ath6kl_connect_event(struct ath6kl_vif *vif, u16 channel, u8 *bssid,
 	memcpy(vif->bssid, bssid, sizeof(vif->bssid));
 	vif->bss_ch = channel;
 
-	if ((vif->nw_type == INFRA_NETWORK)) {
+	if (vif->nw_type == INFRA_NETWORK) {
 		ath6kl_wmi_listeninterval_cmd(ar->wmi, vif->fw_vif_idx,
 					      vif->listen_intvl_t, 0);
 		ath6kl_check_ch_switch(ar, channel);
-- 
2.17.0

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:64092 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab3FZG5b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 02:57:31 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
CC: Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2] ath10k: leave MMIC generation to the HW
Date: Wed, 26 Jun 2013 08:57:24 +0200
Message-ID: <1372229844-7987-1-git-send-email-michal.kazior@tieto.com> (sfid-20130626_085734_584220_B80B878E)
In-Reply-To: <1372060350-31460-4-git-send-email-michal.kazior@tieto.com>
References: <1372060350-31460-4-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apparently HW doesn't require us to generate MMIC
for TKIP suite.

Each frame was 8 bytes longer than it should be
and some APs would drop frames that exceed 1520
bytes of 802.11 payload. This could be observed
during throughput tests or fragmented IP traffic.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4867f30..bfee06d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -56,7 +56,6 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
 		arg.key_cipher = WMI_CIPHER_TKIP;
 		arg.key_txmic_len = 8;
 		arg.key_rxmic_len = 8;
-- 
1.7.9.5


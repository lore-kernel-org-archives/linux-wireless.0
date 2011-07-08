Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8243 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab1GHMmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 08:42:37 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 4/4] ath9k_htc: Inform stack about tx ack status
Date: Fri, 8 Jul 2011 18:12:03 +0530
Message-ID: <1310128923-2778-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110708_144242_040561_5A1B3356)
In-Reply-To: <1310128923-2778-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1310128923-2778-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent firmware changes report tx ack status properly
to driver. Hence updating ath9k_htc driver capabilities.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 61e6d39..3bea7ea 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -754,6 +754,7 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
+		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 
 	hw->wiphy->interface_modes =
-- 
1.7.6


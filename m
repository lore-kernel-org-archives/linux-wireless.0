Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16791 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab1HOIEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 04:04:46 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 3/4] ath6kl: Check sme state before delivering disconnect event to cfg80211
Date: Mon, 15 Aug 2011 01:04:02 -0700
Message-ID: <1313395443-5392-4-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110815_100451_333637_CA81DD78)
In-Reply-To: <1313395443-5392-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1313395443-5392-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

 In some random cases, the firmware is sending two disconnect event to
 the host. In the current model, both diconnect events are passed to
 cfg80211 without checking local sme state machine, which is screwing
 cfg80211 layer state.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index e88b519..b2b70e6 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -643,7 +643,7 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 						NULL, 0,
 						WLAN_STATUS_UNSPECIFIED_FAILURE,
 						GFP_KERNEL);
-		} else {
+		} else if (ar->sme_state == SME_CONNECTED) {
 			cfg80211_disconnected(ar->net_dev, reason,
 					      NULL, 0, GFP_KERNEL);
 		}
-- 
1.7.1


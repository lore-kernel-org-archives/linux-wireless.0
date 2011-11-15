Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2170 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab1KOIpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 03:45:16 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Clear WPS ctrl flag if zero length IE is received from CFG
Date: Tue, 15 Nov 2011 14:14:56 +0530
Message-ID: <1321346696-6127-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20111115_094521_102480_788DCB6B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Connect control flag CONNECT_WPS_FLAG has to be cleared
by default even if the driver receives zero length IE
from CFG.

Otherwise this flag would be always set after WPS exchange
which would lead wpa_supplicant to fail to connect with
the received WPS credentials. This issue is observed only
in OPEN security.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6da5c9e..b99cdc9 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -427,7 +427,8 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		status = ath6kl_set_assoc_req_ies(vif, sme->ie, sme->ie_len);
 		if (status)
 			return status;
-	}
+	} else
+		ar->connect_ctrl_flags &= ~CONNECT_WPS_FLAG;
 
 	if (test_bit(CONNECTED, &vif->flags) &&
 	    vif->ssid_len == sme->ssid_len &&
-- 
1.7.0.4


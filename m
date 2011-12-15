Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58719 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab1LOMSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 07:18:45 -0500
Date: Thu, 15 Dec 2011 14:16:00 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Dai Shuibing <shuibing@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Fix connect command to clear previously used IEs
Message-ID: <20111215121600.GA16588@jouni.qca.qualcomm.com> (sfid-20111215_131849_156400_8E25C9FE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Empty IE buffer means that the new association is not supposed to
include extra IEs. Make sure any previously configured (Re)Association
Request frame IEs get cleared in such a case. This is based on a patch
from Shuibing.

Cc: Dai Shuibing <shuibing@qca.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6c59a21..ac764c1 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -461,13 +461,13 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
-	if (sme->ie && (sme->ie_len > 0)) {
-		status = ath6kl_set_assoc_req_ies(vif, sme->ie, sme->ie_len);
-		if (status) {
-			up(&ar->sem);
-			return status;
-		}
-	} else
+	status = ath6kl_set_assoc_req_ies(vif, sme->ie, sme->ie_len);
+	if (status) {
+		up(&ar->sem);
+		return status;
+	}
+
+	if (sme->ie == NULL || sme->ie_len == 0)
 		ar->connect_ctrl_flags &= ~CONNECT_WPS_FLAG;
 
 	if (test_bit(CONNECTED, &vif->flags) &&
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA

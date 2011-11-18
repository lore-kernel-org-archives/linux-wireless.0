Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:34726 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab1KROKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 09:10:03 -0500
Date: Fri, 18 Nov 2011 17:09:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
	Kevin Fang <kevin.fang@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ath6kl: unlock if ath6kl_cfg80211_connect() fails
Message-ID: <20111118140932.GB9685@elgon.mountain> (sfid-20111118_151010_312913_769C40B5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is an unlock missing on this error path.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0252604..5bb4060 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -427,8 +427,10 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
 	if (sme->ie && (sme->ie_len > 0)) {
 		status = ath6kl_set_assoc_req_ies(vif, sme->ie, sme->ie_len);
-		if (status)
+		if (status) {
+			up(&ar->sem);
 			return status;
+		}
 	}
 
 	if (test_bit(CONNECTED, &vif->flags) &&

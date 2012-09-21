Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8152 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111Ab2IUJjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 05:39:31 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 1/3] ath6kl: Avoid null ptr dereference while printing reg domain pair
Date: Fri, 21 Sep 2012 15:08:53 +0530
Message-ID: <1348220335-29711-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120921_113934_362371_25E7712F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Return value of ath6kl_get_regpair() is stored in 'regpair' in
ath6kl_wmi_regdomain_event() func and it's directly accessed
in the debug prints without checking for NULL value. There are
situation to get NULL pointer as a return value from
ath6kl_get_regpair() func. Fix this.

Found this on code review.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 68b46bd..64b81fd 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -936,8 +936,12 @@ static void ath6kl_wmi_regdomain_event(struct wmi *wmi, u8 *datap, int len)
 
 		regpair = ath6kl_get_regpair((u16) reg_code);
 		country = ath6kl_regd_find_country_by_rd((u16) reg_code);
-		ath6kl_dbg(ATH6KL_DBG_WMI, "Regpair used: 0x%0x\n",
-			   regpair->regDmnEnum);
+		if (regpair)
+			ath6kl_dbg(ATH6KL_DBG_WMI, "Regpair used: 0x%0x\n",
+				   regpair->regDmnEnum);
+		else
+			ath6kl_warn("Regpair not found reg_code 0x%0x\n",
+				    reg_code);
 	}
 
 	if (country && wmi->parent_dev->wiphy_registered) {
-- 
1.7.1


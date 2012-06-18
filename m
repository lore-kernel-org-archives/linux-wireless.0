Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9660 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab2FRNbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 09:31:42 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/4] ath9k: fix mci_is_enabled utility
Date: Mon, 18 Jun 2012 19:02:38 +0530
Message-ID: <1340026360-18873-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120618_153144_545402_AF92E3CA)
In-Reply-To: <1340026360-18873-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1340026360-18873-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During driver stop, btcoex is disabled and also btcoex_hw.enabled
is set to false. Afterwards mci_is_enabled returns false so that
BT is not gaining SPDT control on WLAN sleep. Fix that.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 03d5909..934ea40 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1038,7 +1038,8 @@ static inline bool ath9k_hw_btcoex_is_enabled(struct ath_hw *ah)
 }
 static inline bool ath9k_hw_mci_is_enabled(struct ath_hw *ah)
 {
-	return ah->btcoex_hw.enabled && (ah->caps.hw_caps & ATH9K_HW_CAP_MCI);
+	return ah->common.btcoex_enabled &&
+	       (ah->caps.hw_caps & ATH9K_HW_CAP_MCI);
 
 }
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
-- 
1.7.10.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51371 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbaCMRaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 13:30:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8821ae: fixup staging driver for revised ieee80211_is_robust_mgmt_frame
Date: Thu, 13 Mar 2014 13:16:52 -0400
Message-Id: <1394731012-20493-1-git-send-email-linville@tuxdriver.com> (sfid-20140313_183019_223875_65027107)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit d8ca16db6bb2 ("mac80211: add length check in
ieee80211_is_robust_mgmt_frame()" changed that API to take an skb,
and added "_ieee80211_is_robust_mgmt_frame" as a direct replacement
for the older API.  This is the same fix that was applied to the other
rtlwifi drivers in that commit.

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/staging/rtl8821ae/rtl8821ae/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/trx.c b/drivers/staging/rtl8821ae/rtl8821ae/trx.c
index 75ae4387fe19..963b55f661c8 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/trx.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/trx.c
@@ -616,7 +616,7 @@ bool rtl8821ae_rx_query_desc(struct ieee80211_hw *hw,
 				return false;
 		}
 
-		if ((ieee80211_is_robust_mgmt_frame(hdr)) &&
+		if ((_ieee80211_is_robust_mgmt_frame(hdr)) &&
 			(ieee80211_has_protected(hdr->frame_control)))
 			rx_status->flag &= ~RX_FLAG_DECRYPTED;
 		else
-- 
1.8.5.3


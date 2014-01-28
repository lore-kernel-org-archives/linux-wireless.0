Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:5925 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbaA1QBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 11:01:41 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Antonio Quartulli <antonio@meshcoding.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH] ath6kl: removed useless ibss_joined notification on ibss_leave
Date: Tue, 28 Jan 2014 17:00:14 +0100
Message-Id: <1390924815-3714-1-git-send-email-antonio@meshcoding.com> (sfid-20140128_170144_804034_9192D6B7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When leaving an IBSS there is no need to send cfg80211 a
fake notification about "having joined a cell with zero
BSSID".
This operation has the only effect to create a BSS object
that is not going to be used.

Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index eba32f5..8ce1ce5 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -790,7 +790,6 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 	if (nw_type & ADHOC_NETWORK) {
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "ad-hoc %s selected\n",
 			   nw_type & ADHOC_CREATOR ? "creator" : "joiner");
-		cfg80211_ibss_joined(vif->ndev, bssid, GFP_KERNEL);
 		cfg80211_put_bss(ar->wiphy, bss);
 		return;
 	}
-- 
1.8.5.3


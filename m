Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14453 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbbLRWnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 17:43:50 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: Set SM power save disabled to default value
Date: Fri, 18 Dec 2015 14:43:44 -0800
Message-ID: <1450478624-21881-1-git-send-email-poh@qca.qualcomm.com> (sfid-20151218_234353_961963_E41A2C6E)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use SMPS disabled as default because FW does not indicate
any support of SMPS.

This change will help STAs out that don’t support SMPS from
sticking on 1SS, since they don’t have method to change it
back to multiple chains.

This change also should not affect power consumption of STAs
supporting SMPS, because they are capable to switch the mode
to dynamic or static either at the end of frame sequence or
by using SMPS action frame.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b4bdeb0..6146a29 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3860,7 +3860,8 @@ static struct ieee80211_sta_ht_cap ath10k_get_ht_cap(struct ath10k *ar)
 	ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
 	ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 	ht_cap.cap |= IEEE80211_HT_CAP_DSSSCCK40;
-	ht_cap.cap |= WLAN_HT_CAP_SM_PS_STATIC << IEEE80211_HT_CAP_SM_PS_SHIFT;
+	ht_cap.cap |=
+		WLAN_HT_CAP_SM_PS_DISABLED << IEEE80211_HT_CAP_SM_PS_SHIFT;
 
 	if (ar->ht_cap_info & WMI_HT_CAP_HT20_SGI)
 		ht_cap.cap |= IEEE80211_HT_CAP_SGI_20;
-- 
1.9.1


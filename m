Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:34487 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab3GENPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 07/16] ath10k: silent warning in IBSS mode
Date: Fri,  5 Jul 2013 16:15:08 +0300
Message-Id: <1373030117-18077-8-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_151532_818618_4FAE9931)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

There is no TIM IE generated in IBSS beacons by
mac80211.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 7d4b798..1b5312d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -501,8 +501,8 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 	ie = (u8 *)cfg80211_find_ie(WLAN_EID_TIM, ies,
 				    (u8 *)skb_tail_pointer(bcn) - ies);
 	if (!ie) {
-		/* highly unlikely for mac80211 */
-		ath10k_warn("no tim ie found;\n");
+		if (arvif->vdev_type != WMI_VDEV_TYPE_IBSS)
+			ath10k_warn("no tim ie found;\n");
 		return;
 	}
 
-- 
1.7.9.5


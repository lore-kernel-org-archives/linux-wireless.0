Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:32850 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbaBMJ5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 04:57:07 -0500
Subject: [PATCH 3/3] ath10k: release conf_mutex if vdev_start() fails
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Feb 2014 11:57:05 +0200
Message-ID: <20140213095704.13999.57028.stgit@potku.adurom.net> (sfid-20140213_105732_817877_CF0B33E9)
In-Reply-To: <20140213095652.13999.63855.stgit@potku.adurom.net>
References: <20140213095652.13999.63855.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I modified Michal's commit c930f744bdb0 ("ath10k: implement channel switching") to return
when vdev_start() fails, but forgot to release conf_mutex.

Found by coccinelle:

>> drivers/net/wireless/ath/ath10k/mac.c:2745:5-11: preceding lock on line 2663

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a57dc20..5d3c758 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2770,7 +2770,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 				if (ret) {
 					ath10k_warn("failed to start vdev: %d\n",
 						    ret);
-					return;
+					goto exit;
 				}
 
 				arvif->is_started = true;
@@ -2851,6 +2851,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 			ath10k_bss_assoc(hw, vif, info);
 	}
 
+exit:
 	mutex_unlock(&ar->conf_mutex);
 }
 


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:58011 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab1LMMvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 07:51:33 -0500
Subject: [PATCH v2 2/6] ath6kl: call ath6kl_cfg80211_stop() from ath6kl_close()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 13 Dec 2011 14:51:28 +0200
Message-ID: <20111213125127.10834.23078.stgit@localhost6.localdomain6> (sfid-20111213_135135_609181_A1EDFF14)
In-Reply-To: <20111213124923.10834.20626.stgit@localhost6.localdomain6>
References: <20111213124923.10834.20626.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This way it's possible to keep all disconnect logic in one function and
easier to add new functionality, like stopping scheduled scan.

There are some changes to commands called during network interface close,
but there should not be any visible changes in functionality.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index d9b4ba4..0c7a013 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1005,16 +1005,7 @@ static int ath6kl_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	ath6kl_disconnect(vif);
-
-	if (test_bit(WMI_READY, &ar->flag)) {
-		if (ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx, 0xFFFF,
-					      0, 0, 0, 0, 0, 0, 0, 0, 0))
-			return -EIO;
-
-	}
-
-	ath6kl_cfg80211_scan_complete_event(vif, true);
+	ath6kl_cfg80211_stop(ar);
 
 	clear_bit(WLAN_ENABLED, &vif->flags);
 


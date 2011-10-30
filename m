Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:49109 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab1J3TQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Oct 2011 15:16:39 -0400
Subject: [PATCH 3/5] ath6kl: fix WLAN_ENABLE usage in ath6kl_close()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Oct 2011 21:16:33 +0200
Message-ID: <20111030191633.20466.70964.stgit@localhost6.localdomain6> (sfid-20111030_201651_091303_4E1EA6B7)
In-Reply-To: <20111030190922.20466.299.stgit@localhost6.localdomain6>
References: <20111030190922.20466.299.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If ath6kl_init_hw_stop() failed with an error WLAN_ENABLED would not
be cleared. Found during code review and just a theoretical issue.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 717ed22..def0b7f 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1147,7 +1147,6 @@ static int ath6kl_close(struct net_device *dev)
 					      0, 0, 0, 0, 0, 0, 0, 0, 0))
 			return -EIO;
 
-		clear_bit(WLAN_ENABLED, &vif->flags);
 	}
 
 	ath6kl_cfg80211_scan_complete_event(vif, -ECANCELED);
@@ -1157,6 +1156,8 @@ static int ath6kl_close(struct net_device *dev)
 	if (ret)
 		return ret;
 
+	clear_bit(WLAN_ENABLED, &vif->flags);
+
 	return 0;
 }
 


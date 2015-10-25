Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29747 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbbJYN7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 09:59:41 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4/4] wil6210: handle failure in Tx vring config
Date: Sun, 25 Oct 2015 15:59:24 +0200
Message-Id: <1445781564-24455-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151025_145944_883470_8B7C090D)
In-Reply-To: <1445781564-24455-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1445781564-24455-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When configuring Tx vring for new connection,
WMI call to the firmware may fail. In this case, need to
clean up properly. In particular, need to call
cfg80211_del_sta() in case of AP like interface.

Perform full "disconnect" procedure for proper clean up

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index aade16b..bb69a59 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -422,7 +422,7 @@ static void wil_connect_worker(struct work_struct *work)
 		wil->sta[cid].status = wil_sta_connected;
 		netif_tx_wake_all_queues(ndev);
 	} else {
-		wil->sta[cid].status = wil_sta_unused;
+		wil_disconnect_cid(wil, cid, WLAN_REASON_UNSPECIFIED, true);
 	}
 }
 
-- 
2.1.4


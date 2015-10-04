Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24814 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbJDHX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 03:23:57 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 08/10] wil6210: ratelimit Tx error message
Date: Sun,  4 Oct 2015 10:23:25 +0300
Message-Id: <1443943407-6663-9-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151004_092402_245055_5EA11B6D)
In-Reply-To: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Situations observed when IP stack schedules lots of
frames for Tx while no connection (connection lost,
for example). In this case, dmesg bloated with error
message "FW not connected", printed for every frame.

Ratelimit this error message to avoid dmesg pollution.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index c530c79..0f8b687 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1667,7 +1667,7 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		goto drop;
 	}
 	if (unlikely(!test_bit(wil_status_fwconnected, wil->status))) {
-		wil_err(wil, "FW not connected\n");
+		wil_err_ratelimited(wil, "FW not connected\n");
 		goto drop;
 	}
 	if (unlikely(wil->wdev->iftype == NL80211_IFTYPE_MONITOR)) {
-- 
2.1.4


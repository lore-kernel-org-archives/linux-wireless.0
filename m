Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24814 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbJDHXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 03:23:55 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 07/10] wil6210: capture all frames in sniffer mode
Date: Sun,  4 Oct 2015 10:23:24 +0300
Message-Id: <1443943407-6663-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151004_092359_938783_5252D4C7)
In-Reply-To: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the sniffer (monitor) mode, capture either control only or both
control and data PHY.

It used to be control only or data only PHY due to firmware
issues with configuration for PHY auto-detection; but now
it is resolved.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 2f35d4c..6112189 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1120,7 +1120,7 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
 			cpu_to_le32(ndev->type == ARPHRD_IEEE80211_RADIOTAP);
 		cmd.sniffer_cfg.phy_support =
 			cpu_to_le32((wil->monitor_flags & MONITOR_FLAG_CONTROL)
-				    ? WMI_SNIFFER_CP : WMI_SNIFFER_DP);
+				    ? WMI_SNIFFER_CP : WMI_SNIFFER_BOTH_PHYS);
 	} else {
 		/* Initialize offload (in non-sniffer mode).
 		 * Linux IP stack always calculates IP checksum
-- 
2.1.4


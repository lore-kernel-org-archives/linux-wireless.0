Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64997 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486AbaKNDR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 22:17:59 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: fix mismatched wmi api call
Date: Thu, 13 Nov 2014 19:17:51 -0800
Message-ID: <1415935071-21422-1-git-send-email-poh@qca.qualcomm.com> (sfid-20141114_041802_572469_36C47666)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix to use v10.2 wmi call for firmware v10.2.
It turned out that peer association function was using
v10.1 wmi call for v10.2 firmware during code review.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ae746ce..f5d1081 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4187,9 +4187,9 @@ int ath10k_wmi_peer_assoc(struct ath10k *ar,
 
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
 		if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features))
-			ath10k_wmi_peer_assoc_fill_10_1(ar, skb->data, arg);
-		else
 			ath10k_wmi_peer_assoc_fill_10_2(ar, skb->data, arg);
+		else
+			ath10k_wmi_peer_assoc_fill_10_1(ar, skb->data, arg);
 	} else {
 		ath10k_wmi_peer_assoc_fill_main(ar, skb->data, arg);
 	}
-- 
1.9.1


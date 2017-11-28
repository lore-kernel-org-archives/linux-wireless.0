Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:65419 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752294AbdK1KHp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Nov 2017 05:07:45 -0500
From: <bpothuno@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
        Balaji Pothunoori <bpothuno@qti.qualcomm.com>
Subject: [PATCH] ath10k: handling qos at STA side based on AP WMM enable/disable
Date: Tue, 28 Nov 2017 15:37:30 +0530
Message-ID: <1511863650-9419-1-git-send-email-bpothuno@qti.qualcomm.com> (sfid-20171128_110751_350484_606254B3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Balaji Pothunoori <bpothuno@qti.qualcomm.com>

Data packets are not sent by STA in case of STA joined to
non QOS AP (WMM disabled AP). This is happening because of STA
is sending data packets to firmware from host with qos enabled
along with non qos queue value(TID = 16).
Due to qos enabled, firmware is discarding the packet.

This patch fixes this issue by updating the qos based on station
WME capability field if WMM is disabled in AP.

This patch is required by 10.4 family chipsets like
QCA4019/QCA9888/QCA9884/QCA99X0.
Firmware Versoin : 10.4-3.5.1-00018.

For 10.2.4 family chipsets QCA988X/QCA9887 and QCA6174 this patch
has no effect.

Signed-off-by: Balaji Pothunoori <bpothuno@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0a947ee..2616b99 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2563,7 +2563,7 @@ static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
 		}
 		break;
 	case WMI_VDEV_TYPE_STA:
-		if (vif->bss_conf.qos)
+		if (sta->wme)
 			arg->peer_flags |= arvif->ar->wmi.peer_flags->qos;
 		break;
 	case WMI_VDEV_TYPE_IBSS:
-- 
1.7.9.5

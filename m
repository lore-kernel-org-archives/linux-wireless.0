Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:58191 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaLPIyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2014 03:54:20 -0500
Received: by mail-wg0-f51.google.com with SMTP id x12so16617529wgg.38
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2014 00:54:19 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/2] ath10k: fix low TX rates when IBSS and HT
Date: Tue, 16 Dec 2014 09:52:59 +0100
Message-Id: <1418719980-19753-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20141216_095425_519660_4A80AE46)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fix TX problem when IBSS used in HT mode.
Before we used 6Mbps all the time for TX direction.

Reported-by: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5475f0f..c9e7995 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1411,9 +1411,16 @@ static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
 		if (vif->bss_conf.qos)
 			arg->peer_flags |= WMI_PEER_QOS;
 		break;
+	case WMI_VDEV_TYPE_IBSS:
+		if (sta->wme)
+			arg->peer_flags |= WMI_PEER_QOS;
+		break;
 	default:
 		break;
 	}
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac peer %pM qos %d\n",
+		   sta->addr, !!(arg->peer_flags & WMI_PEER_QOS));
 }
 
 static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
-- 
1.9.1


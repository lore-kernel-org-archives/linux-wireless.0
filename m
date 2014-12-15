Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44360 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaLOMgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 07:36:23 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so8778728wid.17
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2014 04:36:22 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC] ath10k: allow to use HT rates when IBSS
Date: Mon, 15 Dec 2014 13:35:31 +0100
Message-Id: <1418646931-6466-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20141215_133627_855534_3D50F0DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fix TX problem when IBSS connected and
enabled HT rates. Before we used 6Mbps all the
time.

Reported-by: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5475f0f..d358dab 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1408,6 +1408,7 @@ static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
 		}
 		break;
 	case WMI_VDEV_TYPE_STA:
+	case WMI_VDEV_TYPE_IBSS:
 		if (vif->bss_conf.qos)
 			arg->peer_flags |= WMI_PEER_QOS;
 		break;
@@ -1635,6 +1636,17 @@ static int ath10k_station_assoc(struct ath10k *ar,
 		return ret;
 	}
 
+	if (arvif->vdev_type == WMI_VDEV_TYPE_IBSS) {
+		ret = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
+						WMI_PEER_NSS, sta->rx_nss);
+		if (ret) {
+			ath10k_warn(ar, "failed to set nss param %d for STA %pM vdet %i: %d\n",
+				    sta->rx_nss, sta->addr,
+				    arvif->vdev_id, ret);
+			return ret;
+		}
+	}
+
 	/* Re-assoc is run only to update supported rates for given station. It
 	 * doesn't make much sense to reconfigure the peer completely.
 	 */
-- 
1.9.1


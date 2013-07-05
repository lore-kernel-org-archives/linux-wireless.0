Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:34491 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab3GENPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 16/16] ath10k: add missing debug prints
Date: Fri,  5 Jul 2013 16:15:17 +0300
Message-Id: <1373030117-18077-17-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_151537_074760_4130AC76)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 681e941..b7e7e45 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1748,6 +1748,9 @@ int ath10k_wmi_vdev_install_key(struct ath10k *ar,
 	if (arg->key_data)
 		memcpy(cmd->key_data, arg->key_data, arg->key_len);
 
+	ath10k_dbg(ATH10K_DBG_WMI,
+		   "wmi vdev install key idx %d cipher %d len %d\n",
+		   arg->key_idx, arg->key_cipher, arg->key_len);
 	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_INSTALL_KEY_CMDID);
 }
 
@@ -2011,6 +2014,9 @@ int ath10k_wmi_peer_assoc(struct ath10k *ar,
 	cmd->peer_vht_rates.tx_mcs_set =
 		__cpu_to_le32(arg->peer_vht_rates.tx_mcs_set);
 
+	ath10k_dbg(ATH10K_DBG_WMI,
+		   "wmi peer assoc vdev %d addr %pM\n",
+		   arg->vdev_id, arg->addr);
 	return ath10k_wmi_cmd_send(ar, skb, WMI_PEER_ASSOC_CMDID);
 }
 
-- 
1.7.9.5


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:40936 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755587AbdJJIB5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 04:01:57 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k-ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/5] ath10k: Fix TDLS peer TX data failure issue on encryped AP
Date: Tue, 10 Oct 2017 16:02:31 +0800
Message-ID: <1507622551-9156-3-git-send-email-yintang@qti.qualcomm.com> (sfid-20171010_100214_994143_743F0AB9)
In-Reply-To: <1507622551-9156-1-git-send-email-yintang@qti.qualcomm.com>
References: <TDLS for ath10k patch V4>
 <1507622551-9156-1-git-send-email-yintang@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yingying Tang <yintang@qti.qualcomm.com>

For WPA encryption, QCA6174 firmware(version: WLAN.RM.4.4) will unblock
data when M4 was sent successfully. For other encryption which didn't need
4-way handshake firmware will unblock the data when peer authorized. Since
TDLS is 3-way handshake host need send authorize cmd to firmware to unblock
data.

Signed-off-by: Yingying Tang <yintang@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f6702cb..d2530f7 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5841,6 +5841,10 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		ath10k_warn(ar, "Peer %pM disappeared!\n", peer_addr);
 	spin_unlock_bh(&ar->data_lock);
 
+	if (sta && sta->tdls)
+		ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
+					  WMI_PEER_AUTHORIZE, 1);
+
 exit:
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
-- 
1.7.9.5

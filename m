Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:13550 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbdIOLFB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 07:05:01 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [TDLS PATCH V1 5/5] ath10k: Avoid to set WEP key for TDLS peer
Date: Fri, 15 Sep 2017 19:05:48 +0800
Message-ID: <1505473548-22977-1-git-send-email-yintang@qti.qualcomm.com> (sfid-20170915_130509_061641_A34B1D71)
In-Reply-To: <TDLS for ath10k>
References: <TDLS for ath10k>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yingying Tang <yintang@qti.qualcomm.com>

TDLS peer do not need WEP key. Setting WEP key will lead
to TDLS setup failure. Add fix to avoid setting WEP key
for TDLS peer.

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

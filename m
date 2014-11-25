Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:48753 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKYGPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 01:15:16 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/3] ath10k: Fix locking for WEP keys
Date: Tue, 25 Nov 2014 11:46:59 +0530
Message-Id: <1416896220-29691-2-git-send-email-sujith@msujith.org> (sfid-20141125_071520_247414_8C31078E)
In-Reply-To: <1416896220-29691-1-git-send-email-sujith@msujith.org>
References: <1416896220-29691-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

peer->keys needs to be protected by data_lock
since it is also accessed from the WMI path.

Both install() and clear() routines for peer
keys modify the key contents, so use the data_lock
to avoid races.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 2 ++
 drivers/net/wireless/ath/ath10k/mac.c  | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8f86bd3..73da1bb 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -218,6 +218,8 @@ struct ath10k_peer {
 	int vdev_id;
 	u8 addr[ETH_ALEN];
 	DECLARE_BITMAP(peer_ids, ATH10K_MAX_NUM_PEER_IDS);
+
+	/* protected by ar->data_lock */
 	struct ieee80211_key_conf *keys[WMI_MAX_KEY_INDEX + 1];
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index fb95d4d..01de6f3 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -136,7 +136,9 @@ static int ath10k_install_peer_wep_keys(struct ath10k_vif *arvif,
 		if (ret)
 			return ret;
 
+		spin_lock_bh(&ar->data_lock);
 		peer->keys[i] = arvif->wep_keys[i];
+		spin_unlock_bh(&ar->data_lock);
 	}
 
 	return 0;
@@ -173,7 +175,9 @@ static int ath10k_clear_peer_keys(struct ath10k_vif *arvif,
 			ath10k_warn(ar, "failed to remove peer wep key %d: %d\n",
 				    i, ret);
 
+		spin_lock_bh(&ar->data_lock);
 		peer->keys[i] = NULL;
+		spin_unlock_bh(&ar->data_lock);
 	}
 
 	return first_errno;
-- 
2.1.3


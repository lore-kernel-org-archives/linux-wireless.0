Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:38507 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaKXCfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2014 21:35:55 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] ath10k: Fix locking for WEP keys
Date: Mon, 24 Nov 2014 08:07:36 +0530
Message-Id: <1416796657-24657-3-git-send-email-sujith@msujith.org> (sfid-20141124_033600_516929_28A7B0FD)
In-Reply-To: <1416796657-24657-1-git-send-email-sujith@msujith.org>
References: <1416796657-24657-1-git-send-email-sujith@msujith.org>
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
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 23116c2..2200c64 100644
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


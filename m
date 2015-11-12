Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6046 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbbKLRsR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 12:48:17 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: Enable VHT for Mesh
Date: Thu, 12 Nov 2015 09:47:44 -0800
Message-ID: <1447350464-3993-1-git-send-email-poh@qca.qualcomm.com> (sfid-20151112_184820_858399_E3A37238)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh until now has no framework for VHT support which
requires NL80211 and wpa_supplicant updates communicating
with wireless drivers for capabilities.
I've sent patches of NL80211 and wpa_supplicant separately
that can be used for Mesh VHT support.
Also enable ath10k Mesh VHT support in this patch.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a53e213..d38e4d8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7266,6 +7266,7 @@ int ath10k_mac_register(struct ath10k *ar)
 	}
 
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
+	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_VHT_MESH);
 
 	/*
 	 * on LL hardware queues are managed entirely by the FW
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53958 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbcEKRCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 13:02:45 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 19/21] ath10k: Enable adhoc mode for CT firmware.
Date: Wed, 11 May 2016 10:02:31 -0700
Message-Id: <1462986153-16318-20-git-send-email-greearb@candelatech.com> (sfid-20160511_190258_305482_F07493A0)
In-Reply-To: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

CT firmware can support IBSS mode, so allow users to configure this.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f1bfb3a..3fc9006 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7482,6 +7482,10 @@ static const struct ieee80211_iface_limit ath10k_10x_ct_if_limits[] = {
 	.max	= 7,
 	.types	= BIT(NL80211_IFTYPE_AP)
 	},
+	{
+	.max	= 1,
+	.types	= BIT(NL80211_IFTYPE_ADHOC)
+	},
 };
 
 static const struct ieee80211_iface_combination ath10k_if_comb[] = {
@@ -7862,6 +7866,7 @@ int ath10k_mac_register(struct ath10k *ar)
 			ar->hw->wiphy->iface_combinations = ath10k_10x_ct_if_comb;
 			ar->hw->wiphy->n_iface_combinations =
 				ARRAY_SIZE(ath10k_10x_ct_if_comb);
+			ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC);
 		} else {
 			ar->hw->wiphy->iface_combinations = ath10k_10x_if_comb;
 			ar->hw->wiphy->n_iface_combinations =
-- 
2.4.3


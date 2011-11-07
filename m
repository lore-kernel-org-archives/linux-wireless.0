Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51106 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1KGF2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 00:28:13 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 09/11] ath6kl: Expose ath6kl's WOW capabilities to CFG layer
Date: Mon, 7 Nov 2011 10:55:45 +0530
Message-ID: <1320643547-3578-10-git-send-email-rmani@qca.qualcomm.com> (sfid-20111107_062815_856912_B86F8860)
In-Reply-To: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
References: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the list of ath6kl's WOW trigger options in wiphy->wowlan.flags
variable during wiphy registration. So that, those options can be
configured via iw.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index f524276..603dbda 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2509,6 +2509,16 @@ int ath6kl_register_ieee80211_hw(struct ath6kl *ar)
 	wiphy->cipher_suites = cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
+	wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
+			      WIPHY_WOWLAN_DISCONNECT |
+			      WIPHY_WOWLAN_GTK_REKEY_FAILURE  |
+			      WIPHY_WOWLAN_SUPPORTS_GTK_REKEY |
+			      WIPHY_WOWLAN_EAP_IDENTITY_REQ   |
+			      WIPHY_WOWLAN_4WAY_HANDSHAKE;
+	wiphy->wowlan.n_patterns = WOW_MAX_FILTERS_PER_LIST;
+	wiphy->wowlan.pattern_min_len = 1;
+	wiphy->wowlan.pattern_max_len = WOW_PATTERN_SIZE;
+
 	ret = wiphy_register(wiphy);
 	if (ret < 0) {
 		ath6kl_err("couldn't register wiphy device\n");
-- 
1.7.1


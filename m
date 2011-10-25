Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52054 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1JYKin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:38:43 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 7/7] ath6kl: Expose ath6kl wow capabilities to cfg layer
Date: Tue, 25 Oct 2011 16:07:27 +0530
Message-ID: <1319539047-8756-8-git-send-email-rmani@qca.qualcomm.com> (sfid-20111025_123845_974937_8222B9E0)
In-Reply-To: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com>
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

  Set the list of ath6kl's WOW trigger options in wiphy->wowlan.flags
  variable during wiphy registration. So that, those options can be
  configured via iw.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 241b13d..da4a2ff 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2117,6 +2117,16 @@ struct wireless_dev *ath6kl_cfg80211_init(struct device *dev)
 	wdev->wiphy->cipher_suites = cipher_suites;
 	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
+	wdev->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
+				    WIPHY_WOWLAN_DISCONNECT |
+				    WIPHY_WOWLAN_GTK_REKEY_FAILURE  |
+				    WIPHY_WOWLAN_SUPPORTS_GTK_REKEY |
+				    WIPHY_WOWLAN_EAP_IDENTITY_REQ   |
+				    WIPHY_WOWLAN_4WAY_HANDSHAKE;
+	wdev->wiphy->wowlan.n_patterns = WOW_MAX_FILTERS_PER_LIST;
+	wdev->wiphy->wowlan.pattern_min_len = 1;
+	wdev->wiphy->wowlan.pattern_max_len = WOW_PATTERN_SIZE;
+
 	ret = wiphy_register(wdev->wiphy);
 	if (ret < 0) {
 		ath6kl_err("couldn't register wiphy device\n");
-- 
1.7.0.4


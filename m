Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55329 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1KKPDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 10:03:14 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath6kl: Fix bug in setting dot11_auth_mode in AP mode
Date: Fri, 11 Nov 2011 20:33:01 +0530
Message-ID: <1321023781-387-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111111_160317_320009_95634B6F)
In-Reply-To: <1321023781-387-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1321023781-387-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OPEN_AUTH is passed as dot11_auth_mode by default, this would
affect the AP mode when configured with shared authentication
type. Assign appropriate auth type to fix this from driver.
A patch in wpa_supplicant (wpa_supplicant: Set configured auth_algs)
is also needed to fix this.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 89414b1..7250d1a 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1982,7 +1982,7 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	int ies_len;
 	struct wmi_connect_cmd p;
 	int res;
-	int i;
+	int i, ret;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: add=%d\n", __func__, add);
 
@@ -2040,7 +2040,9 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	if (info->hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE)
 		return -EOPNOTSUPP; /* TODO */
 
-	vif->dot11_auth_mode = OPEN_AUTH;
+	ret = ath6kl_set_auth_type(vif, info->auth_type);
+	if (ret)
+		return ret;
 
 	memset(&p, 0, sizeof(p));
 
-- 
1.7.0.4


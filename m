Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44933 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1L2Ksq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Dec 2011 05:48:46 -0500
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Remove redundant key_index check.
Date: Thu, 29 Dec 2011 16:18:39 +0530
Message-ID: <1325155719-4038-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20111229_114849_913235_F534B366)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Less-than-zero comparison of an unsigned value is never true.

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d6806be..25db296 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -524,8 +524,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	    (vif->prwise_crypto == WEP_CRYPT)) {
 		struct ath6kl_key *key = NULL;
 
-		if (sme->key_idx < WMI_MIN_KEY_INDEX ||
-		    sme->key_idx > WMI_MAX_KEY_INDEX) {
+		if (sme->key_idx > WMI_MAX_KEY_INDEX) {
 			ath6kl_err("key index %d out of bounds\n",
 				   sme->key_idx);
 			up(&ar->sem);
@@ -997,7 +996,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 					      params->key);
 	}
 
-	if (key_index < WMI_MIN_KEY_INDEX || key_index > WMI_MAX_KEY_INDEX) {
+	if (key_index > WMI_MAX_KEY_INDEX) {
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 			   "%s: key index %d out of bounds\n", __func__,
 			   key_index);
@@ -1115,7 +1114,7 @@ static int ath6kl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
-	if (key_index < WMI_MIN_KEY_INDEX || key_index > WMI_MAX_KEY_INDEX) {
+	if (key_index > WMI_MAX_KEY_INDEX) {
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 			   "%s: key index %d out of bounds\n", __func__,
 			   key_index);
@@ -1148,7 +1147,7 @@ static int ath6kl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
-	if (key_index < WMI_MIN_KEY_INDEX || key_index > WMI_MAX_KEY_INDEX) {
+	if (key_index > WMI_MAX_KEY_INDEX) {
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 			   "%s: key index %d out of bounds\n", __func__,
 			   key_index);
@@ -1184,7 +1183,7 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 	if (!ath6kl_cfg80211_ready(vif))
 		return -EIO;
 
-	if (key_index < WMI_MIN_KEY_INDEX || key_index > WMI_MAX_KEY_INDEX) {
+	if (key_index > WMI_MAX_KEY_INDEX) {
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
 			   "%s: key index %d out of bounds\n",
 			   __func__, key_index);
-- 
1.7.1


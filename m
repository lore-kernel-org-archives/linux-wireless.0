Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32698 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab0KYBi2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 20:38:28 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/12] iwlagn: remove powersave warning
Date: Wed, 24 Nov 2010 17:32:39 -0800
Message-Id: <1290648768-10075-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Through races, a packet may be enqueued for
transmission to a station while that station
is going to sleep, in which case the warning
here triggers. Instead of warning, check the
condition -- if this packet is not a PS-poll
response then we still enqueue it but it will
be rejected by the device since the station
is marked as asleep.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 07bbc91..e8bd0b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -567,8 +567,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (sta)
 		sta_priv = (void *)sta->drv_priv;
 
-	if (sta_priv && sta_priv->asleep) {
-		WARN_ON(!(info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE));
+	if (sta_priv && sta_priv->asleep &&
+	    (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)) {
 		/*
 		 * This sends an asynchronous command to the device,
 		 * but we can rely on it being processed before the
-- 
1.7.0.4


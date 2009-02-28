Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13154 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbZB1AQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 19:16:48 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/6] iwl3945: synchronize timestamp with uCode
Date: Fri, 27 Feb 2009 16:21:20 -0800
Message-Id: <1235780484-27979-3-git-send-email-reinette.chatre@intel.com> (sfid-20090228_011652_275961_5F9A6892)
In-Reply-To: <1235780484-27979-2-git-send-email-reinette.chatre@intel.com>
References: <1235780484-27979-1-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

In IBSS, TSF maintains local clock counters at each station. Network
Synchronization follows a completely distributed scheme where beacon frames
are generated. Each station maintain its own TSF timestamp, extracted from
beacon timestamps they recieved. Following patch synchronize this beacon timestamp
with uCode.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 6dcc577..443c00e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4305,6 +4305,7 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 {
 	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
+	__le64 timestamp;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
@@ -4326,6 +4327,8 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 	priv->ibss_beacon = skb;
 
 	priv->assoc_id = 0;
+	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
+	priv->timestamp = le64_to_cpu(timestamp);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.5.6.3


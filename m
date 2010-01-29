Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35013 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab0A2TyJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 14:54:09 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/12] iwlwifi: optimize power saving
Date: Fri, 29 Jan 2010 11:53:51 -0800
Message-Id: <1264794842-8046-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
References: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Halperin <dhalperi@cs.washington.edu>

In hostap AP mode, every time the client sends the AP
a packet the STA_NOTIFY_AWAKE code is sent from mac80211.
This results in a command being sent to the uCode even if
the client was not asleep.

The following simple patch has fixed the issue for me without any
degradation that I can find.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4a26892..380d208 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3007,6 +3007,8 @@ static void iwl_mac_sta_notify(struct ieee80211_hw *hw,
 		break;
 	case STA_NOTIFY_AWAKE:
 		WARN_ON(!sta_priv->client);
+		if (!sta_priv->asleep)
+			break;
 		sta_priv->asleep = false;
 		sta_id = iwl_find_station(priv, sta->addr);
 		if (sta_id != IWL_INVALID_STATION)
-- 
1.6.3.3


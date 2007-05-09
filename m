Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54212 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbXEIFlt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2007 01:41:49 -0400
Date: Wed, 9 May 2007 13:41:52 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fail back to use associate from reassociate
Message-ID: <20070509054152.GA30839@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


mac80211: fail back to use associate from reassociate failure

Some APs have strict checking between associate and reassociate. In
a case when an AP is restarted during a connection, it denies the
mac80211 reassoc request since this is a new association for the AP.
To fix this problem, we need to check the status code against
WLAN_STATUS_REASSOC_NO_ASSOC and clear ifsta->prev_bssid_set in
handling the association failure response.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index b003912..dacd2d3 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1182,6 +1182,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
 		       dev->name, status_code);
+		if (status_code == WLAN_STATUS_REASSOC_NO_ASSOC)
+			ifsta->prev_bssid_set = 0;
 		return;
 	}
 

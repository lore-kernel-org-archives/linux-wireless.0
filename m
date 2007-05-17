Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3313 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758649AbXEQRdM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2007 13:33:12 -0400
Date: Thu, 17 May 2007 13:16:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: fail back to use associate from reassociate failure
Message-ID: <20070517171659.GB7720@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

Some APs have strict checking between associate and reassociate. In
a case when an AP is restarted during a connection, it denies the
mac80211 reassoc request since this is a new association for the AP.
To fix this problem, we need to check the status code against
WLAN_STATUS_REASSOC_NO_ASSOC and clear ifsta->prev_bssid_set in
handling the association failure response.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---

 net/mac80211/ieee80211_sta.c |    2 ++
 1 file changed, 2 insertions(+)

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
 

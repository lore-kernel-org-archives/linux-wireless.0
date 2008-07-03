Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17332 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYGCQ4U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 12:56:20 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org, Guy Cohen <guy.cohen@intel.com>
Subject: [PATCH 1/1] mac80211: move netif_carrier_on to after ieee80211_bss_info_change_notify
Date: Thu,  3 Jul 2008 19:56:13 +0300
Message-Id: <1215104173-8918-1-git-send-email-tomas.winkler@intel.com> (sfid-20080703_185624_218376_9C0B3658)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

Putting netif_carrier_on before configuring the driver/device with the
new association state may cause a race (tx frames may be sent before
configuration is done)

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 37ea04f..cb414de 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -564,15 +564,14 @@ static void ieee80211_set_associated(struct net_device *dev,
 			sdata->bss_conf.ht_bss_conf = &conf->ht_bss_conf;
 		}
 
-		netif_carrier_on(dev);
 		ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
 		memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
 		memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
 		ieee80211_sta_send_associnfo(dev, ifsta);
 	} else {
+		netif_carrier_off(dev);
 		ieee80211_sta_tear_down_BA_sessions(dev, ifsta->bssid);
 		ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
-		netif_carrier_off(dev);
 		changed |= ieee80211_reset_erp_info(dev);
 
 		sdata->bss_conf.assoc_ht = 0;
@@ -586,6 +585,10 @@ static void ieee80211_set_associated(struct net_device *dev,
 
 	sdata->bss_conf.assoc = assoc;
 	ieee80211_bss_info_change_notify(sdata, changed);
+
+	if (assoc)
+		netif_carrier_on(dev);
+
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 }
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


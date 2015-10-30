Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shetland.sei.cmu.edu ([192.58.107.44]:35555 "EHLO
	shetland.sei.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876AbbJ3VFu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 17:05:50 -0400
From: arwelle@cert.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211_hwsim: Adds parameter use_hwsim_mon which can be used to disable hwism0
Date: Fri, 30 Oct 2015 17:05:45 -0400
Message-Id: <1446239145-21119-1-git-send-email-arwelle@cert.org> (sfid-20151030_220600_217716_ECBC99E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adam Welle <arwelle@cert.org>

A new parameter, use_hwsim_mon has been created to implement new functionalilty. use_hwsim_mon defaults to true so that normal operation remains the same. When set to false, the hwsim0 device is not created. This value is also checked before calling functions which would transmit data to the hwsim0 device.

Signed-off-by: Adam Welle <arwelle@cert.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 49 +++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ee46f46..8e48869 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -61,6 +61,10 @@ static bool support_p2p_device = true;
 module_param(support_p2p_device, bool, 0444);
 MODULE_PARM_DESC(support_p2p_device, "Support P2P-Device interface type");
 
+static bool use_hwsim_mon = true;
+module_param(use_hwsim_mon, bool, 0444);
+MODULE_PARM_DESC(use_hwsim_mon, "Create and use hwsim0 monitor device");
+
 /**
  * enum hwsim_regtest - the type of regulatory tests we offer
  *
@@ -1292,7 +1296,8 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 				       ARRAY_SIZE(txi->control.rates));
 
 	txi->rate_driver_data[0] = channel;
-	mac80211_hwsim_monitor_rx(hw, skb, channel);
+	if (use_hwsim_mon)
+		mac80211_hwsim_monitor_rx(hw, skb, channel);
 
 	/* wmediumd mode check */
 	_portid = ACCESS_ONCE(wmediumd_portid);
@@ -1305,7 +1310,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 	data->tx_bytes += skb->len;
 	ack = mac80211_hwsim_tx_frame_no_nl(hw, skb, channel);
 
-	if (ack && skb->len >= 16) {
+	if (ack && skb->len >= 16 && use_hwsim_mon) {
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 		mac80211_hwsim_monitor_ack(channel, hdr->addr2);
 	}
@@ -1402,7 +1407,8 @@ static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 				       ARRAY_SIZE(txi->control.rates));
 	}
 
-	mac80211_hwsim_monitor_rx(hw, skb, chan);
+	if (use_hwsim_mon)
+		mac80211_hwsim_monitor_rx(hw, skb, chan);
 
 	if (_pid)
 		return mac80211_hwsim_tx_frame_nl(hw, skb, _pid);
@@ -3260,26 +3266,28 @@ static int __init init_mac80211_hwsim(void)
 			goto out_free_radios;
 	}
 
-	hwsim_mon = alloc_netdev(0, "hwsim%d", NET_NAME_UNKNOWN,
+	if (use_hwsim_mon) {
+		hwsim_mon = alloc_netdev(0, "hwsim%d", NET_NAME_UNKNOWN,
 				 hwsim_mon_setup);
-	if (hwsim_mon == NULL) {
-		err = -ENOMEM;
-		goto out_free_radios;
-	}
+		if (hwsim_mon == NULL) {
+			err = -ENOMEM;
+			goto out_free_radios;
+		}
 
-	rtnl_lock();
-	err = dev_alloc_name(hwsim_mon, hwsim_mon->name);
-	if (err < 0) {
-		rtnl_unlock();
-		goto out_free_radios;
-	}
+		rtnl_lock();
+		err = dev_alloc_name(hwsim_mon, hwsim_mon->name);
+		if (err < 0) {
+			rtnl_unlock();
+			goto out_free_radios;
+		}
 
-	err = register_netdevice(hwsim_mon);
-	if (err < 0) {
+		err = register_netdevice(hwsim_mon);
+		if (err < 0) {
+			rtnl_unlock();
+			goto out_free_mon;
+		}
 		rtnl_unlock();
-		goto out_free_mon;
 	}
-	rtnl_unlock();
 
 	return 0;
 
@@ -3300,7 +3308,10 @@ static void __exit exit_mac80211_hwsim(void)
 	hwsim_exit_netlink();
 
 	mac80211_hwsim_free();
-	unregister_netdev(hwsim_mon);
+
+	if (hwsim_mon)
+		unregister_netdev(hwsim_mon);
+
 	platform_driver_unregister(&mac80211_hwsim_driver);
 }
 module_exit(exit_mac80211_hwsim);
-- 
2.1.4


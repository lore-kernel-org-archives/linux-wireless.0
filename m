Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38437 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab0ISRrO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Sep 2010 13:47:14 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/4] compat-wireless: make patches apply again
Date: Sun, 19 Sep 2010 19:46:45 +0200
Message-Id: <1284918408-32242-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/01-netdev.patch      |   16 ++++++++--------
 patches/30-bridge-port.patch |   10 +++++-----
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index a62571b..5e24cfb 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -45,7 +45,7 @@ without creating a headache on maintenance of the pathes.
  	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
 --- a/net/mac80211/iface.c
 +++ b/net/mac80211/iface.c
-@@ -698,7 +698,12 @@ static const struct net_device_ops ieee8
+@@ -701,7 +701,12 @@ static const struct net_device_ops ieee8
  static void ieee80211_if_setup(struct net_device *dev)
  {
  	ether_setup(dev);
@@ -59,16 +59,16 @@ without creating a headache on maintenance of the pathes.
  	dev->destructor = free_netdev;
  }
  
-@@ -843,7 +848,7 @@ static void ieee80211_setup_sdata(struct
- 
+@@ -847,7 +852,7 @@ static void ieee80211_setup_sdata(struct
  	/* and set some type-dependent values */
  	sdata->vif.type = type;
+ 	sdata->vif.p2p = false;
 -	sdata->dev->netdev_ops = &ieee80211_dataif_ops;
 +	netdev_attach_ops(sdata->dev, &ieee80211_dataif_ops);
  	sdata->wdev.iftype = type;
  
  	sdata->control_port_protocol = cpu_to_be16(ETH_P_PAE);
-@@ -872,7 +877,7 @@ static void ieee80211_setup_sdata(struct
+@@ -886,7 +891,7 @@ static void ieee80211_setup_sdata(struct
  		break;
  	case NL80211_IFTYPE_MONITOR:
  		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -77,7 +77,7 @@ without creating a headache on maintenance of the pathes.
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -1113,6 +1118,8 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -1137,6 +1142,8 @@ int ieee80211_if_add(struct ieee80211_lo
  		return -ENOMEM;
  	dev_net_set(ndev, wiphy_net(local->hw.wiphy));
  
@@ -86,7 +86,7 @@ without creating a headache on maintenance of the pathes.
  	ndev->needed_headroom = local->tx_headroom +
  				4*6 /* four MAC addresses */
  				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
-@@ -1121,6 +1128,7 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -1145,6 +1152,7 @@ int ieee80211_if_add(struct ieee80211_lo
  				- ETH_HLEN /* ethernet hard_header_len */
  				+ IEEE80211_ENCRYPT_HEADROOM;
  	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
@@ -94,7 +94,7 @@ without creating a headache on maintenance of the pathes.
  
  	ret = dev_alloc_name(ndev, ndev->name);
  	if (ret < 0)
-@@ -1169,6 +1177,10 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -1193,6 +1201,10 @@ int ieee80211_if_add(struct ieee80211_lo
  	if (ret)
  		goto fail;
  
@@ -267,7 +267,7 @@ without creating a headache on maintenance of the pathes.
  #define LBS_DEB_LEAVE	0x00000002
 --- a/drivers/net/wireless/mac80211_hwsim.c
 +++ b/drivers/net/wireless/mac80211_hwsim.c
-@@ -1095,7 +1095,7 @@ static const struct net_device_ops hwsim
+@@ -1100,7 +1100,7 @@ static const struct net_device_ops hwsim
  
  static void hwsim_mon_setup(struct net_device *dev)
  {
diff --git a/patches/30-bridge-port.patch b/patches/30-bridge-port.patch
index c2f9b3a..c2ffc45 100644
--- a/patches/30-bridge-port.patch
+++ b/patches/30-bridge-port.patch
@@ -23,18 +23,18 @@ compat-wireless.
 
 --- a/net/wireless/util.c
 +++ b/net/wireless/util.c
-@@ -777,7 +777,7 @@ int cfg80211_change_iface(struct cfg8021
+@@ -781,7 +781,7 @@ int cfg80211_change_iface(struct cfg8021
  		return -EOPNOTSUPP;
  
  	/* if it's part of a bridge, reject changing type to station/ibss */
 -	if ((dev->priv_flags & IFF_BRIDGE_PORT) &&
 +	if (br_port_exists(dev) &&
- 	    (ntype == NL80211_IFTYPE_ADHOC || ntype == NL80211_IFTYPE_STATION))
- 		return -EBUSY;
- 
+ 	    (ntype == NL80211_IFTYPE_ADHOC ||
+ 	     ntype == NL80211_IFTYPE_STATION ||
+ 	     ntype == NL80211_IFTYPE_P2P_CLIENT))
 --- a/net/wireless/nl80211.c
 +++ b/net/wireless/nl80211.c
-@@ -1197,7 +1197,7 @@ static int nl80211_valid_4addr(struct cf
+@@ -1200,7 +1200,7 @@ static int nl80211_valid_4addr(struct cf
  			       enum nl80211_iftype iftype)
  {
  	if (!use_4addr) {
-- 
1.7.0.4


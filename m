Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41248 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab1HBVPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 17:15:37 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: make patches apply again
Date: Tue,  2 Aug 2011 23:15:15 +0200
Message-Id: <1312319715-25979-1-git-send-email-hauke@hauke-m.de> (sfid-20110802_231540_125010_36C0A1D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/01-netdev.patch |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index 244e03e..c0e938c 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -45,10 +45,10 @@ without creating a headache on maintenance of the pathes.
  	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
 --- a/net/mac80211/iface.c
 +++ b/net/mac80211/iface.c
-@@ -698,7 +698,12 @@ static const struct net_device_ops ieee8
- static void ieee80211_if_setup(struct net_device *dev)
+@@ -699,7 +699,12 @@ static void ieee80211_if_setup(struct ne
  {
  	ether_setup(dev);
+ 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 -	dev->netdev_ops = &ieee80211_dataif_ops;
 +	netdev_attach_ops(dev, &ieee80211_dataif_ops);
 +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
@@ -59,7 +59,7 @@ without creating a headache on maintenance of the pathes.
  	dev->destructor = free_netdev;
  }
  
-@@ -845,7 +850,7 @@ static void ieee80211_setup_sdata(struct
+@@ -846,7 +851,7 @@ static void ieee80211_setup_sdata(struct
  	/* and set some type-dependent values */
  	sdata->vif.type = type;
  	sdata->vif.p2p = false;
@@ -68,7 +68,7 @@ without creating a headache on maintenance of the pathes.
  	sdata->wdev.iftype = type;
  
  	sdata->control_port_protocol = cpu_to_be16(ETH_P_PAE);
-@@ -884,7 +889,7 @@ static void ieee80211_setup_sdata(struct
+@@ -885,7 +890,7 @@ static void ieee80211_setup_sdata(struct
  		break;
  	case NL80211_IFTYPE_MONITOR:
  		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -77,7 +77,7 @@ without creating a headache on maintenance of the pathes.
  		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
  				      MONITOR_FLAG_OTHER_BSS;
  		break;
-@@ -1135,6 +1140,8 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -1136,6 +1141,8 @@ int ieee80211_if_add(struct ieee80211_lo
  		return -ENOMEM;
  	dev_net_set(ndev, wiphy_net(local->hw.wiphy));
  
@@ -86,7 +86,7 @@ without creating a headache on maintenance of the pathes.
  	ndev->needed_headroom = local->tx_headroom +
  				4*6 /* four MAC addresses */
  				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
-@@ -1143,6 +1150,7 @@ int ieee80211_if_add(struct ieee80211_lo
+@@ -1144,6 +1151,7 @@ int ieee80211_if_add(struct ieee80211_lo
  				- ETH_HLEN /* ethernet hard_header_len */
  				+ IEEE80211_ENCRYPT_HEADROOM;
  	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
@@ -314,10 +314,10 @@ without creating a headache on maintenance of the pathes.
  {
  	struct bnep_session *s = netdev_priv(dev);
  	struct sock *sk = s->sock->sk;
-@@ -231,7 +235,7 @@ void bnep_net_setup(struct net_device *d
- 	dev->addr_len = ETH_ALEN;
+@@ -232,7 +236,7 @@ void bnep_net_setup(struct net_device *d
  
  	ether_setup(dev);
+ 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 -	dev->netdev_ops = &bnep_netdev_ops;
 +	netdev_attach_ops(dev, &bnep_netdev_ops);
  
-- 
1.7.4.1


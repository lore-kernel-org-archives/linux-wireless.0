Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2036 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758060Ab1F2Xs5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:57 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 053/119] staging: brcm80211: rename netdevice related
 functions in fullmac
Date: Wed, 29 Jun 2011 16:47:17 -0700
Message-ID: <1309391303-22741-54-git-send-email-frankyl@broadcom.com> (sfid-20110630_015117_822090_5712E649)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Change functions related to netdevice in fullmac to more consistent
naming convention.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    1 +
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |   71 +++++++++++-----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    7 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    2 +-
 4 files changed, 40 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 8736e6f..c990a2c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -884,6 +884,7 @@ static inline void MUTEX_UNLOCK_WL_SCAN_SET(void)
 extern dhd_pub_t *brcmf_attach(struct dhd_bus *bus,
 				uint bus_hdrlen);
 extern int brcmf_net_attach(dhd_pub_t *dhdp, int idx);
+extern int brcmf_netdev_wait_pend8021x(struct net_device *dev);
 
 /* Indication from bus module regarding removal/absence of dongle */
 extern void brcmf_detach(dhd_pub_t *dhdp);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index a3b60da..aa31bf0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -364,8 +364,6 @@ module_param(brcmf_pktgen_len, uint, 0);
 #endif
 
 static void dhd_dpc(unsigned long data);
-/* forward decl */
-extern int dhd_wait_pend8021x(struct net_device *dev);
 
 #ifdef TOE
 static int dhd_toe_get(dhd_info_t *dhd, int idx, u32 *toe_ol);
@@ -923,7 +921,7 @@ static int _dhd_sysioc_thread(void *data)
 	return 0;
 }
 
-static int dhd_set_mac_address(struct net_device *dev, void *addr)
+static int brcmf_netdev_set_mac_address(struct net_device *dev, void *addr)
 {
 	int ret = 0;
 
@@ -943,7 +941,7 @@ static int dhd_set_mac_address(struct net_device *dev, void *addr)
 	return ret;
 }
 
-static void dhd_set_multicast_list(struct net_device *dev)
+static void brcmf_netdev_set_multicast_list(struct net_device *dev)
 {
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(dev);
 	int ifidx;
@@ -990,7 +988,7 @@ int brcmf_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
 	return ret;
 }
 
-static int dhd_start_xmit(struct sk_buff *skb, struct net_device *net)
+static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *net)
 {
 	int ret;
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
@@ -1165,7 +1163,7 @@ void brcmf_txcomplete(dhd_pub_t *dhdp, struct sk_buff *txp, bool success)
 
 }
 
-static struct net_device_stats *dhd_get_stats(struct net_device *net)
+static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
 {
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
 	dhd_if_t *ifp;
@@ -1404,7 +1402,7 @@ static int dhd_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
 }
 #endif				/* TOE */
 
-static void dhd_ethtool_get_drvinfo(struct net_device *net,
+static void brcmf_ethtool_get_drvinfo(struct net_device *net,
 				    struct ethtool_drvinfo *info)
 {
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
@@ -1415,11 +1413,11 @@ static void dhd_ethtool_get_drvinfo(struct net_device *net,
 	sprintf(info->bus_info, "%s", dev_name(&wl_cfg80211_get_sdio_func()->dev));
 }
 
-struct ethtool_ops dhd_ethtool_ops = {
-	.get_drvinfo = dhd_ethtool_get_drvinfo
+struct ethtool_ops brcmf_ethtool_ops = {
+	.get_drvinfo = brcmf_ethtool_get_drvinfo
 };
 
-static int dhd_ethtool(dhd_info_t *dhd, void *uaddr)
+static int brcmf_ethtool(dhd_info_t *dhd, void *uaddr)
 {
 	struct ethtool_drvinfo info;
 	char drvname[sizeof(info.driver)];
@@ -1534,7 +1532,8 @@ static int dhd_ethtool(dhd_info_t *dhd, void *uaddr)
 	return 0;
 }
 
-static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
+static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
+				    int cmd)
 {
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
 	dhd_ioctl_t ioc;
@@ -1552,7 +1551,7 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 		return -1;
 
 	if (cmd == SIOCETHTOOL)
-		return dhd_ethtool(dhd, (void *)ifr->ifr_data);
+		return brcmf_ethtool(dhd, (void *)ifr->ifr_data);
 
 	if (cmd != SIOCDEVPRIVATE)
 		return -EOPNOTSUPP;
@@ -1629,7 +1628,7 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 			  ((ioc.cmd == BRCMF_C_SET_VAR) &&
 			   !(strncmp("bsscfg:wsec_key", ioc.buf, 15))));
 	if (is_set_key_cmd)
-		dhd_wait_pend8021x(net);
+		brcmf_netdev_wait_pend8021x(net);
 
 	bcmerror =
 	    brcmf_proto_ioctl(&dhd->pub, ifidx, (wl_ioctl_t *)&ioc, buf,
@@ -1649,7 +1648,7 @@ done:
 	return bcmerror;
 }
 
-static int dhd_stop(struct net_device *net)
+static int brcmf_netdev_stop(struct net_device *net)
 {
 #if !defined(IGNORE_ETH0_DOWN)
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
@@ -1670,7 +1669,7 @@ static int dhd_stop(struct net_device *net)
 	return 0;
 }
 
-static int dhd_open(struct net_device *net)
+static int brcmf_netdev_open(struct net_device *net)
 {
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
 #ifdef TOE
@@ -2059,13 +2058,13 @@ dhd_iovar(dhd_pub_t *pub, int ifidx, char *name, char *cmd_buf, uint cmd_len,
 }
 
 static struct net_device_ops dhd_ops_pri = {
-	.ndo_open = dhd_open,
-	.ndo_stop = dhd_stop,
-	.ndo_get_stats = dhd_get_stats,
-	.ndo_do_ioctl = dhd_ioctl_entry,
-	.ndo_start_xmit = dhd_start_xmit,
-	.ndo_set_mac_address = dhd_set_mac_address,
-	.ndo_set_multicast_list = dhd_set_multicast_list
+	.ndo_open = brcmf_netdev_open,
+	.ndo_stop = brcmf_netdev_stop,
+	.ndo_get_stats = brcmf_netdev_get_stats,
+	.ndo_do_ioctl = brcmf_netdev_ioctl_entry,
+	.ndo_start_xmit = brcmf_netdev_start_xmit,
+	.ndo_set_mac_address = brcmf_netdev_set_mac_address,
+	.ndo_set_multicast_list = brcmf_netdev_set_multicast_list
 };
 
 int brcmf_net_attach(dhd_pub_t *dhdp, int ifidx)
@@ -2102,7 +2101,7 @@ int brcmf_net_attach(dhd_pub_t *dhdp, int ifidx)
 
 	}
 	net->hard_header_len = ETH_HLEN + dhd->pub.hdrlen;
-	net->ethtool_ops = &dhd_ethtool_ops;
+	net->ethtool_ops = &brcmf_ethtool_ops;
 
 	dhd->pub.rxsz = net->mtu + net->hard_header_len + dhd->pub.hdrlen;
 
@@ -2172,7 +2171,7 @@ void brcmf_detach(dhd_pub_t *dhdp)
 			ifp = dhd->iflist[0];
 			ASSERT(ifp);
 			if (ifp->net->netdev_ops == &dhd_ops_pri) {
-				dhd_stop(ifp->net);
+				brcmf_netdev_stop(ifp->net);
 				unregister_netdev(ifp->net);
 			}
 
@@ -2506,7 +2505,7 @@ void brcmf_wait_event_wakeup(dhd_pub_t *dhd)
 	return;
 }
 
-int dhd_dev_reset(struct net_device *dev, u8 flag)
+int brcmf_netdev_reset(struct net_device *dev, u8 flag)
 {
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
 
@@ -2524,7 +2523,7 @@ int dhd_dev_reset(struct net_device *dev, u8 flag)
 	return 1;
 }
 
-int net_os_set_suspend_disable(struct net_device *dev, int val)
+int brcmf_netdev_set_suspend_disable(struct net_device *dev, int val)
 {
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
 	int ret = 0;
@@ -2536,7 +2535,7 @@ int net_os_set_suspend_disable(struct net_device *dev, int val)
 	return ret;
 }
 
-int net_os_set_suspend(struct net_device *dev, int val)
+int brcmf_netdev_set_suspend(struct net_device *dev, int val)
 {
 	int ret = 0;
 #if defined(CONFIG_HAS_EARLYSUSPEND)
@@ -2551,7 +2550,7 @@ int net_os_set_suspend(struct net_device *dev, int val)
 	return ret;
 }
 
-int net_os_set_dtim_skip(struct net_device *dev, int val)
+int brcmf_netdev_set_dtim_skip(struct net_device *dev, int val)
 {
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(dev);
 
@@ -2561,7 +2560,7 @@ int net_os_set_dtim_skip(struct net_device *dev, int val)
 	return 0;
 }
 
-int net_os_set_packet_filter(struct net_device *dev, int val)
+int brcmf_netdev_set_packet_filter(struct net_device *dev, int val)
 {
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(dev);
 	int ret = 0;
@@ -2582,7 +2581,7 @@ int net_os_set_packet_filter(struct net_device *dev, int val)
 	return ret;
 }
 
-void dhd_dev_init_ioctl(struct net_device *dev)
+void brcmf_netdev_init_ioctl(struct net_device *dev)
 {
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
 
@@ -2591,7 +2590,7 @@ void dhd_dev_init_ioctl(struct net_device *dev)
 
 #ifdef PNO_SUPPORT
 /* Linux wrapper to call common dhd_pno_clean */
-int dhd_dev_pno_reset(struct net_device *dev)
+int brcmf_netdev_pno_reset(struct net_device *dev)
 {
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
 
@@ -2599,7 +2598,7 @@ int dhd_dev_pno_reset(struct net_device *dev)
 }
 
 /* Linux wrapper to call common dhd_pno_enable */
-int dhd_dev_pno_enable(struct net_device *dev, int pfn_enabled)
+int brcmf_netdev_pno_enable(struct net_device *dev, int pfn_enabled)
 {
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
 
@@ -2608,7 +2607,7 @@ int dhd_dev_pno_enable(struct net_device *dev, int pfn_enabled)
 
 /* Linux wrapper to call common dhd_pno_set */
 int
-dhd_dev_pno_set(struct net_device *dev, wlc_ssid_t *ssids_local, int nssid,
+brcmf_netdev_pno_set(struct net_device *dev, wlc_ssid_t *ssids_local, int nssid,
 		unsigned char scan_fr)
 {
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
@@ -2617,7 +2616,7 @@ dhd_dev_pno_set(struct net_device *dev, wlc_ssid_t *ssids_local, int nssid,
 }
 
 /* Linux wrapper to get  pno status */
-int dhd_dev_get_pno_status(struct net_device *dev)
+int brcmf_netdev_get_pno_status(struct net_device *dev)
 {
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
 
@@ -2633,7 +2632,7 @@ static int dhd_get_pend_8021x_cnt(dhd_info_t *dhd)
 
 #define MAX_WAIT_FOR_8021X_TX	10
 
-int dhd_wait_pend8021x(struct net_device *dev)
+int brcmf_netdev_wait_pend8021x(struct net_device *dev)
 {
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
 	int timeout = 10 * HZ / 1000;
@@ -2652,7 +2651,7 @@ int dhd_wait_pend8021x(struct net_device *dev)
 	return pend;
 }
 
-void wl_os_wd_timer(struct net_device *ndev, uint wdtick)
+void brcmf_netdev_os_wd_timer(struct net_device *ndev, uint wdtick)
 {
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(ndev);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index dd47451..ca45829 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -342,7 +342,6 @@ do {									\
 	}								\
 } while (0)
 
-extern int dhd_wait_pend8021x(struct net_device *dev);
 #define CHAN2G(_channel, _freq, _flags) {			\
 	.band			= IEEE80211_BAND_2GHZ,		\
 	.center_freq		= (_freq),			\
@@ -1677,7 +1676,7 @@ wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 		}
 		swap_key_from_BE(&key);
 
-		dhd_wait_pend8021x(dev);
+		brcmf_netdev_wait_pend8021x(dev);
 		err = wl_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
 		if (unlikely(err)) {
 			WL_ERR("WLC_SET_KEY error (%d)\n", err);
@@ -2101,7 +2100,7 @@ static s32 wl_cfg80211_resume(struct wiphy *wiphy)
 
 	if (test_bit(WL_STATUS_READY, &wl->status)) {
 		/* Turn on Watchdog timer */
-		wl_os_wd_timer(ndev, brcmf_watchdog_ms);
+		brcmf_netdev_os_wd_timer(ndev, brcmf_watchdog_ms);
 		wl_invoke_iscan(wiphy_to_wl(wiphy));
 	}
 
@@ -2163,7 +2162,7 @@ static s32 wl_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
 	if (test_bit(WL_STATUS_READY, &wl->status)) {
 		WL_INFO("Terminate watchdog timer and enable MPC\n");
 		wl_set_mpc(ndev, 1);
-		wl_os_wd_timer(ndev, 0);
+		brcmf_netdev_os_wd_timer(ndev, 0);
 	}
 
 #if defined(CONFIG_PM_SLEEP)
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 77d0559..6ad6b5b 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -404,6 +404,6 @@ extern s8 *wl_cfg80211_get_fwname(void);	/* get firmware name for
 						 the dongle */
 extern s8 *wl_cfg80211_get_nvramname(void);	/* get nvram name for
 						 the dongle */
-extern void wl_os_wd_timer(struct net_device *ndev, uint wdtick);
+extern void brcmf_netdev_os_wd_timer(struct net_device *ndev, uint wdtick);
 
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.1



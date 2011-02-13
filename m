Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64088 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab1BMOlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 09:41:08 -0500
Received: by mail-bw0-f46.google.com with SMTP id 15so4702340bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 06:41:07 -0800 (PST)
From: Stanislav Fomichev <kernel@fomichev.me>
To: linux-wireless@vger.kernel.org
Cc: brudley@broadcom.com, gregkh@suse.de
Subject: [PATCH 8/8] brcm80211: replace ether_addr with u8[ETH_ALEN]
Date: Sun, 13 Feb 2011 17:40:43 +0300
Message-Id: <1297608043-18381-8-git-send-email-kernel@fomichev.me>
In-Reply-To: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
References: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed proto/ethernet.h as a side effect.

Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h           |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   50 +++++++++---------
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |    5 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   16 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   56 +++++++++----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    3 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |   49 ++++++++---------
 drivers/staging/brcm80211/brcmfmac/wl_iw.h         |    3 +-
 drivers/staging/brcm80211/include/bcmcdc.h         |    4 +-
 drivers/staging/brcm80211/include/bcmutils.h       |    6 +-
 drivers/staging/brcm80211/include/proto/bcmevent.h |    2 +-
 drivers/staging/brcm80211/include/proto/ethernet.h |   36 -------------
 drivers/staging/brcm80211/include/proto/wpa.h      |    2 -
 drivers/staging/brcm80211/include/wlioctl.h        |   23 ++++----
 drivers/staging/brcm80211/sys/wl_mac80211.c        |    4 +-
 drivers/staging/brcm80211/sys/wlc_alloc.c          |   14 -----
 drivers/staging/brcm80211/sys/wlc_ampdu.c          |    2 +-
 drivers/staging/brcm80211/sys/wlc_bmac.c           |   38 ++++++-------
 drivers/staging/brcm80211/sys/wlc_bmac.h           |   10 ++--
 drivers/staging/brcm80211/sys/wlc_bsscfg.h         |    8 +--
 drivers/staging/brcm80211/sys/wlc_key.h            |    2 +-
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |   38 ++++++-------
 drivers/staging/brcm80211/sys/wlc_mac80211.h       |   11 ++--
 drivers/staging/brcm80211/sys/wlc_pub.h            |   14 +----
 drivers/staging/brcm80211/sys/wlc_scb.h            |    1 -
 drivers/staging/brcm80211/util/bcmsrom.c           |   18 +++----
 drivers/staging/brcm80211/util/bcmutils.c          |    6 +-
 29 files changed, 170 insertions(+), 256 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/include/proto/ethernet.h

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 69c6a02..79c17cc 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -95,7 +95,7 @@ typedef struct dhd_pub {
 	/* Dongle media info */
 	bool iswl;		/* Dongle-resident driver is wl */
 	unsigned long drv_version;	/* Version of dongle-resident driver */
-	struct ether_addr mac;	/* MAC address obtained from dongle */
+	u8 mac[ETH_ALEN];	/* MAC address obtained from dongle */
 	dngl_stats_t dstats;	/* Stats for dongle-based data */
 
 	/* Additional stats for the bus level */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 9dabd67..cc7bf2c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -477,7 +477,7 @@ int dhd_prot_init(dhd_pub_t *dhd)
 		dhd_os_proto_unblock(dhd);
 		return ret;
 	}
-	memcpy(dhd->mac.octet, buf, ETH_ALEN);
+	memcpy(dhd->mac, buf, ETH_ALEN);
 
 	dhd_os_proto_unblock(dhd);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 077ccc7..8a9383a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -157,7 +157,7 @@ static int dhd_dump(dhd_pub_t *dhdp, char *buf, int buflen)
 	bcm_bprintf(strbuf, "pub.hdrlen %d pub.maxctl %d pub.rxsz %d\n",
 		    dhdp->hdrlen, dhdp->maxctl, dhdp->rxsz);
 	bcm_bprintf(strbuf, "pub.iswl %d pub.drv_version %ld pub.mac %pM\n",
-		    dhdp->iswl, dhdp->drv_version, &dhdp->mac);
+		    dhdp->iswl, dhdp->drv_version, dhdp->mac);
 	bcm_bprintf(strbuf, "pub.bcmerror %d tickcnt %d\n", dhdp->bcmerror,
 		    dhdp->tickcnt);
 
@@ -1242,7 +1242,7 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 	int scan_unassoc_time = 40;
 #ifdef GET_CUSTOM_MAC_ENABLE
 	int ret = 0;
-	struct ether_addr ea_addr;
+	u8 ea_addr[ETH_ALEN];
 #endif				/* GET_CUSTOM_MAC_ENABLE */
 
 	dhd_os_proto_block(dhd);
@@ -1254,16 +1254,16 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 	 ** firmware but unique per board mac address maybe provided by
 	 ** customer code
 	 */
-	ret = dhd_custom_get_mac_address(ea_addr.octet);
+	ret = dhd_custom_get_mac_address(ea_addr);
 	if (!ret) {
-		bcm_mkiovar("cur_etheraddr", (void *)&ea_addr, ETH_ALEN,
+		bcm_mkiovar("cur_etheraddr", ea_addr, ETH_ALEN,
 			    buf, sizeof(buf));
 		ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, buf, sizeof(buf));
 		if (ret < 0) {
 			DHD_ERROR(("%s: can't set MAC address , error=%d\n",
 				   __func__, ret));
 		} else
-			memcpy(dhd->mac.octet, &ea_addr, ETH_ALEN);
+			memcpy(dhd->mac, ea_addr, ETH_ALEN);
 	}
 #endif				/* GET_CUSTOM_MAC_ENABLE */
 
@@ -1473,9 +1473,9 @@ int dhd_iscan_print_cache(iscan_buf_t *iscan_skip)
 
 			DHD_ISCAN(("%s[%2.2d:%2.2d] %X:%X:%X:%X:%X:%X\n",
 				   iscan_cur != iscan_skip ? "BSS" : "bss", l,
-				   i, bi->BSSID.octet[0], bi->BSSID.octet[1],
-				   bi->BSSID.octet[2], bi->BSSID.octet[3],
-				   bi->BSSID.octet[4], bi->BSSID.octet[5]));
+				   i, bi->BSSID[0], bi->BSSID[1],
+				   bi->BSSID[2], bi->BSSID[3],
+				   bi->BSSID[4], bi->BSSID[5]));
 
 			bi = (wl_bss_info_t *)((unsigned long)bi +
 						dtoh32(bi->length));
@@ -1533,13 +1533,13 @@ int dhd_iscan_delete_bss(void *dhdp, void *addr, iscan_buf_t *iscan_skip)
 					break;
 
 				if (!memcmp
-				    (bi->BSSID.octet, addr, ETH_ALEN)) {
+				    (bi->BSSID, addr, ETH_ALEN)) {
 					DHD_ISCAN(("%s: Del BSS[%2.2d:%2.2d] "
 					"%X:%X:%X:%X:%X:%X\n",
-					__func__, l, i, bi->BSSID.octet[0],
-					bi->BSSID.octet[1], bi->BSSID.octet[2],
-					bi->BSSID.octet[3], bi->BSSID.octet[4],
-					bi->BSSID.octet[5]));
+					__func__, l, i, bi->BSSID[0],
+					bi->BSSID[1], bi->BSSID[2],
+					bi->BSSID[3], bi->BSSID[4],
+					bi->BSSID[5]));
 
 					bi_new = bi;
 					bi = (wl_bss_info_t *)((unsigned long)bi +
@@ -1560,12 +1560,12 @@ int dhd_iscan_delete_bss(void *dhdp, void *addr, iscan_buf_t *iscan_skip)
 						if (bi && bi_new) {
 							DHD_ISCAN(("%s: Moved up BSS[%2.2d:%2.2d]" "%X:%X:%X:%X:%X:%X\n",
 							__func__, l, j,
-							bi->BSSID.octet[0],
-							bi->BSSID.octet[1],
-							bi->BSSID.octet[2],
-							bi->BSSID.octet[3],
-							bi->BSSID.octet[4],
-							bi->BSSID.octet[5]));
+							bi->BSSID[0],
+							bi->BSSID[1],
+							bi->BSSID[2],
+							bi->BSSID[3],
+							bi->BSSID[4],
+							bi->BSSID[5]));
 
 							bi_next =
 							    (wl_bss_info_t *)((unsigned long)bi +
@@ -1641,12 +1641,12 @@ int dhd_iscan_remove_duplicates(void *dhdp, iscan_buf_t *iscan_cur)
 			break;
 
 		DHD_ISCAN(("%s: Find dups for BSS[%2.2d] %X:%X:%X:%X:%X:%X\n",
-			   __func__, i, bi->BSSID.octet[0],
-			   bi->BSSID.octet[1], bi->BSSID.octet[2],
-			   bi->BSSID.octet[3], bi->BSSID.octet[4],
-			   bi->BSSID.octet[5]));
+			   __func__, i, bi->BSSID[0],
+			   bi->BSSID[1], bi->BSSID[2],
+			   bi->BSSID[3], bi->BSSID[4],
+			   bi->BSSID[5]));
 
-		dhd_iscan_delete_bss(dhdp, bi->BSSID.octet, iscan_cur);
+		dhd_iscan_delete_bss(dhdp, bi->BSSID, iscan_cur);
 
 		bi = (wl_bss_info_t *)((unsigned long)bi + dtoh32(bi->length));
 	}
@@ -1672,7 +1672,7 @@ int dhd_iscan_request(void *dhdp, u16 action)
 	char buf[WLC_IOCTL_SMLEN];
 
 	memset(&params, 0, sizeof(wl_iscan_params_t));
-	memcpy(&params.params.bssid, &ether_bcast, ETH_ALEN);
+	memset(params.params.bssid, 255, ETH_ALEN);
 
 	params.params.bss_type = DOT11_BSSTYPE_ANY;
 	params.params.scan_type = DOT11_SCANTYPE_ACTIVE;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
index 06e2e85..b5d84bb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
@@ -149,9 +149,8 @@ int dhd_custom_get_mac_address(unsigned char *buf)
 #ifdef EXAMPLE_GET_MAC
 	/* EXAMPLE code */
 	{
-		struct ether_addr ea_example = {
-			{0x00, 0x11, 0x22, 0x33, 0x44, 0xFF} };
-		memcpy(buf, &ea_example, sizeof(struct ether_addr));
+		u8 ea_example[ETH_ALEN] = {0x00, 0x11, 0x22, 0x33, 0x44, 0xFF};
+		memcpy(buf, ea_example, sizeof(ea_example));
 	}
 #endif				/* EXAMPLE_GET_MAC */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index a3db566..1ce08d9 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -36,7 +36,6 @@
 #include <bcmutils.h>
 #include <bcmendian.h>
 
-#include <proto/ethernet.h>
 #include <dngl_stats.h>
 #include <dhd.h>
 #include <dhd_bus.h>
@@ -46,6 +45,7 @@
 #include <wl_cfg80211.h>
 
 #define EPI_VERSION_STR         "4.218.248.5"
+#define ETHER_TYPE_BRCM		0x886c
 
 #if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC)
 #include <linux/wifi_tiwlan.h>
@@ -247,7 +247,7 @@ typedef struct dhd_info {
 	struct semaphore sysioc_sem;
 	bool set_multicast;
 	bool set_macaddress;
-	struct ether_addr macvalue;
+	u8 macvalue[ETH_ALEN];
 	wait_queue_head_t ctrl_wait;
 	atomic_t pend_8021x_cnt;
 
@@ -803,7 +803,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 }
 
 static int
-_dhd_set_mac_address(dhd_info_t *dhd, int ifidx, struct ether_addr *addr)
+_dhd_set_mac_address(dhd_info_t *dhd, int ifidx, u8 addr[ETH_ALEN])
 {
 	char buf[32];
 	wl_ioctl_t ioc;
@@ -811,7 +811,7 @@ _dhd_set_mac_address(dhd_info_t *dhd, int ifidx, struct ether_addr *addr)
 
 	DHD_TRACE(("%s enter\n", __func__));
 	if (!bcm_mkiovar
-	    ("cur_etheraddr", (char *)addr, ETH_ALEN, buf, 32)) {
+	    ("cur_etheraddr", addr, ETH_ALEN, buf, 32)) {
 		DHD_ERROR(("%s: mkiovar failed for cur_etheraddr\n",
 			   dhd_ifname(&dhd->pub, ifidx)));
 		return -1;
@@ -976,7 +976,7 @@ static int _dhd_sysioc_thread(void *data)
 				if (dhd->set_macaddress) {
 					dhd->set_macaddress = false;
 					_dhd_set_mac_address(dhd, i,
-							     &dhd->macvalue);
+							     dhd->macvalue);
 				}
 			}
 		}
@@ -997,7 +997,7 @@ static int dhd_set_mac_address(struct net_device *dev, void *addr)
 		return -1;
 
 	ASSERT(dhd->sysioc_tsk);
-	memcpy(&dhd->macvalue, sa->sa_data, ETH_ALEN);
+	memcpy(dhd->macvalue, sa->sa_data, ETH_ALEN);
 	dhd->set_macaddress = true;
 	up(&dhd->sysioc_sem);
 
@@ -1866,7 +1866,7 @@ static int dhd_open(struct net_device *net)
 		}
 		atomic_set(&dhd->pend_8021x_cnt, 0);
 
-		memcpy(net->dev_addr, dhd->pub.mac.octet, ETH_ALEN);
+		memcpy(net->dev_addr, dhd->pub.mac, ETH_ALEN);
 
 #ifdef TOE
 		/* Get current TOE mode from dongle */
@@ -2299,7 +2299,7 @@ int dhd_net_attach(dhd_pub_t *dhdp, int ifidx)
 	 */
 	if (ifidx != 0) {
 		/* for virtual interfaces use the primary MAC  */
-		memcpy(temp_addr, dhd->pub.mac.octet, ETH_ALEN);
+		memcpy(temp_addr, dhd->pub.mac, ETH_ALEN);
 
 	}
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 11680ee..13cd15c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -44,7 +44,6 @@
 #include <sbsdpcmdev.h>
 #include <bcmsdpcm.h>
 
-#include <proto/ethernet.h>
 #include <proto/802.1d.h>
 #include <proto/802.11.h>
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 6f7277d..b4384f0 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -20,7 +20,6 @@
 
 #include <bcmutils.h>
 #include <bcmendian.h>
-#include <proto/ethernet.h>
 
 #include <asm/uaccess.h>
 
@@ -648,7 +647,7 @@ wl_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 
 static void wl_iscan_prep(struct wl_scan_params *params, struct wlc_ssid *ssid)
 {
-	memcpy(&params->bssid, &ether_bcast, ETH_ALEN);
+	memset(params->bssid, 255, ETH_ALEN);
 	params->bss_type = DOT11_BSSTYPE_ANY;
 	params->scan_type = 0;
 	params->nprobes = -1;
@@ -1042,9 +1041,9 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(join_params.ssid.SSID, params->ssid, params->ssid_len);
 	join_params.ssid.SSID_len = htod32(params->ssid_len);
 	if (params->bssid)
-		memcpy(&join_params.params.bssid, params->bssid, ETH_ALEN);
+		memcpy(join_params.params.bssid, params->bssid, ETH_ALEN);
 	else
-		memset(&join_params.params.bssid, 0, ETH_ALEN);
+		memset(join_params.params.bssid, 0, ETH_ALEN);
 
 	err = wl_dev_ioctl(dev, WLC_SET_SSID, &join_params,
 			sizeof(join_params));
@@ -1371,7 +1370,7 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(&join_params.ssid.SSID, sme->ssid, join_params.ssid.SSID_len);
 	join_params.ssid.SSID_len = htod32(join_params.ssid.SSID_len);
 	wl_update_prof(wl, NULL, &join_params.ssid, WL_PROF_SSID);
-	memcpy(&join_params.params.bssid, &ether_bcast, ETH_ALEN);
+	memset(join_params.params.bssid, 255, ETH_ALEN);
 
 	wl_ch_to_chanspec(wl->channel, &join_params, &join_params_size);
 	WL_DBG("join_param_size %d\n", join_params_size);
@@ -1404,7 +1403,7 @@ wl_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	act = *(bool *) wl_read_prof(wl, WL_PROF_ACT);
 	if (likely(act)) {
 		scbval.val = reason_code;
-		memcpy(&scbval.ea, &wl->bssid, ETH_ALEN);
+		memcpy(scbval.ea, wl->bssid, ETH_ALEN);
 		scbval.val = htod32(scbval.val);
 		err = wl_dev_ioctl(dev, WLC_DISASSOC, &scbval,
 				sizeof(scb_val_t));
@@ -1531,7 +1530,7 @@ wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 	/* Instead of bcast for ea address for default wep keys,
 		 driver needs it to be Null */
 	if (!is_multicast_ether_addr(mac_addr))
-		memcpy(&key.ea, mac_addr, ETH_ALEN);
+		memcpy(key.ea, mac_addr, ETH_ALEN);
 	key.len = (u32) params->key_len;
 	/* check for key index change */
 	if (key.len == 0) {
@@ -2003,7 +2002,7 @@ wl_update_pmklist(struct net_device *dev, struct wl_pmk_list *pmk_list,
 	WL_DBG("No of elements %d\n", pmk_list->pmkids.npmkid);
 	for (i = 0; i < pmk_list->pmkids.npmkid; i++) {
 		WL_DBG("PMKID[%d]: %pM =\n", i,
-		       &pmk_list->pmkids.pmkid[i].BSSID);
+		       pmk_list->pmkids.pmkid[i].BSSID);
 		for (j = 0; j < WPA2_PMKID_LEN; j++) {
 			WL_DBG("%02x\n", pmk_list->pmkids.pmkid[i].PMKID[j]);
 		}
@@ -2026,11 +2025,11 @@ wl_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
 
 	CHECK_SYS_UP();
 	for (i = 0; i < wl->pmk_list->pmkids.npmkid; i++)
-		if (!memcmp(pmksa->bssid, &wl->pmk_list->pmkids.pmkid[i].BSSID,
+		if (!memcmp(pmksa->bssid, wl->pmk_list->pmkids.pmkid[i].BSSID,
 			    ETH_ALEN))
 			break;
 	if (i < WL_NUM_PMKIDS_MAX) {
-		memcpy(&wl->pmk_list->pmkids.pmkid[i].BSSID, pmksa->bssid,
+		memcpy(wl->pmk_list->pmkids.pmkid[i].BSSID, pmksa->bssid,
 		       ETH_ALEN);
 		memcpy(&wl->pmk_list->pmkids.pmkid[i].PMKID, pmksa->pmkid,
 		       WPA2_PMKID_LEN);
@@ -2040,7 +2039,7 @@ wl_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
 		err = -EINVAL;
 	}
 	WL_DBG("set_pmksa,IW_PMKSA_ADD - PMKID: %pM =\n",
-	       &wl->pmk_list->pmkids.pmkid[wl->pmk_list->pmkids.npmkid].BSSID);
+	       wl->pmk_list->pmkids.pmkid[wl->pmk_list->pmkids.npmkid].BSSID);
 	for (i = 0; i < WPA2_PMKID_LEN; i++) {
 		WL_DBG("%02x\n",
 		       wl->pmk_list->pmkids.pmkid[wl->pmk_list->pmkids.npmkid].
@@ -2062,18 +2061,18 @@ wl_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 	int i;
 
 	CHECK_SYS_UP();
-	memcpy(&pmkid.pmkid[0].BSSID, pmksa->bssid, ETH_ALEN);
+	memcpy(pmkid.pmkid[0].BSSID, pmksa->bssid, ETH_ALEN);
 	memcpy(&pmkid.pmkid[0].PMKID, pmksa->pmkid, WPA2_PMKID_LEN);
 
 	WL_DBG("del_pmksa,IW_PMKSA_REMOVE - PMKID: %pM =\n",
-	       &pmkid.pmkid[0].BSSID);
+	       pmkid.pmkid[0].BSSID);
 	for (i = 0; i < WPA2_PMKID_LEN; i++) {
 		WL_DBG("%02x\n", pmkid.pmkid[0].PMKID[i]);
 	}
 
 	for (i = 0; i < wl->pmk_list->pmkids.npmkid; i++)
 		if (!memcmp
-		    (pmksa->bssid, &wl->pmk_list->pmkids.pmkid[i].BSSID,
+		    (pmksa->bssid, wl->pmk_list->pmkids.pmkid[i].BSSID,
 		     ETH_ALEN))
 			break;
 
@@ -2081,8 +2080,8 @@ wl_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 	    && (i < wl->pmk_list->pmkids.npmkid)) {
 		memset(&wl->pmk_list->pmkids.pmkid[i], 0, sizeof(pmkid_t));
 		for (; i < (wl->pmk_list->pmkids.npmkid - 1); i++) {
-			memcpy(&wl->pmk_list->pmkids.pmkid[i].BSSID,
-			       &wl->pmk_list->pmkids.pmkid[i + 1].BSSID,
+			memcpy(wl->pmk_list->pmkids.pmkid[i].BSSID,
+			       wl->pmk_list->pmkids.pmkid[i + 1].BSSID,
 			       ETH_ALEN);
 			memcpy(&wl->pmk_list->pmkids.pmkid[i].PMKID,
 			       &wl->pmk_list->pmkids.pmkid[i + 1].PMKID,
@@ -2282,7 +2281,7 @@ static s32 wl_inform_single_bss(struct wl_priv *wl, struct wl_bss_info *bi)
 	else
 		band = wiphy->bands[IEEE80211_BAND_5GHZ];
 	notif_bss_info->rssi = bi->RSSI;
-	memcpy(mgmt->bssid, &bi->BSSID, ETH_ALEN);
+	memcpy(mgmt->bssid, bi->BSSID, ETH_ALEN);
 	mgmt_type = wl->active_scan ?
 		IEEE80211_STYPE_PROBE_RESP : IEEE80211_STYPE_BEACON;
 	if (!memcmp(bi->SSID, sr->ssid.SSID, bi->SSID_len)) {
@@ -2317,7 +2316,7 @@ static s32 wl_inform_single_bss(struct wl_priv *wl, struct wl_bss_info *bi)
 	WL_DBG("SSID : \"%s\", rssi %d, channel %d, capability : 0x04%x, bssid %pM\n",
 	       bi->SSID,
 	       notif_bss_info->rssi, notif_bss_info->channel,
-	       mgmt->u.beacon.capab_info, &bi->BSSID);
+	       mgmt->u.beacon.capab_info, bi->BSSID);
 
 	signal = notif_bss_info->rssi * 100;
 	if (unlikely(!cfg80211_inform_bss_frame(wiphy, channel, mgmt,
@@ -2390,8 +2389,7 @@ wl_notify_connect_status(struct wl_priv *wl, struct net_device *ndev,
 	if (wl_is_linkup(wl, e)) {
 		wl_link_up(wl);
 		if (wl_is_ibssmode(wl)) {
-			cfg80211_ibss_joined(ndev, (s8 *)&e->addr,
-					     GFP_KERNEL);
+			cfg80211_ibss_joined(ndev, e->addr, GFP_KERNEL);
 			WL_DBG("joined in IBSS network\n");
 		} else {
 			wl_bss_connect_done(wl, ndev, e, data, true);
@@ -2562,7 +2560,7 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 
 	ssid = (struct wlc_ssid *)wl_read_prof(wl, WL_PROF_SSID);
 	bss =
-	    cfg80211_get_bss(wl_to_wiphy(wl), NULL, (s8 *)&wl->bssid,
+	    cfg80211_get_bss(wl_to_wiphy(wl), NULL, wl->bssid,
 			     ssid->SSID, ssid->SSID_len, WLAN_CAPABILITY_ESS,
 			     WLAN_CAPABILITY_ESS);
 
@@ -2577,7 +2575,7 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 			goto update_bss_info_out;
 		}
 		bi = (struct wl_bss_info *)(wl->extra_buf + 4);
-		if (unlikely(memcmp(&bi->BSSID, &wl->bssid, ETH_ALEN))) {
+		if (unlikely(memcmp(bi->BSSID, wl->bssid, ETH_ALEN))) {
 			err = -EIO;
 			goto update_bss_info_out;
 		}
@@ -2629,10 +2627,10 @@ wl_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
 	s32 err = 0;
 
 	wl_get_assoc_ies(wl);
-	memcpy(&wl->bssid, &e->addr, ETH_ALEN);
+	memcpy(wl->bssid, e->addr, ETH_ALEN);
 	wl_update_bss_info(wl);
 	cfg80211_roamed(ndev,
-			(u8 *)&wl->bssid,
+			wl->bssid,
 			conn_info->req_ie, conn_info->req_ie_len,
 			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
 	WL_DBG("Report roaming result\n");
@@ -2650,11 +2648,11 @@ wl_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
 	s32 err = 0;
 
 	wl_get_assoc_ies(wl);
-	memcpy(&wl->bssid, &e->addr, ETH_ALEN);
+	memcpy(wl->bssid, e->addr, ETH_ALEN);
 	wl_update_bss_info(wl);
 	if (test_and_clear_bit(WL_STATUS_CONNECTING, &wl->status)) {
 		cfg80211_connect_result(ndev,
-					(u8 *)&wl->bssid,
+					wl->bssid,
 					conn_info->req_ie,
 					conn_info->req_ie_len,
 					conn_info->resp_ie,
@@ -2665,7 +2663,7 @@ wl_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
 		       completed ? "succeeded" : "failed");
 	} else {
 		cfg80211_roamed(ndev,
-				(u8 *)&wl->bssid,
+				wl->bssid,
 				conn_info->req_ie, conn_info->req_ie_len,
 				conn_info->resp_ie, conn_info->resp_ie_len,
 				GFP_KERNEL);
@@ -2689,7 +2687,7 @@ wl_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
 	else
 		key_type = NL80211_KEYTYPE_PAIRWISE;
 
-	cfg80211_michael_mic_failure(ndev, (u8 *)&e->addr, key_type, -1,
+	cfg80211_michael_mic_failure(ndev, e->addr, key_type, -1,
 				     NULL, GFP_KERNEL);
 	rtnl_unlock();
 
@@ -3899,7 +3897,7 @@ static void *wl_read_prof(struct wl_priv *wl, s32 item)
 	case WL_PROF_ACT:
 		return &wl->profile->active;
 	case WL_PROF_BSSID:
-		return &wl->profile->bssid;
+		return wl->profile->bssid;
 	case WL_PROF_SSID:
 		return &wl->profile->ssid;
 	}
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 482691b..b7e2e59 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -20,7 +20,6 @@
 #include <linux/wireless.h>
 #include <linux/wireless.h>
 #include <net/cfg80211.h>
-#include <proto/ethernet.h>
 #include <wlioctl.h>
 
 struct wl_conf;
@@ -316,7 +315,7 @@ struct wl_priv {
 						 cfg80211 layer */
 	struct wl_ie ie;	/* information element object for
 					 internal purpose */
-	struct ether_addr bssid;	/* bssid of currently engaged network */
+	u8 bssid[ETH_ALEN];	/* bssid of currently engaged network */
 	struct semaphore event_sync;	/* for synchronization of main event
 					 thread */
 	struct wl_profile *profile;	/* holding dongle profile */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index fbee070..1932bd9 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -23,7 +23,6 @@
 
 #include <bcmutils.h>
 #include <bcmendian.h>
-#include <proto/ethernet.h>
 
 #include <linux/if_arp.h>
 #include <asm/uaccess.h>
@@ -35,7 +34,6 @@
 typedef const struct si_pub si_t;
 #include <wlioctl.h>
 
-#include <proto/ethernet.h>
 #include <dngl_stats.h>
 #include <dhd.h>
 
@@ -688,9 +686,9 @@ wl_iw_set_spy(struct net_device *dev,
 	if (!extra)
 		return -EINVAL;
 
-	iw->spy_num = min_t(int, ARRAY_SIZE(iw->spy_addr), dwrq->length);
+	iw->spy_num = min_t(int, IW_MAX_SPY, dwrq->length);
 	for (i = 0; i < iw->spy_num; i++)
-		memcpy(&iw->spy_addr[i], addr[i].sa_data, ETH_ALEN);
+		memcpy(iw->spy_addr[i], addr[i].sa_data, ETH_ALEN);
 	memset(iw->spy_qual, 0, sizeof(iw->spy_qual));
 
 	return 0;
@@ -712,7 +710,7 @@ wl_iw_get_spy(struct net_device *dev,
 
 	dwrq->length = iw->spy_num;
 	for (i = 0; i < iw->spy_num; i++) {
-		memcpy(addr[i].sa_data, &iw->spy_addr[i], ETH_ALEN);
+		memcpy(addr[i].sa_data, iw->spy_addr[i], ETH_ALEN);
 		addr[i].sa_family = AF_UNIX;
 		memcpy(&qual[i], &iw->spy_qual[i], sizeof(struct iw_quality));
 		iw->spy_qual[i].updated = 0;
@@ -785,7 +783,7 @@ wl_iw_set_wap(struct net_device *dev,
 
 	memcpy(join_params.ssid.SSID, g_ssid.SSID, g_ssid.SSID_len);
 	join_params.ssid.SSID_len = htod32(g_ssid.SSID_len);
-	memcpy(&join_params.params.bssid, awrq->sa_data, ETH_ALEN);
+	memcpy(join_params.params.bssid, awrq->sa_data, ETH_ALEN);
 
 	WL_TRACE("%s  target_channel=%d\n",
 		 __func__, g_wl_iw_params.target_channel);
@@ -840,7 +838,7 @@ wl_iw_mlme(struct net_device *dev,
 	}
 
 	scbval.val = mlme->reason_code;
-	memcpy(&scbval.ea, &mlme->addr.sa_data, ETH_ALEN);
+	memcpy(scbval.ea, mlme->addr.sa_data, ETH_ALEN);
 
 	if (mlme->cmd == IW_MLME_DISASSOC) {
 		scbval.val = htod32(scbval.val);
@@ -911,7 +909,7 @@ wl_iw_get_aplist(struct net_device *dev,
 		if (!(dtoh16(bi->capability) & DOT11_CAP_ESS))
 			continue;
 
-		memcpy(addr[dwrq->length].sa_data, &bi->BSSID, ETH_ALEN);
+		memcpy(addr[dwrq->length].sa_data, bi->BSSID, ETH_ALEN);
 		addr[dwrq->length].sa_family = ARPHRD_ETHER;
 		qual[dwrq->length].qual = rssi_to_qual(dtoh16(bi->RSSI));
 		qual[dwrq->length].level = 0x100 + dtoh16(bi->RSSI);
@@ -983,7 +981,7 @@ wl_iw_iscan_get_aplist(struct net_device *dev,
 			if (!(dtoh16(bi->capability) & DOT11_CAP_ESS))
 				continue;
 
-			memcpy(addr[dwrq->length].sa_data, &bi->BSSID,
+			memcpy(addr[dwrq->length].sa_data, bi->BSSID,
 			       ETH_ALEN);
 			addr[dwrq->length].sa_family = ARPHRD_ETHER;
 			qual[dwrq->length].qual =
@@ -1015,7 +1013,7 @@ static int wl_iw_iscan_prep(wl_scan_params_t *params, wlc_ssid_t *ssid)
 {
 	int err = 0;
 
-	memcpy(&params->bssid, &ether_bcast, ETH_ALEN);
+	memset(params->bssid, 255, ETH_ALEN);
 	params->bss_type = DOT11_BSSTYPE_ANY;
 	params->scan_type = 0;
 	params->nprobes = -1;
@@ -1512,7 +1510,7 @@ wl_iw_get_scan_prep(wl_scan_results_t *list,
 
 		iwe.cmd = SIOCGIWAP;
 		iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-		memcpy(iwe.u.ap_addr.sa_data, &bi->BSSID, ETH_ALEN);
+		memcpy(iwe.u.ap_addr.sa_data, bi->BSSID, ETH_ALEN);
 		event =
 		    IWE_STREAM_ADD_EVENT(info, event, end, &iwe,
 					 IW_EV_ADDR_LEN);
@@ -1781,8 +1779,7 @@ wl_iw_iscan_get_scan(struct net_device *dev,
 				return -E2BIG;
 			iwe.cmd = SIOCGIWAP;
 			iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-			memcpy(iwe.u.ap_addr.sa_data, &bi->BSSID,
-			       ETH_ALEN);
+			memcpy(iwe.u.ap_addr.sa_data, bi->BSSID, ETH_ALEN);
 			event =
 			    IWE_STREAM_ADD_EVENT(info, event, end, &iwe,
 						 IW_EV_ADDR_LEN);
@@ -1919,7 +1916,7 @@ wl_iw_set_essid(struct net_device *dev,
 
 	memcpy(&join_params.ssid.SSID, g_ssid.SSID, g_ssid.SSID_len);
 	join_params.ssid.SSID_len = htod32(g_ssid.SSID_len);
-	memcpy(&join_params.params.bssid, &ether_bcast, ETH_ALEN);
+	memset(join_params.params.bssid, 255, ETH_ALEN);
 
 	wl_iw_ch_to_chanspec(g_wl_iw_params.target_channel, &join_params,
 			     &join_params_size);
@@ -2545,7 +2542,7 @@ wl_iw_set_encodeext(struct net_device *dev,
 	key.len = iwe->key_len;
 
 	if (!is_multicast_ether_addr(iwe->addr.sa_data))
-		memcpy(&key.ea, &iwe->addr.sa_data, ETH_ALEN);
+		memcpy(key.ea, iwe->addr.sa_data, ETH_ALEN);
 
 	if (key.len == 0) {
 		if (iwe->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
@@ -2650,13 +2647,13 @@ wl_iw_set_pmksa(struct net_device *dev,
 			uint j;
 			pmkidptr = &pmkid;
 
-			memcpy(&pmkidptr->pmkid[0].BSSID,
+			memcpy(pmkidptr->pmkid[0].BSSID,
 			       &iwpmksa->bssid.sa_data[0], ETH_ALEN);
 			memcpy(&pmkidptr->pmkid[0].PMKID,
 			       &iwpmksa->pmkid[0], WPA2_PMKID_LEN);
 
 			WL_WSEC("wl_iw_set_pmksa:IW_PMKSA_REMOVE:PMKID: %pM = ",
-				&pmkidptr->pmkid[0].BSSID);
+				pmkidptr->pmkid[0].BSSID);
 			for (j = 0; j < WPA2_PMKID_LEN; j++)
 				WL_WSEC("%02x ", pmkidptr->pmkid[0].PMKID[j]);
 			WL_WSEC("\n");
@@ -2665,15 +2662,15 @@ wl_iw_set_pmksa(struct net_device *dev,
 		for (i = 0; i < pmkid_list.pmkids.npmkid; i++)
 			if (!memcmp
 			    (&iwpmksa->bssid.sa_data[0],
-			     &pmkid_list.pmkids.pmkid[i].BSSID, ETH_ALEN))
+			     pmkid_list.pmkids.pmkid[i].BSSID, ETH_ALEN))
 				break;
 
 		if ((pmkid_list.pmkids.npmkid > 0)
 		    && (i < pmkid_list.pmkids.npmkid)) {
 			memset(&pmkid_list.pmkids.pmkid[i], 0, sizeof(pmkid_t));
 			for (; i < (pmkid_list.pmkids.npmkid - 1); i++) {
-				memcpy(&pmkid_list.pmkids.pmkid[i].BSSID,
-				       &pmkid_list.pmkids.pmkid[i + 1].BSSID,
+				memcpy(pmkid_list.pmkids.pmkid[i].BSSID,
+				       pmkid_list.pmkids.pmkid[i + 1].BSSID,
 				       ETH_ALEN);
 				memcpy(&pmkid_list.pmkids.pmkid[i].PMKID,
 				       &pmkid_list.pmkids.pmkid[i + 1].PMKID,
@@ -2688,10 +2685,10 @@ wl_iw_set_pmksa(struct net_device *dev,
 		for (i = 0; i < pmkid_list.pmkids.npmkid; i++)
 			if (!memcmp
 			    (&iwpmksa->bssid.sa_data[0],
-			     &pmkid_list.pmkids.pmkid[i].BSSID, ETH_ALEN))
+			     pmkid_list.pmkids.pmkid[i].BSSID, ETH_ALEN))
 				break;
 		if (i < MAXPMKID) {
-			memcpy(&pmkid_list.pmkids.pmkid[i].BSSID,
+			memcpy(pmkid_list.pmkids.pmkid[i].BSSID,
 			       &iwpmksa->bssid.sa_data[0],
 			       ETH_ALEN);
 			memcpy(&pmkid_list.pmkids.pmkid[i].PMKID,
@@ -2706,7 +2703,7 @@ wl_iw_set_pmksa(struct net_device *dev,
 			uint k;
 			k = pmkid_list.pmkids.npmkid;
 			WL_WSEC("wl_iw_set_pmksa,IW_PMKSA_ADD - PMKID: %pM = ",
-				&pmkid_list.pmkids.pmkid[k].BSSID);
+				pmkid_list.pmkids.pmkid[k].BSSID);
 			for (j = 0; j < WPA2_PMKID_LEN; j++)
 				WL_WSEC("%02x ",
 					pmkid_list.pmkids.pmkid[k].PMKID[j]);
@@ -2718,7 +2715,7 @@ wl_iw_set_pmksa(struct net_device *dev,
 	for (i = 0; i < pmkid_list.pmkids.npmkid; i++) {
 		uint j;
 		WL_WSEC("PMKID[%d]: %pM = ",
-			i, &pmkid_list.pmkids.pmkid[i].BSSID);
+			i, pmkid_list.pmkids.pmkid[i].BSSID);
 		for (j = 0; j < WPA2_PMKID_LEN; j++)
 			WL_WSEC("%02x ", pmkid_list.pmkids.pmkid[i].PMKID[j]);
 		WL_WSEC("\n");
@@ -3482,8 +3479,8 @@ void wl_iw_event(struct net_device *dev, wl_event_msg_t *e, void *data)
 					if (pmkidcand->preauth)
 						iwpmkidcand->flags |=
 						    IW_PMKID_CAND_PREAUTH;
-					memcpy(&iwpmkidcand->bssid.sa_data,
-					       &pmkidcand->BSSID,
+					memcpy(iwpmkidcand->bssid.sa_data,
+					       pmkidcand->BSSID,
 					       ETH_ALEN);
 #ifndef SANDGATE2G
 					wireless_send_event(dev, cmd, &wrqu,
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.h b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
index c8637c5..08e11fb 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
@@ -19,7 +19,6 @@
 
 #include <linux/wireless.h>
 
-#include <proto/ethernet.h>
 #include <wlioctl.h>
 
 #define WL_SCAN_PARAMS_SSID_MAX	10
@@ -92,7 +91,7 @@ typedef struct wl_iw {
 	u32 gwsec;
 	bool privacy_invoked;
 
-	struct ether_addr spy_addr[IW_MAX_SPY];
+	u8 spy_addr[IW_MAX_SPY][ETH_ALEN];
 	struct iw_quality spy_qual[IW_MAX_SPY];
 	void *wlinfo;
 	dhd_pub_t *pub;
diff --git a/drivers/staging/brcm80211/include/bcmcdc.h b/drivers/staging/brcm80211/include/bcmcdc.h
index 10c1ddc..6dbc94c 100644
--- a/drivers/staging/brcm80211/include/bcmcdc.h
+++ b/drivers/staging/brcm80211/include/bcmcdc.h
@@ -13,7 +13,7 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-#include <proto/ethernet.h>
+#include <linux/if_ether.h>
 
 typedef struct cdc_ioctl {
 	u32 cmd;		/* ioctl command value */
@@ -24,7 +24,7 @@ typedef struct cdc_ioctl {
 } cdc_ioctl_t;
 
 /* Max valid buffer size that can be sent to the dongle */
-#define CDC_MAX_MSG_SIZE   ETHER_MAX_LEN
+#define CDC_MAX_MSG_SIZE   (ETH_FRAME_LEN + ETH_FCS_LEN)
 
 /* len field is divided into input and output buffer lengths */
 #define CDCL_IOC_OUTLEN_MASK   0x0000FFFF	/* maximum or expected
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index a8f76d8..58a170e 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -17,6 +17,8 @@
 #ifndef	_bcmutils_h_
 #define	_bcmutils_h_
 
+#include <linux/if_ether.h>
+
 /* Buffer structure for collecting string-formatted data
 * using bcm_bprintf() API.
 * Use bcm_binit() to initialize before use
@@ -88,8 +90,6 @@
 
 /* forward definition of ether_addr structure used by some function prototypes */
 
-	struct ether_addr;
-
 	extern int ether_isbcast(const void *ea);
 	extern int ether_isnulladdr(const void *ea);
 
@@ -157,7 +157,7 @@ extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
 	extern uint pkttotlen(struct osl_info *osh, struct sk_buff *p);
 
 /* ethernet address */
-	extern int bcm_ether_atoe(char *p, struct ether_addr *ea);
+	extern int bcm_ether_atoe(char *p, u8 ea[ETH_ALEN]);
 
 /* ip address */
 	struct ipv4_addr;
diff --git a/drivers/staging/brcm80211/include/proto/bcmevent.h b/drivers/staging/brcm80211/include/proto/bcmevent.h
index f61c048..5802ea0 100644
--- a/drivers/staging/brcm80211/include/proto/bcmevent.h
+++ b/drivers/staging/brcm80211/include/proto/bcmevent.h
@@ -34,7 +34,7 @@ typedef BWL_PRE_PACKED_STRUCT struct {
 	u32 reason;
 	u32 auth_type;
 	u32 datalen;
-	struct ether_addr addr;
+	u8 addr[ETH_ALEN];
 	char ifname[BCM_MSG_IFNAME_MAX];
 } BWL_POST_PACKED_STRUCT wl_event_msg_t;
 
diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
deleted file mode 100644
index 1176df9..0000000
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef _NET_ETHERNET_H_
-#define _NET_ETHERNET_H_
-
-#include <linux/if_ether.h>
-
-#include <packed_section_start.h>
-
-#define	ETHER_MAX_LEN		1518
-
-#define	ETHER_TYPE_BRCM		0x886c
-
-BWL_PRE_PACKED_STRUCT struct ether_addr {
-	u8 octet[ETH_ALEN];
-} BWL_POST_PACKED_STRUCT;
-
-static const struct ether_addr ether_bcast = { {255, 255, 255, 255, 255, 255} };
-
-#include <packed_section_end.h>
-
-#endif				/* _NET_ETHERNET_H_ */
diff --git a/drivers/staging/brcm80211/include/proto/wpa.h b/drivers/staging/brcm80211/include/proto/wpa.h
index 10c2fb6..5ffcffd 100644
--- a/drivers/staging/brcm80211/include/proto/wpa.h
+++ b/drivers/staging/brcm80211/include/proto/wpa.h
@@ -17,8 +17,6 @@
 #ifndef _proto_wpa_h_
 #define _proto_wpa_h_
 
-#include <proto/ethernet.h>
-
 #define WPA2_PMKID_LEN	16
 #define RSN_CAP_1_REPLAY_CNTR		0
 #define RSN_CAP_2_REPLAY_CNTRS		1
diff --git a/drivers/staging/brcm80211/include/wlioctl.h b/drivers/staging/brcm80211/include/wlioctl.h
index 9be793c..523ebd0 100644
--- a/drivers/staging/brcm80211/include/wlioctl.h
+++ b/drivers/staging/brcm80211/include/wlioctl.h
@@ -17,7 +17,6 @@
 #ifndef _wlioctl_h_
 #define	_wlioctl_h_
 
-#include <proto/ethernet.h>
 #ifdef BRCM_FULLMAC
 #include <proto/bcmeth.h>
 #endif
@@ -46,7 +45,7 @@ typedef struct wl_bss_info {
 	u32 length;		/* byte length of data in this record,
 				 * starting at version and including IEs
 				 */
-	struct ether_addr BSSID;
+	u8 BSSID[ETH_ALEN];
 	u16 beacon_period;	/* units are Kusec */
 	u16 capability;	/* Capability information */
 	u8 SSID_len;
@@ -128,7 +127,7 @@ typedef struct wl_extdscan_params {
 
 typedef struct wl_scan_params {
 	wlc_ssid_t ssid;	/* default: {0, ""} */
-	struct ether_addr bssid;	/* default: bcast */
+	u8 bssid[ETH_ALEN];	/* default: bcast */
 	s8 bss_type;		/* default: any,
 				 * DOT11_BSSTYPE_ANY/INFRASTRUCTURE/INDEPENDENT
 				 */
@@ -234,8 +233,8 @@ typedef struct wl_iscan_results {
 
 typedef struct wl_probe_params {
 	wlc_ssid_t ssid;
-	struct ether_addr bssid;
-	struct ether_addr mac;
+	u8 bssid[ETH_ALEN];
+	u8 mac[ETH_ALEN];
 } wl_probe_params_t;
 #endif /* BRCM_FULLMAC */
 
@@ -262,7 +261,7 @@ typedef struct wl_u32_list {
 
 /* used for association with a specific BSSID and chanspec list */
 typedef struct wl_assoc_params {
-	struct ether_addr bssid;	/* 00:00:00:00:00:00: broadcast scan */
+	u8 bssid[ETH_ALEN];	/* 00:00:00:00:00:00: broadcast scan */
 	s32 chanspec_num;	/* 0: all available channels,
 				 * otherwise count of chanspecs in chanspec_list
 				 */
@@ -492,7 +491,7 @@ typedef struct wl_wsec_key {
 		u16 lo;	/* lower 16 bits of IV */
 	} rxiv;
 	u32 pad_5[2];
-	struct ether_addr ea;	/* per station */
+	u8 ea[ETH_ALEN];	/* per station */
 } wl_wsec_key_t;
 
 #define WSEC_MIN_PSK_LEN	8
@@ -534,7 +533,7 @@ typedef struct {
 #define	MAXPMKID		16
 
 typedef struct _pmkid {
-	struct ether_addr BSSID;
+	u8 BSSID[ETH_ALEN];
 	u8 PMKID[WPA2_PMKID_LEN];
 } pmkid_t;
 
@@ -544,7 +543,7 @@ typedef struct _pmkid_list {
 } pmkid_list_t;
 
 typedef struct _pmkid_cand {
-	struct ether_addr BSSID;
+	u8 BSSID[ETH_ALEN];
 	u8 preauth;
 } pmkid_cand_t;
 
@@ -572,7 +571,7 @@ typedef struct {
 /* Used to get specific STA parameters */
 typedef struct {
 	u32 val;
-	struct ether_addr ea;
+	u8 ea[ETH_ALEN];
 } scb_val_t;
 #endif /* BRCM_FULLMAC */
 
@@ -586,7 +585,7 @@ typedef struct channel_info {
 /* For ioctls that take a list of MAC addresses */
 struct maclist {
 	uint count;		/* number of MAC addresses */
-	struct ether_addr ea[1];	/* variable length array of MAC addresses */
+	u8 ea[1][ETH_ALEN];	/* variable length array of MAC addresses */
 };
 
 /* get pkt count struct passed through ioctl */
@@ -1614,7 +1613,7 @@ struct ampdu_tid_control {
 
 /* structure for identifying ea/tid for sending addba/delba */
 struct ampdu_ea_tid {
-	struct ether_addr ea;	/* Station address */
+	u8 ea[ETH_ALEN];	/* Station address */
 	u8 tid;		/* tid */
 };
 /* structure for identifying retry/tid for retry_limit_tid/rr_retry_limit_tid */
diff --git a/drivers/staging/brcm80211/sys/wl_mac80211.c b/drivers/staging/brcm80211/sys/wl_mac80211.c
index c1c9711..bc7312f 100644
--- a/drivers/staging/brcm80211/sys/wl_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wl_mac80211.c
@@ -400,7 +400,7 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 		/* BSSID changed, for whatever reason (IBSS and managed mode) */
 		/* FIXME: need to store bssid in bsscfg */
 		wlc_set_addrmatch(wl->wlc, RCM_BSSID_OFFSET,
-				  (struct ether_addr *)info->bssid);
+				  info->bssid);
 	}
 	if (changed & BSS_CHANGED_BEACON) {
 		WL_ERROR("BSS_CHANGED_BEACON\n");
@@ -762,7 +762,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 		goto fail;
 	}
 
-	memcpy(perm, &wl->pub->cur_etheraddr, ETH_ALEN);
+	memcpy(perm, wl->pub->cur_etheraddr, ETH_ALEN);
 	ASSERT(is_valid_ether_addr(perm));
 	SET_IEEE80211_PERM_ADDR(hw, perm);
 
diff --git a/drivers/staging/brcm80211/sys/wlc_alloc.c b/drivers/staging/brcm80211/sys/wlc_alloc.c
index 746439e..baf30c6 100644
--- a/drivers/staging/brcm80211/sys/wlc_alloc.c
+++ b/drivers/staging/brcm80211/sys/wlc_alloc.c
@@ -86,13 +86,6 @@ static struct wlc_pub *wlc_pub_malloc(struct osl_info *osh, uint unit,
 	/* need to init the tunables now */
 	wlc_tunables_init(pub->tunables, devid);
 
-	pub->multicast = (struct ether_addr *)wlc_calloc(osh, unit,
-		(sizeof(struct ether_addr) * MAXMULTILIST));
-	if (pub->multicast == NULL) {
-		*err = 1003;
-		goto fail;
-	}
-
 	return pub;
 
  fail:
@@ -105,8 +98,6 @@ static void wlc_pub_mfree(struct osl_info *osh, struct wlc_pub *pub)
 	if (pub == NULL)
 		return;
 
-	if (pub->multicast)
-		kfree(pub->multicast);
 	if (pub->tunables) {
 		kfree(pub->tunables);
 		pub->tunables = NULL;
@@ -140,11 +131,6 @@ void wlc_bsscfg_mfree(struct osl_info *osh, wlc_bsscfg_t *cfg)
 	if (cfg == NULL)
 		return;
 
-	if (cfg->maclist) {
-		kfree(cfg->maclist);
-		cfg->maclist = NULL;
-	}
-
 	if (cfg->current_bss != NULL) {
 		wlc_bss_info_t *current_bss = cfg->current_bss;
 		if (current_bss->bcn_prb != NULL)
diff --git a/drivers/staging/brcm80211/sys/wlc_ampdu.c b/drivers/staging/brcm80211/sys/wlc_ampdu.c
index dcc2969..cface48 100644
--- a/drivers/staging/brcm80211/sys/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/sys/wlc_ampdu.c
@@ -1329,7 +1329,7 @@ void wlc_ampdu_macaddr_upd(struct wlc_info *wlc)
 
 	/* driver needs to write the ta in the template; ta is at offset 16 */
 	memset(template, 0, sizeof(template));
-	memcpy(template, wlc->pub->cur_etheraddr.octet, ETH_ALEN);
+	memcpy(template, wlc->pub->cur_etheraddr, ETH_ALEN);
 	wlc_write_template_ram(wlc, (T_BA_TPL_BASE + 16), (T_RAM_ACCESS_SZ * 2),
 			       template);
 }
diff --git a/drivers/staging/brcm80211/sys/wlc_bmac.c b/drivers/staging/brcm80211/sys/wlc_bmac.c
index a74d2a1..c24fbdc 100644
--- a/drivers/staging/brcm80211/sys/wlc_bmac.c
+++ b/drivers/staging/brcm80211/sys/wlc_bmac.c
@@ -1032,9 +1032,9 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		err = 21;
 		goto fail;
 	}
-	bcm_ether_atoe(macaddr, &wlc_hw->etheraddr);
-	if (is_broadcast_ether_addr(wlc_hw->etheraddr.octet) ||
-	    is_zero_ether_addr(wlc_hw->etheraddr.octet)) {
+	bcm_ether_atoe(macaddr, wlc_hw->etheraddr);
+	if (is_broadcast_ether_addr(wlc_hw->etheraddr) ||
+	    is_zero_ether_addr(wlc_hw->etheraddr)) {
 		WL_ERROR("wl%d: wlc_bmac_attach: bad macaddr %s\n",
 			 unit, macaddr);
 		err = 22;
@@ -1348,15 +1348,15 @@ void wlc_bmac_wait_for_wake(struct wlc_hw_info *wlc_hw)
 	ASSERT(wlc_bmac_read_shm(wlc_hw, M_UCODE_DBGST) != DBGST_ASLEEP);
 }
 
-void wlc_bmac_hw_etheraddr(struct wlc_hw_info *wlc_hw, struct ether_addr *ea)
+void wlc_bmac_hw_etheraddr(struct wlc_hw_info *wlc_hw, u8 ea[ETH_ALEN])
 {
-	memcpy(ea, &wlc_hw->etheraddr, ETH_ALEN);
+	memcpy(ea, wlc_hw->etheraddr, ETH_ALEN);
 }
 
 void wlc_bmac_set_hw_etheraddr(struct wlc_hw_info *wlc_hw,
-			       struct ether_addr *ea)
+			       u8 ea[ETH_ALEN])
 {
-	memcpy(&wlc_hw->etheraddr, ea, ETH_ALEN);
+	memcpy(wlc_hw->etheraddr, ea, ETH_ALEN);
 }
 
 int wlc_bmac_bandtype(struct wlc_hw_info *wlc_hw)
@@ -1720,8 +1720,7 @@ static void wlc_ucode_mute_override_clear(struct wlc_hw_info *wlc_hw)
  * Write a MAC address to the rcmta structure
  */
 void
-wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx,
-		   const struct ether_addr *addr)
+wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx, const u8 addr[ETH_ALEN])
 {
 	d11regs_t *regs = wlc_hw->regs;
 	volatile u16 *objdata16 = (volatile u16 *)&regs->objdata;
@@ -1733,11 +1732,8 @@ wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx,
 
 	ASSERT(wlc_hw->corerev > 4);
 
-	mac_hm =
-	    (addr->octet[3] << 24) | (addr->octet[2] << 16) | (addr->
-							       octet[1] << 8) |
-	    addr->octet[0];
-	mac_l = (addr->octet[5] << 8) | addr->octet[4];
+	mac_hm = (addr[3] << 24) | (addr[2] << 16) | (addr[1] << 8) | addr[0];
+	mac_l = (addr[5] << 8) | addr[4];
 
 	osh = wlc_hw->osh;
 
@@ -1754,7 +1750,7 @@ wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx,
  */
 void
 wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw, int match_reg_offset,
-		       const struct ether_addr *addr)
+		       const u8 addr[ETH_ALEN])
 {
 	d11regs_t *regs;
 	u16 mac_l;
@@ -1767,9 +1763,9 @@ wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw, int match_reg_offset,
 	ASSERT((match_reg_offset < RCM_SIZE) || (wlc_hw->corerev == 4));
 
 	regs = wlc_hw->regs;
-	mac_l = addr->octet[0] | (addr->octet[1] << 8);
-	mac_m = addr->octet[2] | (addr->octet[3] << 8);
-	mac_h = addr->octet[4] | (addr->octet[5] << 8);
+	mac_l = addr[0] | (addr[1] << 8);
+	mac_m = addr[2] | (addr[3] << 8);
+	mac_h = addr[4] | (addr[5] << 8);
 
 	osh = wlc_hw->osh;
 
@@ -3042,7 +3038,7 @@ void wlc_intrsrestore(struct wlc_info *wlc, u32 macintmask)
 
 void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
 {
-	struct ether_addr null_ether_addr = { {0, 0, 0, 0, 0, 0} };
+	u8 null_ether_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
 
 	if (on) {
 		/* suspend tx fifos */
@@ -3053,7 +3049,7 @@ void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
 
 		/* zero the address match register so we do not send ACKs */
 		wlc_bmac_set_addrmatch(wlc_hw, RCM_MAC_OFFSET,
-				       &null_ether_addr);
+				       null_ether_addr);
 	} else {
 		/* resume tx fifos */
 		if (!wlc_hw->wlc->tx_suspended) {
@@ -3065,7 +3061,7 @@ void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
 
 		/* Restore address */
 		wlc_bmac_set_addrmatch(wlc_hw, RCM_MAC_OFFSET,
-				       &wlc_hw->etheraddr);
+				       wlc_hw->etheraddr);
 	}
 
 	wlc_phy_mute_upd(wlc_hw->band->pi, on, flags);
diff --git a/drivers/staging/brcm80211/sys/wlc_bmac.h b/drivers/staging/brcm80211/sys/wlc_bmac.h
index 98150aa..2e93e6c 100644
--- a/drivers/staging/brcm80211/sys/wlc_bmac.h
+++ b/drivers/staging/brcm80211/sys/wlc_bmac.h
@@ -201,12 +201,10 @@ extern void wlc_bmac_write_template_ram(struct wlc_hw_info *wlc_hw, int offset,
 extern void wlc_bmac_copyfrom_vars(struct wlc_hw_info *wlc_hw, char **buf,
 				   uint *len);
 
-extern void wlc_bmac_process_ps_switch(struct wlc_hw_info *wlc,
-				       struct ether_addr *ea, s8 ps_on);
 extern void wlc_bmac_hw_etheraddr(struct wlc_hw_info *wlc_hw,
-				  struct ether_addr *ea);
+				  u8 ea[ETH_ALEN]);
 extern void wlc_bmac_set_hw_etheraddr(struct wlc_hw_info *wlc_hw,
-				      struct ether_addr *ea);
+				      u8 ea[ETH_ALEN]);
 extern bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw);
 
 extern bool wlc_bmac_radio_read_hwdisabled(struct wlc_hw_info *wlc_hw);
@@ -227,10 +225,10 @@ extern void wlc_ucode_wake_override_clear(struct wlc_hw_info *wlc_hw,
 					  u32 override_bit);
 
 extern void wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx,
-			       const struct ether_addr *addr);
+			       const u8 addr[ETH_ALEN]);
 extern void wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw,
 				   int match_reg_offset,
-				   const struct ether_addr *addr);
+				   const u8 addr[ETH_ALEN]);
 extern void wlc_bmac_write_hw_bcntemplates(struct wlc_hw_info *wlc_hw,
 					   void *bcn, int len, bool both);
 
diff --git a/drivers/staging/brcm80211/sys/wlc_bsscfg.h b/drivers/staging/brcm80211/sys/wlc_bsscfg.h
index d6a1971..3a5b55b 100644
--- a/drivers/staging/brcm80211/sys/wlc_bsscfg.h
+++ b/drivers/staging/brcm80211/sys/wlc_bsscfg.h
@@ -68,10 +68,6 @@ struct wlc_bsscfg {
 	s8 _idx;		/* the index of this bsscfg,
 				 * assigned at wlc_bsscfg_alloc()
 				 */
-	/* MAC filter */
-	uint nmac;		/* # of entries on maclist array */
-	int macmode;		/* allow/deny stations on maclist array */
-	struct ether_addr *maclist;	/* list of source MAC addrs to match */
 
 	/* security */
 	u32 wsec;		/* wireless security bitvec */
@@ -93,8 +89,8 @@ struct wlc_bsscfg {
 	u32 tk_cm_bt_tmstmp;	/* Timestamp when TKIP BT is activated */
 	bool tk_cm_activate;	/* activate countermeasures after EAPOL-Key sent */
 
-	struct ether_addr BSSID;	/* BSSID (associated) */
-	struct ether_addr cur_etheraddr;	/* h/w address */
+	u8 BSSID[ETH_ALEN];	/* BSSID (associated) */
+	u8 cur_etheraddr[ETH_ALEN];	/* h/w address */
 	u16 bcmc_fid;	/* the last BCMC FID queued to TX_BCMC_FIFO */
 	u16 bcmc_fid_shm;	/* the last BCMC FID written to shared mem */
 
diff --git a/drivers/staging/brcm80211/sys/wlc_key.h b/drivers/staging/brcm80211/sys/wlc_key.h
index 6678c69..3e23d51 100644
--- a/drivers/staging/brcm80211/sys/wlc_key.h
+++ b/drivers/staging/brcm80211/sys/wlc_key.h
@@ -87,7 +87,7 @@ typedef struct wsec_iv {
 #define WLC_NUMRXIVS	16	/* # rx IVs (one per 802.11e TID) */
 
 typedef struct wsec_key {
-	struct ether_addr ea;	/* per station */
+	u8 ea[ETH_ALEN];	/* per station */
 	u8 idx;		/* key index in wsec_keys array */
 	u8 id;		/* key ID [0-3] */
 	u8 algo;		/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index 8083244..35c5897 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -300,7 +300,7 @@ static int _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		      struct wlc_if *wlcif);
 
 #if defined(BCMDBG)
-void wlc_get_rcmta(struct wlc_info *wlc, int idx, struct ether_addr *addr)
+void wlc_get_rcmta(struct wlc_info *wlc, int idx, u8 addr[ETH_ALEN])
 {
 	d11regs_t *regs = wlc->regs;
 	u32 v32;
@@ -315,15 +315,15 @@ void wlc_get_rcmta(struct wlc_info *wlc, int idx, struct ether_addr *addr)
 	W_REG(osh, &regs->objaddr, (OBJADDR_RCMTA_SEL | (idx * 2)));
 	(void)R_REG(osh, &regs->objaddr);
 	v32 = R_REG(osh, &regs->objdata);
-	addr->octet[0] = (u8) v32;
-	addr->octet[1] = (u8) (v32 >> 8);
-	addr->octet[2] = (u8) (v32 >> 16);
-	addr->octet[3] = (u8) (v32 >> 24);
+	addr[0] = (u8) v32;
+	addr[1] = (u8) (v32 >> 8);
+	addr[2] = (u8) (v32 >> 16);
+	addr[3] = (u8) (v32 >> 24);
 	W_REG(osh, &regs->objaddr, (OBJADDR_RCMTA_SEL | ((idx * 2) + 1)));
 	(void)R_REG(osh, &regs->objaddr);
 	v32 = R_REG(osh, (volatile u16 *)&regs->objdata);
-	addr->octet[4] = (u8) v32;
-	addr->octet[5] = (u8) (v32 >> 8);
+	addr[4] = (u8) v32;
+	addr[5] = (u8) (v32 >> 8);
 }
 #endif				/* defined(BCMDBG) */
 
@@ -679,7 +679,7 @@ int wlc_set_mac(wlc_bsscfg_t *cfg)
 
 	if (cfg == wlc->cfg) {
 		/* enter the MAC addr into the RXE match registers */
-		wlc_set_addrmatch(wlc, RCM_MAC_OFFSET, &cfg->cur_etheraddr);
+		wlc_set_addrmatch(wlc, RCM_MAC_OFFSET, cfg->cur_etheraddr);
 	}
 
 	wlc_ampdu_macaddr_upd(wlc);
@@ -696,7 +696,7 @@ void wlc_set_bssid(wlc_bsscfg_t *cfg)
 
 	/* if primary config, we need to update BSSID in RXE match registers */
 	if (cfg == wlc->cfg) {
-		wlc_set_addrmatch(wlc, RCM_BSSID_OFFSET, &cfg->BSSID);
+		wlc_set_addrmatch(wlc, RCM_BSSID_OFFSET, cfg->BSSID);
 	}
 #ifdef SUPPORT_HWKEYS
 	else if (BSSCFG_STA(cfg) && cfg->BSS) {
@@ -1728,7 +1728,6 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	ASSERT(WSEC_MAX_DEFAULT_KEYS == WLC_DEFAULT_KEYS);
 
 	/* some code depends on packed structures */
-	ASSERT(sizeof(struct ether_addr) == ETH_ALEN);
 	ASSERT(sizeof(struct ethhdr) == ETH_HLEN);
 	ASSERT(sizeof(d11regs_t) == SI_CORE_SIZE);
 	ASSERT(sizeof(ofdm_phy_hdr_t) == D11_PHY_HDR_LEN);
@@ -1838,9 +1837,9 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 			wlc->core->txavail[i] = wlc->hw->txavail[i];
 	}
 
-	wlc_bmac_hw_etheraddr(wlc->hw, &wlc->perm_etheraddr);
+	wlc_bmac_hw_etheraddr(wlc->hw, wlc->perm_etheraddr);
 
-	memcpy(&pub->cur_etheraddr, &wlc->perm_etheraddr, ETH_ALEN);
+	memcpy(pub->cur_etheraddr, wlc->perm_etheraddr, ETH_ALEN);
 
 	for (j = 0; j < NBANDS(wlc); j++) {
 		/* Use band 1 for single band 11a */
@@ -3600,8 +3599,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 				if (src_key->flags & WSEC_PRIMARY_KEY)
 					key.flags |= WL_PRIMARY_KEY;
 
-				memcpy(key.ea.octet, src_key->ea.octet,
-				       ETH_ALEN);
+				memcpy(key.ea, src_key->ea, ETH_ALEN);
 			}
 
 			memcpy(arg, &key, sizeof(key));
@@ -3637,7 +3635,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 				u32 hi;
 				/* group keys in WPA-NONE (IBSS only, AES and TKIP) use a global TXIV */
 				if ((bsscfg->WPA_auth & WPA_AUTH_NONE) &&
-				    is_zero_ether_addr(key->ea.octet)) {
+				    is_zero_ether_addr(key->ea)) {
 					lo = bsscfg->wpa_none_txiv.lo;
 					hi = bsscfg->wpa_none_txiv.hi;
 				} else {
@@ -7655,9 +7653,9 @@ wlc_bcn_prb_template(struct wlc_info *wlc, uint type, ratespec_t bcn_rspec,
 	/* DUR is 0 for multicast bcn, or filled in by MAC for prb resp */
 	/* A1 filled in by MAC for prb resp, broadcast for bcn */
 	if (type == IEEE80211_STYPE_BEACON)
-		memcpy(h->da, &ether_bcast, ETH_ALEN);
-	memcpy(h->sa, &cfg->cur_etheraddr, ETH_ALEN);
-	memcpy(h->bssid, &cfg->BSSID, ETH_ALEN);
+		memset(h->da, 255, ETH_ALEN);
+	memcpy(h->sa, cfg->cur_etheraddr, ETH_ALEN);
+	memcpy(h->bssid, cfg->BSSID, ETH_ALEN);
 
 	/* SEQ filled in by MAC */
 
@@ -8220,12 +8218,12 @@ void wlc_write_hw_bcntemplates(struct wlc_info *wlc, void *bcn, int len,
 
 void
 wlc_set_addrmatch(struct wlc_info *wlc, int match_reg_offset,
-		  const struct ether_addr *addr)
+		  const u8 addr[ETH_ALEN])
 {
 	wlc_bmac_set_addrmatch(wlc->hw, match_reg_offset, addr);
 }
 
-void wlc_set_rcmta(struct wlc_info *wlc, int idx, const struct ether_addr *addr)
+void wlc_set_rcmta(struct wlc_info *wlc, int idx, const u8 addr[ETH_ALEN])
 {
 	wlc_bmac_set_rcmta(wlc->hw, idx, addr);
 }
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.h b/drivers/staging/brcm80211/sys/wlc_mac80211.h
index d0c274b..cea7c33 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.h
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.h
@@ -470,7 +470,7 @@ struct wlc_hw_info {
 	uint mac_suspend_depth;	/* current depth of mac_suspend levels */
 	u32 wake_override;	/* Various conditions to force MAC to WAKE mode */
 	u32 mute_override;	/* Prevent ucode from sending beacons */
-	struct ether_addr etheraddr;	/* currently configured ethernet address */
+	u8 etheraddr[ETH_ALEN];	/* currently configured ethernet address */
 	u32 led_gpio_mask;	/* LED GPIO Mask */
 	bool noreset;		/* true= do not reset hw, used by WLC_OUT */
 	bool forcefastclk;	/* true if the h/w is forcing the use of fast clk */
@@ -566,7 +566,7 @@ struct wlc_info {
 
 	u32 machwcap;	/* MAC capabilities, BMAC shadow */
 
-	struct ether_addr perm_etheraddr;	/* original sprom local ethernet address */
+	u8 perm_etheraddr[ETH_ALEN];	/* original sprom local ethernet address */
 
 	bool bandlocked;	/* disable auto multi-band switching */
 	bool bandinit_pending;	/* track band init in auto band */
@@ -835,13 +835,12 @@ extern void wlc_write_template_ram(struct wlc_info *wlc, int offset, int len,
 extern void wlc_write_hw_bcntemplates(struct wlc_info *wlc, void *bcn, int len,
 				      bool both);
 #if defined(BCMDBG)
-extern void wlc_get_rcmta(struct wlc_info *wlc, int idx,
-			  struct ether_addr *addr);
+extern void wlc_get_rcmta(struct wlc_info *wlc, int idx, u8 addr[ETH_ALEN]);
 #endif
 extern void wlc_set_rcmta(struct wlc_info *wlc, int idx,
-			  const struct ether_addr *addr);
+			  const u8 addr[ETH_ALEN]);
 extern void wlc_set_addrmatch(struct wlc_info *wlc, int match_reg_offset,
-			      const struct ether_addr *addr);
+			      const u8 addr[ETH_ALEN]);
 extern void wlc_read_tsf(struct wlc_info *wlc, u32 *tsf_l_ptr,
 			 u32 *tsf_h_ptr);
 extern void wlc_set_cwmin(struct wlc_info *wlc, u16 newmin);
diff --git a/drivers/staging/brcm80211/sys/wlc_pub.h b/drivers/staging/brcm80211/sys/wlc_pub.h
index c304156..6b9d378 100644
--- a/drivers/staging/brcm80211/sys/wlc_pub.h
+++ b/drivers/staging/brcm80211/sys/wlc_pub.h
@@ -157,9 +157,6 @@ typedef void *wlc_pkt_t;
 /* Event data type */
 typedef struct wlc_event {
 	wl_event_msg_t event;	/* encapsulated event */
-	struct ether_addr *addr;	/* used to keep a trace of the potential present of
-					 * an address in wlc_event_msg_t
-					 */
 	int bsscfgidx;		/* BSS config when needed */
 	struct wl_if *wlif;	/* pointer to wlif */
 	void *data;		/* used to hang additional data on an event */
@@ -168,7 +165,7 @@ typedef struct wlc_event {
 
 /* wlc internal bss_info, wl external one is in wlioctl.h */
 typedef struct wlc_bss_info {
-	struct ether_addr BSSID;	/* network BSSID */
+	u8 BSSID[ETH_ALEN];	/* network BSSID */
 	u16 flags;		/* flags for internal attributes */
 	u8 SSID_len;		/* the length of SSID */
 	u8 SSID[32];		/* SSID string */
@@ -294,10 +291,7 @@ struct wlc_pub {
 	s8 _coex;		/* 20/40 MHz BSS Management AUTO, ENAB, DISABLE */
 	bool _priofc;		/* Priority-based flowcontrol */
 
-	struct ether_addr cur_etheraddr;	/* our local ethernet address */
-
-	struct ether_addr *multicast;	/* ptr to list of multicast addresses */
-	uint nmulticast;	/* # enabled multicast addresses */
+	u8 cur_etheraddr[ETH_ALEN];	/* our local ethernet address */
 
 	u32 wlfeatureflag;	/* Flags to control sw features from registry */
 	int psq_pkts_total;	/* total num of ps pkts */
@@ -527,7 +521,7 @@ extern void wlc_statsupd(struct wlc_info *wlc);
 extern int wlc_get_header_len(void);
 extern void wlc_mac_bcn_promisc_change(struct wlc_info *wlc, bool promisc);
 extern void wlc_set_addrmatch(struct wlc_info *wlc, int match_reg_offset,
-			      const struct ether_addr *addr);
+			      const u8 addr[ETH_ALEN]);
 extern void wlc_wme_setparams(struct wlc_info *wlc, u16 aci, void *arg,
 			      bool suspend);
 
@@ -566,8 +560,6 @@ extern int wlc_module_register(struct wlc_pub *pub, const bcm_iovar_t *iovars,
 			       watchdog_fn_t watchdog_fn, down_fn_t down_fn);
 extern int wlc_module_unregister(struct wlc_pub *pub, const char *name,
 				 void *hdl);
-extern void wlc_event_if(struct wlc_info *wlc, struct wlc_bsscfg *cfg,
-			 wlc_event_t *e, const struct ether_addr *addr);
 extern void wlc_suspend_mac_and_wait(struct wlc_info *wlc);
 extern void wlc_enable_mac(struct wlc_info *wlc);
 extern u16 wlc_rate_shm_offset(struct wlc_info *wlc, u8 rate);
diff --git a/drivers/staging/brcm80211/sys/wlc_scb.h b/drivers/staging/brcm80211/sys/wlc_scb.h
index fe84e99..096a6b3 100644
--- a/drivers/staging/brcm80211/sys/wlc_scb.h
+++ b/drivers/staging/brcm80211/sys/wlc_scb.h
@@ -58,7 +58,6 @@ struct scb {
 	u32 flags;		/* various bit flags as defined below */
 	u32 flags2;		/* various bit flags2 as defined below */
 	u8 state;		/* current state bitfield of auth/assoc process */
-	struct ether_addr ea;	/* station address */
 	void *fragbuf[NUMPRIO];	/* defragmentation buffer per prio */
 	uint fragresid[NUMPRIO];	/* #bytes unused in frag buffer per prio */
 
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index 992d247..f70b26c 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -44,8 +44,6 @@
 #include <sbsdpcmdev.h>
 #endif
 
-#include <proto/ethernet.h>	/* for sprom content groking */
-
 #define	BS_ERROR(args)
 
 #define SROM_OFFSET(sih) ((sih->ccrev > 31) ? \
@@ -1725,16 +1723,16 @@ static void _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, varbuf_t *b)
 			continue;
 
 		if (flags & SRFL_ETHADDR) {
-			struct ether_addr ea;
+			u8 ea[ETH_ALEN];
 
-			ea.octet[0] = (srom[srv->off - off] >> 8) & 0xff;
-			ea.octet[1] = srom[srv->off - off] & 0xff;
-			ea.octet[2] = (srom[srv->off + 1 - off] >> 8) & 0xff;
-			ea.octet[3] = srom[srv->off + 1 - off] & 0xff;
-			ea.octet[4] = (srom[srv->off + 2 - off] >> 8) & 0xff;
-			ea.octet[5] = srom[srv->off + 2 - off] & 0xff;
+			ea[0] = (srom[srv->off - off] >> 8) & 0xff;
+			ea[1] = srom[srv->off - off] & 0xff;
+			ea[2] = (srom[srv->off + 1 - off] >> 8) & 0xff;
+			ea[3] = srom[srv->off + 1 - off] & 0xff;
+			ea[4] = (srom[srv->off + 2 - off] >> 8) & 0xff;
+			ea[5] = srom[srv->off + 2 - off] & 0xff;
 
-			varbuf_append(b, "%s=%pM", name, ea.octet);
+			varbuf_append(b, "%s=%pM", name, ea);
 		} else {
 			ASSERT(mask_valid(srv->mask));
 			ASSERT(mask_width(srv->mask));
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 43bce96..ca3ea1f 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -22,13 +22,13 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/if_ether.h>
 #include <osl.h>
 #include <bcmutils.h>
 #include <siutils.h>
 #include <bcmnvram.h>
 #include <bcmendian.h>
 #include <bcmdevs.h>
-#include <proto/ethernet.h>
 #include <proto/802.1d.h>
 #include <proto/802.11.h>
 
@@ -348,12 +348,12 @@ struct sk_buff *BCMFASTPATH pktq_mdeq(struct pktq *pq, uint prec_bmp,
 }
 
 /* parse a xx:xx:xx:xx:xx:xx format ethernet address */
-int bcm_ether_atoe(char *p, struct ether_addr *ea)
+int bcm_ether_atoe(char *p, u8 ea[ETH_ALEN])
 {
 	int i = 0;
 
 	for (;;) {
-		ea->octet[i++] = (char)simple_strtoul(p, &p, 16);
+		ea[i++] = (char)simple_strtoul(p, &p, 16);
 		if (!*p++ || i == 6)
 			break;
 	}
-- 
1.7.1


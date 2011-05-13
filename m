Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3405 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758636Ab1EMKAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/32] staging: brcm80211: removed stats WEXT support
 from fullmac
Date: Fri, 13 May 2011 11:59:34 +0200
Message-ID: <1305280792-9475-14-git-send-email-arend@broadcom.com> (sfid-20110513_120115_672125_C142A1B0)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Wireless Extension support is obsolete and made use of counters that are
going to be removed in the next patches.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   31 -------
 drivers/staging/brcm80211/brcmfmac/wl_iw.c     |  101 +-----------------------
 2 files changed, 1 insertions(+), 131 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index aedf4a9..ba73ce0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -385,10 +385,6 @@ module_param(dhd_pktgen_len, uint, 0);
 #define DHD_COMPILED
 #endif
 
-#if defined(CONFIG_WIRELESS_EXT)
-struct iw_statistics *dhd_get_wireless_stats(struct net_device *dev);
-#endif				/* defined(CONFIG_WIRELESS_EXT) */
-
 static void dhd_dpc(unsigned long data);
 /* forward decl */
 extern int dhd_wait_pend8021x(struct net_device *dev);
@@ -2205,18 +2201,6 @@ int dhd_net_attach(dhd_pub_t *dhdp, int ifidx)
 	net->hard_header_len = ETH_HLEN + dhd->pub.hdrlen;
 	net->ethtool_ops = &dhd_ethtool_ops;
 
-#if defined(CONFIG_WIRELESS_EXT)
-	if (!IS_CFG80211_FAVORITE()) {
-#if WIRELESS_EXT < 19
-		net->get_wireless_stats = dhd_get_wireless_stats;
-#endif				/* WIRELESS_EXT < 19 */
-#if WIRELESS_EXT > 12
-		net->wireless_handlers =
-		    (struct iw_handler_def *)&wl_iw_handler_def;
-#endif				/* WIRELESS_EXT > 12 */
-	}
-#endif				/* defined(CONFIG_WIRELESS_EXT) */
-
 	dhd->pub.rxsz = net->mtu + net->hard_header_len + dhd->pub.hdrlen;
 
 	memcpy(net->dev_addr, temp_addr, ETH_ALEN);
@@ -2623,21 +2607,6 @@ void dhd_os_sdtxunlock(dhd_pub_t *pub)
 	dhd_os_sdunlock(pub);
 }
 
-#if defined(CONFIG_WIRELESS_EXT)
-struct iw_statistics *dhd_get_wireless_stats(struct net_device *dev)
-{
-	int res = 0;
-	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(dev);
-
-	res = wl_iw_get_wireless_stats(dev, &dhd->iw.wstats);
-
-	if (res == 0)
-		return &dhd->iw.wstats;
-	else
-		return NULL;
-}
-#endif	/* defined(CONFIG_WIRELESS_EXT) */
-
 static int
 dhd_wl_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 		  wl_event_msg_t *event, void **data)
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 1f85e77..929ceaf 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -69,8 +69,6 @@ uint wl_msg_level = WL_ERROR_VAL;
 #define MAX_WLIW_IOCTL_LEN 1024
 
 #ifdef CONFIG_WIRELESS_EXT
-
-extern struct iw_statistics *dhd_get_wireless_stats(struct net_device *dev);
 extern int dhd_wait_pend8021x(struct net_device *dev);
 #endif
 
@@ -3132,7 +3130,7 @@ const struct iw_handler_def wl_iw_handler_def = {
 	.private_args = 0,
 
 #if WIRELESS_EXT >= 19
-	.get_wireless_stats = dhd_get_wireless_stats,
+	.get_wireless_stats = NULL,
 #endif
 };
 #endif				/* WIRELESS_EXT > 12 */
@@ -3549,103 +3547,6 @@ void wl_iw_event(struct net_device *dev, wl_event_msg_t *e, void *data)
 #endif				/* WIRELESS_EXT > 13 */
 }
 
-int
-wl_iw_get_wireless_stats(struct net_device *dev, struct iw_statistics *wstats)
-{
-	int res = 0;
-	struct wl_cnt cnt;
-	int phy_noise;
-	int rssi;
-	scb_val_t scb_val;
-
-	phy_noise = 0;
-	res = dev_wlc_ioctl(dev, WLC_GET_PHY_NOISE, &phy_noise,
-				sizeof(phy_noise));
-	if (res)
-		goto done;
-
-	phy_noise = le32_to_cpu(phy_noise);
-	WL_TRACE("wl_iw_get_wireless_stats phy noise=%d\n", phy_noise);
-
-	memset(&scb_val, 0, sizeof(scb_val_t));
-	res = dev_wlc_ioctl(dev, WLC_GET_RSSI, &scb_val, sizeof(scb_val_t));
-	if (res)
-		goto done;
-
-	rssi = le32_to_cpu(scb_val.val);
-	WL_TRACE("wl_iw_get_wireless_stats rssi=%d\n", rssi);
-	if (rssi <= WL_IW_RSSI_NO_SIGNAL)
-		wstats->qual.qual = 0;
-	else if (rssi <= WL_IW_RSSI_VERY_LOW)
-		wstats->qual.qual = 1;
-	else if (rssi <= WL_IW_RSSI_LOW)
-		wstats->qual.qual = 2;
-	else if (rssi <= WL_IW_RSSI_GOOD)
-		wstats->qual.qual = 3;
-	else if (rssi <= WL_IW_RSSI_VERY_GOOD)
-		wstats->qual.qual = 4;
-	else
-		wstats->qual.qual = 5;
-
-	wstats->qual.level = 0x100 + rssi;
-	wstats->qual.noise = 0x100 + phy_noise;
-#if WIRELESS_EXT > 18
-	wstats->qual.updated |= (IW_QUAL_ALL_UPDATED | IW_QUAL_DBM);
-#else
-	wstats->qual.updated |= 7;
-#endif
-
-#if WIRELESS_EXT > 11
-	WL_TRACE("wl_iw_get_wireless_stats counters=%zu\n",
-		 sizeof(struct wl_cnt));
-
-	memset(&cnt, 0, sizeof(struct wl_cnt));
-	res =
-	    dev_wlc_bufvar_get(dev, "counters", (char *)&cnt,
-			       sizeof(struct wl_cnt));
-	if (res) {
-		WL_ERROR("wl_iw_get_wireless_stats counters failed error=%d\n",
-			 res);
-		goto done;
-	}
-
-	cnt.version = le16_to_cpu(cnt.version);
-	if (cnt.version != WL_CNT_T_VERSION) {
-		WL_TRACE("\tIncorrect counter version: expected %d; got %d\n",
-			 WL_CNT_T_VERSION, cnt.version);
-		goto done;
-	}
-
-	wstats->discard.nwid = 0;
-	wstats->discard.code = le32_to_cpu(cnt.rxundec);
-	wstats->discard.fragment = le32_to_cpu(cnt.rxfragerr);
-	wstats->discard.retries = le32_to_cpu(cnt.txfail);
-	wstats->discard.misc = le32_to_cpu(cnt.rxrunt) +
-		le32_to_cpu(cnt.rxgiant);
-	wstats->miss.beacon = 0;
-
-	WL_TRACE("wl_iw_get_wireless_stats counters txframe=%d txbyte=%d\n",
-		 le32_to_cpu(cnt.txframe), le32_to_cpu(cnt.txbyte));
-	WL_TRACE("wl_iw_get_wireless_stats counters rxfrmtoolong=%d\n",
-		  le32_to_cpu(cnt.rxfrmtoolong));
-	WL_TRACE("wl_iw_get_wireless_stats counters rxbadplcp=%d\n",
-		  le32_to_cpu(cnt.rxbadplcp));
-	WL_TRACE("wl_iw_get_wireless_stats counters rxundec=%d\n",
-		  le32_to_cpu(cnt.rxundec));
-	WL_TRACE("wl_iw_get_wireless_stats counters rxfragerr=%d\n",
-		  le32_to_cpu(cnt.rxfragerr));
-	WL_TRACE("wl_iw_get_wireless_stats counters txfail=%d\n",
-		  le32_to_cpu(cnt.txfail));
-	WL_TRACE("wl_iw_get_wireless_stats counters rxrunt=%d\n",
-		  le32_to_cpu(cnt.rxrunt));
-	WL_TRACE("wl_iw_get_wireless_stats counters rxgiant=%d\n",
-		  le32_to_cpu(cnt.rxgiant));
-#endif				/* WIRELESS_EXT > 11 */
-
-done:
-	return res;
-}
-
 int wl_iw_attach(struct net_device *dev, void *dhdp)
 {
 	int params_size;
-- 
1.7.4.1



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33471 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750894AbdARO1T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 09:27:19 -0500
Received: by mail-lf0-f68.google.com with SMTP id x1so2002856lff.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2017 06:27:18 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH RFC 2/2] brcmfmac: add brcmf_err_pub macro for better error messages
Date: Wed, 18 Jan 2017 15:27:03 +0100
Message-Id: <20170118142703.9824-2-zajec5@gmail.com> (sfid-20170118_152722_762512_F1E10918)
In-Reply-To: <20170118142703.9824-1-zajec5@gmail.com>
References: <20170118142703.9824-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This macro accepts an extra argument of struct brcmf_pub pointer. It
allows referencing struct device and printing error using dev_err. This
is very useful on devices with more than one wireless card suppored by
brcmfmac. Thanks for dev_err it's possible to identify device that error
is related to.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
I could convert few more brcmf_err calls to this new brcmf_err_pub but I don't
want to spent too much time on this in case someone has a better idea.

If you do, comment! :)

Example
Before:
[   14.735640] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Sep 18 2015 03:30:01 version 7.35.177.56 (r587209) FWID 01-6cb8e269
[   15.155732] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Sep 18 2015 03:30:01 version 7.35.177.56 (r587209) FWID 01-6cb8e269
[   15.535682] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Sep 18 2015 03:30:01 version 7.35.177.56 (r587209) FWID 01-6cb8e269
After:
[   14.746754] brcmfmac 0000:01:00.0: brcmf_c_preinit_dcmds: Firmware version = wl0: Sep 18 2015 03:30:01 version 7.35.177.56 (r587209) FWID 01-6cb8e269
[   15.166854] brcmfmac 0001:03:00.0: brcmf_c_preinit_dcmds: Firmware version = wl0: Sep 18 2015 03:30:01 version 7.35.177.56 (r587209) FWID 01-6cb8e269
[   15.546807] brcmfmac 0001:04:00.0: brcmf_c_preinit_dcmds: Firmware version = wl0: Sep 18 2015 03:30:01 version 7.35.177.56 (r587209) FWID 01-6cb8e269
---
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 19 ++++++-------
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 31 +++++++++++-----------
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   | 17 ++++++++----
 .../broadcom/brcm80211/brcmfmac/tracepoint.c       |  4 +--
 4 files changed, 40 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 5fb4a14..7a05de78 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -108,6 +108,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 {
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
 	u8 buf[BRCMF_DCMD_SMLEN];
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmf_rev_info_le revinfo;
 	struct brcmf_rev_info *ri;
 	char *ptr;
@@ -117,7 +118,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_get(ifp, "cur_etheraddr", ifp->mac_addr,
 				       sizeof(ifp->mac_addr));
 	if (err < 0) {
-		brcmf_err("Retreiving cur_etheraddr failed, %d\n", err);
+		brcmf_err_pub(pub, "Retreiving cur_etheraddr failed, %d\n", err);
 		goto done;
 	}
 	memcpy(ifp->drvr->mac, ifp->mac_addr, sizeof(ifp->drvr->mac));
@@ -126,7 +127,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 				     &revinfo, sizeof(revinfo));
 	ri = &ifp->drvr->revinfo;
 	if (err < 0) {
-		brcmf_err("retrieving revision info failed, %d\n", err);
+		brcmf_err_pub(pub, "retrieving revision info failed, %d\n", err);
 	} else {
 		ri->vendorid = le32_to_cpu(revinfo.vendorid);
 		ri->deviceid = le32_to_cpu(revinfo.deviceid);
@@ -153,7 +154,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	strcpy(buf, "ver");
 	err = brcmf_fil_iovar_data_get(ifp, "ver", buf, sizeof(buf));
 	if (err < 0) {
-		brcmf_err("Retreiving version information failed, %d\n",
+		brcmf_err_pub(pub, "Retreiving version information failed, %d\n",
 			  err);
 		goto done;
 	}
@@ -161,7 +162,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	strsep(&ptr, "\n");
 
 	/* Print fw version info */
-	brcmf_err("Firmware version = %s\n", buf);
+	brcmf_err_pub(pub, "Firmware version = %s\n", buf);
 
 	/* locate firmware version number for ethtool */
 	ptr = strrchr(buf, ' ') + 1;
@@ -170,7 +171,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	/* set mpc */
 	err = brcmf_fil_iovar_int_set(ifp, "mpc", 1);
 	if (err) {
-		brcmf_err("failed setting mpc\n");
+		brcmf_err_pub(pub, "failed setting mpc\n");
 		goto done;
 	}
 
@@ -180,14 +181,14 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_get(ifp, "event_msgs", eventmask,
 				       BRCMF_EVENTING_MASK_LEN);
 	if (err) {
-		brcmf_err("Get event_msgs error (%d)\n", err);
+		brcmf_err_pub(pub, "Get event_msgs error (%d)\n", err);
 		goto done;
 	}
 	setbit(eventmask, BRCMF_E_IF);
 	err = brcmf_fil_iovar_data_set(ifp, "event_msgs", eventmask,
 				       BRCMF_EVENTING_MASK_LEN);
 	if (err) {
-		brcmf_err("Set event_msgs error (%d)\n", err);
+		brcmf_err_pub(pub, "Set event_msgs error (%d)\n", err);
 		goto done;
 	}
 
@@ -195,7 +196,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_CHANNEL_TIME,
 				    BRCMF_DEFAULT_SCAN_CHANNEL_TIME);
 	if (err) {
-		brcmf_err("BRCMF_C_SET_SCAN_CHANNEL_TIME error (%d)\n",
+		brcmf_err_pub(pub, "BRCMF_C_SET_SCAN_CHANNEL_TIME error (%d)\n",
 			  err);
 		goto done;
 	}
@@ -204,7 +205,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 				    BRCMF_DEFAULT_SCAN_UNASSOC_TIME);
 	if (err) {
-		brcmf_err("BRCMF_C_SET_SCAN_UNASSOC_TIME error (%d)\n",
+		brcmf_err_pub(pub, "BRCMF_C_SET_SCAN_UNASSOC_TIME error (%d)\n",
 			  err);
 		goto done;
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index b73a55b..a42007b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -59,7 +59,7 @@ struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx)
 	s32 bsscfgidx;
 
 	if (ifidx < 0 || ifidx >= BRCMF_MAX_IFS) {
-		brcmf_err("ifidx %d out of range\n", ifidx);
+		brcmf_err_pub(drvr, "ifidx %d out of range\n", ifidx);
 		return NULL;
 	}
 
@@ -204,7 +204,8 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 
 	/* Can the device send data? */
 	if (drvr->bus_if->state != BRCMF_BUS_UP) {
-		brcmf_err("xmit rejected state=%d\n", drvr->bus_if->state);
+		brcmf_err_pub(drvr, "xmit rejected state=%d\n",
+			      drvr->bus_if->state);
 		netif_stop_queue(ndev);
 		dev_kfree_skb(skb);
 		ret = -ENODEV;
@@ -222,7 +223,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		dev_kfree_skb(skb);
 		skb = skb2;
 		if (skb == NULL) {
-			brcmf_err("%s: skb_realloc_headroom failed\n",
+			brcmf_err_pub(drvr, "%s: skb_realloc_headroom failed\n",
 				  brcmf_ifname(ifp));
 			ret = -ENOMEM;
 			goto done;
@@ -466,7 +467,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 
 	/* If bus is not ready, can't continue */
 	if (bus_if->state != BRCMF_BUS_UP) {
-		brcmf_err("failed bus is not ready\n");
+		brcmf_err_pub(drvr, "failed bus is not ready\n");
 		return -EAGAIN;
 	}
 
@@ -480,7 +481,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 		ndev->features &= ~NETIF_F_IP_CSUM;
 
 	if (brcmf_cfg80211_up(ndev)) {
-		brcmf_err("failed to bring up cfg80211\n");
+		brcmf_err_pub(drvr, "failed to bring up cfg80211\n");
 		return -EIO;
 	}
 
@@ -525,7 +526,7 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 	else
 		err = register_netdev(ndev);
 	if (err != 0) {
-		brcmf_err("couldn't register the net device\n");
+		brcmf_err_pub(drvr, "couldn't register the net device\n");
 		goto fail;
 	}
 
@@ -643,7 +644,7 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 	 */
 	if (ifp) {
 		if (ifidx) {
-			brcmf_err("ERROR: netdev:%s already exists\n",
+			brcmf_err_pub(drvr, "ERROR: netdev:%s already exists\n",
 				  ifp->ndev->name);
 			netif_stop_queue(ifp->ndev);
 			brcmf_net_detach(ifp->ndev, false);
@@ -702,7 +703,7 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bsscfgidx,
 	ifp = drvr->iflist[bsscfgidx];
 	drvr->iflist[bsscfgidx] = NULL;
 	if (!ifp) {
-		brcmf_err("Null interface, bsscfgidx=%d\n", bsscfgidx);
+		brcmf_err_pub(drvr, "Null interface, bsscfgidx=%d\n", bsscfgidx);
 		return;
 	}
 	brcmf_dbg(TRACE, "Enter, bsscfgidx=%d, ifidx=%d\n", bsscfgidx,
@@ -787,7 +788,7 @@ static int brcmf_inetaddr_changed(struct notifier_block *nb,
 	ret = brcmf_fil_iovar_data_get(ifp, "arp_hostip", addr_table,
 				       sizeof(addr_table));
 	if (ret) {
-		brcmf_err("fail to get arp ip table err:%d\n", ret);
+		brcmf_err_pub(drvr, "fail to get arp ip table err:%d\n", ret);
 		return NOTIFY_OK;
 	}
 
@@ -804,7 +805,7 @@ static int brcmf_inetaddr_changed(struct notifier_block *nb,
 			ret = brcmf_fil_iovar_data_set(ifp, "arp_hostip",
 				&ifa->ifa_address, sizeof(ifa->ifa_address));
 			if (ret)
-				brcmf_err("add arp ip err %d\n", ret);
+				brcmf_err_pub(drvr, "add arp ip err %d\n", ret);
 		}
 		break;
 	case NETDEV_DOWN:
@@ -816,7 +817,7 @@ static int brcmf_inetaddr_changed(struct notifier_block *nb,
 			ret = brcmf_fil_iovar_data_set(ifp, "arp_hostip_clear",
 						       NULL, 0);
 			if (ret) {
-				brcmf_err("fail to clear arp ip table err:%d\n",
+				brcmf_err_pub(drvr, "fail to clear arp ip table err:%d\n",
 					  ret);
 				return NOTIFY_OK;
 			}
@@ -827,7 +828,7 @@ static int brcmf_inetaddr_changed(struct notifier_block *nb,
 							       &addr_table[i],
 							       sizeof(addr_table[i]));
 				if (ret)
-					brcmf_err("add arp ip err %d\n",
+					brcmf_err_pub(drvr, "add arp ip err %d\n",
 						  ret);
 			}
 		}
@@ -923,7 +924,7 @@ int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings)
 	/* Attach and link in the protocol */
 	ret = brcmf_proto_attach(drvr);
 	if (ret != 0) {
-		brcmf_err("brcmf_prot_attach failed\n");
+		brcmf_err_pub(drvr, "brcmf_prot_attach failed\n");
 		goto fail;
 	}
 
@@ -1045,7 +1046,7 @@ int brcmf_bus_started(struct device *dev)
 	return 0;
 
 fail:
-	brcmf_err("failed: %d\n", ret);
+	brcmf_err_pub(drvr, "failed: %d\n", ret);
 	if (drvr->config) {
 		brcmf_cfg80211_detach(drvr->config);
 		drvr->config = NULL;
@@ -1152,7 +1153,7 @@ int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
 				 MAX_WAIT_FOR_8021X_TX);
 
 	if (!err)
-		brcmf_err("Timed out waiting for no pending 802.1x packets\n");
+		brcmf_err_pub(ifp->drvr, "Timed out waiting for no pending 802.1x packets\n");
 
 	return !err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 1fe4aa9..aab8c71 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -50,16 +50,23 @@
  * debugging is not selected. When debugging the driver error
  * messages are as important as other tracing or even more so.
  */
-#define brcmf_err(fmt, ...)						\
+#define __brcmf_err(dev, fmt, ...)					\
 	do {								\
 		if (IS_ENABLED(CONFIG_BRCMDBG) || net_ratelimit())	\
-			pr_err("%s: " fmt, __func__, ##__VA_ARGS__);	\
+			dev_err(dev, "%s: " fmt, __func__,		\
+				##__VA_ARGS__);				\
 	} while (0)
+#define brcmf_err(fmt, ...)						\
+	__brcmf_err(NULL, fmt, ##__VA_ARGS__)
+#define brcmf_err_pub(pub, fmt, ...)					\
+	__brcmf_err(pub->bus_if->dev, fmt, ##__VA_ARGS__)
 #else
-__printf(2, 3)
-void __brcmf_err(const char *func, const char *fmt, ...);
+__printf(3, 4)
+void __brcmf_err(struct brcmf_pub *pub, const char *func, const char *fmt, ...);
 #define brcmf_err(fmt, ...) \
-	__brcmf_err(__func__, fmt, ##__VA_ARGS__)
+	__brcmf_err(NULL, __func__, fmt, ##__VA_ARGS__)
+#define brcmf_err_pub(fmt, ...) \
+	__brcmf_err(pub, __func__, fmt, ##__VA_ARGS__)
 #endif
 
 #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
index fe67559..3e8d60b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
@@ -21,7 +21,7 @@
 #include "tracepoint.h"
 #include "debug.h"
 
-void __brcmf_err(const char *func, const char *fmt, ...)
+void __brcmf_err(struct brcmf_pub *pub, const char *func, const char *fmt, ...)
 {
 	struct va_format vaf = {
 		.fmt = fmt,
@@ -30,7 +30,7 @@ void __brcmf_err(const char *func, const char *fmt, ...)
 
 	va_start(args, fmt);
 	vaf.va = &args;
-	pr_err("%s: %pV", func, &vaf);
+	dev_err(pub ? pub->bus_if->dev, NULL, "%s: %pV", func, &vaf);
 	trace_brcmf_err(func, &vaf);
 	va_end(args);
 }
-- 
2.10.1

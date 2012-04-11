Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3443 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab2DKJxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:53:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/9] brcm80211: fmac: make brcmf_net_attach() static
Date: Wed, 11 Apr 2012 11:52:43 +0200
Message-ID: <1334137971-3972-2-git-send-email-arend@broadcom.com> (sfid-20120411_115334_409874_2EFA4772)
In-Reply-To: <1334137971-3972-1-git-send-email-arend@broadcom.com>
References: <1334137971-3972-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_net_attach() is only used within dhd_linux.c so
it does not need to be extern. This patch makes the function static.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 -
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  116 ++++++++++----------
 2 files changed, 58 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 07686a7..9f63701 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -632,7 +632,6 @@ extern const struct bcmevent_name bcmevent_names[];
 extern uint brcmf_c_mkiovar(char *name, char *data, uint datalen,
 			  char *buf, uint len);
 
-extern int brcmf_net_attach(struct brcmf_pub *drvr, int idx);
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
 extern s32 brcmf_exec_dcmd(struct net_device *dev, u32 cmd, void *arg, u32 len);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 2a1e5ae..153d369 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -843,6 +843,64 @@ static const struct net_device_ops brcmf_netdev_ops_pri = {
 	.ndo_set_rx_mode = brcmf_netdev_set_multicast_list
 };
 
+static int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
+{
+	struct net_device *ndev;
+	u8 temp_addr[ETH_ALEN] = {
+		0x00, 0x90, 0x4c, 0x11, 0x22, 0x33};
+
+	brcmf_dbg(TRACE, "ifidx %d\n", ifidx);
+
+	ndev = drvr->iflist[ifidx]->ndev;
+	ndev->netdev_ops = &brcmf_netdev_ops_pri;
+
+	/*
+	 * We have to use the primary MAC for virtual interfaces
+	 */
+	if (ifidx != 0) {
+		/* for virtual interfaces use the primary MAC  */
+		memcpy(temp_addr, drvr->mac, ETH_ALEN);
+
+	}
+
+	if (ifidx == 1) {
+		brcmf_dbg(TRACE, "ACCESS POINT MAC:\n");
+		/*  ACCESSPOINT INTERFACE CASE */
+		temp_addr[0] |= 0X02;	/* set bit 2 ,
+			 - Locally Administered address  */
+
+	}
+	ndev->hard_header_len = ETH_HLEN + drvr->hdrlen;
+	ndev->ethtool_ops = &brcmf_ethtool_ops;
+
+	drvr->rxsz = ndev->mtu + ndev->hard_header_len +
+			      drvr->hdrlen;
+
+	memcpy(ndev->dev_addr, temp_addr, ETH_ALEN);
+
+	/* attach to cfg80211 for primary interface */
+	if (!ifidx) {
+		drvr->config = brcmf_cfg80211_attach(ndev, drvr->dev, drvr);
+		if (drvr->config == NULL) {
+			brcmf_dbg(ERROR, "wl_cfg80211_attach failed\n");
+			goto fail;
+		}
+	}
+
+	if (register_netdev(ndev) != 0) {
+		brcmf_dbg(ERROR, "couldn't register the net device\n");
+		goto fail;
+	}
+
+	brcmf_dbg(INFO, "%s: Broadcom Dongle Host Driver\n", ndev->name);
+
+	return 0;
+
+fail:
+	ndev->netdev_ops = NULL;
+	return -EBADE;
+}
+
 int
 brcmf_add_if(struct device *dev, int ifidx, char *name, u8 *mac_addr)
 {
@@ -1021,64 +1079,6 @@ int brcmf_bus_start(struct device *dev)
 	return 0;
 }
 
-int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
-{
-	struct net_device *ndev;
-	u8 temp_addr[ETH_ALEN] = {
-		0x00, 0x90, 0x4c, 0x11, 0x22, 0x33};
-
-	brcmf_dbg(TRACE, "ifidx %d\n", ifidx);
-
-	ndev = drvr->iflist[ifidx]->ndev;
-	ndev->netdev_ops = &brcmf_netdev_ops_pri;
-
-	/*
-	 * We have to use the primary MAC for virtual interfaces
-	 */
-	if (ifidx != 0) {
-		/* for virtual interfaces use the primary MAC  */
-		memcpy(temp_addr, drvr->mac, ETH_ALEN);
-
-	}
-
-	if (ifidx == 1) {
-		brcmf_dbg(TRACE, "ACCESS POINT MAC:\n");
-		/*  ACCESSPOINT INTERFACE CASE */
-		temp_addr[0] |= 0X02;	/* set bit 2 ,
-			 - Locally Administered address  */
-
-	}
-	ndev->hard_header_len = ETH_HLEN + drvr->hdrlen;
-	ndev->ethtool_ops = &brcmf_ethtool_ops;
-
-	drvr->rxsz = ndev->mtu + ndev->hard_header_len +
-			      drvr->hdrlen;
-
-	memcpy(ndev->dev_addr, temp_addr, ETH_ALEN);
-
-	/* attach to cfg80211 for primary interface */
-	if (!ifidx) {
-		drvr->config = brcmf_cfg80211_attach(ndev, drvr->dev, drvr);
-		if (drvr->config == NULL) {
-			brcmf_dbg(ERROR, "wl_cfg80211_attach failed\n");
-			goto fail;
-		}
-	}
-
-	if (register_netdev(ndev) != 0) {
-		brcmf_dbg(ERROR, "couldn't register the net device\n");
-		goto fail;
-	}
-
-	brcmf_dbg(INFO, "%s: Broadcom Dongle Host Driver\n", ndev->name);
-
-	return 0;
-
-fail:
-	ndev->netdev_ops = NULL;
-	return -EBADE;
-}
-
 static void brcmf_bus_detach(struct brcmf_pub *drvr)
 {
 	brcmf_dbg(TRACE, "Enter\n");
-- 
1.7.5.4



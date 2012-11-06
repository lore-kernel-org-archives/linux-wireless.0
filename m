Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4925 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab2KFAWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:45 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 06/24] brcmfmac: use fwil for netdev callbacks.
Date: Mon, 5 Nov 2012 16:22:14 -0800
Message-ID: <1352161352-30405-7-git-send-email-frankyl@broadcom.com> (sfid-20121106_013117_016617_D8B62E14)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Change setting up multicast, mac address and offloading to use the
refactored firmware interface layer. Remove obsolete brcmf_proto_dcmd
function.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   70 ------
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  256 ++++++--------------
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    3 -
 3 files changed, 70 insertions(+), 259 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index b9d8a5a..601d4d7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -277,76 +277,6 @@ done:
 	return ret;
 }
 
-int
-brcmf_proto_dcmd(struct brcmf_pub *drvr, int ifidx, struct brcmf_dcmd *dcmd,
-		  int len)
-{
-	struct brcmf_proto *prot = drvr->prot;
-	int ret = -1;
-
-	if (drvr->bus_if->state == BRCMF_BUS_DOWN) {
-		brcmf_dbg(ERROR, "bus is down. we have nothing to do.\n");
-		return ret;
-	}
-	mutex_lock(&drvr->proto_block);
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	if (len > BRCMF_DCMD_MAXLEN)
-		goto done;
-
-	if (prot->pending == true) {
-		brcmf_dbg(TRACE, "CDC packet is pending!!!! cmd=0x%x (%lu) lastcmd=0x%x (%lu)\n",
-			  dcmd->cmd, (unsigned long)dcmd->cmd, prot->lastcmd,
-			  (unsigned long)prot->lastcmd);
-		if (dcmd->cmd == BRCMF_C_SET_VAR ||
-		    dcmd->cmd == BRCMF_C_GET_VAR)
-			brcmf_dbg(TRACE, "iovar cmd=%s\n", (char *)dcmd->buf);
-
-		goto done;
-	}
-
-	prot->pending = true;
-	prot->lastcmd = dcmd->cmd;
-	if (dcmd->set)
-		ret = brcmf_proto_cdc_set_dcmd(drvr, ifidx, dcmd->cmd,
-						   dcmd->buf, len);
-	else {
-		ret = brcmf_proto_cdc_query_dcmd(drvr, ifidx, dcmd->cmd,
-						     dcmd->buf, len);
-		if (ret > 0)
-			dcmd->used = ret -
-					sizeof(struct brcmf_proto_cdc_dcmd);
-	}
-
-	if (ret >= 0)
-		ret = 0;
-	else {
-		struct brcmf_proto_cdc_dcmd *msg = &prot->msg;
-		/* len == needed when set/query fails from dongle */
-		dcmd->needed = le32_to_cpu(msg->len);
-	}
-
-	/* Intercept the wme_dp dongle cmd here */
-	if (!ret && dcmd->cmd == BRCMF_C_SET_VAR &&
-	    !strcmp(dcmd->buf, "wme_dp")) {
-		int slen;
-		__le32 val = 0;
-
-		slen = strlen("wme_dp") + 1;
-		if (len >= (int)(slen + sizeof(int)))
-			memcpy(&val, (char *)dcmd->buf + slen, sizeof(int));
-		drvr->wme_dp = (u8) le32_to_cpu(val);
-	}
-
-	prot->pending = false;
-
-done:
-	mutex_unlock(&drvr->proto_block);
-
-	return ret;
-}
-
 static bool pkt_sum_needed(struct sk_buff *skb)
 {
 	return skb->ip_summed == CHECKSUM_PARTIAL;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 2976523..b130f20 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -45,6 +45,7 @@
 #include "dhd_proto.h"
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
+#include "fwil.h"
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN fullmac driver.");
@@ -95,38 +96,35 @@ char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 
 static void _brcmf_set_multicast_list(struct work_struct *work)
 {
+	struct brcmf_if *ifp;
 	struct net_device *ndev;
 	struct netdev_hw_addr *ha;
-	u32 dcmd_value, cnt;
+	u32 cmd_value, cnt;
 	__le32 cnt_le;
-	__le32 dcmd_le_value;
-
-	struct brcmf_dcmd dcmd;
 	char *buf, *bufp;
-	uint buflen;
-	int ret;
-
+	u32 buflen;
+	s32 err;
 	struct brcmf_pub *drvr = container_of(work, struct brcmf_pub,
 						    multicast_work);
 
-	ndev = drvr->iflist[0]->ndev;
-	cnt = netdev_mc_count(ndev);
+	brcmf_dbg(TRACE, "enter\n");
+
+	ifp = drvr->iflist[0];
+	ndev = ifp->ndev;
 
 	/* Determine initial value of allmulti flag */
-	dcmd_value = (ndev->flags & IFF_ALLMULTI) ? true : false;
+	cmd_value = (ndev->flags & IFF_ALLMULTI) ? true : false;
 
 	/* Send down the multicast list first. */
-
-	buflen = sizeof("mcast_list") + sizeof(cnt) + (cnt * ETH_ALEN);
-	bufp = buf = kmalloc(buflen, GFP_ATOMIC);
-	if (!bufp)
+	cnt = netdev_mc_count(ndev);
+	buflen = sizeof(cnt) + (cnt * ETH_ALEN);
+	buf = kmalloc(buflen, GFP_ATOMIC);
+	if (!buf)
 		return;
-
-	strcpy(bufp, "mcast_list");
-	bufp += strlen("mcast_list") + 1;
+	bufp = buf;
 
 	cnt_le = cpu_to_le32(cnt);
-	memcpy(bufp, &cnt_le, sizeof(cnt));
+	memcpy(bufp, &cnt_le, sizeof(cnt_le));
 	bufp += sizeof(cnt_le);
 
 	netdev_for_each_mc_addr(ha, ndev) {
@@ -137,110 +135,55 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 		cnt--;
 	}
 
-	memset(&dcmd, 0, sizeof(dcmd));
-	dcmd.cmd = BRCMF_C_SET_VAR;
-	dcmd.buf = buf;
-	dcmd.len = buflen;
-	dcmd.set = true;
-
-	ret = brcmf_proto_dcmd(drvr, 0, &dcmd, dcmd.len);
-	if (ret < 0) {
-		brcmf_dbg(ERROR, "%s: set mcast_list failed, cnt %d\n",
-			  brcmf_ifname(drvr, 0), cnt);
-		dcmd_value = cnt ? true : dcmd_value;
+	err = brcmf_fil_iovar_data_set(ifp, "mcast_list", buf, buflen);
+	if (err < 0) {
+		brcmf_dbg(ERROR, "Setting mcast_list failed, %d\n", err);
+		cmd_value = cnt ? true : cmd_value;
 	}
 
 	kfree(buf);
 
-	/* Now send the allmulti setting.  This is based on the setting in the
+	/*
+	 * Now send the allmulti setting.  This is based on the setting in the
 	 * net_device flags, but might be modified above to be turned on if we
 	 * were trying to set some addresses and dongle rejected it...
 	 */
-
-	buflen = sizeof("allmulti") + sizeof(dcmd_value);
-	buf = kmalloc(buflen, GFP_ATOMIC);
-	if (!buf)
-		return;
-
-	dcmd_le_value = cpu_to_le32(dcmd_value);
-
-	if (!brcmf_c_mkiovar
-	    ("allmulti", (void *)&dcmd_le_value,
-	    sizeof(dcmd_le_value), buf, buflen)) {
-		brcmf_dbg(ERROR, "%s: mkiovar failed for allmulti, datalen %d buflen %u\n",
-			  brcmf_ifname(drvr, 0),
-			  (int)sizeof(dcmd_value), buflen);
-		kfree(buf);
-		return;
-	}
-
-	memset(&dcmd, 0, sizeof(dcmd));
-	dcmd.cmd = BRCMF_C_SET_VAR;
-	dcmd.buf = buf;
-	dcmd.len = buflen;
-	dcmd.set = true;
-
-	ret = brcmf_proto_dcmd(drvr, 0, &dcmd, dcmd.len);
-	if (ret < 0) {
-		brcmf_dbg(ERROR, "%s: set allmulti %d failed\n",
-			  brcmf_ifname(drvr, 0),
-			  le32_to_cpu(dcmd_le_value));
-	}
-
-	kfree(buf);
-
-	/* Finally, pick up the PROMISC flag as well, like the NIC
-		 driver does */
-
-	dcmd_value = (ndev->flags & IFF_PROMISC) ? true : false;
-	dcmd_le_value = cpu_to_le32(dcmd_value);
-
-	memset(&dcmd, 0, sizeof(dcmd));
-	dcmd.cmd = BRCMF_C_SET_PROMISC;
-	dcmd.buf = &dcmd_le_value;
-	dcmd.len = sizeof(dcmd_le_value);
-	dcmd.set = true;
-
-	ret = brcmf_proto_dcmd(drvr, 0, &dcmd, dcmd.len);
-	if (ret < 0) {
-		brcmf_dbg(ERROR, "%s: set promisc %d failed\n",
-			  brcmf_ifname(drvr, 0),
-			  le32_to_cpu(dcmd_le_value));
-	}
+	err = brcmf_fil_iovar_int_set(ifp, "allmulti", cmd_value);
+	if (err < 0)
+		brcmf_dbg(ERROR, "Setting allmulti failed, %d\n", err);
+
+	/*Finally, pick up the PROMISC flag */
+	cmd_value = (ndev->flags & IFF_PROMISC) ? true : false;
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PROMISC, cmd_value);
+	if (err < 0)
+		brcmf_dbg(ERROR, "Setting BRCMF_C_SET_PROMISC failed, %d\n",
+			  err);
 }
 
 static void
 _brcmf_set_mac_address(struct work_struct *work)
 {
-	char buf[32];
-	struct brcmf_dcmd dcmd;
-	int ret;
+	struct brcmf_if *ifp;
+	struct net_device *ndev;
+	s32 err;
 
 	struct brcmf_pub *drvr = container_of(work, struct brcmf_pub,
 						    setmacaddr_work);
 
 	brcmf_dbg(TRACE, "enter\n");
-	if (!brcmf_c_mkiovar("cur_etheraddr", (char *)drvr->macvalue,
-			   ETH_ALEN, buf, 32)) {
-		brcmf_dbg(ERROR, "%s: mkiovar failed for cur_etheraddr\n",
-			  brcmf_ifname(drvr, 0));
-		return;
-	}
-	memset(&dcmd, 0, sizeof(dcmd));
-	dcmd.cmd = BRCMF_C_SET_VAR;
-	dcmd.buf = buf;
-	dcmd.len = 32;
-	dcmd.set = true;
 
-	ret = brcmf_proto_dcmd(drvr, 0, &dcmd, dcmd.len);
-	if (ret < 0)
-		brcmf_dbg(ERROR, "%s: set cur_etheraddr failed\n",
-			  brcmf_ifname(drvr, 0));
-	else
-		memcpy(drvr->iflist[0]->ndev->dev_addr,
-		       drvr->macvalue, ETH_ALEN);
+	ifp = drvr->iflist[0];
+	ndev = ifp->ndev;
 
-	return;
+	err = brcmf_fil_iovar_data_set(ifp, "cur_etheraddr", drvr->macvalue,
+				       ETH_ALEN);
+	if (err < 0) {
+		brcmf_dbg(ERROR, "Setting cur_etheraddr failed, %d\n", err);
+	} else {
+		brcmf_dbg(TRACE, "MAC address updated to %pM\n",
+			  drvr->macvalue);
+		memcpy(ndev->dev_addr, drvr->macvalue, ETH_ALEN);
+	}
 }
 
 static int brcmf_netdev_set_mac_address(struct net_device *ndev, void *addr)
@@ -487,83 +430,26 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
 	return &ifp->stats;
 }
 
-/* Retrieve current toe component enables, which are kept
-	 as a bitmap in toe_ol iovar */
-static int brcmf_toe_get(struct brcmf_pub *drvr, int ifidx, u32 *toe_ol)
-{
-	struct brcmf_dcmd dcmd;
-	__le32 toe_le;
-	char buf[32];
-	int ret;
-
-	memset(&dcmd, 0, sizeof(dcmd));
-
-	dcmd.cmd = BRCMF_C_GET_VAR;
-	dcmd.buf = buf;
-	dcmd.len = (uint) sizeof(buf);
-	dcmd.set = false;
-
-	strcpy(buf, "toe_ol");
-	ret = brcmf_proto_dcmd(drvr, ifidx, &dcmd, dcmd.len);
-	if (ret < 0) {
-		/* Check for older dongle image that doesn't support toe_ol */
-		if (ret == -EIO) {
-			brcmf_dbg(ERROR, "%s: toe not supported by device\n",
-				  brcmf_ifname(drvr, ifidx));
-			return -EOPNOTSUPP;
-		}
-
-		brcmf_dbg(INFO, "%s: could not get toe_ol: ret=%d\n",
-			  brcmf_ifname(drvr, ifidx), ret);
-		return ret;
-	}
-
-	memcpy(&toe_le, buf, sizeof(u32));
-	*toe_ol = le32_to_cpu(toe_le);
-	return 0;
-}
-
-/* Set current toe component enables in toe_ol iovar,
-	 and set toe global enable iovar */
-static int brcmf_toe_set(struct brcmf_pub *drvr, int ifidx, u32 toe_ol)
+/*
+ * Set current toe component enables in toe_ol iovar,
+ * and set toe global enable iovar
+ */
+static int brcmf_toe_set(struct brcmf_if *ifp, u32 toe_ol)
 {
-	struct brcmf_dcmd dcmd;
-	char buf[32];
-	int ret;
-	__le32 toe_le = cpu_to_le32(toe_ol);
-
-	memset(&dcmd, 0, sizeof(dcmd));
-
-	dcmd.cmd = BRCMF_C_SET_VAR;
-	dcmd.buf = buf;
-	dcmd.len = (uint) sizeof(buf);
-	dcmd.set = true;
-
-	/* Set toe_ol as requested */
-	strcpy(buf, "toe_ol");
-	memcpy(&buf[sizeof("toe_ol")], &toe_le, sizeof(u32));
+	s32 err;
 
-	ret = brcmf_proto_dcmd(drvr, ifidx, &dcmd, dcmd.len);
-	if (ret < 0) {
-		brcmf_dbg(ERROR, "%s: could not set toe_ol: ret=%d\n",
-			  brcmf_ifname(drvr, ifidx), ret);
-		return ret;
+	err = brcmf_fil_iovar_int_set(ifp, "toe_ol", toe_ol);
+	if (err < 0) {
+		brcmf_dbg(ERROR, "Setting toe_ol failed, %d\n", err);
+		return err;
 	}
 
-	/* Enable toe globally only if any components are enabled. */
-	toe_le = cpu_to_le32(toe_ol != 0);
+	err = brcmf_fil_iovar_int_set(ifp, "toe", (toe_ol != 0));
+	if (err < 0)
+		brcmf_dbg(ERROR, "Setting toe failed, %d\n", err);
 
-	strcpy(buf, "toe");
-	memcpy(&buf[sizeof("toe")], &toe_le, sizeof(u32));
-
-	ret = brcmf_proto_dcmd(drvr, ifidx, &dcmd, dcmd.len);
-	if (ret < 0) {
-		brcmf_dbg(ERROR, "%s: could not set toe: ret=%d\n",
-			  brcmf_ifname(drvr, ifidx), ret);
-		return ret;
-	}
+	return err;
 
-	return 0;
 }
 
 static void brcmf_ethtool_get_drvinfo(struct net_device *ndev,
@@ -581,8 +467,9 @@ static const struct ethtool_ops brcmf_ethtool_ops = {
 	.get_drvinfo = brcmf_ethtool_get_drvinfo,
 };
 
-static int brcmf_ethtool(struct brcmf_pub *drvr, void __user *uaddr)
+static int brcmf_ethtool(struct brcmf_if *ifp, void __user *uaddr)
 {
+	struct brcmf_pub *drvr = ifp->drvr;
 	struct ethtool_drvinfo info;
 	char drvname[sizeof(info.driver)];
 	u32 cmd;
@@ -633,7 +520,7 @@ static int brcmf_ethtool(struct brcmf_pub *drvr, void __user *uaddr)
 		/* Get toe offload components from dongle */
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_GTXCSUM:
-		ret = brcmf_toe_get(drvr, 0, &toe_cmpnt);
+		ret = brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_cmpnt);
 		if (ret < 0)
 			return ret;
 
@@ -654,7 +541,7 @@ static int brcmf_ethtool(struct brcmf_pub *drvr, void __user *uaddr)
 			return -EFAULT;
 
 		/* Read the current settings, update and write back */
-		ret = brcmf_toe_get(drvr, 0, &toe_cmpnt);
+		ret = brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_cmpnt);
 		if (ret < 0)
 			return ret;
 
@@ -666,18 +553,16 @@ static int brcmf_ethtool(struct brcmf_pub *drvr, void __user *uaddr)
 		else
 			toe_cmpnt &= ~csum_dir;
 
-		ret = brcmf_toe_set(drvr, 0, toe_cmpnt);
+		ret = brcmf_toe_set(ifp, toe_cmpnt);
 		if (ret < 0)
 			return ret;
 
 		/* If setting TX checksum mode, tell Linux the new mode */
 		if (cmd == ETHTOOL_STXCSUM) {
 			if (edata.data)
-				drvr->iflist[0]->ndev->features |=
-				    NETIF_F_IP_CSUM;
+				ifp->ndev->features |= NETIF_F_IP_CSUM;
 			else
-				drvr->iflist[0]->ndev->features &=
-				    ~NETIF_F_IP_CSUM;
+				ifp->ndev->features &= ~NETIF_F_IP_CSUM;
 		}
 
 		break;
@@ -701,7 +586,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *ndev, struct ifreq *ifr,
 		return -1;
 
 	if (cmd == SIOCETHTOOL)
-		return brcmf_ethtool(drvr, ifr->ifr_data);
+		return brcmf_ethtool(ifp, ifr->ifr_data);
 
 	return -EOPNOTSUPP;
 }
@@ -730,7 +615,6 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	struct brcmf_bus *bus_if = drvr->bus_if;
 	u32 toe_ol;
 	s32 ret = 0;
-	uint up = 0;
 
 	brcmf_dbg(TRACE, "ifidx %d\n", ifp->idx);
 
@@ -746,7 +630,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 		memcpy(ndev->dev_addr, drvr->mac, ETH_ALEN);
 
 		/* Get current TOE mode from dongle */
-		if (brcmf_toe_get(drvr, ifp->idx, &toe_ol) >= 0
+		if (brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_ol) >= 0
 		    && (toe_ol & TOE_TX_CSUM_OL) != 0)
 			drvr->iflist[ifp->idx]->ndev->features |=
 				NETIF_F_IP_CSUM;
@@ -756,7 +640,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	}
 
 	/* make sure RF is ready for work */
-	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_UP, (char *)&up, sizeof(up));
+	brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 0);
 
 	/* Allow transmit calls */
 	netif_start_queue(ndev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
index 7fe6779..9b7969d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
@@ -43,7 +43,4 @@ extern int brcmf_proto_dcmd(struct brcmf_pub *drvr, int ifidx,
 /* Sets dongle media info (drv_version, mac address). */
 extern int brcmf_c_preinit_dcmds(struct brcmf_if *ifp);
 
-extern int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx,
-				     uint cmd, void *buf, uint len);
-
 #endif				/* _BRCMF_PROTO_H_ */
-- 
1.7.9.5



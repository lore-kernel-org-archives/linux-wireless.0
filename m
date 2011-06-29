Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1912 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554Ab1F2Xsu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:50 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 069/119] staging: brcm80211: remove TOE macro definition
Date: Wed, 29 Jun 2011 16:47:33 -0700
Message-ID: <1309391303-22741-70-git-send-email-frankyl@broadcom.com> (sfid-20110630_015112_792973_F7857D0B)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The code conditional by TOE macro is always needed so TOE macro
usage has been removed from the fullmac sources.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile    |    3 +--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   14 --------------
 2 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index c97e5bb..7441649 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -21,8 +21,7 @@ ccflags-y :=			\
 	-DBRCMF_FIRSTREAD=64	\
 	-DBRCMF_SDALIGN=64	\
 	-DMAX_HDR_READ=64	\
-	-DSHOW_EVENTS		\
-	-DTOE
+	-DSHOW_EVENTS
 
 ccflags-$(CONFIG_BRCMDBG)	+= -DDHD_DEBUG
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 8a2c73d..0764d02 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -364,12 +364,8 @@ module_param(brcmf_pktgen_len, uint, 0);
 #endif
 
 static void brcmf_dpc(unsigned long data);
-
-#ifdef TOE
 static int brcmf_toe_get(dhd_info_t *dhd, int idx, u32 *toe_ol);
 static int brcmf_toe_set(dhd_info_t *dhd, int idx, u32 toe_ol);
-#endif				/* TOE */
-
 static int brcmf_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 			     brcmf_event_msg_t *event_ptr, void **data_ptr);
 
@@ -1315,7 +1311,6 @@ void brcmf_sched_dpc(dhd_pub_t *dhdp)
 	tasklet_schedule(&dhd->tasklet);
 }
 
-#ifdef TOE
 /* Retrieve current toe component enables, which are kept
 	 as a bitmap in toe_ol iovar */
 static int brcmf_toe_get(dhd_info_t *dhd, int ifidx, u32 *toe_ol)
@@ -1393,7 +1388,6 @@ static int brcmf_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
 
 	return 0;
 }
-#endif				/* TOE */
 
 static void brcmf_ethtool_get_drvinfo(struct net_device *net,
 				    struct ethtool_drvinfo *info)
@@ -1415,11 +1409,9 @@ static int brcmf_ethtool(dhd_info_t *dhd, void *uaddr)
 	struct ethtool_drvinfo info;
 	char drvname[sizeof(info.driver)];
 	u32 cmd;
-#ifdef TOE
 	struct ethtool_value edata;
 	u32 toe_cmpnt, csum_dir;
 	int ret;
-#endif
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -1464,7 +1456,6 @@ static int brcmf_ethtool(dhd_info_t *dhd, void *uaddr)
 			 (int)sizeof(drvname), drvname, info.driver));
 		break;
 
-#ifdef TOE
 		/* Get toe offload components from dongle */
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_GTXCSUM:
@@ -1516,7 +1507,6 @@ static int brcmf_ethtool(dhd_info_t *dhd, void *uaddr)
 		}
 
 		break;
-#endif				/* TOE */
 
 	default:
 		return -EOPNOTSUPP;
@@ -1665,9 +1655,7 @@ static int brcmf_netdev_stop(struct net_device *net)
 static int brcmf_netdev_open(struct net_device *net)
 {
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
-#ifdef TOE
 	u32 toe_ol;
-#endif
 	int ifidx = brcmf_net2idx(dhd, net);
 	s32 ret = 0;
 
@@ -1685,14 +1673,12 @@ static int brcmf_netdev_open(struct net_device *net)
 
 		memcpy(net->dev_addr, dhd->pub.mac, ETH_ALEN);
 
-#ifdef TOE
 		/* Get current TOE mode from dongle */
 		if (brcmf_toe_get(dhd, ifidx, &toe_ol) >= 0
 		    && (toe_ol & TOE_TX_CSUM_OL) != 0)
 			dhd->iflist[ifidx]->net->features |= NETIF_F_IP_CSUM;
 		else
 			dhd->iflist[ifidx]->net->features &= ~NETIF_F_IP_CSUM;
-#endif
 	}
 	/* Allow transmit calls */
 	netif_start_queue(net);
-- 
1.7.1



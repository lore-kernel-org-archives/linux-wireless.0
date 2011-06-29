Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4636 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758233Ab1F2Xtm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 063/119] staging: brcm80211: remove PKT_FILTER_SUPPORT
 macro definition
Date: Wed, 29 Jun 2011 16:47:27 -0700
Message-ID: <1309391303-22741-64-git-send-email-frankyl@broadcom.com> (sfid-20110630_015306_564306_70A8EC3B)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Packet filtering support is now always compiled into the fullmac
driver.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile     |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd.h        |    2 -
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |   24 +++++++++-------------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |    2 -
 4 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index 8a7cbf3..95d3147 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -26,7 +26,6 @@ ccflags-y :=			\
 	-DEMBEDDED_PLATFORM	\
 	-DMAX_HDR_READ=64	\
 	-DMMC_SDIO_ABORT	\
-	-DPKT_FILTER_SUPPORT	\
 	-DSHOW_EVENTS		\
 	-DTOE
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index fb88c05..65e00a8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -970,11 +970,9 @@ extern int brcmf_bus_start(dhd_pub_t *dhdp);
 extern void brcmf_wait_for_event(dhd_pub_t *dhd, bool * lockvar);
 extern void brcmf_wait_event_wakeup(dhd_pub_t *dhd);
 
-#ifdef PKT_FILTER_SUPPORT
 extern void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg);
 extern void brcmf_c_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg,
 					     int enable, int master_mode);
-#endif
 
 #ifdef BCMDBG
 #define ASSERT(exp) \
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 8f593cf..b481eb3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -1190,6 +1190,7 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 	uint bcn_timeout = 3;
 	int scan_assoc_time = 40;
 	int scan_unassoc_time = 40;
+	int i;
 #ifdef GET_CUSTOM_MAC_ENABLE
 	int ret = 0;
 	u8 ea_addr[ETH_ALEN];
@@ -1288,22 +1289,17 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 		brcmf_c_arp_offload_set(dhd, brcmf_arp_mode);
 	brcmf_c_arp_offload_enable(dhd, brcmf_arp_enable);
 
-#ifdef PKT_FILTER_SUPPORT
-	{
-		int i;
-		/* Set up pkt filter */
-		if (brcmf_pkt_filter_enable) {
-			for (i = 0; i < dhd->pktfilter_count; i++) {
-				brcmf_c_pktfilter_offload_set(dhd,
-							  dhd->pktfilter[i]);
-				brcmf_c_pktfilter_offload_enable(dhd,
-				     dhd->pktfilter[i],
-				     brcmf_pkt_filter_init,
-				     brcmf_master_mode);
-			}
+	/* Set up pkt filter */
+	if (brcmf_pkt_filter_enable) {
+		for (i = 0; i < dhd->pktfilter_count; i++) {
+			brcmf_c_pktfilter_offload_set(dhd,
+						  dhd->pktfilter[i]);
+			brcmf_c_pktfilter_offload_enable(dhd,
+			     dhd->pktfilter[i],
+			     brcmf_pkt_filter_init,
+			     brcmf_master_mode);
 		}
 	}
-#endif				/* PKT_FILTER_SUPPORT */
 
 	brcmf_os_proto_unblock(dhd);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 9ee4866..c3a0e94 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -375,7 +375,6 @@ static int brcmf_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 
 static void brcmf_set_packet_filter(int value, dhd_pub_t *dhd)
 {
-#ifdef PKT_FILTER_SUPPORT
 	DHD_TRACE(("%s: %d\n", __func__, value));
 	/* 1 - Enable packet filter, only allow unicast packet to send up */
 	/* 0 - Disable packet filter */
@@ -388,7 +387,6 @@ static void brcmf_set_packet_filter(int value, dhd_pub_t *dhd)
 						     value, brcmf_master_mode);
 		}
 	}
-#endif
 }
 
 #if defined(CONFIG_HAS_EARLYSUSPEND)
-- 
1.7.1



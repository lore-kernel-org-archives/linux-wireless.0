Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4829 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759572Ab1KWBWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:15 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 13/24] brcm80211: fmac: remove function brcmf_c_init
Date: Tue, 22 Nov 2011 17:21:48 -0800
Message-ID: <1322011319-24863-14-git-send-email-frankyl@broadcom.com> (sfid-20111123_022229_716982_90FAF1DA)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmf_c_init only init brcmf_msg_level used for debug. It's no longer
needed as brcmf_msg_level doesn't cause trouble to multiple instances.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 --
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   15 ---------------
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   10 ----------
 4 files changed, 1 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 7962f64..046a9e4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -733,8 +733,6 @@ extern int brcmf_c_host_event(struct brcmf_info *drvr_priv, int *idx,
 			      void *pktdata, struct brcmf_event_msg *,
 			      void **data_ptr);
 
-extern void brcmf_c_init(void);
-
 extern int brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx,
 			char *name, u8 *mac_addr);
 extern void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 40928e5..69f335a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -32,8 +32,6 @@
 #define PKTFILTER_BUF_SIZE		2048
 #define BRCMF_ARPOL_MODE		0xb	/* agent|snoop|peer_autoreply */
 
-int brcmf_msg_level;
-
 #define MSGTRACE_VERSION	1
 
 #define BRCMF_PKT_FILTER_FIXED_LEN	offsetof(struct brcmf_pkt_filter_le, u)
@@ -85,19 +83,6 @@ brcmf_c_mkiovar(char *name, char *data, uint datalen, char *buf, uint buflen)
 	return len;
 }
 
-void brcmf_c_init(void)
-{
-	/* Init global variables at run-time, not as part of the declaration.
-	 * This is required to support init/de-init of the driver.
-	 * Initialization
-	 * of globals as part of the declaration results in non-deterministic
-	 * behaviour since the value of the globals may be different on the
-	 * first time that the driver is initialized vs subsequent
-	 * initializations.
-	 */
-	brcmf_msg_level = BRCMF_ERROR_VAL;
-}
-
 bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 		      struct sk_buff *pkt, int prec)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 73d32802..683a7ed 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -76,6 +76,7 @@ struct brcmf_info {
 };
 
 /* Error bits */
+int brcmf_msg_level = BRCMF_ERROR_VAL;
 module_param(brcmf_msg_level, int, 0);
 
 int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 1f3e319..8acd1bb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3867,16 +3867,6 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	int ret;
 	struct brcmf_bus *bus;
 
-	/* Init global variables at run-time, not as part of the declaration.
-	 * This is required to support init/de-init of the driver.
-	 * Initialization
-	 * of globals as part of the declaration results in non-deterministic
-	 * behavior since the value of the globals may be different on the
-	 * first time that the driver is initialized vs subsequent
-	 * initializations.
-	 */
-	brcmf_c_init();
-
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* We make an assumption about address window mappings:
-- 
1.7.5.4



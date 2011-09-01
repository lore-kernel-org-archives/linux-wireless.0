Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2963 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab1IAJRn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:43 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 20/30] staging: brcm80211: use static qualifier for
 local symbols in brcmfmac
Date: Thu, 1 Sep 2011 11:17:10 +0200
Message-ID: <1314868640-9425-21-git-send-email-rvossen@broadcom.com> (sfid-20110901_111832_621685_DDE53F41)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Cleanup resulted in merging several files and made several symbols
local to a source file. These were found by running sparse as it
gave the warning: symbol 'foo' was not declared. Should it be static?

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    2 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   10 +++++-----
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |   15 ++++++++-------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   11 +----------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   10 +++++-----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |    5 +++--
 6 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index e35c56a..2490dde 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -49,7 +49,7 @@ enum {
 	IOV_RXCHAIN
 };
 
-const struct brcmu_iovar sdioh_iovars[] = {
+static const struct brcmu_iovar sdioh_iovars[] = {
 	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
 	,
 	{"sd_rxchain", IOV_RXCHAIN, 0, IOVT_BOOL, 0}
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index fd34dd4..5482005 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -50,10 +50,10 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
 
 #ifdef CONFIG_PM_SLEEP
-DECLARE_WAIT_QUEUE_HEAD(sdioh_request_byte_wait);
-DECLARE_WAIT_QUEUE_HEAD(sdioh_request_word_wait);
-DECLARE_WAIT_QUEUE_HEAD(sdioh_request_packet_wait);
-DECLARE_WAIT_QUEUE_HEAD(sdioh_request_buffer_wait);
+static DECLARE_WAIT_QUEUE_HEAD(sdioh_request_byte_wait);
+static DECLARE_WAIT_QUEUE_HEAD(sdioh_request_word_wait);
+static DECLARE_WAIT_QUEUE_HEAD(sdioh_request_packet_wait);
+static DECLARE_WAIT_QUEUE_HEAD(sdioh_request_buffer_wait);
 #endif		/* CONFIG_PM_SLEEP */
 
 static bool
@@ -379,7 +379,7 @@ brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 }
 
 /* Read client card reg */
-int
+static int
 brcmf_sdioh_card_regread(struct brcmf_sdio_dev *sdiodev, int func, u32 regaddr,
 			 int regsize, u32 *data)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index e5214b2..3abd434 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -36,11 +36,12 @@ int brcmf_msg_level;
 #define MSGTRACE_VERSION	1
 
 #ifdef BCMDBG
-const char brcmf_version[] =
-"Dongle Host Driver, version " BRCMF_VERSION_STR "\nCompiled on " __DATE__
-" at " __TIME__;
+static const char brcmf_version[] =
+	"Dongle Host Driver, version " BRCMF_VERSION_STR "\nCompiled on "
+	__DATE__ " at " __TIME__;
 #else
-const char brcmf_version[] = "Dongle Host Driver, version " BRCMF_VERSION_STR;
+static const char brcmf_version[] =
+	"Dongle Host Driver, version " BRCMF_VERSION_STR;
 #endif
 
 /* IOVar table */
@@ -58,7 +59,7 @@ enum {
 	IOV_LAST
 };
 
-const struct brcmu_iovar brcmf_iovars[] = {
+static const struct brcmu_iovar brcmf_iovars[] = {
 	{"version", IOV_VERSION, 0, IOVT_BUFFER, sizeof(brcmf_version)}
 	,
 #ifdef BCMDBG
@@ -1038,7 +1039,7 @@ fail:
 	kfree(buf);
 }
 
-void brcmf_c_arp_offload_set(struct brcmf_pub *drvr, int arp_mode)
+static void brcmf_c_arp_offload_set(struct brcmf_pub *drvr, int arp_mode)
 {
 	char iovbuf[32];
 	int retcode;
@@ -1055,7 +1056,7 @@ void brcmf_c_arp_offload_set(struct brcmf_pub *drvr, int arp_mode)
 			  arp_mode);
 }
 
-void brcmf_c_arp_offload_enable(struct brcmf_pub *drvr, int arp_enable)
+static void brcmf_c_arp_offload_enable(struct brcmf_pub *drvr, int arp_enable)
 {
 	char iovbuf[32];
 	int retcode;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 7121b16..470759a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -831,7 +831,7 @@ static void brcmf_ethtool_get_drvinfo(struct net_device *net,
 		dev_name(&brcmf_cfg80211_get_sdio_func()->dev));
 }
 
-struct ethtool_ops brcmf_ethtool_ops = {
+static struct ethtool_ops brcmf_ethtool_ops = {
 	.get_drvinfo = brcmf_ethtool_get_drvinfo
 };
 
@@ -1494,15 +1494,6 @@ int brcmf_os_proto_unblock(struct brcmf_pub *drvr)
 	return 0;
 }
 
-int brcmf_netdev_reset(struct net_device *dev, u8 flag)
-{
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **)netdev_priv(dev);
-
-	brcmf_bus_devreset(&drvr_priv->pub, flag);
-
-	return 1;
-}
-
 static int brcmf_get_pend_8021x_cnt(struct brcmf_info *drvr_priv)
 {
 	return atomic_read(&drvr_priv->pend_8021x_cnt);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 49914c6..8e4e0d0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -769,7 +769,7 @@ uint brcmf_txbound;
 uint brcmf_rxbound;
 module_param(brcmf_txbound, uint, 0);
 module_param(brcmf_rxbound, uint, 0);
-uint brcmf_txminmax;
+static uint brcmf_txminmax;
 
 int brcmf_idletime = 1;
 module_param(brcmf_idletime, int, 0);
@@ -1151,7 +1151,7 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
 	return 0;
 }
 
-int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
+static int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 {
 	uint retries = 0;
 
@@ -1765,7 +1765,7 @@ enum {
 	IOV_VARS
 };
 
-const struct brcmu_iovar brcmf_sdio_iovars[] = {
+static const struct brcmu_iovar brcmf_sdio_iovars[] = {
 	{"intr", IOV_INTR, 0, IOVT_BOOL, 0},
 	{"sleep", IOV_SLEEP, 0, IOVT_BOOL, 0},
 	{"pollrate", IOV_POLLRATE, 0, IOVT_UINT32, 0},
@@ -2287,7 +2287,7 @@ break2:
 }
 #endif				/* BCMDBG */
 
-int brcmf_sdbrcm_downloadvars(struct brcmf_bus *bus, void *arg, int len)
+static int brcmf_sdbrcm_downloadvars(struct brcmf_bus *bus, void *arg, int len)
 {
 	int bcmerror = 0;
 
@@ -4497,7 +4497,7 @@ void brcmf_sdbrcm_isr(void *arg)
 	brcmf_sdbrcm_sched_dpc(bus);
 }
 
-extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
+static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 {
 	struct brcmf_bus *bus;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 9010ce7..60a04b3 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -38,7 +38,7 @@ static struct sdio_func *cfg80211_sdio_func;
 static struct brcmf_cfg80211_dev *cfg80211_dev;
 static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 
-u32 brcmf_dbg_level = WL_DBG_ERR;
+static u32 brcmf_dbg_level = WL_DBG_ERR;
 
 /*
 ** cfg80211_ops api/callback list
@@ -3830,7 +3830,8 @@ dongle_scantime_out:
 	return err;
 }
 
-s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv, bool need_lock)
+static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv,
+			       bool need_lock)
 {
 	struct net_device *ndev;
 	struct wireless_dev *wdev;
-- 
1.7.4.1



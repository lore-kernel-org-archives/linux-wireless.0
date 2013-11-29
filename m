Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1064 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab3K2LZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/19] brcmfmac: provide firmware version in ethtool
 driver info
Date: Fri, 29 Nov 2013 12:25:17 +0100
Message-ID: <1385724324-6361-13-git-send-email-arend@broadcom.com> (sfid-20131129_122547_719961_B102D229)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Knowing the firmware version is pretty useful information when
looking at issues. It is retrieved during initialization so
store it in driver data structure to fill the ethtool driver
info when requested.

Reviewed-by: Hante Meuleman <meuleman@brodcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h        |    7 ++++++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c |    5 +++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c  |    4 ++--
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 4ed7a97..714194c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -211,6 +211,11 @@
 
 #define BRCMF_AMPDU_RX_REORDER_MAXFLOWS		256
 
+/* Length of firmware version string stored for
+ * ethtool driver info which uses 32 bytes as well.
+ */
+#define BRCMF_DRIVER_FIRMWARE_VERSION_LEN	32
+
 /* Pattern matching filter. Specifies an offset within received packets to
  * start matching, the pattern to match, the size of the pattern, and a bitmask
  * that indicates which bits within the pattern should be matched.
@@ -544,7 +549,7 @@ struct brcmf_pub {
 	u8 wme_dp;		/* wme discard priority */
 
 	/* Dongle media info */
-	unsigned long drv_version;	/* Version of dongle-resident driver */
+	char fwver[BRCMF_DRIVER_FIRMWARE_VERSION_LEN];
 	u8 mac[ETH_ALEN];		/* MAC address obtained from dongle */
 
 	/* Multicast data packets sent to dongle */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 6017633..d5811a4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -278,9 +278,14 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	}
 	ptr = (char *)buf;
 	strsep(&ptr, "\n");
+
 	/* Print fw version info */
 	brcmf_err("Firmware version = %s\n", buf);
 
+	/* locate firmware version number for ethtool */
+	ptr = strrchr(buf, ' ') + 1;
+	strlcpy(ifp->drvr->fwver, ptr, sizeof(ifp->drvr->fwver));
+
 	/*
 	 * Setup timeout if Beacons are lost and roam is off to report
 	 * link down
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 644e62e..bce0b8e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -599,8 +599,8 @@ static void brcmf_ethtool_get_drvinfo(struct net_device *ndev,
 	struct brcmf_pub *drvr = ifp->drvr;
 
 	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	snprintf(info->version, sizeof(info->version), "%lu",
-		 drvr->drv_version);
+	snprintf(info->version, sizeof(info->version), "n/a");
+	strlcpy(info->fw_version, drvr->fwver, sizeof(info->fw_version));
 	strlcpy(info->bus_info, dev_name(drvr->bus_if->dev),
 		sizeof(info->bus_info));
 }
-- 
1.7.10.4



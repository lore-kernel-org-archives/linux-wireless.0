Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:40587 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759954AbbAYTbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:52 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 12/14] brcmfmac: show firmware release info in ethtool driver info
Date: Sun, 25 Jan 2015 20:31:41 +0100
Message-ID: <1422214303-7816-13-git-send-email-arend@broadcom.com> (sfid-20150125_203213_582004_2FDFBF1A)
In-Reply-To: <1422214303-7816-1-git-send-email-arend@broadcom.com>
References: <1422214303-7816-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ethtool driver info already contained the unique firmware
identifier. This patch adds the firmware release version.

   $ ethtool -i wlan4
   driver: brcmfmac
   version: 6.10.224.22
   firmware-version: 01-32bd010f

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/core.c     |  4 +++-
 drivers/net/wireless/brcm80211/brcmutil/utils.c    | 27 ++++++++++++++++++++++
 .../net/wireless/brcm80211/include/brcmu_utils.h   |  2 ++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 6406f95..8d03588 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -601,9 +601,11 @@ static void brcmf_ethtool_get_drvinfo(struct net_device *ndev,
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
+	char drev[BRCMU_DOTREV_LEN];
 
 	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	snprintf(info->version, sizeof(info->version), "n/a");
+	strlcpy(info->version, brcmu_dotrev_str(drvr->revinfo.driverrev, drev),
+		sizeof(info->version));
 	strlcpy(info->fw_version, drvr->fwver, sizeof(info->fw_version));
 	strlcpy(info->bus_info, dev_name(drvr->bus_if->dev),
 		sizeof(info->bus_info));
diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index 34937d8..0543607 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -277,6 +277,33 @@ char *brcmu_boardrev_str(u32 brev, char *buf)
 }
 EXPORT_SYMBOL(brcmu_boardrev_str);
 
+char *brcmu_dotrev_str(u32 dotrev, char *buf)
+{
+	u8 dotval[4];
+
+	if (!dotrev) {
+		snprintf(buf, BRCMU_DOTREV_LEN, "unknown");
+		return buf;
+	}
+	dotval[0] = (dotrev >> 24) & 0xFF;
+	dotval[1] = (dotrev >> 16) & 0xFF;
+	dotval[2] = (dotrev >> 8) & 0xFF;
+	dotval[3] = dotrev & 0xFF;
+
+	if (dotval[3])
+		snprintf(buf, BRCMU_DOTREV_LEN, "%d.%d.%d.%d", dotval[0],
+			dotval[1], dotval[2], dotval[3]);
+	else if (dotval[2])
+		snprintf(buf, BRCMU_DOTREV_LEN, "%d.%d.%d", dotval[0],
+			dotval[1], dotval[2]);
+	else
+		snprintf(buf, BRCMU_DOTREV_LEN, "%d.%d", dotval[0],
+			dotval[1]);
+
+	return buf;
+}
+EXPORT_SYMBOL(brcmu_dotrev_str);
+
 #if defined(DEBUG)
 /* pretty hex print a pkt buffer chain */
 void brcmu_prpkt(const char *msg, struct sk_buff *p0)
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index 197317b..4196952 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -219,7 +219,9 @@ void brcmu_dbg_hex_dump(const void *data, size_t size, const char *fmt, ...)
 #endif
 
 #define BRCMU_BOARDREV_LEN	8
+#define BRCMU_DOTREV_LEN	16
 
 char *brcmu_boardrev_str(u32 brev, char *buf);
+char *brcmu_dotrev_str(u32 dotrev, char *buf);
 
 #endif				/* _BRCMU_UTILS_H_ */
-- 
1.9.1


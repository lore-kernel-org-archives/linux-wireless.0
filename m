Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:3886 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759949AbbAYTbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:50 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 10/14] brcmfmac: determine chip info when not provided by bus layer
Date: Sun, 25 Jan 2015 20:31:39 +0100
Message-ID: <1422214303-7816-11-git-send-email-arend@broadcom.com> (sfid-20150125_203239_509445_341EF2AC)
In-Reply-To: <1422214303-7816-1-git-send-email-arend@broadcom.com>
References: <1422214303-7816-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some scenarios the chip number and revision may not be provided
by the bus layer. If the chip number is not filled, the common
layer will ask the firmware for this information.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/core.c     | 15 ++++++++
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |  1 +
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   | 41 ++++++++++++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index b8520c3..5f16a7e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -948,6 +948,7 @@ int brcmf_bus_start(struct device *dev)
 	struct brcmf_pub *drvr = bus_if->drvr;
 	struct brcmf_if *ifp;
 	struct brcmf_if *p2p_ifp;
+	struct brcmf_rev_info_le revinfo;
 
 	brcmf_dbg(TRACE, "\n");
 
@@ -971,6 +972,20 @@ int brcmf_bus_start(struct device *dev)
 	if (ret < 0)
 		goto fail;
 
+	/* assure we have chipid before feature attach */
+	if (!bus_if->chip) {
+		ret = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_REVINFO, &revinfo,
+					     sizeof(revinfo));
+		if (ret < 0) {
+			brcmf_err("no chipid determined - device may malfunction\n");
+		} else {
+			bus_if->chip = le32_to_cpu(revinfo.chipnum);
+			bus_if->chiprev = le32_to_cpu(revinfo.chiprev);
+			brcmf_dbg(INFO, "firmware revinfo: chip %x (%d) rev %d\n",
+				  bus_if->chip, bus_if->chip,
+				  bus_if->chiprev);
+		}
+	}
 	brcmf_feat_attach(drvr);
 
 	ret = brcmf_fws_init(drvr);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
index 37345e7..5434dcf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
@@ -59,6 +59,7 @@
 #define BRCMF_C_SET_COUNTRY			84
 #define BRCMF_C_GET_PM				85
 #define BRCMF_C_SET_PM				86
+#define BRCMF_C_GET_REVINFO			98
 #define BRCMF_C_GET_CURR_RATESET		114
 #define BRCMF_C_GET_AP				117
 #define BRCMF_C_SET_AP				118
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index 619669b..3749209 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -539,4 +539,45 @@ struct brcmf_fil_country_le {
 	char ccode[BRCMF_COUNTRY_BUF_SZ];
 };
 
+/**
+ * struct brcmf_rev_info_le - device revision info.
+ *
+ * @vendorid: PCI vendor id.
+ * @deviceid: device id of chip.
+ * @radiorev: radio revision.
+ * @chiprev: chip revision.
+ * @corerev: core revision.
+ * @boardid: board identifier (usu. PCI sub-device id).
+ * @boardvendor: board vendor (usu. PCI sub-vendor id).
+ * @boardrev: board revision.
+ * @driverrev: driver version.
+ * @ucoderev: microcode version.
+ * @bus: bus type.
+ * @chipnum: chip number.
+ * @phytype: phy type.
+ * @phyrev: phy revision.
+ * @anarev: anacore rev.
+ * @chippkg: chip package info.
+ * @nvramrev: nvram revision number.
+ */
+struct brcmf_rev_info_le {
+	__le32 vendorid;
+	__le32 deviceid;
+	__le32 radiorev;
+	__le32 chiprev;
+	__le32 corerev;
+	__le32 boardid;
+	__le32 boardvendor;
+	__le32 boardrev;
+	__le32 driverrev;
+	__le32 ucoderev;
+	__le32 bus;
+	__le32 chipnum;
+	__le32 phytype;
+	__le32 phyrev;
+	__le32 anarev;
+	__le32 chippkg;
+	__le32 nvramrev;
+};
+
 #endif /* FWIL_TYPES_H_ */
-- 
1.9.1


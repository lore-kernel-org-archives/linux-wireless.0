Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:7421 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759943AbbAYTbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:52 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 11/14] brcmfmac: always obtain device revision info upon intialization
Date: Sun, 25 Jan 2015 20:31:40 +0100
Message-ID: <1422214303-7816-12-git-send-email-arend@broadcom.com> (sfid-20150125_203224_213553_CCBDEA80)
In-Reply-To: <1422214303-7816-1-git-send-email-arend@broadcom.com>
References: <1422214303-7816-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Obtain device revision information and store it.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/common.c | 30 ++++++++++++++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/core.c   | 16 ++++---------
 drivers/net/wireless/brcm80211/brcmfmac/core.h   | 22 +++++++++++++++++
 3 files changed, 54 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/common.c b/drivers/net/wireless/brcm80211/brcmfmac/common.c
index ddf05af..91213a6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/common.c
@@ -41,6 +41,8 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
 	u8 buf[BRCMF_DCMD_SMLEN];
 	struct brcmf_join_pref_params join_pref_params[2];
+	struct brcmf_rev_info_le revinfo;
+	struct brcmf_rev_info *ri;
 	char *ptr;
 	s32 err;
 
@@ -48,12 +50,36 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_get(ifp, "cur_etheraddr", ifp->mac_addr,
 				       sizeof(ifp->mac_addr));
 	if (err < 0) {
-		brcmf_err("Retreiving cur_etheraddr failed, %d\n",
-			  err);
+		brcmf_err("Retreiving cur_etheraddr failed, %d\n", err);
 		goto done;
 	}
 	memcpy(ifp->drvr->mac, ifp->mac_addr, sizeof(ifp->drvr->mac));
 
+	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_REVINFO,
+				     &revinfo, sizeof(revinfo));
+	if (err < 0) {
+		brcmf_err("retrieving revision info failed, %d\n", err);
+	} else {
+		ri = &ifp->drvr->revinfo;
+		ri->vendorid = le32_to_cpu(revinfo.vendorid);
+		ri->deviceid = le32_to_cpu(revinfo.deviceid);
+		ri->radiorev = le32_to_cpu(revinfo.radiorev);
+		ri->chiprev = le32_to_cpu(revinfo.chiprev);
+		ri->corerev = le32_to_cpu(revinfo.corerev);
+		ri->boardid = le32_to_cpu(revinfo.boardid);
+		ri->boardvendor = le32_to_cpu(revinfo.boardvendor);
+		ri->boardrev = le32_to_cpu(revinfo.boardrev);
+		ri->driverrev = le32_to_cpu(revinfo.driverrev);
+		ri->ucoderev = le32_to_cpu(revinfo.ucoderev);
+		ri->bus = le32_to_cpu(revinfo.bus);
+		ri->chipnum = le32_to_cpu(revinfo.chipnum);
+		ri->phytype = le32_to_cpu(revinfo.phytype);
+		ri->phyrev = le32_to_cpu(revinfo.phyrev);
+		ri->anarev = le32_to_cpu(revinfo.anarev);
+		ri->chippkg = le32_to_cpu(revinfo.chippkg);
+		ri->nvramrev = le32_to_cpu(revinfo.nvramrev);
+	}
+
 	/* query for 'ver' to get version info from firmware */
 	memset(buf, 0, sizeof(buf));
 	strcpy(buf, "ver");
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 5f16a7e..6406f95 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -948,7 +948,6 @@ int brcmf_bus_start(struct device *dev)
 	struct brcmf_pub *drvr = bus_if->drvr;
 	struct brcmf_if *ifp;
 	struct brcmf_if *p2p_ifp;
-	struct brcmf_rev_info_le revinfo;
 
 	brcmf_dbg(TRACE, "\n");
 
@@ -974,17 +973,10 @@ int brcmf_bus_start(struct device *dev)
 
 	/* assure we have chipid before feature attach */
 	if (!bus_if->chip) {
-		ret = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_REVINFO, &revinfo,
-					     sizeof(revinfo));
-		if (ret < 0) {
-			brcmf_err("no chipid determined - device may malfunction\n");
-		} else {
-			bus_if->chip = le32_to_cpu(revinfo.chipnum);
-			bus_if->chiprev = le32_to_cpu(revinfo.chiprev);
-			brcmf_dbg(INFO, "firmware revinfo: chip %x (%d) rev %d\n",
-				  bus_if->chip, bus_if->chip,
-				  bus_if->chiprev);
-		}
+		bus_if->chip = drvr->revinfo.chipnum;
+		bus_if->chiprev = drvr->revinfo.chiprev;
+		brcmf_dbg(INFO, "firmware revinfo: chip %x (%d) rev %d\n",
+			  bus_if->chip, bus_if->chip, bus_if->chiprev);
 	}
 	brcmf_feat_attach(drvr);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index f2f7d3d..db7f35f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -71,6 +71,27 @@ struct brcmf_proto;	/* device communication protocol info */
 struct brcmf_cfg80211_dev; /* cfg80211 device info */
 struct brcmf_fws_info; /* firmware signalling info */
 
+/* see struct brcmf_rev_info_le in fwil_types.h */
+struct brcmf_rev_info {
+	u32 vendorid;
+	u32 deviceid;
+	u32 radiorev;
+	u32 chiprev;
+	u32 corerev;
+	u32 boardid;
+	u32 boardvendor;
+	u32 boardrev;
+	u32 driverrev;
+	u32 ucoderev;
+	u32 bus;
+	u32 chipnum;
+	u32 phytype;
+	u32 phyrev;
+	u32 anarev;
+	u32 chippkg;
+	u32 nvramrev;
+};
+
 /* Common structure for module and instance linkage */
 struct brcmf_pub {
 	/* Linkage ponters */
@@ -104,6 +125,7 @@ struct brcmf_pub {
 	u32 feat_flags;
 	u32 chip_quirks;
 
+	struct brcmf_rev_info revinfo;
 #ifdef DEBUG
 	struct dentry *dbgfs_dir;
 #endif
-- 
1.9.1


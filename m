Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:46094 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753106AbeCPKMJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 06:12:09 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 02/12] brcmfmac: use brcmf_chip_name() to store name in revinfo
Date: Fri, 16 Mar 2018 11:11:15 +0100
Message-Id: <1521195085-439-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180316_111226_965667_B0D2E72C)
In-Reply-To: <1521195085-439-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1521195085-439-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chip id can either be four or five digits. For the chip name either
the hexadecimal value needs to be taken (four digits) or the decimal
value (five digits). The function brcmf_chip_name() does this conversion
so use it to store the name in driver revision info.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  9 +++++----
 .../wireless/broadcom/brcm80211/brcmfmac/chip.h    |  3 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 23 ++++++++++++++++------
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 10 +---------
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  3 +--
 5 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index f7b30ce..bf45369 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -464,12 +464,12 @@ static void brcmf_chip_ai_resetcore(struct brcmf_core_priv *core, u32 prereset,
 	ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
 }
 
-static char *brcmf_chip_name(uint chipid, char *buf, uint len)
+char *brcmf_chip_name(u32 id, u32 rev, char *buf, uint len)
 {
 	const char *fmt;
 
-	fmt = ((chipid > 0xa000) || (chipid < 0x4000)) ? "%d" : "%x";
-	snprintf(buf, len, fmt, chipid);
+	fmt = ((id > 0xa000) || (id < 0x4000)) ? "BCM%d/%u" : "BCM%x/%u";
+	snprintf(buf, len, fmt, id, rev);
 	return buf;
 }
 
@@ -924,7 +924,8 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 	ci->pub.chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
 	socitype = (regdata & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
 
-	brcmf_chip_name(ci->pub.chip, ci->pub.name, sizeof(ci->pub.name));
+	brcmf_chip_name(ci->pub.chip, ci->pub.chiprev,
+			ci->pub.name, sizeof(ci->pub.name));
 	brcmf_dbg(INFO, "found %s chip: BCM%s, rev=%d\n",
 		  socitype == SOCI_SB ? "SB" : "AXI", ci->pub.name,
 		  ci->pub.chiprev);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
index dd0ec3e..0ae3b33 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
@@ -45,7 +45,7 @@ struct brcmf_chip {
 	u32 rambase;
 	u32 ramsize;
 	u32 srsize;
-	char name[8];
+	char name[12];
 };
 
 /**
@@ -93,5 +93,6 @@ void brcmf_chip_resetcore(struct brcmf_core *core, u32 prereset, u32 reset,
 void brcmf_chip_set_passive(struct brcmf_chip *ci);
 bool brcmf_chip_set_active(struct brcmf_chip *ci, u32 rstvec);
 bool brcmf_chip_sr_capable(struct brcmf_chip *pub);
+char *brcmf_chip_name(u32 chipid, u32 chiprev, char *buf, uint len);
 
 #endif /* BRCMF_AXIDMP_H */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 70ef983..09601f8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -30,6 +30,7 @@
 #include "common.h"
 #include "of.h"
 #include "firmware.h"
+#include "chip.h"
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
@@ -127,14 +128,13 @@ static int brcmf_c_download(struct brcmf_if *ifp, u16 flag,
 static int brcmf_c_get_clm_name(struct brcmf_if *ifp, u8 *clm_name)
 {
 	struct brcmf_bus *bus = ifp->drvr->bus_if;
-	struct brcmf_rev_info *ri = &ifp->drvr->revinfo;
 	u8 fw_name[BRCMF_FW_NAME_LEN];
 	u8 *ptr;
 	size_t len;
 	s32 err;
 
 	memset(fw_name, 0, BRCMF_FW_NAME_LEN);
-	err = brcmf_bus_get_fwname(bus, ri->chipnum, ri->chiprev, fw_name);
+	err = brcmf_bus_get_fwname(bus, bus->chip, bus->chiprev, fw_name);
 	if (err) {
 		brcmf_err("get firmware name failed (%d)\n", err);
 		goto done;
@@ -234,6 +234,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 {
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
 	u8 buf[BRCMF_DCMD_SMLEN];
+	struct brcmf_bus *bus;
 	struct brcmf_rev_info_le revinfo;
 	struct brcmf_rev_info *ri;
 	char *clmver;
@@ -249,16 +250,18 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	}
 	memcpy(ifp->drvr->mac, ifp->mac_addr, sizeof(ifp->drvr->mac));
 
+	bus = ifp->drvr->bus_if;
+	ri = &ifp->drvr->revinfo;
+
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_REVINFO,
 				     &revinfo, sizeof(revinfo));
-	ri = &ifp->drvr->revinfo;
 	if (err < 0) {
 		brcmf_err("retrieving revision info failed, %d\n", err);
+		strlcpy(ri->chipname, "UNKNOWN", sizeof(ri->chipname));
 	} else {
 		ri->vendorid = le32_to_cpu(revinfo.vendorid);
 		ri->deviceid = le32_to_cpu(revinfo.deviceid);
 		ri->radiorev = le32_to_cpu(revinfo.radiorev);
-		ri->chiprev = le32_to_cpu(revinfo.chiprev);
 		ri->corerev = le32_to_cpu(revinfo.corerev);
 		ri->boardid = le32_to_cpu(revinfo.boardid);
 		ri->boardvendor = le32_to_cpu(revinfo.boardvendor);
@@ -266,15 +269,23 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		ri->driverrev = le32_to_cpu(revinfo.driverrev);
 		ri->ucoderev = le32_to_cpu(revinfo.ucoderev);
 		ri->bus = le32_to_cpu(revinfo.bus);
-		ri->chipnum = le32_to_cpu(revinfo.chipnum);
 		ri->phytype = le32_to_cpu(revinfo.phytype);
 		ri->phyrev = le32_to_cpu(revinfo.phyrev);
 		ri->anarev = le32_to_cpu(revinfo.anarev);
 		ri->chippkg = le32_to_cpu(revinfo.chippkg);
 		ri->nvramrev = le32_to_cpu(revinfo.nvramrev);
+
+		if (!bus->chip) {
+			bus->chip = le32_to_cpu(revinfo.chipnum);
+			bus->chiprev = le32_to_cpu(revinfo.chiprev);
+		}
 	}
 	ri->result = err;
 
+	if (bus->chip)
+		brcmf_chip_name(bus->chip, bus->chiprev,
+				ri->chipname, sizeof(ri->chipname));
+
 	/* Do any CLM downloading */
 	err = brcmf_c_process_clm_blob(ifp);
 	if (err < 0) {
@@ -295,7 +306,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	strsep(&ptr, "\n");
 
 	/* Print fw version info */
-	brcmf_info("Firmware version = %s\n", buf);
+	brcmf_info("Firmware: %s %s\n", ri->chipname, buf);
 
 	/* locate firmware version number for ethtool */
 	ptr = strrchr(buf, ' ') + 1;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 1904852..e8c16d7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -924,8 +924,7 @@ static int brcmf_revinfo_read(struct seq_file *s, void *data)
 	seq_printf(s, "vendorid: 0x%04x\n", ri->vendorid);
 	seq_printf(s, "deviceid: 0x%04x\n", ri->deviceid);
 	seq_printf(s, "radiorev: %s\n", brcmu_dotrev_str(ri->radiorev, drev));
-	seq_printf(s, "chipnum: %u (%x)\n", ri->chipnum, ri->chipnum);
-	seq_printf(s, "chiprev: %u\n", ri->chiprev);
+	seq_printf(s, "chip: %s\n", ri->chipname);
 	seq_printf(s, "chippkg: %u\n", ri->chippkg);
 	seq_printf(s, "corerev: %u\n", ri->corerev);
 	seq_printf(s, "boardid: 0x%04x\n", ri->boardid);
@@ -975,13 +974,6 @@ static int brcmf_bus_started(struct brcmf_pub *drvr)
 
 	brcmf_debugfs_add_entry(drvr, "revinfo", brcmf_revinfo_read);
 
-	/* assure we have chipid before feature attach */
-	if (!bus_if->chip) {
-		bus_if->chip = drvr->revinfo.chipnum;
-		bus_if->chiprev = drvr->revinfo.chiprev;
-		brcmf_dbg(INFO, "firmware revinfo: chip %x (%d) rev %d\n",
-			  bus_if->chip, bus_if->chip, bus_if->chiprev);
-	}
 	brcmf_feat_attach(drvr);
 
 	ret = brcmf_proto_init_done(drvr);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index df8a1ec..6fd6745 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -87,7 +87,6 @@ struct brcmf_rev_info {
 	u32 vendorid;
 	u32 deviceid;
 	u32 radiorev;
-	u32 chiprev;
 	u32 corerev;
 	u32 boardid;
 	u32 boardvendor;
@@ -95,7 +94,7 @@ struct brcmf_rev_info {
 	u32 driverrev;
 	u32 ucoderev;
 	u32 bus;
-	u32 chipnum;
+	char chipname[12];
 	u32 phytype;
 	u32 phyrev;
 	u32 anarev;
-- 
1.9.1

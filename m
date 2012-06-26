Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4071 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab2FZT1X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 15:27:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>
Subject: [PATCH 3/7] brcmfmac: move glom alignment setting to SDIO bus
 layer
Date: Tue, 26 Jun 2012 21:26:36 +0200
Message-ID: <1340738800-14087-4-git-send-email-arend@broadcom.com> (sfid-20120626_212730_779235_635C8B01)
In-Reply-To: <1340738800-14087-1-git-send-email-arend@broadcom.com>
References: <1340738800-14087-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

txglomming alignment is a SDIO bus specific feature. It is more
appropriate to place it in SDIO bus layer instead of common layer.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    7 -------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   21 ++++++++++++++------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 40fa472..2621dd3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -800,7 +800,6 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];	/*  Room for
 				 "event_msgs" + '\0' + bitvec  */
 	char buf[128], *ptr;
-	u32 dongle_align = drvr->bus_if->align;
 	u32 roaming = 1;
 	uint bcn_timeout = 3;
 	int scan_assoc_time = 40;
@@ -828,12 +827,6 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 	/* Print fw version info */
 	brcmf_dbg(ERROR, "Firmware version = %s\n", buf);
 
-	/* Match Host and Dongle rx alignment */
-	brcmf_c_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
-		    sizeof(iovbuf));
-	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
-				  sizeof(iovbuf));
-
 	/* Setup timeout if Beacons are lost and roam is off to report
 		 link down */
 	brcmf_c_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 1616c14..581e7d9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -4171,6 +4171,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	struct brcmf_sdio *bus;
 	struct brcmf_bus_dcmd *dlst;
 	u32 dngl_txglom;
+	u32 dngl_txglomalign;
 	u8 idx;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -4260,12 +4261,20 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	/* sdio bus core specific dcmd */
 	idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
 	dlst = kzalloc(sizeof(struct brcmf_bus_dcmd), GFP_KERNEL);
-	if (bus->ci->c_inf[idx].rev < 12 && dlst) {
-		/* for sdio core rev < 12, disable txgloming */
-		dngl_txglom = 0;
-		dlst->name = "bus:txglom";
-		dlst->param = (char *)&dngl_txglom;
-		dlst->param_len = sizeof(u32);
+	if (dlst) {
+		if (bus->ci->c_inf[idx].rev < 12) {
+			/* for sdio core rev < 12, disable txgloming */
+			dngl_txglom = 0;
+			dlst->name = "bus:txglom";
+			dlst->param = (char *)&dngl_txglom;
+			dlst->param_len = sizeof(u32);
+		} else {
+			/* otherwise, set txglomalign */
+			dngl_txglomalign = bus->sdiodev->bus_if->align;
+			dlst->name = "bus:txglomalign";
+			dlst->param = (char *)&dngl_txglomalign;
+			dlst->param_len = sizeof(u32);
+		}
 		list_add(&dlst->list, &bus->sdiodev->bus_if->dcmd_list);
 	}
 
-- 
1.7.9.5



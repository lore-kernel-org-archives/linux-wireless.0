Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2305 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab2FZT1U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 15:27:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>
Subject: [PATCH 2/7] brcmfmac: restrict dongle txglom disable to old
 SDIO core
Date: Tue, 26 Jun 2012 21:26:35 +0200
Message-ID: <1340738800-14087-3-git-send-email-arend@broadcom.com> (sfid-20120626_212724_015851_A660D6B0)
In-Reply-To: <1340738800-14087-1-git-send-email-arend@broadcom.com>
References: <1340738800-14087-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

txglomming is a firmware feature for sdio bus interface. For SDIO
device cores newer than revision 11, the default setting of
firmware should be used instead of disabling it from the host side.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    6 ------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 1c9eb18..40fa472 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -801,7 +801,6 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 				 "event_msgs" + '\0' + bitvec  */
 	char buf[128], *ptr;
 	u32 dongle_align = drvr->bus_if->align;
-	u32 glom = 0;
 	u32 roaming = 1;
 	uint bcn_timeout = 3;
 	int scan_assoc_time = 40;
@@ -835,11 +834,6 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
-	/* disable glom option per default */
-	brcmf_c_mkiovar("bus:txglom", (char *)&glom, 4, iovbuf, sizeof(iovbuf));
-	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
-				  sizeof(iovbuf));
-
 	/* Setup timeout if Beacons are lost and roam is off to report
 		 link down */
 	brcmf_c_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 076b772..1616c14 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -4169,6 +4169,9 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 {
 	int ret;
 	struct brcmf_sdio *bus;
+	struct brcmf_bus_dcmd *dlst;
+	u32 dngl_txglom;
+	u8 idx;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -4254,6 +4257,18 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdio_debugfs_create(bus);
 	brcmf_dbg(INFO, "completed!!\n");
 
+	/* sdio bus core specific dcmd */
+	idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
+	dlst = kzalloc(sizeof(struct brcmf_bus_dcmd), GFP_KERNEL);
+	if (bus->ci->c_inf[idx].rev < 12 && dlst) {
+		/* for sdio core rev < 12, disable txgloming */
+		dngl_txglom = 0;
+		dlst->name = "bus:txglom";
+		dlst->param = (char *)&dngl_txglom;
+		dlst->param_len = sizeof(u32);
+		list_add(&dlst->list, &bus->sdiodev->bus_if->dcmd_list);
+	}
+
 	/* if firmware path present try to download and bring up bus */
 	ret = brcmf_bus_start(bus->sdiodev->dev);
 	if (ret != 0) {
-- 
1.7.9.5



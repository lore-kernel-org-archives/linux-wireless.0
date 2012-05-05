Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1333 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907Ab2EEB1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 21:27:50 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/11] brcmfmac: introduce unified register access
 interface for SDIO
Date: Fri, 4 May 2012 18:27:31 -0700
Message-ID: <1336181258-7305-5-git-send-email-frankyl@broadcom.com> (sfid-20120505_032825_636261_5A2ACE7D)
In-Reply-To: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
References: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both brcmf_sdcard_cfg_read/write and brcmf_sdcard_reg_read/write
are used as interface functions for register access of SDIO WiFi
dongle. A unified interface brcmf_sdio_regr/w is introduced in
this patch in order to simplify the interface and keep the
complexity within the lower layer.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  113 ++++++++++++++++++++
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   12 +++
 2 files changed, 125 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index f971fa8..5e719d8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -233,6 +233,119 @@ brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 	return err;
 }
 
+static int
+brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
+			void *data, bool write)
+{
+	u8 func_num, reg_size;
+	u32 bar;
+	s32 retry = 0;
+	int ret;
+
+	/*
+	 * figure out how to read the register based on address range
+	 * 0x00 ~ 0xFF: function 0 CCCR
+	 * 0x10000 ~ 0x1FFFF: function 1 miscellaneous registers
+	 * The rest: function 1 silicon backplane core registers
+	 */
+	if ((addr & ~REG_F0_CCCR_MASK) == 0) {
+		func_num = SDIO_FUNC_0;
+		reg_size = 1;
+	} else if ((addr & ~REG_F1_MISC_MASK) == 0) {
+		func_num = SDIO_FUNC_1;
+		reg_size = 1;
+	} else {
+		func_num = SDIO_FUNC_1;
+		reg_size = 4;
+
+		/* Set the window for SB core register */
+		bar = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
+		if (bar != sdiodev->sbwad) {
+			ret = brcmf_sdcard_set_sbaddr_window(sdiodev, bar);
+			if (ret != 0) {
+				memset(data, 0xFF, reg_size);
+				return ret;
+			}
+			sdiodev->sbwad = bar;
+		}
+		addr &= SBSDIO_SB_OFT_ADDR_MASK;
+		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+	}
+
+	do {
+		if (!write)
+			memset(data, 0, reg_size);
+		if (retry)	/* wait for 1 ms till bus get settled down */
+			usleep_range(1000, 2000);
+		if (reg_size == 1)
+			ret = brcmf_sdioh_request_byte(sdiodev, write,
+						       func_num, addr, data);
+		else
+			ret = brcmf_sdioh_request_word(sdiodev, write,
+						       func_num, addr, data, 4);
+	} while (ret != 0 && retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
+
+	sdiodev->regfail = (ret != 0);
+	if (sdiodev->regfail)
+		brcmf_dbg(ERROR, "failed with %d\n", ret);
+
+	return ret;
+}
+
+u8 brcmf_sdio_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
+{
+	u8 data;
+	int retval;
+
+	brcmf_dbg(INFO, "addr:0x%08x\n", addr);
+	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, false);
+	brcmf_dbg(INFO, "data:0x%02x\n", data);
+
+	if (ret)
+		*ret = retval;
+
+	return data;
+}
+
+u32 brcmf_sdio_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
+{
+	u32 data;
+	int retval;
+
+	brcmf_dbg(INFO, "addr:0x%08x\n", addr);
+	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, false);
+	brcmf_dbg(INFO, "data:0x%08x\n", data);
+
+	if (ret)
+		*ret = retval;
+
+	return data;
+}
+
+void brcmf_sdio_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
+		      u8 data, int *ret)
+{
+	int retval;
+
+	brcmf_dbg(INFO, "addr:0x%08x, data:0x%02x\n", addr, data);
+	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, true);
+
+	if (ret)
+		*ret = retval;
+}
+
+void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
+		      u32 data, int *ret)
+{
+	int retval;
+
+	brcmf_dbg(INFO, "addr:0x%08x, data:0x%08x\n", addr, data);
+	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, true);
+
+	if (ret)
+		*ret = retval;
+}
+
 u32 brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr)
 {
 	int status;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 6df06cf..d6ed2d8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -40,6 +40,10 @@
 /* Maximum number of I/O funcs */
 #define SDIOD_MAX_IOFUNCS	7
 
+/* mask of register map */
+#define REG_F0_CCCR_MASK	0xFF
+#define REG_F1_MISC_MASK	0x1FFFF
+
 /* as of sdiod rev 0, supports 3 functions */
 #define SBSDIO_NUM_FUNCTION		3
 
@@ -186,6 +190,14 @@ brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr);
 extern u32
 brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, u32 data);
 
+/* sdio device register access interface */
+extern u8 brcmf_sdio_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret);
+extern u32 brcmf_sdio_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret);
+extern void brcmf_sdio_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
+			     u8 data, int *ret);
+extern void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
+			     u32 data, int *ret);
+
 /* Indicate if last reg read/write failed */
 extern bool brcmf_sdcard_regfail(struct brcmf_sdio_dev *sdiodev);
 
-- 
1.7.9.5



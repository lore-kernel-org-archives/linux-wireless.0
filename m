Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44406 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2ABHAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 02:00:08 -0500
Received: by wgbds13 with SMTP id ds13so21284992wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jan 2012 23:00:07 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] ssb: SPROM: extract each core power info
Date: Mon,  2 Jan 2012 08:41:23 +0100
Message-Id: <1325490085-3806-1-git-send-email-zajec5@gmail.com> (sfid-20120102_080037_889050_F51BFCDB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We already extract some basic info but it's incomplete, reads info
about the first core only. Used data structure doesn't allow easy
adding of more cores.
This patch adds new struct and array for storing power info. The plan
is to: switch all extractors (including the ones using NVRAM) to new
struct, switch drivers, then deprecate and finally drop old SSB fields.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/pci.c            |   40 +++++++++++++++++++++++++++++++++++++++-
 include/linux/ssb/ssb.h      |    8 ++++++++
 include/linux/ssb/ssb_regs.h |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+), 1 deletions(-)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 973223f..befa89e 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -523,7 +523,13 @@ static void sprom_extract_r45(struct ssb_sprom *out, const u16 *in)
 static void sprom_extract_r8(struct ssb_sprom *out, const u16 *in)
 {
 	int i;
-	u16 v;
+	u16 v, o;
+	u16 pwr_info_offset[] = {
+		SSB_SROM8_PWR_INFO_CORE0, SSB_SROM8_PWR_INFO_CORE1,
+		SSB_SROM8_PWR_INFO_CORE2, SSB_SROM8_PWR_INFO_CORE3
+	};
+	BUILD_BUG_ON(ARRAY_SIZE(pwr_info_offset) !=
+			ARRAY_SIZE(out->core_pwr_info));
 
 	/* extract the MAC address */
 	for (i = 0; i < 3; i++) {
@@ -607,6 +613,38 @@ static void sprom_extract_r8(struct ssb_sprom *out, const u16 *in)
 	memcpy(&out->antenna_gain.ghz5, &out->antenna_gain.ghz24,
 	       sizeof(out->antenna_gain.ghz5));
 
+	/* Extract cores power info info */
+	for (i = 0; i < ARRAY_SIZE(pwr_info_offset); i++) {
+		o = pwr_info_offset[i];
+		SPEX(core_pwr_info[i].itssi_2g, o + SSB_SROM8_2G_MAXP_ITSSI,
+			SSB_SPROM8_2G_ITSSI, SSB_SPROM8_2G_ITSSI_SHIFT);
+		SPEX(core_pwr_info[i].maxpwr_2g, o + SSB_SROM8_2G_MAXP_ITSSI,
+			SSB_SPROM8_2G_MAXP, 0);
+
+		SPEX(core_pwr_info[i].pa_2g[0], o + SSB_SROM8_2G_PA_0, ~0, 0);
+		SPEX(core_pwr_info[i].pa_2g[1], o + SSB_SROM8_2G_PA_1, ~0, 0);
+		SPEX(core_pwr_info[i].pa_2g[2], o + SSB_SROM8_2G_PA_2, ~0, 0);
+
+		SPEX(core_pwr_info[i].itssi_5g, o + SSB_SROM8_5G_MAXP_ITSSI,
+			SSB_SPROM8_5G_ITSSI, SSB_SPROM8_5G_ITSSI_SHIFT);
+		SPEX(core_pwr_info[i].maxpwr_5g, o + SSB_SROM8_5G_MAXP_ITSSI,
+			SSB_SPROM8_5G_MAXP, 0);
+		SPEX(core_pwr_info[i].maxpwr_5gh, o + SSB_SPROM8_5GHL_MAXP,
+			SSB_SPROM8_5GH_MAXP, 0);
+		SPEX(core_pwr_info[i].maxpwr_5gl, o + SSB_SPROM8_5GHL_MAXP,
+			SSB_SPROM8_5GL_MAXP, SSB_SPROM8_5GL_MAXP_SHIFT);
+
+		SPEX(core_pwr_info[i].pa_5gl[0], o + SSB_SROM8_5GL_PA_0, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5gl[1], o + SSB_SROM8_5GL_PA_1, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5gl[2], o + SSB_SROM8_5GL_PA_2, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5g[0], o + SSB_SROM8_5G_PA_0, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5g[1], o + SSB_SROM8_5G_PA_1, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5g[2], o + SSB_SROM8_5G_PA_2, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5gh[0], o + SSB_SROM8_5GH_PA_0, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5gh[1], o + SSB_SROM8_5GH_PA_1, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5gh[2], o + SSB_SROM8_5GH_PA_2, ~0, 0);
+	}
+
 	/* Extract FEM info */
 	SPEX(fem.ghz2.tssipos, SSB_SPROM8_FEM2G,
 		SSB_SROM8_FEM_TSSIPOS, SSB_SROM8_FEM_TSSIPOS_SHIFT);
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index dcf35b0..bbc2612 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -16,6 +16,12 @@ struct pcmcia_device;
 struct ssb_bus;
 struct ssb_driver;
 
+struct ssb_sprom_core_pwr_info {
+	u8 itssi_2g, itssi_5g;
+	u8 maxpwr_2g, maxpwr_5gl, maxpwr_5g, maxpwr_5gh;
+	u16 pa_2g[3], pa_5gl[3], pa_5g[3], pa_5gh[3];
+};
+
 struct ssb_sprom {
 	u8 revision;
 	u8 il0mac[6];		/* MAC address for 802.11b/g */
@@ -82,6 +88,8 @@ struct ssb_sprom {
 	u16 boardflags2_hi;	/* Board flags (bits 48-63) */
 	/* TODO store board flags in a single u64 */
 
+	struct ssb_sprom_core_pwr_info core_pwr_info[4];
+
 	/* Antenna gain values for up to 4 antennas
 	 * on each band. Values in dBm/4 (Q5.2). Negative gain means the
 	 * loss in the connectors is bigger than the gain. */
diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index c814ae6..40b1ef8 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -449,6 +449,39 @@
 #define SSB_SPROM8_TS_SLP_OPT_CORRX	0x00B6
 #define SSB_SPROM8_FOC_HWIQ_IQSWP	0x00B8
 #define SSB_SPROM8_PHYCAL_TEMPDELTA	0x00BA
+
+/* There are 4 blocks with power info sharing the same layout */
+#define SSB_SROM8_PWR_INFO_CORE0	0x00C0
+#define SSB_SROM8_PWR_INFO_CORE1	0x00E0
+#define SSB_SROM8_PWR_INFO_CORE2	0x0100
+#define SSB_SROM8_PWR_INFO_CORE3	0x0120
+
+#define SSB_SROM8_2G_MAXP_ITSSI		0x00
+#define  SSB_SPROM8_2G_MAXP		0x00FF
+#define  SSB_SPROM8_2G_ITSSI		0xFF00
+#define  SSB_SPROM8_2G_ITSSI_SHIFT	8
+#define SSB_SROM8_2G_PA_0		0x02	/* 2GHz power amp settings */
+#define SSB_SROM8_2G_PA_1		0x04
+#define SSB_SROM8_2G_PA_2		0x06
+#define SSB_SROM8_5G_MAXP_ITSSI		0x08	/* 5GHz ITSSI and 5.3GHz Max Power */
+#define  SSB_SPROM8_5G_MAXP		0x00FF
+#define  SSB_SPROM8_5G_ITSSI		0xFF00
+#define  SSB_SPROM8_5G_ITSSI_SHIFT	8
+#define SSB_SPROM8_5GHL_MAXP		0x0A	/* 5.2GHz and 5.8GHz Max Power */
+#define  SSB_SPROM8_5GH_MAXP		0x00FF
+#define  SSB_SPROM8_5GL_MAXP		0xFF00
+#define  SSB_SPROM8_5GL_MAXP_SHIFT	8
+#define SSB_SROM8_5G_PA_0		0x0C	/* 5.3GHz power amp settings */
+#define SSB_SROM8_5G_PA_1		0x0E
+#define SSB_SROM8_5G_PA_2		0x10
+#define SSB_SROM8_5GL_PA_0		0x12	/* 5.2GHz power amp settings */
+#define SSB_SROM8_5GL_PA_1		0x14
+#define SSB_SROM8_5GL_PA_2		0x16
+#define SSB_SROM8_5GH_PA_0		0x18	/* 5.8GHz power amp settings */
+#define SSB_SROM8_5GH_PA_1		0x1A
+#define SSB_SROM8_5GH_PA_2		0x1C
+
+/* TODO: Make it deprecated */
 #define SSB_SPROM8_MAXP_BG		0x00C0  /* Max Power 2GHz in path 1 */
 #define  SSB_SPROM8_MAXP_BG_MASK	0x00FF  /* Mask for Max Power 2GHz */
 #define  SSB_SPROM8_ITSSI_BG		0xFF00	/* Mask for path 1 itssi_bg */
@@ -473,6 +506,7 @@
 #define SSB_SPROM8_PA1HIB0		0x00D8	/* 5.8GHz power amp settings */
 #define SSB_SPROM8_PA1HIB1		0x00DA
 #define SSB_SPROM8_PA1HIB2		0x00DC
+
 #define SSB_SPROM8_CCK2GPO		0x0140	/* CCK power offset */
 #define SSB_SPROM8_OFDM2GPO		0x0142	/* 2.4GHz OFDM power offset */
 #define SSB_SPROM8_OFDM5GPO		0x0146	/* 5.3GHz OFDM power offset */
-- 
1.7.3.4


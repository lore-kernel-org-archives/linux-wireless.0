Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:51283 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaGOOTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 10:19:08 -0400
Received: by mail-we0-f179.google.com with SMTP id u57so3418131wes.24
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 07:19:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: extract power info from SPROM revs 4 and 5
Date: Tue, 15 Jul 2014 16:18:57 +0200
Message-Id: <1405433937-17355-1-git-send-email-zajec5@gmail.com> (sfid-20140715_161912_886649_FAF084C6)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed to properly handle early 802.11n devices like BCM4321.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/pci.c            | 45 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ssb/ssb_regs.h | 37 ++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 6318364..0f28c08 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -470,7 +470,15 @@ static void sprom_extract_r458(struct ssb_sprom *out, const u16 *in)
 
 static void sprom_extract_r45(struct ssb_sprom *out, const u16 *in)
 {
+	static const u16 pwr_info_offset[] = {
+		SSB_SPROM4_PWR_INFO_CORE0, SSB_SPROM4_PWR_INFO_CORE1,
+		SSB_SPROM4_PWR_INFO_CORE2, SSB_SPROM4_PWR_INFO_CORE3
+	};
 	u16 il0mac_offset;
+	int i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(pwr_info_offset) !=
+		     ARRAY_SIZE(out->core_pwr_info));
 
 	if (out->revision == 4)
 		il0mac_offset = SSB_SPROM4_IL0MAC;
@@ -543,6 +551,43 @@ static void sprom_extract_r45(struct ssb_sprom *out, const u16 *in)
 						     SSB_SPROM4_AGAIN3,
 						     SSB_SPROM4_AGAIN3_SHIFT);
 
+	/* Extract cores power info info */
+	for (i = 0; i < ARRAY_SIZE(pwr_info_offset); i++) {
+		u16 o = pwr_info_offset[i];
+
+		SPEX(core_pwr_info[i].itssi_2g, o + SSB_SPROM4_2G_MAXP_ITSSI,
+			SSB_SPROM4_2G_ITSSI, SSB_SPROM4_2G_ITSSI_SHIFT);
+		SPEX(core_pwr_info[i].maxpwr_2g, o + SSB_SPROM4_2G_MAXP_ITSSI,
+			SSB_SPROM4_2G_MAXP, 0);
+
+		SPEX(core_pwr_info[i].pa_2g[0], o + SSB_SPROM4_2G_PA_0, ~0, 0);
+		SPEX(core_pwr_info[i].pa_2g[1], o + SSB_SPROM4_2G_PA_1, ~0, 0);
+		SPEX(core_pwr_info[i].pa_2g[2], o + SSB_SPROM4_2G_PA_2, ~0, 0);
+		SPEX(core_pwr_info[i].pa_2g[3], o + SSB_SPROM4_2G_PA_3, ~0, 0);
+
+		SPEX(core_pwr_info[i].itssi_5g, o + SSB_SPROM4_5G_MAXP_ITSSI,
+			SSB_SPROM4_5G_ITSSI, SSB_SPROM4_5G_ITSSI_SHIFT);
+		SPEX(core_pwr_info[i].maxpwr_5g, o + SSB_SPROM4_5G_MAXP_ITSSI,
+			SSB_SPROM4_5G_MAXP, 0);
+		SPEX(core_pwr_info[i].maxpwr_5gh, o + SSB_SPROM4_5GHL_MAXP,
+			SSB_SPROM4_5GH_MAXP, 0);
+		SPEX(core_pwr_info[i].maxpwr_5gl, o + SSB_SPROM4_5GHL_MAXP,
+			SSB_SPROM4_5GL_MAXP, SSB_SPROM4_5GL_MAXP_SHIFT);
+
+		SPEX(core_pwr_info[i].pa_5gl[0], o + SSB_SPROM4_5GL_PA_0, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5gl[1], o + SSB_SPROM4_5GL_PA_1, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5gl[2], o + SSB_SPROM4_5GL_PA_2, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5gl[3], o + SSB_SPROM4_5GL_PA_3, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5g[0], o + SSB_SPROM4_5G_PA_0, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5g[1], o + SSB_SPROM4_5G_PA_1, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5g[2], o + SSB_SPROM4_5G_PA_2, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5g[3], o + SSB_SPROM4_5G_PA_3, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5gh[0], o + SSB_SPROM4_5GH_PA_0, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5gh[1], o + SSB_SPROM4_5GH_PA_1, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5gh[2], o + SSB_SPROM4_5GH_PA_2, ~0, 0);
+		SPEX(core_pwr_info[i].pa_5gh[3], o + SSB_SPROM4_5GH_PA_3, ~0, 0);
+	}
+
 	sprom_extract_r458(out, in);
 
 	/* TODO - get remaining rev 4 stuff needed */
diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index f9f931c..f7b9100 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -345,6 +345,43 @@
 #define  SSB_SPROM4_TXPID5GH2_SHIFT	0
 #define  SSB_SPROM4_TXPID5GH3		0xFF00
 #define  SSB_SPROM4_TXPID5GH3_SHIFT	8
+
+/* There are 4 blocks with power info sharing the same layout */
+#define SSB_SPROM4_PWR_INFO_CORE0	0x0080
+#define SSB_SPROM4_PWR_INFO_CORE1	0x00AE
+#define SSB_SPROM4_PWR_INFO_CORE2	0x00DC
+#define SSB_SPROM4_PWR_INFO_CORE3	0x010A
+
+#define SSB_SPROM4_2G_MAXP_ITSSI	0x00	/* 2 GHz ITSSI and 2 GHz Max Power */
+#define  SSB_SPROM4_2G_MAXP		0x00FF
+#define  SSB_SPROM4_2G_ITSSI		0xFF00
+#define  SSB_SPROM4_2G_ITSSI_SHIFT	8
+#define SSB_SPROM4_2G_PA_0		0x02	/* 2 GHz power amp */
+#define SSB_SPROM4_2G_PA_1		0x04
+#define SSB_SPROM4_2G_PA_2		0x06
+#define SSB_SPROM4_2G_PA_3		0x08
+#define SSB_SPROM4_5G_MAXP_ITSSI	0x0A	/* 5 GHz ITSSI and 5.3 GHz Max Power */
+#define  SSB_SPROM4_5G_MAXP		0x00FF
+#define  SSB_SPROM4_5G_ITSSI		0xFF00
+#define  SSB_SPROM4_5G_ITSSI_SHIFT	8
+#define SSB_SPROM4_5GHL_MAXP		0x0C	/* 5.2 GHz and 5.8 GHz Max Power */
+#define  SSB_SPROM4_5GH_MAXP		0x00FF
+#define  SSB_SPROM4_5GL_MAXP		0xFF00
+#define  SSB_SPROM4_5GL_MAXP_SHIFT	8
+#define SSB_SPROM4_5G_PA_0		0x0E	/* 5.3 GHz power amp */
+#define SSB_SPROM4_5G_PA_1		0x10
+#define SSB_SPROM4_5G_PA_2		0x12
+#define SSB_SPROM4_5G_PA_3		0x14
+#define SSB_SPROM4_5GL_PA_0		0x16	/* 5.2 GHz power amp */
+#define SSB_SPROM4_5GL_PA_1		0x18
+#define SSB_SPROM4_5GL_PA_2		0x1A
+#define SSB_SPROM4_5GL_PA_3		0x1C
+#define SSB_SPROM4_5GH_PA_0		0x1E	/* 5.8 GHz power amp */
+#define SSB_SPROM4_5GH_PA_1		0x20
+#define SSB_SPROM4_5GH_PA_2		0x22
+#define SSB_SPROM4_5GH_PA_3		0x24
+
+/* TODO: Make it deprecated */
 #define SSB_SPROM4_MAXP_BG		0x0080  /* Max Power BG in path 1 */
 #define  SSB_SPROM4_MAXP_BG_MASK	0x00FF  /* Mask for Max Power BG */
 #define  SSB_SPROM4_ITSSI_BG		0xFF00	/* Mask for path 1 itssi_bg */
-- 
1.8.4.5


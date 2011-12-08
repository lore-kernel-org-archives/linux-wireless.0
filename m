Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60889 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1LHQV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 11:21:27 -0500
Received: by faar15 with SMTP id r15so469646faa.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 08:21:26 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] ssb: extract FEM info from SPROM
Date: Thu,  8 Dec 2011 18:02:21 +0100
Message-Id: <1323363742-10603-1-git-send-email-zajec5@gmail.com> (sfid-20111208_172131_815556_B34DB2DE)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/pci.c            |   23 +++++++++++++++++++++++
 include/linux/ssb/ssb.h      |    9 +++++++++
 include/linux/ssb/ssb_regs.h |   17 +++++++++++++++++
 3 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 34c3bab..973223f 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -607,6 +607,29 @@ static void sprom_extract_r8(struct ssb_sprom *out, const u16 *in)
 	memcpy(&out->antenna_gain.ghz5, &out->antenna_gain.ghz24,
 	       sizeof(out->antenna_gain.ghz5));
 
+	/* Extract FEM info */
+	SPEX(fem.ghz2.tssipos, SSB_SPROM8_FEM2G,
+		SSB_SROM8_FEM_TSSIPOS, SSB_SROM8_FEM_TSSIPOS_SHIFT);
+	SPEX(fem.ghz2.extpa_gain, SSB_SPROM8_FEM2G,
+		SSB_SROM8_FEM_EXTPA_GAIN, SSB_SROM8_FEM_EXTPA_GAIN_SHIFT);
+	SPEX(fem.ghz2.pdet_range, SSB_SPROM8_FEM2G,
+		SSB_SROM8_FEM_PDET_RANGE, SSB_SROM8_FEM_PDET_RANGE_SHIFT);
+	SPEX(fem.ghz2.tr_iso, SSB_SPROM8_FEM2G,
+		SSB_SROM8_FEM_TR_ISO, SSB_SROM8_FEM_TR_ISO_SHIFT);
+	SPEX(fem.ghz2.antswlut, SSB_SPROM8_FEM2G,
+		SSB_SROM8_FEM_ANTSWLUT, SSB_SROM8_FEM_ANTSWLUT_SHIFT);
+
+	SPEX(fem.ghz5.tssipos, SSB_SPROM8_FEM5G,
+		SSB_SROM8_FEM_TSSIPOS, SSB_SROM8_FEM_TSSIPOS_SHIFT);
+	SPEX(fem.ghz5.extpa_gain, SSB_SPROM8_FEM5G,
+		SSB_SROM8_FEM_EXTPA_GAIN, SSB_SROM8_FEM_EXTPA_GAIN_SHIFT);
+	SPEX(fem.ghz5.pdet_range, SSB_SPROM8_FEM5G,
+		SSB_SROM8_FEM_PDET_RANGE, SSB_SROM8_FEM_PDET_RANGE_SHIFT);
+	SPEX(fem.ghz5.tr_iso, SSB_SPROM8_FEM5G,
+		SSB_SROM8_FEM_TR_ISO, SSB_SROM8_FEM_TR_ISO_SHIFT);
+	SPEX(fem.ghz5.antswlut, SSB_SPROM8_FEM5G,
+		SSB_SROM8_FEM_ANTSWLUT, SSB_SROM8_FEM_ANTSWLUT_SHIFT);
+
 	sprom_extract_r458(out, in);
 
 	/* TODO - get remaining rev 8 stuff needed */
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 061e560..dcf35b0 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -94,6 +94,15 @@ struct ssb_sprom {
 		} ghz5;		/* 5GHz band */
 	} antenna_gain;
 
+	struct {
+		struct {
+			u8 tssipos, extpa_gain, pdet_range, tr_iso, antswlut;
+		} ghz2;
+		struct {
+			u8 tssipos, extpa_gain, pdet_range, tr_iso, antswlut;
+		} ghz5;
+	} fem;
+
 	/* TODO - add any parameters needed from rev 2, 3, 4, 5 or 8 SPROMs */
 };
 
diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index 9894120..c814ae6 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -432,6 +432,23 @@
 #define  SSB_SPROM8_RXPO2G		0x00FF	/* 2GHz RX power offset */
 #define  SSB_SPROM8_RXPO5G		0xFF00	/* 5GHz RX power offset */
 #define  SSB_SPROM8_RXPO5G_SHIFT	8
+#define SSB_SPROM8_FEM2G		0x00AE
+#define SSB_SPROM8_FEM5G		0x00B0
+#define  SSB_SROM8_FEM_TSSIPOS		0x0001
+#define  SSB_SROM8_FEM_TSSIPOS_SHIFT	0
+#define  SSB_SROM8_FEM_EXTPA_GAIN	0x0006
+#define  SSB_SROM8_FEM_EXTPA_GAIN_SHIFT	1
+#define  SSB_SROM8_FEM_PDET_RANGE	0x00F8
+#define  SSB_SROM8_FEM_PDET_RANGE_SHIFT	3
+#define  SSB_SROM8_FEM_TR_ISO		0x0700
+#define  SSB_SROM8_FEM_TR_ISO_SHIFT	8
+#define  SSB_SROM8_FEM_ANTSWLUT		0xF800
+#define  SSB_SROM8_FEM_ANTSWLUT_SHIFT	11
+#define SSB_SPROM8_THERMAL		0x00B2
+#define SSB_SPROM8_MPWR_RAWTS		0x00B4
+#define SSB_SPROM8_TS_SLP_OPT_CORRX	0x00B6
+#define SSB_SPROM8_FOC_HWIQ_IQSWP	0x00B8
+#define SSB_SPROM8_PHYCAL_TEMPDELTA	0x00BA
 #define SSB_SPROM8_MAXP_BG		0x00C0  /* Max Power 2GHz in path 1 */
 #define  SSB_SPROM8_MAXP_BG_MASK	0x00FF  /* Mask for Max Power 2GHz */
 #define  SSB_SPROM8_ITSSI_BG		0xFF00	/* Mask for path 1 itssi_bg */
-- 
1.7.3.4


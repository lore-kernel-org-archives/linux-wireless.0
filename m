Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:64600 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaAMVUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 16:20:41 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 6/8] brcmfmac: rename chip and core related structures
Date: Mon, 13 Jan 2014 22:20:27 +0100
Message-ID: <1389648029-23560-7-git-send-email-arend@broadcom.com> (sfid-20140113_222051_866851_48481ED3)
In-Reply-To: <1389648029-23560-1-git-send-email-arend@broadcom.com>
References: <1389648029-23560-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   54 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |   27 +++++-----
 3 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index b9d5f73..ef24a1b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -369,7 +369,7 @@ struct brcmf_sdio_hdrinfo {
 /* Private data for SDIO bus interaction */
 struct brcmf_sdio {
 	struct brcmf_sdio_dev *sdiodev;	/* sdio device handler */
-	struct chip_info *ci;	/* Chip info struct */
+	struct brcmf_chip *ci;	/* Chip info struct */
 
 	u32 ramsize;		/* Size of RAM in SOCRAM (bytes) */
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index fb2f918..70bfeb86 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -111,7 +111,7 @@ static const struct sdiod_drive_str sdiod_drvstr_tab2_3v3[] = {
 };
 
 u8
-brcmf_sdio_chip_getinfidx(struct chip_info *ci, u16 coreid)
+brcmf_sdio_chip_getinfidx(struct brcmf_chip *ci, u16 coreid)
 {
 	u8 idx;
 
@@ -124,7 +124,7 @@ brcmf_sdio_chip_getinfidx(struct chip_info *ci, u16 coreid)
 
 static u32
 brcmf_sdio_sb_corerev(struct brcmf_sdio_dev *sdiodev,
-		      struct chip_info *ci, u16 coreid)
+		      struct brcmf_chip *ci, u16 coreid)
 {
 	u32 regdata;
 	u8 idx;
@@ -139,7 +139,7 @@ brcmf_sdio_sb_corerev(struct brcmf_sdio_dev *sdiodev,
 
 static u32
 brcmf_sdio_ai_corerev(struct brcmf_sdio_dev *sdiodev,
-		      struct chip_info *ci, u16 coreid)
+		      struct brcmf_chip *ci, u16 coreid)
 {
 	u8 idx;
 
@@ -150,7 +150,7 @@ brcmf_sdio_ai_corerev(struct brcmf_sdio_dev *sdiodev,
 
 static bool
 brcmf_sdio_sb_iscoreup(struct brcmf_sdio_dev *sdiodev,
-		       struct chip_info *ci, u16 coreid)
+		       struct brcmf_chip *ci, u16 coreid)
 {
 	u32 regdata;
 	u8 idx;
@@ -169,7 +169,7 @@ brcmf_sdio_sb_iscoreup(struct brcmf_sdio_dev *sdiodev,
 
 static bool
 brcmf_sdio_ai_iscoreup(struct brcmf_sdio_dev *sdiodev,
-		       struct chip_info *ci, u16 coreid)
+		       struct brcmf_chip *ci, u16 coreid)
 {
 	u32 regdata;
 	u8 idx;
@@ -193,7 +193,7 @@ brcmf_sdio_ai_iscoreup(struct brcmf_sdio_dev *sdiodev,
 
 static void
 brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
-			  struct chip_info *ci, u16 coreid, u32 pre_resetbits,
+			  struct brcmf_chip *ci, u16 coreid, u32 pre_resetbits,
 			  u32 in_resetbits)
 {
 	u32 regdata, base;
@@ -280,7 +280,7 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 
 static void
 brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
-			  struct chip_info *ci, u16 coreid, u32 pre_resetbits,
+			  struct brcmf_chip *ci, u16 coreid, u32 pre_resetbits,
 			  u32 in_resetbits)
 {
 	u8 idx;
@@ -320,7 +320,7 @@ brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
 
 static void
 brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
-			struct chip_info *ci, u16 coreid,  u32 pre_resetbits,
+			struct brcmf_chip *ci, u16 coreid,  u32 pre_resetbits,
 			u32 in_resetbits, u32 post_resetbits)
 {
 	u32 regdata;
@@ -388,7 +388,7 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 
 static void
 brcmf_sdio_ai_resetcore(struct brcmf_sdio_dev *sdiodev,
-			struct chip_info *ci, u16 coreid, u32 pre_resetbits,
+			struct brcmf_chip *ci, u16 coreid, u32 pre_resetbits,
 			u32 in_resetbits, u32 post_resetbits)
 {
 	u8 idx;
@@ -418,7 +418,7 @@ brcmf_sdio_ai_resetcore(struct brcmf_sdio_dev *sdiodev,
 
 #ifdef DEBUG
 /* safety check for chipinfo */
-static int brcmf_sdio_chip_cichk(struct chip_info *ci)
+static int brcmf_sdio_chip_cichk(struct brcmf_chip *ci)
 {
 	u8 core_idx;
 
@@ -445,14 +445,14 @@ static int brcmf_sdio_chip_cichk(struct chip_info *ci)
 	return 0;
 }
 #else	/* DEBUG */
-static inline int brcmf_sdio_chip_cichk(struct chip_info *ci)
+static inline int brcmf_sdio_chip_cichk(struct brcmf_chip *ci)
 {
 	return 0;
 }
 #endif
 
 static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
-				       struct chip_info *ci)
+				       struct brcmf_chip *ci)
 {
 	u32 regdata;
 	u32 socitype;
@@ -701,7 +701,7 @@ brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
 
 static void
 brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
-			     struct chip_info *ci)
+			     struct brcmf_chip *ci)
 {
 	u32 base = ci->c_inf[0].base;
 
@@ -736,15 +736,14 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 }
 
 int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
-			   struct chip_info **ci_ptr)
+			   struct brcmf_chip **ci_ptr)
 {
 	int ret;
-	struct chip_info *ci;
+	struct brcmf_chip *ci;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	/* alloc chip_info_t */
-	ci = kzalloc(sizeof(struct chip_info), GFP_ATOMIC);
+	ci = kzalloc(sizeof(*ci), GFP_ATOMIC);
 	if (!ci)
 		return -ENOMEM;
 
@@ -772,7 +771,7 @@ err:
 }
 
 void
-brcmf_sdio_chip_detach(struct chip_info **ci_ptr)
+brcmf_sdio_chip_detach(struct brcmf_chip **ci_ptr)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -791,7 +790,7 @@ static char *brcmf_sdio_chip_name(uint chipid, char *buf, uint len)
 
 void
 brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
-				  struct chip_info *ci, u32 drivestrength)
+				  struct brcmf_chip *ci, u32 drivestrength)
 {
 	const struct sdiod_drive_str *str_tab = NULL;
 	u32 str_mask;
@@ -863,7 +862,7 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 
 static void
 brcmf_sdio_chip_cm3_enterdl(struct brcmf_sdio_dev *sdiodev,
-			    struct chip_info *ci)
+			    struct brcmf_chip *ci)
 {
 	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3, 0, 0);
 	ci->resetcore(sdiodev, ci, BCMA_CORE_80211,
@@ -872,8 +871,8 @@ brcmf_sdio_chip_cm3_enterdl(struct brcmf_sdio_dev *sdiodev,
 	ci->resetcore(sdiodev, ci, BCMA_CORE_INTERNAL_MEM, 0, 0, 0);
 }
 
-static bool
-brcmf_sdio_chip_cm3_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci)
+static bool brcmf_sdio_chip_cm3_exitdl(struct brcmf_sdio_dev *sdiodev,
+				       struct brcmf_chip *ci)
 {
 	u8 core_idx;
 	u32 reg_addr;
@@ -896,7 +895,7 @@ brcmf_sdio_chip_cm3_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci)
 
 static inline void
 brcmf_sdio_chip_cr4_enterdl(struct brcmf_sdio_dev *sdiodev,
-			    struct chip_info *ci)
+			    struct brcmf_chip *ci)
 {
 	u8 idx;
 	u32 regdata;
@@ -917,9 +916,8 @@ brcmf_sdio_chip_cr4_enterdl(struct brcmf_sdio_dev *sdiodev,
 		      BCMA_IOCTL_80211_PHYCLOCKEN, BCMA_IOCTL_80211_PHYCLOCKEN);
 }
 
-static bool
-brcmf_sdio_chip_cr4_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
-			   u32 rstvec)
+static bool brcmf_sdio_chip_cr4_exitdl(struct brcmf_sdio_dev *sdiodev,
+				       struct brcmf_chip *ci, u32 rstvec)
 {
 	u8 core_idx;
 	u32 reg_addr;
@@ -942,7 +940,7 @@ brcmf_sdio_chip_cr4_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
 }
 
 void brcmf_sdio_chip_enter_download(struct brcmf_sdio_dev *sdiodev,
-				    struct chip_info *ci)
+				    struct brcmf_chip *ci)
 {
 	u8 arm_core_idx;
 
@@ -956,7 +954,7 @@ void brcmf_sdio_chip_enter_download(struct brcmf_sdio_dev *sdiodev,
 }
 
 bool brcmf_sdio_chip_exit_download(struct brcmf_sdio_dev *sdiodev,
-				   struct chip_info *ci, u32 rstvec)
+				   struct brcmf_chip *ci, u32 rstvec)
 {
 	u8 arm_core_idx;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index a1aadf4..fb06143 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -54,7 +54,7 @@
 
 #define BRCMF_MAX_CORENUM	6
 
-struct chip_core_info {
+struct brcmf_core {
 	u16 id;
 	u16 rev;
 	u32 base;
@@ -63,27 +63,27 @@ struct chip_core_info {
 	u32 cib;
 };
 
-struct chip_info {
+struct brcmf_chip {
 	u32 chip;
 	u32 chiprev;
 	/* core info */
 	/* always put chipcommon core at 0, bus core at 1 */
-	struct chip_core_info c_inf[BRCMF_MAX_CORENUM];
+	struct brcmf_core c_inf[BRCMF_MAX_CORENUM];
 	u32 pmurev;
 	u32 pmucaps;
 	u32 ramsize;
 	u32 rambase;
 	u32 rst_vec;	/* reset vertor for ARM CR4 core */
 
-	bool (*iscoreup)(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
+	bool (*iscoreup)(struct brcmf_sdio_dev *sdiodev, struct brcmf_chip *ci,
 			 u16 coreid);
-	u32 (*corerev)(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
+	u32 (*corerev)(struct brcmf_sdio_dev *sdiodev, struct brcmf_chip *ci,
 			 u16 coreid);
 	void (*coredisable)(struct brcmf_sdio_dev *sdiodev,
-			struct chip_info *ci, u16 coreid, u32 pre_resetbits,
+			struct brcmf_chip *ci, u16 coreid, u32 pre_resetbits,
 			u32 in_resetbits);
 	void (*resetcore)(struct brcmf_sdio_dev *sdiodev,
-			struct chip_info *ci, u16 coreid, u32 pre_resetbits,
+			struct brcmf_chip *ci, u16 coreid, u32 pre_resetbits,
 			u32 in_resetbits, u32 post_resetbits);
 };
 
@@ -217,14 +217,15 @@ struct sdpcmd_regs {
 };
 
 int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
-			   struct chip_info **ci_ptr);
-void brcmf_sdio_chip_detach(struct chip_info **ci_ptr);
+			   struct brcmf_chip **ci_ptr);
+void brcmf_sdio_chip_detach(struct brcmf_chip **ci_ptr);
 void brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
-				       struct chip_info *ci, u32 drivestrength);
-u8 brcmf_sdio_chip_getinfidx(struct chip_info *ci, u16 coreid);
+				       struct brcmf_chip *ci,
+				       u32 drivestrength);
+u8 brcmf_sdio_chip_getinfidx(struct brcmf_chip *ci, u16 coreid);
 void brcmf_sdio_chip_enter_download(struct brcmf_sdio_dev *sdiodev,
-				    struct chip_info *ci);
+				    struct brcmf_chip *ci);
 bool brcmf_sdio_chip_exit_download(struct brcmf_sdio_dev *sdiodev,
-				   struct chip_info *ci, u32 rstvec);
+				   struct brcmf_chip *ci, u32 rstvec);
 
 #endif		/* _BRCMFMAC_SDIO_CHIP_H_ */
-- 
1.7.10.4


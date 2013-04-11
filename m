Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4952 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab3DKL3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:29:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/15] brcmfmac: support save&restore firmware feature
Date: Thu, 11 Apr 2013 13:28:46 +0200
Message-ID: <1365679740-25679-2-git-send-email-arend@broadcom.com> (sfid-20130411_132943_048135_82FC3932)
In-Reply-To: <1365679740-25679-1-git-send-email-arend@broadcom.com>
References: <1365679740-25679-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

Save & restore is an advanced power saving feature,
supported only on selected devices.
SR operation is almost completely transparent to the driver.
Support for it is hardware and firmware dependent.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  262 +++++++++++++++++++-
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   22 +-
 .../net/wireless/brcm80211/include/chipcommon.h    |   14 +-
 3 files changed, 282 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 4ff2d3c..fb4ff91 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -324,6 +324,9 @@ MODULE_FIRMWARE(BRCMF_SDIO_NV_NAME);
 					 */
 #define BRCMF_IDLE_INTERVAL	1
 
+#define KSO_WAIT_US 50
+#define MAX_KSO_ATTEMPTS (PMU_MAX_TRANSITION_DLY/KSO_WAIT_US)
+
 /*
  * Conversion of 802.1D priority to precedence level
  */
@@ -588,12 +591,14 @@ struct brcmf_sdio {
 
 	bool txoff;		/* Transmit flow-controlled */
 	struct brcmf_sdio_count sdcnt;
+	bool sr_enabled; /* SaveRestore enabled */
+	bool sleeping; /* SDIO bus sleeping */
 };
 
 /* clkstate */
 #define CLK_NONE	0
 #define CLK_SDONLY	1
-#define CLK_PENDING	2	/* Not used yet */
+#define CLK_PENDING	2
 #define CLK_AVAIL	3
 
 #ifdef DEBUG
@@ -665,6 +670,62 @@ w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset)
 	return ret;
 }
 
+static int
+brcmf_sdbrcm_kso_control(struct brcmf_sdio *bus, bool on)
+{
+	u8 wr_val = 0, rd_val, cmp_val, bmask;
+	int err = 0;
+	int try_cnt = 0;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	wr_val = (on << SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
+	/* 1st KSO write goes to AOS wake up core if device is asleep  */
+	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
+			 wr_val, &err);
+	if (err) {
+		brcmf_err("SDIO_AOS KSO write error: %d\n", err);
+		return err;
+	}
+
+	if (on) {
+		/* device WAKEUP through KSO:
+		 * write bit 0 & read back until
+		 * both bits 0 (kso bit) & 1 (dev on status) are set
+		 */
+		cmp_val = SBSDIO_FUNC1_SLEEPCSR_KSO_MASK |
+			  SBSDIO_FUNC1_SLEEPCSR_DEVON_MASK;
+		bmask = cmp_val;
+		usleep_range(2000, 3000);
+	} else {
+		/* Put device to sleep, turn off KSO */
+		cmp_val = 0;
+		/* only check for bit0, bit1(dev on status) may not
+		 * get cleared right away
+		 */
+		bmask = SBSDIO_FUNC1_SLEEPCSR_KSO_MASK;
+	}
+
+	do {
+		/* reliable KSO bit set/clr:
+		 * the sdiod sleep write access is synced to PMU 32khz clk
+		 * just one write attempt may fail,
+		 * read it back until it matches written value
+		 */
+		rd_val = brcmf_sdio_regrb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
+					  &err);
+		if (((rd_val & bmask) == cmp_val) && !err)
+			break;
+		brcmf_dbg(SDIO, "KSO wr/rd retry:%d (max: %d) ERR:%x\n",
+			  try_cnt, MAX_KSO_ATTEMPTS, err);
+		udelay(KSO_WAIT_US);
+		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
+				 wr_val, &err);
+	} while (try_cnt++ < MAX_KSO_ATTEMPTS);
+
+	return err;
+}
+
 #define PKT_AVAILABLE()		(intstatus & I_HMB_FRAME_IND)
 
 #define HOSTINTMASK		(I_HMB_SW_MASK | I_CHIPACTIVE)
@@ -680,6 +741,11 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 
 	clkctl = 0;
 
+	if (bus->sr_enabled) {
+		bus->clkstate = (on ? CLK_AVAIL : CLK_SDONLY);
+		return 0;
+	}
+
 	if (on) {
 		/* Request HT Avail */
 		clkreq =
@@ -856,6 +922,63 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 	return 0;
 }
 
+static int
+brcmf_sdbrcm_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
+{
+	int err = 0;
+	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "request %s currently %s\n",
+		  (sleep ? "SLEEP" : "WAKE"),
+		  (bus->sleeping ? "SLEEP" : "WAKE"));
+
+	/* If SR is enabled control bus state with KSO */
+	if (bus->sr_enabled) {
+		/* Done if we're already in the requested state */
+		if (sleep == bus->sleeping)
+			goto end;
+
+		/* Going to sleep */
+		if (sleep) {
+			/* Don't sleep if something is pending */
+			if (atomic_read(&bus->intstatus) ||
+			    atomic_read(&bus->ipend) > 0 ||
+			    (!atomic_read(&bus->fcstate) &&
+			    brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) &&
+			    data_ok(bus)))
+				 return -EBUSY;
+			err = brcmf_sdbrcm_kso_control(bus, false);
+			/* disable watchdog */
+			if (!err)
+				brcmf_sdbrcm_wd_timer(bus, 0);
+		} else {
+			bus->idlecount = 0;
+			err = brcmf_sdbrcm_kso_control(bus, true);
+		}
+		if (!err) {
+			/* Change state */
+			bus->sleeping = sleep;
+			brcmf_dbg(SDIO, "new state %s\n",
+				  (sleep ? "SLEEP" : "WAKE"));
+		} else {
+			brcmf_err("error while changing bus sleep state %d\n",
+				  err);
+			return err;
+		}
+	}
+
+end:
+	/* control clocks */
+	if (sleep) {
+		if (!bus->sr_enabled)
+			brcmf_sdbrcm_clkctl(bus, CLK_NONE, pendok);
+	} else {
+		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, pendok);
+	}
+
+	return err;
+
+}
+
 static u32 brcmf_sdbrcm_hostmail(struct brcmf_sdio *bus)
 {
 	u32 intstatus = 0;
@@ -1960,7 +2083,7 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 	sdio_claim_host(bus->sdiodev->func[1]);
 
 	/* Enable clock for device interrupts */
-	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+	brcmf_sdbrcm_bus_sleep(bus, false, false);
 
 	/* Disable and clear interrupts at the chip level also */
 	w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, hostintmask));
@@ -2096,7 +2219,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	sdio_claim_host(bus->sdiodev->func[1]);
 
 	/* If waiting for HTAVAIL, check status */
-	if (bus->clkstate == CLK_PENDING) {
+	if (!bus->sr_enabled && bus->clkstate == CLK_PENDING) {
 		u8 clkctl, devctl = 0;
 
 #ifdef DEBUG
@@ -2142,7 +2265,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	}
 
 	/* Make sure backplane clock is on */
-	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
+	brcmf_sdbrcm_bus_sleep(bus, false, true);
 
 	/* Pending interrupt indicates new device status */
 	if (atomic_read(&bus->ipend) > 0) {
@@ -2288,8 +2411,9 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	if ((bus->clkstate != CLK_PENDING)
 	    && bus->idletime == BRCMF_IDLE_IMMEDIATE) {
 		bus->activity = false;
+		brcmf_dbg(SDIO, "idle state\n");
 		sdio_claim_host(bus->sdiodev->func[1]);
-		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
+		brcmf_sdbrcm_bus_sleep(bus, true, false);
 		sdio_release_host(bus->sdiodev->func[1]);
 	}
 }
@@ -2592,7 +2716,7 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 
 	/* Make sure backplane clock is on */
 	sdio_claim_host(bus->sdiodev->func[1]);
-	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+	brcmf_sdbrcm_bus_sleep(bus, false, false);
 	sdio_release_host(bus->sdiodev->func[1]);
 
 	/* Hardware tag: 2 byte len followed by 2 byte ~len check (all LE) */
@@ -2650,6 +2774,7 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 
 		bus->activity = false;
 		sdio_claim_host(bus->sdiodev->func[1]);
+		brcmf_dbg(INFO, "idle\n");
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 		sdio_release_host(bus->sdiodev->func[1]);
 	} else {
@@ -2686,7 +2811,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	 * address of sdpcm_shared structure
 	 */
 	sdio_claim_host(bus->sdiodev->func[1]);
-	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+	brcmf_sdbrcm_bus_sleep(bus, false, false);
 	rv = brcmf_sdbrcm_membytes(bus, false, shaddr,
 				   (u8 *)&addr_le, 4);
 	sdio_release_host(bus->sdiodev->func[1]);
@@ -3325,6 +3450,103 @@ err:
 	return bcmerror;
 }
 
+static bool brcmf_sdbrcm_sr_capable(struct brcmf_sdio *bus)
+{
+	u32 addr, reg;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	/* old chips with PMU version less than 17 don't support save restore */
+	if (bus->ci->pmurev < 17)
+		return false;
+
+	/* read PMU chipcontrol register 3*/
+	addr = CORE_CC_REG(bus->ci->c_inf[0].base, chipcontrol_addr);
+	brcmf_sdio_regwl(bus->sdiodev, addr, 3, NULL);
+	addr = CORE_CC_REG(bus->ci->c_inf[0].base, chipcontrol_data);
+	reg = brcmf_sdio_regrl(bus->sdiodev, addr, NULL);
+
+	return (bool)reg;
+}
+
+static void brcmf_sdbrcm_sr_init(struct brcmf_sdio *bus)
+{
+	int err = 0;
+	u8 val;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	val = brcmf_sdio_regrb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL,
+			       &err);
+	if (err) {
+		brcmf_err("error reading SBSDIO_FUNC1_WAKEUPCTRL\n");
+		return;
+	}
+
+	val |= 1 << SBSDIO_FUNC1_WCTRL_HTWAIT_SHIFT;
+	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL,
+			 val, &err);
+	if (err) {
+		brcmf_err("error writing SBSDIO_FUNC1_WAKEUPCTRL\n");
+		return;
+	}
+
+	/* Add CMD14 Support */
+	brcmf_sdio_regwb(bus->sdiodev, SDIO_CCCR_BRCM_CARDCAP,
+			 (SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT |
+			  SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT),
+			 &err);
+	if (err) {
+		brcmf_err("error writing SDIO_CCCR_BRCM_CARDCAP\n");
+		return;
+	}
+
+	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+			 SBSDIO_FORCE_HT, &err);
+	if (err) {
+		brcmf_err("error writing SBSDIO_FUNC1_CHIPCLKCSR\n");
+		return;
+	}
+
+	/* set flag */
+	bus->sr_enabled = true;
+	brcmf_dbg(INFO, "SR enabled\n");
+}
+
+/* enable KSO bit */
+static int brcmf_sdbrcm_kso_init(struct brcmf_sdio *bus)
+{
+	u8 val;
+	int err = 0;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	/* KSO bit added in SDIO core rev 12 */
+	if (bus->ci->c_inf[1].rev < 12)
+		return 0;
+
+	val = brcmf_sdio_regrb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
+			       &err);
+	if (err) {
+		brcmf_err("error reading SBSDIO_FUNC1_SLEEPCSR\n");
+		return err;
+	}
+
+	if (!(val & SBSDIO_FUNC1_SLEEPCSR_KSO_MASK)) {
+		val |= (SBSDIO_FUNC1_SLEEPCSR_KSO_EN <<
+			SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
+		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
+				 val, &err);
+		if (err) {
+			brcmf_err("error writing SBSDIO_FUNC1_SLEEPCSR\n");
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+
 static bool
 brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
 {
@@ -3423,8 +3645,13 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 		ret = -ENODEV;
 	}
 
-	/* Restore previous clock setting */
-	brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, saveclk, &err);
+	if (brcmf_sdbrcm_sr_capable(bus)) {
+		brcmf_sdbrcm_sr_init(bus);
+	} else {
+		/* Restore previous clock setting */
+		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+				 saveclk, &err);
+	}
 
 	if (ret == 0) {
 		ret = brcmf_sdio_intr_register(bus->sdiodev);
@@ -3485,7 +3712,8 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 	brcmf_dbg(TIMER, "Enter\n");
 
 	/* Poll period: check device if appropriate. */
-	if (bus->poll && (++bus->polltick >= bus->pollrate)) {
+	if (!bus->sr_enabled &&
+	    bus->poll && (++bus->polltick >= bus->pollrate)) {
 		u32 intstatus = 0;
 
 		/* Reset poll tick */
@@ -3536,7 +3764,7 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 			bus->console.count -= bus->console_interval;
 			sdio_claim_host(bus->sdiodev->func[1]);
 			/* Make sure backplane clock is on */
-			brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+			brcmf_sdbrcm_bus_sleep(bus, false, false);
 			if (brcmf_sdbrcm_readconsole(bus) < 0)
 				/* stop on error */
 				bus->console_interval = 0;
@@ -3553,8 +3781,9 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 				bus->activity = false;
 				brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 			} else {
+				brcmf_dbg(SDIO, "idle\n");
 				sdio_claim_host(bus->sdiodev->func[1]);
-				brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
+				brcmf_sdbrcm_bus_sleep(bus, true, false);
 				sdio_release_host(bus->sdiodev->func[1]);
 			}
 		}
@@ -3686,6 +3915,11 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 		goto fail;
 	}
 
+	if (brcmf_sdbrcm_kso_init(bus)) {
+		brcmf_err("error enabling KSO\n");
+		goto fail;
+	}
+
 	brcmf_sdio_chip_drivestrengthinit(bus->sdiodev, bus->ci,
 					  SDIO_DRIVE_STRENGTH);
 
@@ -3755,6 +3989,10 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_sdio *bus)
 	bus->use_rxchain = false;
 	bus->sd_rxchain = false;
 
+	/* SR state */
+	bus->sleeping = false;
+	bus->sr_enabled = false;
+
 	return true;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 0d30afd..4e681ae 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -48,7 +48,11 @@
 #define SBSDIO_NUM_FUNCTION		3
 
 /* function 0 vendor specific CCCR registers */
-#define SDIO_CCCR_BRCM_SEPINT		0xf2
+#define SDIO_CCCR_BRCM_CARDCAP			0xf0
+#define SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT	0x02
+#define SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT	0x04
+#define SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC	0x08
+#define SDIO_CCCR_BRCM_SEPINT			0xf2
 
 #define  SDIO_SEPINT_MASK		0x01
 #define  SDIO_SEPINT_OE			0x02
@@ -97,9 +101,23 @@
 #define SBSDIO_FUNC1_RFRAMEBCLO		0x1001B
 /* Read Frame Byte Count High */
 #define SBSDIO_FUNC1_RFRAMEBCHI		0x1001C
+/* MesBusyCtl (rev 11) */
+#define SBSDIO_FUNC1_MESBUSYCTRL	0x1001D
+/* Sdio Core Rev 12 */
+#define SBSDIO_FUNC1_WAKEUPCTRL		0x1001E
+#define SBSDIO_FUNC1_WCTRL_ALPWAIT_MASK		0x1
+#define SBSDIO_FUNC1_WCTRL_ALPWAIT_SHIFT	0
+#define SBSDIO_FUNC1_WCTRL_HTWAIT_MASK		0x2
+#define SBSDIO_FUNC1_WCTRL_HTWAIT_SHIFT		1
+#define SBSDIO_FUNC1_SLEEPCSR		0x1001F
+#define SBSDIO_FUNC1_SLEEPCSR_KSO_MASK		0x1
+#define SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT		0
+#define SBSDIO_FUNC1_SLEEPCSR_KSO_EN		1
+#define SBSDIO_FUNC1_SLEEPCSR_DEVON_MASK	0x2
+#define SBSDIO_FUNC1_SLEEPCSR_DEVON_SHIFT	1
 
 #define SBSDIO_FUNC1_MISC_REG_START	0x10000	/* f1 misc register start */
-#define SBSDIO_FUNC1_MISC_REG_LIMIT	0x1001C	/* f1 misc register end */
+#define SBSDIO_FUNC1_MISC_REG_LIMIT	0x1001F	/* f1 misc register end */
 
 /* function 1 OCP space */
 
diff --git a/drivers/net/wireless/brcm80211/include/chipcommon.h b/drivers/net/wireless/brcm80211/include/chipcommon.h
index f96834a..d242333 100644
--- a/drivers/net/wireless/brcm80211/include/chipcommon.h
+++ b/drivers/net/wireless/brcm80211/include/chipcommon.h
@@ -205,7 +205,7 @@ struct chipcregs {
 	u32 res_req_timer_sel;
 	u32 res_req_timer;
 	u32 res_req_mask;
-	u32 PAD;
+	u32 pmucapabilities_ext; /* 0x64c, pmurev >=15 */
 	u32 chipcontrol_addr;	/* 0x650 */
 	u32 chipcontrol_data;	/* 0x654 */
 	u32 regcontrol_addr;
@@ -214,7 +214,11 @@ struct chipcregs {
 	u32 pllcontrol_data;
 	u32 pmustrapopt;	/* 0x668, corerev >= 28 */
 	u32 pmu_xtalfreq;	/* 0x66C, pmurev >= 10 */
-	u32 PAD[100];
+	u32 retention_ctl;          /* 0x670, pmurev >= 15 */
+	u32 PAD[3];
+	u32 retention_grpidx;       /* 0x680 */
+	u32 retention_grpctl;       /* 0x684 */
+	u32 PAD[94];
 	u16 sromotp[768];
 };
 
@@ -276,6 +280,12 @@ struct chipcregs {
 #define PCAP5_VC_SHIFT	22
 #define PCAP5_CC_MASK	0xf8000000
 #define PCAP5_CC_SHIFT	27
+/* pmucapabilites_ext PMU rev >= 15 */
+#define PCAPEXT_SR_SUPPORTED_MASK	(1 << 1)
+/* retention_ctl PMU rev >= 15 */
+#define PMU_RCTL_MACPHY_DISABLE_MASK        (1 << 26)
+#define PMU_RCTL_LOGIC_DISABLE_MASK         (1 << 27)
+
 
 /*
 * Maximum delay for the PMU state transition in us.
-- 
1.7.10.4



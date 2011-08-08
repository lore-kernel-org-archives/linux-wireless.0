Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3144 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab1HHN7a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 56/82] staging: brcm80211: fixed checkpatch warnings
 for 'include' dir
Date: Mon, 8 Aug 2011 15:58:40 +0200
Message-ID: <1312811946-16713-57-git-send-email-arend@broadcom.com> (sfid-20110808_160138_492250_E71E5B46)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

All of them being 'line longer than 80 chars' type of warning.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/include/brcmu_utils.h |    3 +-
 drivers/staging/brcm80211/include/brcmu_wifi.h  |  103 +++++++++++++++--------
 drivers/staging/brcm80211/include/chipcommon.h  |    9 ++-
 drivers/staging/brcm80211/include/defs.h        |   14 ++-
 drivers/staging/brcm80211/include/soc.h         |    5 +-
 5 files changed, 88 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index 513fa34..da13e24 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -264,7 +264,8 @@ struct brcmu_tlv {
 	u8 data[1];
 };
 
-#define ETHER_ADDR_STR_LEN	18	/* 18-bytes of Ethernet address buffer length */
+/* 18-bytes of Ethernet address buffer length */
+#define ETHER_ADDR_STR_LEN	18
 
 /* externs */
 /* crc */
diff --git a/drivers/staging/brcm80211/include/brcmu_wifi.h b/drivers/staging/brcm80211/include/brcmu_wifi.h
index 949349f..717d885 100644
--- a/drivers/staging/brcm80211/include/brcmu_wifi.h
+++ b/drivers/staging/brcm80211/include/brcmu_wifi.h
@@ -31,13 +31,16 @@
 #define CH_EWA_VALID			0x04
 #define CH_20MHZ_APART			4
 #define CH_10MHZ_APART			2
-#define CH_5MHZ_APART			1	/* 2G band channels are 5 Mhz apart */
+#define CH_5MHZ_APART			1 /* 2G band channels are 5 Mhz apart */
 #define CH_MAX_2G_CHANNEL		14	/* Max channel in 2G band */
 #define BRCM_MAX_2G_CHANNEL	CH_MAX_2G_CHANNEL	/* legacy define */
-#define	MAXCHANNEL		224	/* max # supported channels. The max channel no is 216,
-					 * this is that + 1 rounded up to a multiple of NBBY (8).
-					 * DO NOT MAKE it > 255: channels are u8's all over
-					 */
+
+/*
+ * max # supported channels. The max channel no is 216, this is that + 1
+ * rounded up to a multiple of NBBY (8). DO NOT MAKE it > 255: channels are
+ * u8's all over
+*/
+#define	MAXCHANNEL		224
 
 #define WL_CHANSPEC_CHAN_MASK		0x00ff
 #define WL_CHANSPEC_CHAN_SHIFT		0
@@ -66,20 +69,30 @@
 #define WF_CHAN_FACTOR_4_G		8000	/* 4.9 GHz band for Japan */
 
 /* channel defines */
-#define LOWER_20_SB(channel)	(((channel) > CH_10MHZ_APART) ? ((channel) - CH_10MHZ_APART) : 0)
-#define UPPER_20_SB(channel)	(((channel) < (MAXCHANNEL - CH_10MHZ_APART)) ? \
-				((channel) + CH_10MHZ_APART) : 0)
-#define CHSPEC_BANDUNIT(chspec)	(CHSPEC_IS5G(chspec) ? BAND_5G_INDEX : \
-						       BAND_2G_INDEX)
-#define CH20MHZ_CHSPEC(channel)	(u16)((u16)(channel) | WL_CHANSPEC_BW_20 | \
-				WL_CHANSPEC_CTL_SB_NONE | (((channel) <= CH_MAX_2G_CHANNEL) ? \
-				WL_CHANSPEC_BAND_2G : WL_CHANSPEC_BAND_5G))
-#define NEXT_20MHZ_CHAN(channel)	(((channel) < (MAXCHANNEL - CH_20MHZ_APART)) ? \
-					((channel) + CH_20MHZ_APART) : 0)
-#define CH40MHZ_CHSPEC(channel, ctlsb)	(u16) \
-					((channel) | (ctlsb) | WL_CHANSPEC_BW_40 | \
-					((channel) <= CH_MAX_2G_CHANNEL ? WL_CHANSPEC_BAND_2G : \
-					WL_CHANSPEC_BAND_5G))
+#define LOWER_20_SB(channel) \
+	(((channel) > CH_10MHZ_APART) ? ((channel) - CH_10MHZ_APART) : 0)
+
+#define UPPER_20_SB(channel) \
+	(((channel) < (MAXCHANNEL - CH_10MHZ_APART)) ? \
+	 ((channel) + CH_10MHZ_APART) : 0)
+
+#define CHSPEC_BANDUNIT(chspec) \
+	(CHSPEC_IS5G(chspec) ? BAND_5G_INDEX : BAND_2G_INDEX)
+
+#define CH20MHZ_CHSPEC(channel) \
+	(u16)((u16)(channel) | WL_CHANSPEC_BW_20 | WL_CHANSPEC_CTL_SB_NONE | \
+		    (((channel) <= CH_MAX_2G_CHANNEL) ? \
+		    WL_CHANSPEC_BAND_2G : WL_CHANSPEC_BAND_5G))
+
+#define NEXT_20MHZ_CHAN(channel) \
+	(((channel) < (MAXCHANNEL - CH_20MHZ_APART)) ? \
+	 ((channel) + CH_20MHZ_APART) : 0)
+
+#define CH40MHZ_CHSPEC(channel, ctlsb) \
+	(u16)((channel) | (ctlsb) | WL_CHANSPEC_BW_40 | \
+	      ((channel) <= CH_MAX_2G_CHANNEL ? \
+		WL_CHANSPEC_BAND_2G : WL_CHANSPEC_BAND_5G))
+
 #define CHSPEC_CHANNEL(chspec)	((u8)((chspec) & WL_CHANSPEC_CHAN_MASK))
 #define CHSPEC_BAND(chspec)	((chspec) & WL_CHANSPEC_BAND_MASK)
 
@@ -97,22 +110,40 @@
 
 #define CHSPEC_CTL_SB(chspec)	((chspec) & WL_CHANSPEC_CTL_SB_MASK)
 #define CHSPEC_BW(chspec)	((chspec) & WL_CHANSPEC_BW_MASK)
-#define CHSPEC_IS10(chspec)	(((chspec) & WL_CHANSPEC_BW_MASK) == WL_CHANSPEC_BW_10)
-#define CHSPEC_IS20(chspec)	(((chspec) & WL_CHANSPEC_BW_MASK) == WL_CHANSPEC_BW_20)
+
+#define CHSPEC_IS10(chspec) \
+	(((chspec) & WL_CHANSPEC_BW_MASK) == WL_CHANSPEC_BW_10)
+
+#define CHSPEC_IS20(chspec) \
+	(((chspec) & WL_CHANSPEC_BW_MASK) == WL_CHANSPEC_BW_20)
+
 #ifndef CHSPEC_IS40
-#define CHSPEC_IS40(chspec)	(((chspec) & WL_CHANSPEC_BW_MASK) == WL_CHANSPEC_BW_40)
+#define CHSPEC_IS40(chspec) \
+	(((chspec) & WL_CHANSPEC_BW_MASK) == WL_CHANSPEC_BW_40)
 #endif
 
 #endif				/* !WL11N_20MHZONLY */
 
-#define CHSPEC_IS5G(chspec)	(((chspec) & WL_CHANSPEC_BAND_MASK) == WL_CHANSPEC_BAND_5G)
-#define CHSPEC_IS2G(chspec)	(((chspec) & WL_CHANSPEC_BAND_MASK) == WL_CHANSPEC_BAND_2G)
-#define CHSPEC_SB_NONE(chspec)	(((chspec) & WL_CHANSPEC_CTL_SB_MASK) == WL_CHANSPEC_CTL_SB_NONE)
-#define CHSPEC_SB_UPPER(chspec)	(((chspec) & WL_CHANSPEC_CTL_SB_MASK) == WL_CHANSPEC_CTL_SB_UPPER)
-#define CHSPEC_SB_LOWER(chspec)	(((chspec) & WL_CHANSPEC_CTL_SB_MASK) == WL_CHANSPEC_CTL_SB_LOWER)
-#define CHSPEC_CTL_CHAN(chspec)  ((CHSPEC_SB_LOWER(chspec)) ? \
-				  (LOWER_20_SB(((chspec) & WL_CHANSPEC_CHAN_MASK))) : \
-				  (UPPER_20_SB(((chspec) & WL_CHANSPEC_CHAN_MASK))))
+#define CHSPEC_IS5G(chspec) \
+	(((chspec) & WL_CHANSPEC_BAND_MASK) == WL_CHANSPEC_BAND_5G)
+
+#define CHSPEC_IS2G(chspec) \
+	(((chspec) & WL_CHANSPEC_BAND_MASK) == WL_CHANSPEC_BAND_2G)
+
+#define CHSPEC_SB_NONE(chspec) \
+	(((chspec) & WL_CHANSPEC_CTL_SB_MASK) == WL_CHANSPEC_CTL_SB_NONE)
+
+#define CHSPEC_SB_UPPER(chspec) \
+	(((chspec) & WL_CHANSPEC_CTL_SB_MASK) == WL_CHANSPEC_CTL_SB_UPPER)
+
+#define CHSPEC_SB_LOWER(chspec) \
+	(((chspec) & WL_CHANSPEC_CTL_SB_MASK) == WL_CHANSPEC_CTL_SB_LOWER)
+
+#define CHSPEC_CTL_CHAN(chspec) \
+	((CHSPEC_SB_LOWER(chspec)) ? \
+	(LOWER_20_SB(((chspec) & WL_CHANSPEC_CHAN_MASK))) : \
+	(UPPER_20_SB(((chspec) & WL_CHANSPEC_CHAN_MASK))))
+
 #define CHSPEC2BAND(chspec) (CHSPEC_IS5G(chspec) ? BRCM_BAND_5G : BRCM_BAND_2G)
 
 #define CHANSPEC_STR_LEN    8
@@ -147,9 +178,9 @@
 extern bool brcmu_chspec_malformed(u16 chanspec);
 
 /*
- * This function returns the channel number that control traffic is being sent on, for legacy
- * channels this is just the channel number, for 40MHZ channels it is the upper or lowre 20MHZ
- * sideband depending on the chanspec selected
+ * This function returns the channel number that control traffic is being sent
+ * on, for legacy channels this is just the channel number, for 40MHZ channels
+ * it is the upper or lower 20MHZ sideband depending on the chanspec selected.
  */
 extern u8 brcmu_chspec_ctlchan(u16 chspec);
 
@@ -185,11 +216,13 @@ extern int brcmu_mhz2channel(uint freq, uint start_factor);
 #define CRYPTO_ALGO_NALG		7
 
 /* wireless security bitvec */
+
 #define WEP_ENABLED		0x0001
 #define TKIP_ENABLED		0x0002
 #define AES_ENABLED		0x0004
 #define WSEC_SWFLAG		0x0008
-#define SES_OW_ENABLED		0x0040	/* to go into transition mode without setting wep */
+/* to go into transition mode without setting wep */
+#define SES_OW_ENABLED		0x0040
 
 /* WPA authentication mode bitvec */
 #define WPA_AUTH_DISABLED	0x0000	/* Legacy (i.e., non-WPA) */
@@ -198,7 +231,7 @@ extern int brcmu_mhz2channel(uint freq, uint start_factor);
 #define WPA_AUTH_PSK		0x0004	/* Pre-shared key */
 #define WPA_AUTH_RESERVED1	0x0008
 #define WPA_AUTH_RESERVED2	0x0010
-					/* #define WPA_AUTH_8021X 0x0020 *//* 802.1x, reserved */
+
 #define WPA2_AUTH_RESERVED1	0x0020
 #define WPA2_AUTH_UNSPECIFIED	0x0040	/* over 802.1x */
 #define WPA2_AUTH_PSK		0x0080	/* Pre-shared key */
diff --git a/drivers/staging/brcm80211/include/chipcommon.h b/drivers/staging/brcm80211/include/chipcommon.h
index 8de5913..fefabc3 100644
--- a/drivers/staging/brcm80211/include/chipcommon.h
+++ b/drivers/staging/brcm80211/include/chipcommon.h
@@ -231,7 +231,8 @@ struct chipcregs {
 #define	CC_CAP_UARTS_MASK	0x00000003	/* Number of UARTs */
 #define CC_CAP_MIPSEB		0x00000004	/* MIPS is in big-endian mode */
 #define CC_CAP_UCLKSEL		0x00000018	/* UARTs clock select */
-#define CC_CAP_UINTCLK		0x00000008	/* UARTs are driven by internal divided clock */
+/* UARTs are driven by internal divided clock */
+#define CC_CAP_UINTCLK		0x00000008
 #define CC_CAP_UARTGPIO		0x00000020	/* UARTs own GPIOs 15:12 */
 #define CC_CAP_EXTBUS_MASK	0x000000c0	/* External bus mask */
 #define CC_CAP_EXTBUS_NONE	0x00000000	/* No ExtBus present */
@@ -248,10 +249,12 @@ struct chipcregs {
 #define CC_CAP_BKPLN64		0x08000000	/* 64-bit backplane */
 #define	CC_CAP_PMU		0x10000000	/* PMU Present, rev >= 20 */
 #define	CC_CAP_SROM		0x40000000	/* Srom Present, rev >= 32 */
-#define	CC_CAP_NFLASH		0x80000000	/* Nand flash present, rev >= 35 */
+/* Nand flash present, rev >= 35 */
+#define	CC_CAP_NFLASH		0x80000000
 
 #define	CC_CAP2_SECI		0x00000001	/* SECI Present, rev >= 36 */
-#define	CC_CAP2_GSIO		0x00000002	/* GSIO (spi/i2c) present, rev >= 37 */
+/* GSIO (spi/i2c) present, rev >= 37 */
+#define	CC_CAP2_GSIO		0x00000002
 
 /* pmucapabilities */
 #define PCAP_REV_MASK	0x000000ff
diff --git a/drivers/staging/brcm80211/include/defs.h b/drivers/staging/brcm80211/include/defs.h
index 838424c..8e0c559 100644
--- a/drivers/staging/brcm80211/include/defs.h
+++ b/drivers/staging/brcm80211/include/defs.h
@@ -55,8 +55,10 @@
 #define WL_NUMRATES		16	/* max # of rates in a rateset */
 
 struct brcm_rateset {
-	u32 count;		/* # rates in this set */
-	u8 rates[WL_NUMRATES];	/* rates in 500kbps units w/hi bit set if basic */
+	/* # rates in this set */
+	u32 count;
+	/* rates in 500kbps units w/hi bit set if basic */
+	u8 rates[WL_NUMRATES];
 };
 
 #define BRCM_CNTRY_BUF_SZ	4	/* Country string is 3 bytes + NUL */
@@ -71,10 +73,12 @@ struct brcm_rateset {
 #define BRCM_GET_PHYLIST				180
 
 /* Bit masks for radio disabled status - returned by WL_GET_RADIO */
+
 #define WL_RADIO_SW_DISABLE		(1<<0)
 #define WL_RADIO_HW_DISABLE		(1<<1)
 #define WL_RADIO_MPC_DISABLE		(1<<2)
-#define WL_RADIO_COUNTRY_DISABLE	(1<<3)	/* some countries don't support any channel */
+/* some countries don't support any channel */
+#define WL_RADIO_COUNTRY_DISABLE	(1<<3)
 
 /* Override bit for SET_TXPWR.  if set, ignore other level limits */
 #define WL_TXPWR_OVERRIDE	(1U<<31)
@@ -100,7 +104,9 @@ struct brcm_rateset {
 /*
  * Sonics Configuration Space Registers.
  */
-#define	SBCONFIGOFF		0xf00	/* core sbconfig regs are top 256bytes of regs */
+
+/* core sbconfig regs are top 256bytes of regs */
+#define	SBCONFIGOFF		0xf00
 
 /* cpp contortions to concatenate w/arg prescan */
 #ifndef	PAD
diff --git a/drivers/staging/brcm80211/include/soc.h b/drivers/staging/brcm80211/include/soc.h
index 6e5a705..f23edc5 100644
--- a/drivers/staging/brcm80211/include/soc.h
+++ b/drivers/staging/brcm80211/include/soc.h
@@ -81,9 +81,8 @@
 #define	DMEMS_CORE_ID		0x835	/* SDR/DDR1 memory controller core */
 #define	DEF_SHIM_COMP		0x837	/* SHIM component in ubus/6362 */
 #define OOB_ROUTER_CORE_ID	0x367	/* OOB router core ID */
-#define	DEF_AI_COMP		0xfff	/* Default component, in ai chips it maps all
-					 * unused address ranges
-					 */
+/* Default component, in ai chips it maps all unused address ranges */
+#define	DEF_AI_COMP		0xfff
 
 /* Common core control flags */
 #define	SICF_BIST_EN		0x8000
-- 
1.7.4.1



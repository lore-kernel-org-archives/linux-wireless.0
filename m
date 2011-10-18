Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2287 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536Ab1JRMD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/15] brcm80211: smac: removed support for SROM rev < 8
Date: Tue, 18 Oct 2011 14:03:00 +0200
Message-ID: <1318939391-19495-5-git-send-email-arend@broadcom.com> (sfid-20111018_140356_823467_C315E0FC)
In-Reply-To: <1318939391-19495-1-git-send-email-arend@broadcom.com>
References: <1318939391-19495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Supported chips contain SROM rev 8 and upwards.

Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/srom.c |  376 +++---------------------
 drivers/net/wireless/brcm80211/brcmsmac/srom.h |    5 -
 2 files changed, 34 insertions(+), 347 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/srom.c b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
index b52b0d2..a884fe0 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/srom.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
@@ -63,9 +63,6 @@
 #define	SROM_MACHI_ET1		42
 #define	SROM_MACMID_ET1		43
 #define	SROM_MACLO_ET1		44
-#define	SROM3_MACHI		37
-#define	SROM3_MACMID		38
-#define	SROM3_MACLO		39
 
 #define	SROM_BXARSSI2G		40
 #define	SROM_BXARSSI5G		41
@@ -102,7 +99,6 @@
 
 #define	SROM_BFL		57
 #define	SROM_BFL2		28
-#define	SROM3_BFL2		61
 
 #define	SROM_AG10		58
 
@@ -110,99 +106,16 @@
 
 #define	SROM_OPO		60
 
-#define	SROM3_LEDDC		62
-
 #define	SROM_CRCREV		63
 
-/* SROM Rev 4: Reallocate the software part of the srom to accommodate
- * MIMO features. It assumes up to two PCIE functions and 440 bytes
- * of usable srom i.e. the usable storage in chips with OTP that
- * implements hardware redundancy.
- */
-
 #define	SROM4_WORDS		220
 
-#define	SROM4_SIGN		32
-#define	SROM4_SIGNATURE		0x5372
-
-#define	SROM4_BREV		33
-
-#define	SROM4_BFL0		34
-#define	SROM4_BFL1		35
-#define	SROM4_BFL2		36
-#define	SROM4_BFL3		37
-#define	SROM5_BFL0		37
-#define	SROM5_BFL1		38
-#define	SROM5_BFL2		39
-#define	SROM5_BFL3		40
-
-#define	SROM4_MACHI		38
-#define	SROM4_MACMID		39
-#define	SROM4_MACLO		40
-#define	SROM5_MACHI		41
-#define	SROM5_MACMID		42
-#define	SROM5_MACLO		43
-
-#define	SROM4_CCODE		41
-#define	SROM4_REGREV		42
-#define	SROM5_CCODE		34
-#define	SROM5_REGREV		35
-
-#define	SROM4_LEDBH10		43
-#define	SROM4_LEDBH32		44
-#define	SROM5_LEDBH10		59
-#define	SROM5_LEDBH32		60
-
-#define	SROM4_LEDDC		45
-#define	SROM5_LEDDC		45
-
-#define	SROM4_AA		46
-
-#define	SROM4_AG10		47
-#define	SROM4_AG32		48
-
-#define	SROM4_TXPID2G		49
-#define	SROM4_TXPID5G		51
-#define	SROM4_TXPID5GL		53
-#define	SROM4_TXPID5GH		55
-
-#define SROM4_TXRXC		61
 #define SROM4_TXCHAIN_MASK	0x000f
-#define SROM4_TXCHAIN_SHIFT	0
 #define SROM4_RXCHAIN_MASK	0x00f0
-#define SROM4_RXCHAIN_SHIFT	4
 #define SROM4_SWITCH_MASK	0xff00
-#define SROM4_SWITCH_SHIFT	8
 
 /* Per-path fields */
 #define	MAX_PATH_SROM		4
-#define	SROM4_PATH0		64
-#define	SROM4_PATH1		87
-#define	SROM4_PATH2		110
-#define	SROM4_PATH3		133
-
-#define	SROM4_2G_ITT_MAXP	0
-#define	SROM4_2G_PA		1
-#define	SROM4_5G_ITT_MAXP	5
-#define	SROM4_5GLH_MAXP		6
-#define	SROM4_5G_PA		7
-#define	SROM4_5GL_PA		11
-#define	SROM4_5GH_PA		15
-
-/* All the miriad power offsets */
-#define	SROM4_2G_CCKPO		156
-#define	SROM4_2G_OFDMPO		157
-#define	SROM4_5G_OFDMPO		159
-#define	SROM4_5GL_OFDMPO	161
-#define	SROM4_5GH_OFDMPO	163
-#define	SROM4_2G_MCSPO		165
-#define	SROM4_5G_MCSPO		173
-#define	SROM4_5GL_MCSPO		181
-#define	SROM4_5GH_MCSPO		189
-#define	SROM4_CDDPO		197
-#define	SROM4_STBCPO		198
-#define	SROM4_BW40PO		199
-#define	SROM4_BWDUPPO		200
 
 #define	SROM4_CRCREV		219
 
@@ -425,103 +338,32 @@ struct brcms_varbuf {
 static const struct brcms_sromvar pci_sromvars[] = {
 	{BRCMS_SROM_DEVID, 0xffffff00, SRFL_PRHEX | SRFL_NOVAR, PCI_F0DEVID,
 	 0xffff},
-	{BRCMS_SROM_BOARDREV, 0x0000000e, SRFL_PRHEX, SROM_AABREV,
-	 SROM_BR_MASK},
-	{BRCMS_SROM_BOARDREV, 0x000000f0, SRFL_PRHEX, SROM4_BREV, 0xffff},
 	{BRCMS_SROM_BOARDREV, 0xffffff00, SRFL_PRHEX, SROM8_BREV, 0xffff},
-	{BRCMS_SROM_BOARDFLAGS, 0x00000002, SRFL_PRHEX, SROM_BFL, 0xffff},
-	{BRCMS_SROM_BOARDFLAGS, 0x00000004, SRFL_PRHEX | SRFL_MORE, SROM_BFL,
-	 0xffff},
-	{BRCMS_SROM_CONT, 0, 0, SROM_BFL2, 0xffff},
-	{BRCMS_SROM_BOARDFLAGS, 0x00000008, SRFL_PRHEX | SRFL_MORE, SROM_BFL,
-	 0xffff},
-	{BRCMS_SROM_CONT, 0, 0, SROM3_BFL2, 0xffff},
-	{BRCMS_SROM_BOARDFLAGS, 0x00000010, SRFL_PRHEX | SRFL_MORE, SROM4_BFL0,
-	 0xffff},
-	{BRCMS_SROM_CONT, 0, 0, SROM4_BFL1, 0xffff},
-	{BRCMS_SROM_BOARDFLAGS, 0x000000e0, SRFL_PRHEX | SRFL_MORE, SROM5_BFL0,
-	 0xffff},
-	{BRCMS_SROM_CONT, 0, 0, SROM5_BFL1, 0xffff},
 	{BRCMS_SROM_BOARDFLAGS, 0xffffff00, SRFL_PRHEX | SRFL_MORE, SROM8_BFL0,
 	 0xffff},
 	{BRCMS_SROM_CONT, 0, 0, SROM8_BFL1, 0xffff},
-	{BRCMS_SROM_BOARDFLAGS2, 0x00000010, SRFL_PRHEX | SRFL_MORE, SROM4_BFL2,
-	 0xffff},
-	{BRCMS_SROM_CONT, 0, 0, SROM4_BFL3, 0xffff},
-	{BRCMS_SROM_BOARDFLAGS2, 0x000000e0, SRFL_PRHEX | SRFL_MORE, SROM5_BFL2,
-	 0xffff},
-	{BRCMS_SROM_CONT, 0, 0, SROM5_BFL3, 0xffff},
 	{BRCMS_SROM_BOARDFLAGS2, 0xffffff00, SRFL_PRHEX | SRFL_MORE, SROM8_BFL2,
 	 0xffff},
 	{BRCMS_SROM_CONT, 0, 0, SROM8_BFL3, 0xffff},
 	{BRCMS_SROM_BOARDTYPE, 0xfffffffc, SRFL_PRHEX, SROM_SSID, 0xffff},
-	{BRCMS_SROM_BOARDNUM, 0x00000006, 0, SROM_MACLO_IL0, 0xffff},
-	{BRCMS_SROM_BOARDNUM, 0x00000008, 0, SROM3_MACLO, 0xffff},
-	{BRCMS_SROM_BOARDNUM, 0x00000010, 0, SROM4_MACLO, 0xffff},
-	{BRCMS_SROM_BOARDNUM, 0x000000e0, 0, SROM5_MACLO, 0xffff},
 	{BRCMS_SROM_BOARDNUM, 0xffffff00, 0, SROM8_MACLO, 0xffff},
-	{BRCMS_SROM_CC, 0x00000002, 0, SROM_AABREV, SROM_CC_MASK},
-	{BRCMS_SROM_REGREV, 0x00000008, 0, SROM_OPO, 0xff00},
-	{BRCMS_SROM_REGREV, 0x00000010, 0, SROM4_REGREV, 0x00ff},
-	{BRCMS_SROM_REGREV, 0x000000e0, 0, SROM5_REGREV, 0x00ff},
 	{BRCMS_SROM_REGREV, 0xffffff00, 0, SROM8_REGREV, 0x00ff},
-	{BRCMS_SROM_LEDBH0, 0x0000000e, SRFL_NOFFS, SROM_LEDBH10, 0x00ff},
-	{BRCMS_SROM_LEDBH1, 0x0000000e, SRFL_NOFFS, SROM_LEDBH10, 0xff00},
-	{BRCMS_SROM_LEDBH2, 0x0000000e, SRFL_NOFFS, SROM_LEDBH32, 0x00ff},
-	{BRCMS_SROM_LEDBH3, 0x0000000e, SRFL_NOFFS, SROM_LEDBH32, 0xff00},
-	{BRCMS_SROM_LEDBH0, 0x00000010, SRFL_NOFFS, SROM4_LEDBH10, 0x00ff},
-	{BRCMS_SROM_LEDBH1, 0x00000010, SRFL_NOFFS, SROM4_LEDBH10, 0xff00},
-	{BRCMS_SROM_LEDBH2, 0x00000010, SRFL_NOFFS, SROM4_LEDBH32, 0x00ff},
-	{BRCMS_SROM_LEDBH3, 0x00000010, SRFL_NOFFS, SROM4_LEDBH32, 0xff00},
-	{BRCMS_SROM_LEDBH0, 0x000000e0, SRFL_NOFFS, SROM5_LEDBH10, 0x00ff},
-	{BRCMS_SROM_LEDBH1, 0x000000e0, SRFL_NOFFS, SROM5_LEDBH10, 0xff00},
-	{BRCMS_SROM_LEDBH2, 0x000000e0, SRFL_NOFFS, SROM5_LEDBH32, 0x00ff},
-	{BRCMS_SROM_LEDBH3, 0x000000e0, SRFL_NOFFS, SROM5_LEDBH32, 0xff00},
 	{BRCMS_SROM_LEDBH0, 0xffffff00, SRFL_NOFFS, SROM8_LEDBH10, 0x00ff},
 	{BRCMS_SROM_LEDBH1, 0xffffff00, SRFL_NOFFS, SROM8_LEDBH10, 0xff00},
 	{BRCMS_SROM_LEDBH2, 0xffffff00, SRFL_NOFFS, SROM8_LEDBH32, 0x00ff},
 	{BRCMS_SROM_LEDBH3, 0xffffff00, SRFL_NOFFS, SROM8_LEDBH32, 0xff00},
-	{BRCMS_SROM_PA0B0, 0x0000000e, SRFL_PRHEX, SROM_WL0PAB0, 0xffff},
-	{BRCMS_SROM_PA0B1, 0x0000000e, SRFL_PRHEX, SROM_WL0PAB1, 0xffff},
-	{BRCMS_SROM_PA0B2, 0x0000000e, SRFL_PRHEX, SROM_WL0PAB2, 0xffff},
-	{BRCMS_SROM_PA0ITSSIT, 0x0000000e, 0, SROM_ITT, 0x00ff},
-	{BRCMS_SROM_PA0MAXPWR, 0x0000000e, 0, SROM_WL10MAXP, 0x00ff},
 	{BRCMS_SROM_PA0B0, 0xffffff00, SRFL_PRHEX, SROM8_W0_PAB0, 0xffff},
 	{BRCMS_SROM_PA0B1, 0xffffff00, SRFL_PRHEX, SROM8_W0_PAB1, 0xffff},
 	{BRCMS_SROM_PA0B2, 0xffffff00, SRFL_PRHEX, SROM8_W0_PAB2, 0xffff},
 	{BRCMS_SROM_PA0ITSSIT, 0xffffff00, 0, SROM8_W0_ITTMAXP, 0xff00},
 	{BRCMS_SROM_PA0MAXPWR, 0xffffff00, 0, SROM8_W0_ITTMAXP, 0x00ff},
-	{BRCMS_SROM_OPO, 0x0000000c, 0, SROM_OPO, 0x00ff},
 	{BRCMS_SROM_OPO, 0xffffff00, 0, SROM8_2G_OFDMPO, 0x00ff},
-	{BRCMS_SROM_AA2G, 0x0000000e, 0, SROM_AABREV, SROM_AA0_MASK},
-	{BRCMS_SROM_AA2G, 0x000000f0, 0, SROM4_AA, 0x00ff},
 	{BRCMS_SROM_AA2G, 0xffffff00, 0, SROM8_AA, 0x00ff},
-	{BRCMS_SROM_AA5G, 0x0000000e, 0, SROM_AABREV, SROM_AA1_MASK},
-	{BRCMS_SROM_AA5G, 0x000000f0, 0, SROM4_AA, 0xff00},
 	{BRCMS_SROM_AA5G, 0xffffff00, 0, SROM8_AA, 0xff00},
-	{BRCMS_SROM_AG0, 0x0000000e, 0, SROM_AG10, 0x00ff},
-	{BRCMS_SROM_AG1, 0x0000000e, 0, SROM_AG10, 0xff00},
-	{BRCMS_SROM_AG0, 0x000000f0, 0, SROM4_AG10, 0x00ff},
-	{BRCMS_SROM_AG1, 0x000000f0, 0, SROM4_AG10, 0xff00},
-	{BRCMS_SROM_AG2, 0x000000f0, 0, SROM4_AG32, 0x00ff},
-	{BRCMS_SROM_AG3, 0x000000f0, 0, SROM4_AG32, 0xff00},
 	{BRCMS_SROM_AG0, 0xffffff00, 0, SROM8_AG10, 0x00ff},
 	{BRCMS_SROM_AG1, 0xffffff00, 0, SROM8_AG10, 0xff00},
 	{BRCMS_SROM_AG2, 0xffffff00, 0, SROM8_AG32, 0x00ff},
 	{BRCMS_SROM_AG3, 0xffffff00, 0, SROM8_AG32, 0xff00},
-	{BRCMS_SROM_PA1B0, 0x0000000e, SRFL_PRHEX, SROM_WL1PAB0, 0xffff},
-	{BRCMS_SROM_PA1B1, 0x0000000e, SRFL_PRHEX, SROM_WL1PAB1, 0xffff},
-	{BRCMS_SROM_PA1B2, 0x0000000e, SRFL_PRHEX, SROM_WL1PAB2, 0xffff},
-	{BRCMS_SROM_PA1LOB0, 0x0000000c, SRFL_PRHEX, SROM_WL1LPAB0, 0xffff},
-	{BRCMS_SROM_PA1LOB1, 0x0000000c, SRFL_PRHEX, SROM_WL1LPAB1, 0xffff},
-	{BRCMS_SROM_PA1LOB2, 0x0000000c, SRFL_PRHEX, SROM_WL1LPAB2, 0xffff},
-	{BRCMS_SROM_PA1HIB0, 0x0000000c, SRFL_PRHEX, SROM_WL1HPAB0, 0xffff},
-	{BRCMS_SROM_PA1HIB1, 0x0000000c, SRFL_PRHEX, SROM_WL1HPAB1, 0xffff},
-	{BRCMS_SROM_PA1HIB2, 0x0000000c, SRFL_PRHEX, SROM_WL1HPAB2, 0xffff},
-	{BRCMS_SROM_PA1ITSSIT, 0x0000000e, 0, SROM_ITT, 0xff00},
-	{BRCMS_SROM_PA1MAXPWR, 0x0000000e, 0, SROM_WL10MAXP, 0xff00},
-	{BRCMS_SROM_PA1LOMAXPWR, 0x0000000c, 0, SROM_WL1LHMAXP, 0xff00},
-	{BRCMS_SROM_PA1HIMAXPWR, 0x0000000c, 0, SROM_WL1LHMAXP, 0x00ff},
 	{BRCMS_SROM_PA1B0, 0xffffff00, SRFL_PRHEX, SROM8_W1_PAB0, 0xffff},
 	{BRCMS_SROM_PA1B1, 0xffffff00, SRFL_PRHEX, SROM8_W1_PAB1, 0xffff},
 	{BRCMS_SROM_PA1B2, 0xffffff00, SRFL_PRHEX, SROM8_W1_PAB2, 0xffff},
@@ -535,40 +377,20 @@ static const struct brcms_sromvar pci_sromvars[] = {
 	{BRCMS_SROM_PA1MAXPWR, 0xffffff00, 0, SROM8_W1_ITTMAXP, 0x00ff},
 	{BRCMS_SROM_PA1LOMAXPWR, 0xffffff00, 0, SROM8_W1_MAXP_LCHC, 0xff00},
 	{BRCMS_SROM_PA1HIMAXPWR, 0xffffff00, 0, SROM8_W1_MAXP_LCHC, 0x00ff},
-	{BRCMS_SROM_BXA2G, 0x00000008, 0, SROM_BXARSSI2G, 0x1800},
-	{BRCMS_SROM_RSSISAV2G, 0x00000008, 0, SROM_BXARSSI2G, 0x0700},
-	{BRCMS_SROM_RSSISMC2G, 0x00000008, 0, SROM_BXARSSI2G, 0x00f0},
-	{BRCMS_SROM_RSSISMF2G, 0x00000008, 0, SROM_BXARSSI2G, 0x000f},
 	{BRCMS_SROM_BXA2G, 0xffffff00, 0, SROM8_BXARSSI2G, 0x1800},
 	{BRCMS_SROM_RSSISAV2G, 0xffffff00, 0, SROM8_BXARSSI2G, 0x0700},
 	{BRCMS_SROM_RSSISMC2G, 0xffffff00, 0, SROM8_BXARSSI2G, 0x00f0},
 	{BRCMS_SROM_RSSISMF2G, 0xffffff00, 0, SROM8_BXARSSI2G, 0x000f},
-	{BRCMS_SROM_BXA5G, 0x00000008, 0, SROM_BXARSSI5G, 0x1800},
-	{BRCMS_SROM_RSSISAV5G, 0x00000008, 0, SROM_BXARSSI5G, 0x0700},
-	{BRCMS_SROM_RSSISMC5G, 0x00000008, 0, SROM_BXARSSI5G, 0x00f0},
-	{BRCMS_SROM_RSSISMF5G, 0x00000008, 0, SROM_BXARSSI5G, 0x000f},
 	{BRCMS_SROM_BXA5G, 0xffffff00, 0, SROM8_BXARSSI5G, 0x1800},
 	{BRCMS_SROM_RSSISAV5G, 0xffffff00, 0, SROM8_BXARSSI5G, 0x0700},
 	{BRCMS_SROM_RSSISMC5G, 0xffffff00, 0, SROM8_BXARSSI5G, 0x00f0},
 	{BRCMS_SROM_RSSISMF5G, 0xffffff00, 0, SROM8_BXARSSI5G, 0x000f},
-	{BRCMS_SROM_TRI2G, 0x00000008, 0, SROM_TRI52G, 0x00ff},
-	{BRCMS_SROM_TRI5G, 0x00000008, 0, SROM_TRI52G, 0xff00},
-	{BRCMS_SROM_TRI5GL, 0x00000008, 0, SROM_TRI5GHL, 0x00ff},
-	{BRCMS_SROM_TRI5GH, 0x00000008, 0, SROM_TRI5GHL, 0xff00},
 	{BRCMS_SROM_TRI2G, 0xffffff00, 0, SROM8_TRI52G, 0x00ff},
 	{BRCMS_SROM_TRI5G, 0xffffff00, 0, SROM8_TRI52G, 0xff00},
 	{BRCMS_SROM_TRI5GL, 0xffffff00, 0, SROM8_TRI5GHL, 0x00ff},
 	{BRCMS_SROM_TRI5GH, 0xffffff00, 0, SROM8_TRI5GHL, 0xff00},
-	{BRCMS_SROM_RXPO2G, 0x00000008, SRFL_PRSIGN, SROM_RXPO52G, 0x00ff},
-	{BRCMS_SROM_RXPO5G, 0x00000008, SRFL_PRSIGN, SROM_RXPO52G, 0xff00},
 	{BRCMS_SROM_RXPO2G, 0xffffff00, SRFL_PRSIGN, SROM8_RXPO52G, 0x00ff},
 	{BRCMS_SROM_RXPO5G, 0xffffff00, SRFL_PRSIGN, SROM8_RXPO52G, 0xff00},
-	{BRCMS_SROM_TXCHAIN, 0x000000f0, SRFL_NOFFS, SROM4_TXRXC,
-	 SROM4_TXCHAIN_MASK},
-	{BRCMS_SROM_RXCHAIN, 0x000000f0, SRFL_NOFFS, SROM4_TXRXC,
-	 SROM4_RXCHAIN_MASK},
-	{BRCMS_SROM_ANTSWITCH, 0x000000f0, SRFL_NOFFS, SROM4_TXRXC,
-	 SROM4_SWITCH_MASK},
 	{BRCMS_SROM_TXCHAIN, 0xffffff00, SRFL_NOFFS, SROM8_TXRXC,
 	 SROM4_TXCHAIN_MASK},
 	{BRCMS_SROM_RXCHAIN, 0xffffff00, SRFL_NOFFS, SROM8_TXRXC,
@@ -595,43 +417,11 @@ static const struct brcms_sromvar pci_sromvars[] = {
 	 SROM8_FEM_ANTSWLUT_MASK},
 	{BRCMS_SROM_TEMPTHRESH, 0xffffff00, 0, SROM8_THERMAL, 0xff00},
 	{BRCMS_SROM_TEMPOFFSET, 0xffffff00, 0, SROM8_THERMAL, 0x00ff},
-	{BRCMS_SROM_TXPID2GA0, 0x000000f0, 0, SROM4_TXPID2G, 0x00ff},
-	{BRCMS_SROM_TXPID2GA1, 0x000000f0, 0, SROM4_TXPID2G, 0xff00},
-	{BRCMS_SROM_TXPID2GA2, 0x000000f0, 0, SROM4_TXPID2G + 1, 0x00ff},
-	{BRCMS_SROM_TXPID2GA3, 0x000000f0, 0, SROM4_TXPID2G + 1, 0xff00},
-	{BRCMS_SROM_TXPID5GA0, 0x000000f0, 0, SROM4_TXPID5G, 0x00ff},
-	{BRCMS_SROM_TXPID5GA1, 0x000000f0, 0, SROM4_TXPID5G, 0xff00},
-	{BRCMS_SROM_TXPID5GA2, 0x000000f0, 0, SROM4_TXPID5G + 1, 0x00ff},
-	{BRCMS_SROM_TXPID5GA3, 0x000000f0, 0, SROM4_TXPID5G + 1, 0xff00},
-	{BRCMS_SROM_TXPID5GLA0, 0x000000f0, 0, SROM4_TXPID5GL, 0x00ff},
-	{BRCMS_SROM_TXPID5GLA1, 0x000000f0, 0, SROM4_TXPID5GL, 0xff00},
-	{BRCMS_SROM_TXPID5GLA2, 0x000000f0, 0, SROM4_TXPID5GL + 1, 0x00ff},
-	{BRCMS_SROM_TXPID5GLA3, 0x000000f0, 0, SROM4_TXPID5GL + 1, 0xff00},
-	{BRCMS_SROM_TXPID5GHA0, 0x000000f0, 0, SROM4_TXPID5GH, 0x00ff},
-	{BRCMS_SROM_TXPID5GHA1, 0x000000f0, 0, SROM4_TXPID5GH, 0xff00},
-	{BRCMS_SROM_TXPID5GHA2, 0x000000f0, 0, SROM4_TXPID5GH + 1, 0x00ff},
-	{BRCMS_SROM_TXPID5GHA3, 0x000000f0, 0, SROM4_TXPID5GH + 1, 0xff00},
-
-	{BRCMS_SROM_CCODE, 0x0000000f, SRFL_CCODE, SROM_CCODE, 0xffff},
-	{BRCMS_SROM_CCODE, 0x00000010, SRFL_CCODE, SROM4_CCODE, 0xffff},
-	{BRCMS_SROM_CCODE, 0x000000e0, SRFL_CCODE, SROM5_CCODE, 0xffff},
+
 	{BRCMS_SROM_CCODE, 0xffffff00, SRFL_CCODE, SROM8_CCODE, 0xffff},
 	{BRCMS_SROM_MACADDR, 0xffffff00, SRFL_ETHADDR, SROM8_MACHI, 0xffff},
-	{BRCMS_SROM_MACADDR, 0x000000e0, SRFL_ETHADDR, SROM5_MACHI, 0xffff},
-	{BRCMS_SROM_MACADDR, 0x00000010, SRFL_ETHADDR, SROM4_MACHI, 0xffff},
-	{BRCMS_SROM_MACADDR, 0x00000008, SRFL_ETHADDR, SROM3_MACHI, 0xffff},
-	{BRCMS_SROM_IL0MACADDR, 0x00000007, SRFL_ETHADDR, SROM_MACHI_IL0,
-	 0xffff},
-	{BRCMS_SROM_ET1MACADDR, 0x00000007, SRFL_ETHADDR, SROM_MACHI_ET1,
-	 0xffff},
 	{BRCMS_SROM_LEDDC, 0xffffff00, SRFL_NOFFS | SRFL_LEDDC, SROM8_LEDDC,
 	 0xffff},
-	{BRCMS_SROM_LEDDC, 0x000000e0, SRFL_NOFFS | SRFL_LEDDC, SROM5_LEDDC,
-	 0xffff},
-	{BRCMS_SROM_LEDDC, 0x00000010, SRFL_NOFFS | SRFL_LEDDC, SROM4_LEDDC,
-	 0xffff},
-	{BRCMS_SROM_LEDDC, 0x00000008, SRFL_NOFFS | SRFL_LEDDC, SROM3_LEDDC,
-	 0xffff},
 	{BRCMS_SROM_RAWTEMPSENSE, 0xffffff00, SRFL_PRHEX, SROM8_MPWR_RAWTS,
 	 0x01ff},
 	{BRCMS_SROM_MEASPOWER, 0xffffff00, SRFL_PRHEX, SROM8_MPWR_RAWTS,
@@ -651,16 +441,7 @@ static const struct brcms_sromvar pci_sromvars[] = {
 	{BRCMS_SROM_PHYCAL_TEMPDELTA, 0xffffff00, 0, SROM8_PHYCAL_TEMPDELTA,
 	 0x00ff},
 
-	{BRCMS_SROM_CCK2GPO, 0x000000f0, 0, SROM4_2G_CCKPO, 0xffff},
 	{BRCMS_SROM_CCK2GPO, 0x00000100, 0, SROM8_2G_CCKPO, 0xffff},
-	{BRCMS_SROM_OFDM2GPO, 0x000000f0, SRFL_MORE, SROM4_2G_OFDMPO, 0xffff},
-	{BRCMS_SROM_CONT, 0, 0, SROM4_2G_OFDMPO + 1, 0xffff},
-	{BRCMS_SROM_OFDM5GPO, 0x000000f0, SRFL_MORE, SROM4_5G_OFDMPO, 0xffff},
-	{BRCMS_SROM_CONT, 0, 0, SROM4_5G_OFDMPO + 1, 0xffff},
-	{BRCMS_SROM_OFDM5GLPO, 0x000000f0, SRFL_MORE, SROM4_5GL_OFDMPO, 0xffff},
-	{BRCMS_SROM_CONT, 0, 0, SROM4_5GL_OFDMPO + 1, 0xffff},
-	{BRCMS_SROM_OFDM5GHPO, 0x000000f0, SRFL_MORE, SROM4_5GH_OFDMPO, 0xffff},
-	{BRCMS_SROM_CONT, 0, 0, SROM4_5GH_OFDMPO + 1, 0xffff},
 	{BRCMS_SROM_OFDM2GPO, 0x00000100, SRFL_MORE, SROM8_2G_OFDMPO, 0xffff},
 	{BRCMS_SROM_CONT, 0, 0, SROM8_2G_OFDMPO + 1, 0xffff},
 	{BRCMS_SROM_OFDM5GPO, 0x00000100, SRFL_MORE, SROM8_5G_OFDMPO, 0xffff},
@@ -669,38 +450,6 @@ static const struct brcms_sromvar pci_sromvars[] = {
 	{BRCMS_SROM_CONT, 0, 0, SROM8_5GL_OFDMPO + 1, 0xffff},
 	{BRCMS_SROM_OFDM5GHPO, 0x00000100, SRFL_MORE, SROM8_5GH_OFDMPO, 0xffff},
 	{BRCMS_SROM_CONT, 0, 0, SROM8_5GH_OFDMPO + 1, 0xffff},
-	{BRCMS_SROM_MCS2GPO0, 0x000000f0, 0, SROM4_2G_MCSPO, 0xffff},
-	{BRCMS_SROM_MCS2GPO1, 0x000000f0, 0, SROM4_2G_MCSPO + 1, 0xffff},
-	{BRCMS_SROM_MCS2GPO2, 0x000000f0, 0, SROM4_2G_MCSPO + 2, 0xffff},
-	{BRCMS_SROM_MCS2GPO3, 0x000000f0, 0, SROM4_2G_MCSPO + 3, 0xffff},
-	{BRCMS_SROM_MCS2GPO4, 0x000000f0, 0, SROM4_2G_MCSPO + 4, 0xffff},
-	{BRCMS_SROM_MCS2GPO5, 0x000000f0, 0, SROM4_2G_MCSPO + 5, 0xffff},
-	{BRCMS_SROM_MCS2GPO6, 0x000000f0, 0, SROM4_2G_MCSPO + 6, 0xffff},
-	{BRCMS_SROM_MCS2GPO7, 0x000000f0, 0, SROM4_2G_MCSPO + 7, 0xffff},
-	{BRCMS_SROM_MCS5GPO0, 0x000000f0, 0, SROM4_5G_MCSPO, 0xffff},
-	{BRCMS_SROM_MCS5GPO1, 0x000000f0, 0, SROM4_5G_MCSPO + 1, 0xffff},
-	{BRCMS_SROM_MCS5GPO2, 0x000000f0, 0, SROM4_5G_MCSPO + 2, 0xffff},
-	{BRCMS_SROM_MCS5GPO3, 0x000000f0, 0, SROM4_5G_MCSPO + 3, 0xffff},
-	{BRCMS_SROM_MCS5GPO4, 0x000000f0, 0, SROM4_5G_MCSPO + 4, 0xffff},
-	{BRCMS_SROM_MCS5GPO5, 0x000000f0, 0, SROM4_5G_MCSPO + 5, 0xffff},
-	{BRCMS_SROM_MCS5GPO6, 0x000000f0, 0, SROM4_5G_MCSPO + 6, 0xffff},
-	{BRCMS_SROM_MCS5GPO7, 0x000000f0, 0, SROM4_5G_MCSPO + 7, 0xffff},
-	{BRCMS_SROM_MCS5GLPO0, 0x000000f0, 0, SROM4_5GL_MCSPO, 0xffff},
-	{BRCMS_SROM_MCS5GLPO1, 0x000000f0, 0, SROM4_5GL_MCSPO + 1, 0xffff},
-	{BRCMS_SROM_MCS5GLPO2, 0x000000f0, 0, SROM4_5GL_MCSPO + 2, 0xffff},
-	{BRCMS_SROM_MCS5GLPO3, 0x000000f0, 0, SROM4_5GL_MCSPO + 3, 0xffff},
-	{BRCMS_SROM_MCS5GLPO4, 0x000000f0, 0, SROM4_5GL_MCSPO + 4, 0xffff},
-	{BRCMS_SROM_MCS5GLPO5, 0x000000f0, 0, SROM4_5GL_MCSPO + 5, 0xffff},
-	{BRCMS_SROM_MCS5GLPO6, 0x000000f0, 0, SROM4_5GL_MCSPO + 6, 0xffff},
-	{BRCMS_SROM_MCS5GLPO7, 0x000000f0, 0, SROM4_5GL_MCSPO + 7, 0xffff},
-	{BRCMS_SROM_MCS5GHPO0, 0x000000f0, 0, SROM4_5GH_MCSPO, 0xffff},
-	{BRCMS_SROM_MCS5GHPO1, 0x000000f0, 0, SROM4_5GH_MCSPO + 1, 0xffff},
-	{BRCMS_SROM_MCS5GHPO2, 0x000000f0, 0, SROM4_5GH_MCSPO + 2, 0xffff},
-	{BRCMS_SROM_MCS5GHPO3, 0x000000f0, 0, SROM4_5GH_MCSPO + 3, 0xffff},
-	{BRCMS_SROM_MCS5GHPO4, 0x000000f0, 0, SROM4_5GH_MCSPO + 4, 0xffff},
-	{BRCMS_SROM_MCS5GHPO5, 0x000000f0, 0, SROM4_5GH_MCSPO + 5, 0xffff},
-	{BRCMS_SROM_MCS5GHPO6, 0x000000f0, 0, SROM4_5GH_MCSPO + 6, 0xffff},
-	{BRCMS_SROM_MCS5GHPO7, 0x000000f0, 0, SROM4_5GH_MCSPO + 7, 0xffff},
 	{BRCMS_SROM_MCS2GPO0, 0x00000100, 0, SROM8_2G_MCSPO, 0xffff},
 	{BRCMS_SROM_MCS2GPO1, 0x00000100, 0, SROM8_2G_MCSPO + 1, 0xffff},
 	{BRCMS_SROM_MCS2GPO2, 0x00000100, 0, SROM8_2G_MCSPO + 2, 0xffff},
@@ -733,10 +482,6 @@ static const struct brcms_sromvar pci_sromvars[] = {
 	{BRCMS_SROM_MCS5GHPO5, 0x00000100, 0, SROM8_5GH_MCSPO + 5, 0xffff},
 	{BRCMS_SROM_MCS5GHPO6, 0x00000100, 0, SROM8_5GH_MCSPO + 6, 0xffff},
 	{BRCMS_SROM_MCS5GHPO7, 0x00000100, 0, SROM8_5GH_MCSPO + 7, 0xffff},
-	{BRCMS_SROM_CDDPO, 0x000000f0, 0, SROM4_CDDPO, 0xffff},
-	{BRCMS_SROM_STBCPO, 0x000000f0, 0, SROM4_STBCPO, 0xffff},
-	{BRCMS_SROM_BW40PO, 0x000000f0, 0, SROM4_BW40PO, 0xffff},
-	{BRCMS_SROM_BWDUPPO, 0x000000f0, 0, SROM4_BWDUPPO, 0xffff},
 	{BRCMS_SROM_CDDPO, 0x00000100, 0, SROM8_CDDPO, 0xffff},
 	{BRCMS_SROM_STBCPO, 0x00000100, 0, SROM8_STBCPO, 0xffff},
 	{BRCMS_SROM_BW40PO, 0x00000100, 0, SROM8_BW40PO, 0xffff},
@@ -812,34 +557,6 @@ static const struct brcms_sromvar pci_sromvars[] = {
 };
 
 static const struct brcms_sromvar perpath_pci_sromvars[] = {
-	{BRCMS_SROM_MAXP2GA0, 0x000000f0, 0, SROM4_2G_ITT_MAXP, 0x00ff},
-	{BRCMS_SROM_ITT2GA0, 0x000000f0, 0, SROM4_2G_ITT_MAXP, 0xff00},
-	{BRCMS_SROM_ITT5GA0, 0x000000f0, 0, SROM4_5G_ITT_MAXP, 0xff00},
-	{BRCMS_SROM_PA2GW0A0, 0x000000f0, SRFL_PRHEX, SROM4_2G_PA, 0xffff},
-	{BRCMS_SROM_PA2GW1A0, 0x000000f0, SRFL_PRHEX, SROM4_2G_PA + 1, 0xffff},
-	{BRCMS_SROM_PA2GW2A0, 0x000000f0, SRFL_PRHEX, SROM4_2G_PA + 2, 0xffff},
-	{BRCMS_SROM_PA2GW3A0, 0x000000f0, SRFL_PRHEX, SROM4_2G_PA + 3, 0xffff},
-	{BRCMS_SROM_MAXP5GA0, 0x000000f0, 0, SROM4_5G_ITT_MAXP, 0x00ff},
-	{BRCMS_SROM_MAXP5GHA0, 0x000000f0, 0, SROM4_5GLH_MAXP, 0x00ff},
-	{BRCMS_SROM_MAXP5GLA0, 0x000000f0, 0, SROM4_5GLH_MAXP, 0xff00},
-	{BRCMS_SROM_PA5GW0A0, 0x000000f0, SRFL_PRHEX, SROM4_5G_PA, 0xffff},
-	{BRCMS_SROM_PA5GW1A0, 0x000000f0, SRFL_PRHEX, SROM4_5G_PA + 1, 0xffff},
-	{BRCMS_SROM_PA5GW2A0, 0x000000f0, SRFL_PRHEX, SROM4_5G_PA + 2, 0xffff},
-	{BRCMS_SROM_PA5GW3A0, 0x000000f0, SRFL_PRHEX, SROM4_5G_PA + 3, 0xffff},
-	{BRCMS_SROM_PA5GLW0A0, 0x000000f0, SRFL_PRHEX, SROM4_5GL_PA, 0xffff},
-	{BRCMS_SROM_PA5GLW1A0, 0x000000f0, SRFL_PRHEX, SROM4_5GL_PA + 1,
-	 0xffff},
-	{BRCMS_SROM_PA5GLW2A0, 0x000000f0, SRFL_PRHEX, SROM4_5GL_PA + 2,
-	 0xffff},
-	{BRCMS_SROM_PA5GLW3A0, 0x000000f0, SRFL_PRHEX, SROM4_5GL_PA + 3,
-	 0xffff},
-	{BRCMS_SROM_PA5GHW0A0, 0x000000f0, SRFL_PRHEX, SROM4_5GH_PA, 0xffff},
-	{BRCMS_SROM_PA5GHW1A0, 0x000000f0, SRFL_PRHEX, SROM4_5GH_PA + 1,
-	 0xffff},
-	{BRCMS_SROM_PA5GHW2A0, 0x000000f0, SRFL_PRHEX, SROM4_5GH_PA + 2,
-	 0xffff},
-	{BRCMS_SROM_PA5GHW3A0, 0x000000f0, SRFL_PRHEX, SROM4_5GH_PA + 3,
-	 0xffff},
 	{BRCMS_SROM_MAXP2GA0, 0xffffff00, 0, SROM8_2G_ITT_MAXP, 0x00ff},
 	{BRCMS_SROM_ITT2GA0, 0xffffff00, 0, SROM8_2G_ITT_MAXP, 0xff00},
 	{BRCMS_SROM_ITT5GA0, 0xffffff00, 0, SROM8_5G_ITT_MAXP, 0xff00},
@@ -881,12 +598,6 @@ srom_window_address(struct si_pub *sih, u8 __iomem *curmap)
 	return NULL;
 }
 
-/* Parse SROM and create name=value pairs. 'srom' points to
- * the SROM word array. 'off' specifies the offset of the
- * first word 'srom' points to, which should be either 0 or
- * SROM3_SWRG_OFF (full SROM or software region).
- */
-
 static uint mask_shift(u16 mask)
 {
 	uint i;
@@ -935,6 +646,9 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, struct list_head *var_list)
 	uint width;
 	uint flags;
 	u32 sr = (1 << sromrev);
+	uint p;
+	uint pb =  SROM8_PATH0;
+	const uint psz = SROM8_PATH1 - SROM8_PATH0;
 
 	/* first store the srom revision */
 	entry = kzalloc(sizeof(struct brcms_srom_list_head), GFP_KERNEL);
@@ -1032,47 +746,34 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, struct list_head *var_list)
 		list_add(&entry->var_list, var_list);
 	}
 
-	if (sromrev >= 4) {
-		/* Do per-path variables */
-		uint p, pb, psz;
-
-		if (sromrev >= 8) {
-			pb = SROM8_PATH0;
-			psz = SROM8_PATH1 - SROM8_PATH0;
-		} else {
-			pb = SROM4_PATH0;
-			psz = SROM4_PATH1 - SROM4_PATH0;
-		}
-
-		for (p = 0; p < MAX_PATH_SROM; p++) {
-			for (srv = perpath_pci_sromvars;
-			     srv->varid != BRCMS_SROM_NULL; srv++) {
-				if ((srv->revmask & sr) == 0)
-					continue;
+	for (p = 0; p < MAX_PATH_SROM; p++) {
+		for (srv = perpath_pci_sromvars;
+		     srv->varid != BRCMS_SROM_NULL; srv++) {
+			if ((srv->revmask & sr) == 0)
+				continue;
 
-				if (srv->flags & SRFL_NOVAR)
-					continue;
+			if (srv->flags & SRFL_NOVAR)
+				continue;
 
-				w = srom[pb + srv->off];
-				val = (w & srv->mask) >> mask_shift(srv->mask);
-				width = mask_width(srv->mask);
+			w = srom[pb + srv->off];
+			val = (w & srv->mask) >> mask_shift(srv->mask);
+			width = mask_width(srv->mask);
 
-				/* Cheating: no per-path var is more than
-				 * 1 word */
-				if ((srv->flags & SRFL_NOFFS)
-				    && ((int)val == (1 << width) - 1))
-					continue;
+			/* Cheating: no per-path var is more than
+			 * 1 word */
+			if ((srv->flags & SRFL_NOFFS)
+			    && ((int)val == (1 << width) - 1))
+				continue;
 
-				entry =
-				    kzalloc(sizeof(struct brcms_srom_list_head),
-					    GFP_KERNEL);
-				entry->varid = srv->varid+p;
-				entry->var_type = BRCMS_SROM_UNUMBER;
-				entry->uval = val;
-				list_add(&entry->var_list, var_list);
-			}
-			pb += psz;
+			entry =
+			    kzalloc(sizeof(struct brcms_srom_list_head),
+				    GFP_KERNEL);
+			entry->varid = srv->varid+p;
+			entry->var_type = BRCMS_SROM_UNUMBER;
+			entry->uval = val;
+			list_add(&entry->var_list, var_list);
 		}
+		pb += psz;
 	}
 }
 
@@ -1177,22 +878,14 @@ static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap)
 		err = sprom_read_pci(sih, sromwindow, 0, srom, SROM_WORDS,
 				     true);
 
-		if ((srom[SROM4_SIGN] == SROM4_SIGNATURE) ||
-		    (((sih->buscoretype == PCIE_CORE_ID)
-		      && (sih->buscorerev >= 6))
-		     || ((sih->buscoretype == PCI_CORE_ID)
-			 && (sih->buscorerev >= 0xe)))) {
-			/* sromrev >= 4, read more */
+		if ((sih->buscoretype == PCIE_CORE_ID && sih->buscorerev >= 6)
+		     || (sih->buscoretype == PCI_CORE_ID &&
+			 sih->buscorerev >= 0xe)) {
 			err = sprom_read_pci(sih, sromwindow, 0, srom,
 					     SROM4_WORDS, true);
 			sromrev = srom[SROM4_CRCREV] & 0xff;
-		} else if (err == 0) {
-			/* srom is good and is rev < 4 */
-			/* top word of sprom contains version and crc8 */
-			sromrev = srom[SROM_CRCREV] & 0xff;
-			/* bcm4401 sroms misprogrammed */
-			if (sromrev == 0x10)
-				sromrev = 1;
+		} else {
+			err = -EIO;
 		}
 	} else {
 		/* Use OTP if SPROM not available */
@@ -1209,10 +902,9 @@ static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap)
 		sr = 1 << sromrev;
 
 		/*
-		 * srom version check: Current valid versions: 1, 2, 3, 4, 5, 8,
-		 * 9
+		 * srom version check: Current valid versions: 8, 9
 		 */
-		if ((sr & 0x33e) == 0) {
+		if ((sr & 0x300) == 0) {
 			err = -EINVAL;
 			goto errout;
 		}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/srom.h b/drivers/net/wireless/brcm80211/brcmsmac/srom.h
index 708c43f..c81df97 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/srom.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/srom.h
@@ -26,9 +26,4 @@ extern void srom_free_vars(struct si_pub *sih);
 extern int srom_read(struct si_pub *sih, uint bus, void *curmap,
 		     uint byteoff, uint nbytes, u16 *buf, bool check_crc);
 
-/* parse standard PCMCIA cis, normally used by SB/PCMCIA/SDIO/SPI/OTP
- *   and extract from it into name=value pairs
- */
-extern int srom_parsecis(u8 **pcis, uint ciscnt,
-			 char **vars, uint *count);
 #endif				/* _BRCM_SROM_H_ */
-- 
1.7.4.1



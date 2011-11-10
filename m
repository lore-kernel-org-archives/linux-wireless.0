Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3747 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1KJTau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:50 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/19] brcm80211: smac: remove code under unused macro
 definitions
Date: Thu, 10 Nov 2011 20:30:17 +0100
Message-ID: <1320953434-16859-4-git-send-email-arend@broadcom.com> (sfid-20111110_203130_844941_F2D0BAD2)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There were a couple of code segments left that were placed under
a macro definition that was not applicable or not used in the
brcmsmac driver. These pieces of code have been removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |  118 --------------------
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |    8 --
 2 files changed, 0 insertions(+), 126 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 89ad1b7..55e9f45 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -1153,121 +1153,6 @@ brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm, u16 chanspec,
 			      &txpwr);
 }
 
-#ifdef POWER_DBG
-static void wlc_phy_txpower_limits_dump(struct txpwr_limits *txpwr)
-{
-	int i;
-	char buf[80];
-	char fraction[4][4] = { "   ", ".25", ".5 ", ".75" };
-
-	sprintf(buf, "CCK                ");
-	for (i = 0; i < BRCMS_NUM_RATES_CCK; i++)
-		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->cck[i] / BRCMS_TXPWR_DB_FACTOR,
-			fraction[txpwr->cck[i] % BRCMS_TXPWR_DB_FACTOR]);
-	printk(KERN_DEBUG "%s\n", buf);
-
-	sprintf(buf, "20 MHz OFDM SISO   ");
-	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++)
-		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->ofdm[i] / BRCMS_TXPWR_DB_FACTOR,
-			fraction[txpwr->ofdm[i] % BRCMS_TXPWR_DB_FACTOR]);
-	printk(KERN_DEBUG "%s\n", buf);
-
-	sprintf(buf, "20 MHz OFDM CDD    ");
-	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++)
-		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->ofdm_cdd[i] / BRCMS_TXPWR_DB_FACTOR,
-			fraction[txpwr->ofdm_cdd[i] % BRCMS_TXPWR_DB_FACTOR]);
-	printk(KERN_DEBUG "%s\n", buf);
-
-	sprintf(buf, "40 MHz OFDM SISO   ");
-	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++)
-		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->ofdm_40_siso[i] / BRCMS_TXPWR_DB_FACTOR,
-			fraction[txpwr->ofdm_40_siso[i] %
-							BRCMS_TXPWR_DB_FACTOR]);
-	printk(KERN_DEBUG "%s\n", buf);
-
-	sprintf(buf, "40 MHz OFDM CDD    ");
-	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++)
-		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->ofdm_40_cdd[i] / BRCMS_TXPWR_DB_FACTOR,
-			fraction[txpwr->ofdm_40_cdd[i] %
-							BRCMS_TXPWR_DB_FACTOR]);
-	printk(KERN_DEBUG "%s\n", buf);
-
-	sprintf(buf, "20 MHz MCS0-7 SISO ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++)
-		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_20_siso[i] / BRCMS_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_20_siso[i] %
-							BRCMS_TXPWR_DB_FACTOR]);
-	printk(KERN_DEBUG "%s\n", buf);
-
-	sprintf(buf, "20 MHz MCS0-7 CDD  ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++)
-		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_20_cdd[i] / BRCMS_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_20_cdd[i] %
-							BRCMS_TXPWR_DB_FACTOR]);
-	printk(KERN_DEBUG "%s\n", buf);
-
-	sprintf(buf, "20 MHz MCS0-7 STBC ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++)
-		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_20_stbc[i] / BRCMS_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_20_stbc[i] %
-							BRCMS_TXPWR_DB_FACTOR]);
-	printk(KERN_DEBUG "%s\n", buf);
-
-	sprintf(buf, "20 MHz MCS8-15 SDM ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_2_STREAM; i++)
-		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_20_mimo[i] / BRCMS_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_20_mimo[i] %
-							BRCMS_TXPWR_DB_FACTOR]);
-	printk(KERN_DEBUG "%s\n", buf);
-
-	sprintf(buf, "40 MHz MCS0-7 SISO ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++)
-		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_40_siso[i] / BRCMS_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_40_siso[i] %
-							BRCMS_TXPWR_DB_FACTOR]);
-	printk(KERN_DEBUG "%s\n", buf);
-
-	sprintf(buf, "40 MHz MCS0-7 CDD  ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++)
-		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_40_cdd[i] / BRCMS_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_40_cdd[i] %
-							BRCMS_TXPWR_DB_FACTOR]);
-	printk(KERN_DEBUG "%s\n", buf);
-
-	sprintf(buf, "40 MHz MCS0-7 STBC ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++)
-		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_40_stbc[i] / BRCMS_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_40_stbc[i] %
-							BRCMS_TXPWR_DB_FACTOR]);
-	printk(KERN_DEBUG "%s\n", buf);
-
-	sprintf(buf, "40 MHz MCS8-15 SDM ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_2_STREAM; i++)
-		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_40_mimo[i] / BRCMS_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_40_mimo[i] %
-							BRCMS_TXPWR_DB_FACTOR]);
-	}
-	printk(KERN_DEBUG "%s\n", buf);
-
-	printk(KERN_DEBUG "MCS32               %2d%s\n",
-	       txpwr->mcs32 / BRCMS_TXPWR_DB_FACTOR,
-	       fraction[txpwr->mcs32 % BRCMS_TXPWR_DB_FACTOR]);
-}
-#endif				/* POWER_DBG */
-
 void
 brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 		       struct txpwr_limits *txpwr)
@@ -1478,9 +1363,6 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 			txpwr->mcs_40_stbc[i] = txpwr->mcs_40_cdd[i];
 	}
 
-#ifdef POWER_DBG
-	wlc_phy_txpower_limits_dump(txpwr);
-#endif
 	return;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index 2faea50..e17edf7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -190,15 +190,7 @@ u16 read_radio_reg(struct brcms_phy *pi, u16 addr)
 		data = R_REG(&pi->regs->radioregdata);
 	} else {
 		W_REG_FLUSH(&pi->regs->phy4waddr, addr);
-
-#ifdef __ARM_ARCH_4T__
-		__asm__(" .align 4 ");
-		__asm__(" nop ");
-		data = R_REG(&pi->regs->phy4wdatalo);
-#else
 		data = R_REG(&pi->regs->phy4wdatalo);
-#endif
-
 	}
 	pi->phy_wreg = 0;
 
-- 
1.7.5.4



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4769 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab1HZNT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:57 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 02/13] staging: brcm80211: remove macro definitions from
 brcmsmac Makefile
Date: Fri, 26 Aug 2011 15:19:29 +0200
Message-ID: <1314364780-9462-3-git-send-email-rvossen@broadcom.com> (sfid-20110826_152016_400698_1C415469)
In-Reply-To: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
References: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The Makefile for the brcmsmac driver contains macro definitions that
are always set and even some are not used in the source code anymore.
This patch removes those definitions from the Makefile and source code.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/Makefile      |    7 -------
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    5 +----
 drivers/staging/brcm80211/brcmsmac/srom.c        |   12 ++----------
 3 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index 3147c48..eee2fe3 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -16,13 +16,6 @@
 # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
 ccflags-y :=				\
-	-DWLC_HIGH				\
-	-DWLC_LOW				\
-	-DSTA					\
-	-DWME					\
-	-DWL11N					\
-	-DDBAND					\
-	-DBCMNVRAMR				\
 	-Idrivers/staging/brcm80211/brcmsmac \
 	-Idrivers/staging/brcm80211/brcmsmac/phy \
 	-Idrivers/staging/brcm80211/include
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 5307bd8..cbb0bde 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -1666,13 +1666,10 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 			}
 		}
 	}
-#if WL11N
+
 	max_num_rate = ((ISNPHY(pi)) ? (TXP_NUM_RATES) :
 			((ISLCNPHY(pi)) ?
 			 (TXP_LAST_SISO_MCS_20 + 1) : (TXP_LAST_OFDM + 1)));
-#else
-	max_num_rate = ((ISNPHY(pi)) ? (TXP_NUM_RATES) : (TXP_LAST_OFDM + 1));
-#endif
 
 	wlc_phy_upd_env_txpwr_rate_limits(pi, band);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 90e2ac8..a8f7c00 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -798,9 +798,7 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 			     uint *count);
 static int sprom_read_pci(struct si_pub *sih, u16 *sprom,
 			  uint wordoff, u16 *buf, uint nwords, bool check_crc);
-#if defined(BCMNVRAMR)
 static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz);
-#endif
 
 static int initvars_table(char *start, char *end,
 			  char **vars, uint *count);
@@ -940,7 +938,6 @@ sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
 	return err;
 }
 
-#if defined(BCMNVRAMR)
 static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 {
 	u8 *otp;
@@ -976,7 +973,7 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 
 	return err;
 }
-#endif				/* defined(BCMNVRAMR) */
+
 /*
 * Create variable table from memory.
 * Return 0 on success, nonzero on error.
@@ -1208,18 +1205,13 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 				sromrev = 1;
 		}
 	}
-#if defined(BCMNVRAMR)
-	/* Use OTP if SPROM not available */
 	else {
+		/* Use OTP if SPROM not available */
 		err = otp_read_pci(sih, srom, SROM_MAX);
 		if (err == 0)
 			/* OTP only contain SROM rev8/rev9 for now */
 			sromrev = srom[SROM4_CRCREV] & 0xff;
 	}
-#else
-	else
-		err = -ENODEV;
-#endif
 
 	if (!err) {
 		/* Bitmask for the sromrev */
-- 
1.7.4.1



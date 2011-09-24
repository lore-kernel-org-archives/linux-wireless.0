Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4595 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab1IXCJU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 22:09:20 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 19/20] staging: brcm80211: various global var related
 changes in softmac
Date: Fri, 23 Sep 2011 19:09:07 -0700
Message-ID: <1316830148-28661-20-git-send-email-frankyl@broadcom.com> (sfid-20110924_040939_651560_A51673CD)
In-Reply-To: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   11 +----------
 drivers/staging/brcm80211/brcmsmac/main.h |    2 +-
 drivers/staging/brcm80211/brcmsmac/otp.c  |    4 ++--
 drivers/staging/brcm80211/brcmsmac/rate.h |    1 -
 drivers/staging/brcm80211/brcmsmac/srom.c |   15 +++++++++------
 5 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 5edf8b8..ee11286 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -428,8 +428,6 @@ const u8 wme_fifo2ac[] = { AC_BK, AC_BE, AC_VI, AC_VO, AC_BE, AC_BE };
 /* WME/802.1E Access Category to TX FIFO number */
 static const u8 wme_ac2fifo[] = { 1, 0, 2, 3 };
 
-static bool in_send_q;
-
 /* 802.1D Priority to precedence queue mapping */
 const u8 wlc_prio2prec_map[] = {
 	_BRCMS_PREC_BE,		/* 0 BE - Best-effort */
@@ -442,7 +440,7 @@ const u8 wlc_prio2prec_map[] = {
 	_BRCMS_PREC_NC,		/* 7 NC - Network Control */
 };
 
-static u16 xmtfifo_sz[][NFIFO] = {
+static const u16 xmtfifo_sz[][NFIFO] = {
 	/* corerev 20: 5120, 49152, 49152, 5376, 4352, 1280 */
 	{20, 192, 192, 21, 17, 5},
 	/* corerev 21: 2304, 14848, 5632, 3584, 3584, 1280 */
@@ -7717,11 +7715,6 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 	struct pktq *q = &qi->q;
 	struct ieee80211_tx_info *tx_info;
 
-	if (in_send_q)
-		return;
-	else
-		in_send_q = true;
-
 	prec_map = wlc->tx_prec_map;
 
 	/* Send all the enq'd pkts that we can.
@@ -7753,8 +7746,6 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 			prec_map = wlc->tx_prec_map;
 		}
 	}
-
-	in_send_q = false;
 }
 
 void
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 47665da..c938add 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -359,7 +359,7 @@ struct brcms_hardware {
 	u16 chanspec;	/* bmac chanspec shadow */
 
 	uint *txavail[NFIFO];	/* # tx descriptors available */
-	u16 *xmtfifo_sz;	/* fifo size in 256B for each xmt fifo */
+	const u16 *xmtfifo_sz;	/* fifo size in 256B for each xmt fifo */
 
 	u32 pllreq;		/* pll requests to keep PLL on */
 
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
index 05c78c7..06cb575 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -80,7 +80,7 @@ struct otp_fn_s {
 
 struct otpinfo {
 	uint ccrev;		/* chipc revision */
-	struct otp_fn_s *fn;		/* OTP functions */
+	const struct otp_fn_s *fn;	/* OTP functions */
 	struct si_pub *sih;		/* Saved sb handle */
 
 	/* IPX OTP section */
@@ -442,7 +442,7 @@ static int ipxotp_nvread(struct otpinfo *oi, char *data, uint *len)
 	return -ENOTSUPP;
 }
 
-static struct otp_fn_s ipxotp_fn = {
+static const struct otp_fn_s ipxotp_fn = {
 	(int (*)(struct otpinfo *)) ipxotp_size,
 	(u16 (*)(struct otpinfo *, struct chipcregs *, uint)) ipxotp_read_bit,
 
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.h b/drivers/staging/brcm80211/brcmsmac/rate.h
index 2cc66e0..e7b9dc2 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/rate.h
@@ -27,7 +27,6 @@ extern const struct brcms_c_rateset cck_ofdm_rates;
 extern const struct brcms_c_rateset ofdm_rates;
 extern const struct brcms_c_rateset cck_rates;
 extern const struct brcms_c_rateset gphy_legacy_rates;
-extern const struct brcms_c_rateset wlc_lrs_rates;
 extern const struct brcms_c_rateset rate_limit_1_2;
 
 struct brcms_mcs_info {
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index b37faf4..0105306 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -778,7 +778,9 @@ static const struct brcms_sromvar perpath_pci_sromvars[] = {
 	{NULL, 0, 0, 0, 0}
 };
 
-static u8 srom_crc8_table[CRC8_TABLE_SIZE];
+/* crc table has the same contents for every device instance, so it can be
+ * shared between devices. */
+static u8 brcms_srom_crc8_table[CRC8_TABLE_SIZE];
 
 static u16 *srom_window_address(struct si_pub *sih, u8 *curmap)
 {
@@ -1052,8 +1054,9 @@ sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
 
 		/* fixup the endianness so crc8 will pass */
 		htol16_buf(buf, nwords * 2);
-		if (crc8(srom_crc8_table, (u8 *) buf, nwords * 2,
-			 CRC8_INIT_VALUE) != CRC8_GOOD_VALUE(srom_crc8_table))
+		if (crc8(brcms_srom_crc8_table, (u8 *) buf, nwords * 2,
+			 CRC8_INIT_VALUE) !=
+			 CRC8_GOOD_VALUE(brcms_srom_crc8_table))
 			/* DBG only pci always read srom4 first, then srom8/9 */
 			err = -EIO;
 
@@ -1089,8 +1092,8 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 
 	/* fixup the endianness so crc8 will pass */
 	htol16_buf(buf, bufsz);
-	if (crc8(srom_crc8_table, (u8 *) buf, SROM4_WORDS * 2,
-		 CRC8_INIT_VALUE) != CRC8_GOOD_VALUE(srom_crc8_table))
+	if (crc8(brcms_srom_crc8_table, (u8 *) buf, SROM4_WORDS * 2,
+		 CRC8_INIT_VALUE) != CRC8_GOOD_VALUE(brcms_srom_crc8_table))
 		err = -EIO;
 
 	/* now correct the endianness of the byte array */
@@ -1147,7 +1150,7 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 
 	sromwindow = srom_window_address(sih, curmap);
 
-	crc8_populate_lsb(srom_crc8_table, SROM_CRC8_POLY);
+	crc8_populate_lsb(brcms_srom_crc8_table, SROM_CRC8_POLY);
 	if (ai_is_sprom_available(sih)) {
 		err = sprom_read_pci(sih, sromwindow, 0, srom, SROM_WORDS,
 				     true);
-- 
1.7.1



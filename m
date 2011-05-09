Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3216 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab1EIOdE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:04 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Henry Ptasinski" <henryp@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 3/4] staging: brcm80211: remove unused cis_hnbuvars
Date: Mon, 9 May 2011 16:32:55 +0200
Message-ID: <1304951576-2351-4-git-send-email-arend@broadcom.com> (sfid-20110509_163605_007150_6A528E5E)
In-Reply-To: <1304951576-2351-1-git-send-email-arend@broadcom.com>
References: <1304951576-2351-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

The cis_hnbuvars structure is completely unused, so it can be deleted.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcoom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/util/bcmsrom_tbl.h |   70 --------------------------
 1 files changed, 0 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/brcm80211/util/bcmsrom_tbl.h b/drivers/staging/brcm80211/util/bcmsrom_tbl.h
index 22ae7c1..f4b3e61 100644
--- a/drivers/staging/brcm80211/util/bcmsrom_tbl.h
+++ b/drivers/staging/brcm80211/util/bcmsrom_tbl.h
@@ -17,7 +17,6 @@
 #ifndef	_bcmsrom_tbl_h_
 #define	_bcmsrom_tbl_h_
 
-#include "sbpcmcia.h"
 #include "wlioctl.h"
 
 typedef struct {
@@ -511,73 +510,4 @@ typedef struct {
 #define OTP_MANFID	(0xff - 3)	/* CISTPL_MANFID */
 #define OTP_RAW1	(0xff - 4)	/* Like RAW, but comes first */
 
-static const cis_tuple_t cis_hnbuvars[] = {
-	{OTP_RAW1, 0, ""},	/* special case */
-	{OTP_VERS_1, 0, "smanf sproductname"},	/* special case (non BRCM tuple) */
-	{OTP_MANFID, 4, "2manfid 2prodid"},	/* special case (non BRCM tuple) */
-	{HNBU_SROMREV, 2, "1sromrev"},
-	/* NOTE: subdevid is also written to boardtype.
-	 *       Need to write HNBU_BOARDTYPE to change it if it is different.
-	 */
-	{HNBU_CHIPID, 11, "2vendid 2devid 2chiprev 2subvendid 2subdevid"},
-	{HNBU_BOARDREV, 3, "2boardrev"},
-	{HNBU_PAPARMS, 10, "2pa0b0 2pa0b1 2pa0b2 1pa0itssit 1pa0maxpwr 1opo"},
-	{HNBU_AA, 3, "1aa2g 1aa5g"},
-	{HNBU_AA, 3, "1aa0 1aa1"},	/* backward compatibility */
-	{HNBU_AG, 5, "1ag0 1ag1 1ag2 1ag3"},
-	{HNBU_BOARDFLAGS, 9, "4boardflags 4boardflags2"},
-	{HNBU_LEDS, 5, "1ledbh0 1ledbh1 1ledbh2 1ledbh3"},
-	{HNBU_CCODE, 4, "2ccode 1cctl"},
-	{HNBU_CCKPO, 3, "2cckpo"},
-	{HNBU_OFDMPO, 5, "4ofdmpo"},
-	{HNBU_RDLID, 3, "2rdlid"},
-	{HNBU_RSSISMBXA2G, 3, "0rssismf2g 0rssismc2g 0rssisav2g 0bxa2g"},	/* special case */
-	{HNBU_RSSISMBXA5G, 3, "0rssismf5g 0rssismc5g 0rssisav5g 0bxa5g"},	/* special case */
-	{HNBU_XTALFREQ, 5, "4xtalfreq"},
-	{HNBU_TRI2G, 2, "1tri2g"},
-	{HNBU_TRI5G, 4, "1tri5gl 1tri5g 1tri5gh"},
-	{HNBU_RXPO2G, 2, "1rxpo2g"},
-	{HNBU_RXPO5G, 2, "1rxpo5g"},
-	{HNBU_BOARDNUM, 3, "2boardnum"},
-	{HNBU_MACADDR, 7, "6macaddr"},	/* special case */
-	{HNBU_RDLSN, 3, "2rdlsn"},
-	{HNBU_BOARDTYPE, 3, "2boardtype"},
-	{HNBU_LEDDC, 3, "2leddc"},
-	{HNBU_RDLRNDIS, 2, "1rdlndis"},
-	{HNBU_CHAINSWITCH, 5, "1txchain 1rxchain 2antswitch"},
-	{HNBU_REGREV, 2, "1regrev"},
-	{HNBU_FEM, 5, "0antswctl2g, 0triso2g, 0pdetrange2g, 0extpagain2g, 0tssipos2g" "0antswctl5g, 0triso5g, 0pdetrange5g, 0extpagain5g, 0tssipos5g"},	/* special case */
-	{HNBU_PAPARMS_C0, 31, "1maxp2ga0 1itt2ga0 2pa2gw0a0 2pa2gw1a0 "
-	 "2pa2gw2a0 1maxp5ga0 1itt5ga0 1maxp5gha0 1maxp5gla0 2pa5gw0a0 "
-	 "2pa5gw1a0 2pa5gw2a0 2pa5glw0a0 2pa5glw1a0 2pa5glw2a0 2pa5ghw0a0 "
-	 "2pa5ghw1a0 2pa5ghw2a0"},
-	{HNBU_PAPARMS_C1, 31, "1maxp2ga1 1itt2ga1 2pa2gw0a1 2pa2gw1a1 "
-	 "2pa2gw2a1 1maxp5ga1 1itt5ga1 1maxp5gha1 1maxp5gla1 2pa5gw0a1 "
-	 "2pa5gw1a1 2pa5gw2a1 2pa5glw0a1 2pa5glw1a1 2pa5glw2a1 2pa5ghw0a1 "
-	 "2pa5ghw1a1 2pa5ghw2a1"},
-	{HNBU_PO_CCKOFDM, 19, "2cck2gpo 4ofdm2gpo 4ofdm5gpo 4ofdm5glpo "
-	 "4ofdm5ghpo"},
-	{HNBU_PO_MCS2G, 17, "2mcs2gpo0 2mcs2gpo1 2mcs2gpo2 2mcs2gpo3 "
-	 "2mcs2gpo4 2mcs2gpo5 2mcs2gpo6 2mcs2gpo7"},
-	{HNBU_PO_MCS5GM, 17, "2mcs5gpo0 2mcs5gpo1 2mcs5gpo2 2mcs5gpo3 "
-	 "2mcs5gpo4 2mcs5gpo5 2mcs5gpo6 2mcs5gpo7"},
-	{HNBU_PO_MCS5GLH, 33, "2mcs5glpo0 2mcs5glpo1 2mcs5glpo2 2mcs5glpo3 "
-	 "2mcs5glpo4 2mcs5glpo5 2mcs5glpo6 2mcs5glpo7 "
-	 "2mcs5ghpo0 2mcs5ghpo1 2mcs5ghpo2 2mcs5ghpo3 "
-	 "2mcs5ghpo4 2mcs5ghpo5 2mcs5ghpo6 2mcs5ghpo7"},
-	{HNBU_CCKFILTTYPE, 2, "1cckdigfilttype"},
-	{HNBU_PO_CDD, 3, "2cddpo"},
-	{HNBU_PO_STBC, 3, "2stbcpo"},
-	{HNBU_PO_40M, 3, "2bw40po"},
-	{HNBU_PO_40MDUP, 3, "2bwduppo"},
-	{HNBU_RDLRWU, 2, "1rdlrwu"},
-	{HNBU_WPS, 3, "1wpsgpio 1wpsled"},
-	{HNBU_USBFS, 2, "1usbfs"},
-	{HNBU_CUSTOM1, 5, "4customvar1"},
-	{OTP_RAW, 0, ""},	/* special case */
-	{HNBU_OFDMPO5G, 13, "4ofdm5gpo 4ofdm5glpo 4ofdm5ghpo"},
-	{HNBU_USBEPNUM, 3, "2usbepnum"},
-	{0xFF, 0, ""}
-};
-
 #endif				/* _bcmsrom_tbl_h_ */
-- 
1.7.4.1



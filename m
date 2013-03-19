Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:64007 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab3CSMS4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 08:18:56 -0400
Received: by mail-ee0-f41.google.com with SMTP id c13so197853eek.14
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 05:18:55 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] ssb: extract board_type from SPROM
Date: Tue, 19 Mar 2013 13:18:43 +0100
Message-Id: <1363695524-22064-1-git-send-email-zajec5@gmail.com> (sfid-20130319_131900_357048_B814569F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/pci.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 63ff69f..99bd5ad 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -369,6 +369,7 @@ static void sprom_extract_r123(struct ssb_sprom *out, const u16 *in)
 	SPEX(et0mdcport, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET0M, 14);
 	SPEX(et1mdcport, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET1M, 15);
 	SPEX(board_rev, SSB_SPROM1_BINF, SSB_SPROM1_BINF_BREV, 0);
+	SPEX(board_type, SSB_SPROM1_SPID, 0xFFFF, 0);
 	if (out->revision == 1)
 		SPEX(country_code, SSB_SPROM1_BINF, SSB_SPROM1_BINF_CCODE,
 		     SSB_SPROM1_BINF_CCODE_SHIFT);
@@ -464,6 +465,7 @@ static void sprom_extract_r45(struct ssb_sprom *out, const u16 *in)
 	SPEX(et1phyaddr, SSB_SPROM4_ETHPHY, SSB_SPROM4_ETHPHY_ET1A,
 	     SSB_SPROM4_ETHPHY_ET1A_SHIFT);
 	SPEX(board_rev, SSB_SPROM4_BOARDREV, 0xFFFF, 0);
+	SPEX(board_type, SSB_SPROM1_SPID, 0xFFFF, 0);
 	if (out->revision == 4) {
 		SPEX(alpha2[0], SSB_SPROM4_CCODE, 0xff00, 8);
 		SPEX(alpha2[1], SSB_SPROM4_CCODE, 0x00ff, 0);
@@ -535,6 +537,7 @@ static void sprom_extract_r8(struct ssb_sprom *out, const u16 *in)
 	sprom_get_mac(out->il0mac, &in[SPOFF(SSB_SPROM8_IL0MAC)]);
 
 	SPEX(board_rev, SSB_SPROM8_BOARDREV, 0xFFFF, 0);
+	SPEX(board_type, SSB_SPROM1_SPID, 0xFFFF, 0);
 	SPEX(alpha2[0], SSB_SPROM8_CCODE, 0xff00, 8);
 	SPEX(alpha2[1], SSB_SPROM8_CCODE, 0x00ff, 0);
 	SPEX(boardflags_lo, SSB_SPROM8_BFLLO, 0xFFFF, 0);
-- 
1.7.10.4


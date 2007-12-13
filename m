Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56951 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762772AbXLMG7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:33 -0500
Subject: [PATCH 74/48] libertas: fix sparse endianness warnings in scan.c
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2w-0005sy-Mf@shinybook.infradead.org> (sfid-20071213_070109_181119_82861026)
Date: Thu, 13 Dec 2007 01:59:50 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 17:54:36 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/scan.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 8b6ce61..92d84c7 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -709,7 +709,7 @@ static int lbs_process_bss(struct bss_descriptor *bss,
 
 	if (*bytesleft >= sizeof(beaconsize)) {
 		/* Extract & convert beacon size from the command buffer */
-		beaconsize = le16_to_cpu(get_unaligned((u16 *)*pbeaconinfo));
+		beaconsize = le16_to_cpu(get_unaligned((__le16 *)*pbeaconinfo));
 		*bytesleft -= sizeof(beaconsize);
 		*pbeaconinfo += sizeof(beaconsize);
 	}
@@ -823,7 +823,7 @@ static int lbs_process_bss(struct bss_descriptor *bss,
 
 		case MFIE_TYPE_IBSS_SET:
 			pibss = (struct ieeetypes_ibssparamset *) pos;
-			bss->atimwindow = le32_to_cpu(pibss->atimwindow);
+			bss->atimwindow = le16_to_cpu(pibss->atimwindow);
 			memmove(&bss->ssparamset.ibssparamset, pibss,
 				sizeof(struct ieeetypes_ibssparamset));
 			lbs_deb_scan("got IBSS IE\n");
@@ -1562,12 +1562,11 @@ int lbs_ret_80211_scan(struct lbs_private *priv, struct cmd_ds_command *resp)
 		goto done;
 	}
 
-	bytesleft = le16_to_cpu(get_unaligned((u16*)&pscan->bssdescriptsize));
+	bytesleft = le16_to_cpu(pscan->bssdescriptsize);
 	lbs_deb_scan("SCAN_RESP: bssdescriptsize %d\n", bytesleft);
 
-	scanrespsize = le16_to_cpu(get_unaligned((u16*)&resp->size));
-	lbs_deb_scan("SCAN_RESP: scan results %d\n",
-	       pscan->nr_sets);
+	scanrespsize = le16_to_cpu(resp->size);
+	lbs_deb_scan("SCAN_RESP: scan results %d\n", pscan->nr_sets);
 
 	pbssinfo = pscan->bssdesc_and_tlvbuffer;
 
-- 
1.5.3.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3156 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934694Ab1JENUl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:20:41 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/15] staging: brcm80211: remove parameter 'off' from
 _initvars_srom_pci()
Date: Wed, 5 Oct 2011 15:20:11 +0200
Message-ID: <1317820814-7083-13-git-send-email-arend@broadcom.com> (sfid-20111005_152045_791240_22F3C146)
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function is called once with parameter 'off' fixed to zero. This
parameter has been removed.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/srom.c |   30 +++++++++++-----------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 75de8d1..8400cf4 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -924,7 +924,7 @@ static inline void htol16_buf(u16 *buf, unsigned int size)
  * convert binary srom data into linked list of srom variable items.
  */
 static void
-_initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct list_head *var_list)
+_initvars_srom_pci(u8 sromrev, u16 *srom, struct list_head *var_list)
 {
 	struct brcms_srom_list_head *entry;
 	enum brcms_srom_id id;
@@ -950,9 +950,6 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct list_head *var_list)
 		if ((srv->revmask & sr) == 0)
 			continue;
 
-		if (srv->off < off)
-			continue;
-
 		flags = srv->flags;
 		id = srv->varid;
 
@@ -964,26 +961,26 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct list_head *var_list)
 			/*
 			 * stored in string format XX:XX:XX:XX:XX:XX (17 chars)
 			 */
-			ea[0] = (srom[srv->off - off] >> 8) & 0xff;
-			ea[1] = srom[srv->off - off] & 0xff;
-			ea[2] = (srom[srv->off + 1 - off] >> 8) & 0xff;
-			ea[3] = srom[srv->off + 1 - off] & 0xff;
-			ea[4] = (srom[srv->off + 2 - off] >> 8) & 0xff;
-			ea[5] = srom[srv->off + 2 - off] & 0xff;
+			ea[0] = (srom[srv->off] >> 8) & 0xff;
+			ea[1] = srom[srv->off] & 0xff;
+			ea[2] = (srom[srv->off + 1] >> 8) & 0xff;
+			ea[3] = srom[srv->off + 1] & 0xff;
+			ea[4] = (srom[srv->off + 2] >> 8) & 0xff;
+			ea[5] = srom[srv->off + 2] & 0xff;
 			/* 17 characters + string terminator - union size */
 			extra_space = 18 - sizeof(s32);
 			type = BRCMS_SROM_STRING;
 		} else {
-			w = srom[srv->off - off];
+			w = srom[srv->off];
 			val = (w & srv->mask) >> mask_shift(srv->mask);
 			width = mask_width(srv->mask);
 
 			while (srv->flags & SRFL_MORE) {
 				srv++;
-				if (srv->off == 0 || srv->off < off)
+				if (srv->off == 0)
 					continue;
 
-				w = srom[srv->off - off];
+				w = srom[srv->off];
 				val +=
 				    ((w & srv->mask) >> mask_shift(srv->
 								   mask)) <<
@@ -1052,13 +1049,10 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct list_head *var_list)
 				if ((srv->revmask & sr) == 0)
 					continue;
 
-				if (pb + srv->off < off)
-					continue;
-
 				if (srv->flags & SRFL_NOVAR)
 					continue;
 
-				w = srom[pb + srv->off - off];
+				w = srom[pb + srv->off];
 				val = (w & srv->mask) >> mask_shift(srv->mask);
 				width = mask_width(srv->mask);
 
@@ -1226,7 +1220,7 @@ static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap,
 		INIT_LIST_HEAD(&sii->var_list);
 
 		/* parse SROM into name=value pairs. */
-		_initvars_srom_pci(sromrev, srom, 0, &sii->var_list);
+		_initvars_srom_pci(sromrev, srom, &sii->var_list);
 	}
 
 errout:
-- 
1.7.4.1



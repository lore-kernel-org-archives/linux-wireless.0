Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3118 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab1HHN7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 27/82] staging: brcm80211: use mac_pton() instead of
 own implementation
Date: Mon, 8 Aug 2011 15:58:11 +0200
Message-ID: <1312811946-16713-28-git-send-email-arend@broadcom.com> (sfid-20110808_160222_341577_C403910F)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmu_ether_atoe() does exactly the same as mac_pton().
The driver now uses the latter and brcmu_ether_atoe() has been removed
as it is not used anymore.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c       |    5 +++--
 drivers/staging/brcm80211/brcmutil/utils.c      |   15 ---------------
 drivers/staging/brcm80211/include/brcmu_utils.h |    3 ---
 3 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index a493795..eb394f5 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/pci_ids.h>
+#include <linux/if_ether.h>
 #include <net/mac80211.h>
 #include <brcm_hw_ids.h>
 #include <aiutils.h>
@@ -4584,8 +4585,8 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 		err = 21;
 		goto fail;
 	}
-	brcmu_ether_atoe(macaddr, wlc_hw->etheraddr);
-	if (is_broadcast_ether_addr(wlc_hw->etheraddr) ||
+	if (!mac_pton(macaddr, wlc_hw->etheraddr) ||
+	    is_broadcast_ether_addr(wlc_hw->etheraddr) ||
 	    is_zero_ether_addr(wlc_hw->etheraddr)) {
 		wiphy_err(wiphy, "wl%d: brcms_b_attach: bad macaddr %s\n",
 			  unit, macaddr);
diff --git a/drivers/staging/brcm80211/brcmutil/utils.c b/drivers/staging/brcm80211/brcmutil/utils.c
index cad1600..2151e0b 100644
--- a/drivers/staging/brcm80211/brcmutil/utils.c
+++ b/drivers/staging/brcm80211/brcmutil/utils.c
@@ -350,21 +350,6 @@ struct sk_buff *brcmu_pktq_mdeq(struct pktq *pq, uint prec_bmp,
 }
 EXPORT_SYMBOL(brcmu_pktq_mdeq);
 
-/* parse a xx:xx:xx:xx:xx:xx format ethernet address */
-int brcmu_ether_atoe(char *p, u8 *ea)
-{
-	int i = 0;
-
-	for (;;) {
-		ea[i++] = (char)simple_strtoul(p, &p, 16);
-		if (!*p++ || i == 6)
-			break;
-	}
-
-	return i == 6;
-}
-EXPORT_SYMBOL(brcmu_ether_atoe);
-
 #if defined(BCMDBG)
 /* pretty hex print a pkt buffer chain */
 void brcmu_prpkt(const char *msg, struct sk_buff *p0)
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index 8a340f0..513fa34 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -133,9 +133,6 @@ extern uint brcmu_pktfrombuf(struct sk_buff *p,
 	uint offset, int len, unsigned char *buf);
 extern uint brcmu_pkttotlen(struct sk_buff *p);
 
-/* ethernet address */
-extern int brcmu_ether_atoe(char *p, u8 *ea);
-
 /* ip address */
 struct ipv4_addr;
 
-- 
1.7.4.1



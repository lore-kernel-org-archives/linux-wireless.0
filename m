Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53825 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab2F3NRc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 09:17:32 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 03/18] brcmsmac: remove ai_get_buscore{type,rev}()
Date: Sat, 30 Jun 2012 15:16:06 +0200
Message-Id: <1341062181-28071-4-git-send-email-hauke@hauke-m.de> (sfid-20120630_151735_809906_D9B3C69B)
In-Reply-To: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two functions are not used any more.

Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   15 ---------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    4 ----
 2 files changed, 19 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index c7ec9b7..339e533 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -469,9 +469,6 @@ ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 		sii->pub.pmurev = sii->pub.pmucaps & PCAP_REV_MASK;
 	}
 
-	/* figure out buscore */
-	sii->buscore = ai_findcore(&sii->pub, PCIE_CORE_ID, 0);
-
 	return true;
 }
 
@@ -804,15 +801,3 @@ bool ai_deviceremoved(struct si_pub *sih)
 
 	return false;
 }
-
-uint ai_get_buscoretype(struct si_pub *sih)
-{
-	struct si_info *sii = (struct si_info *)sih;
-	return sii->buscore->id.id;
-}
-
-uint ai_get_buscorerev(struct si_pub *sih)
-{
-	struct si_info *sii = (struct si_info *)sih;
-	return sii->buscore->id.rev;
-}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index d6fa982..fb7f439 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -168,7 +168,6 @@ struct si_info {
 	struct si_pub pub;	/* back plane public state (must be first) */
 	struct bcma_bus *icbus;	/* handle to soc interconnect bus */
 	struct pci_dev *pcibus;	/* handle to pci bus */
-	struct bcma_device *buscore;
 
 	u32 chipst;		/* chip status */
 };
@@ -202,9 +201,6 @@ extern void ai_pci_up(struct si_pub *sih);
 /* Enable Ex-PA for 4313 */
 extern void ai_epa_4313war(struct si_pub *sih);
 
-extern uint ai_get_buscoretype(struct si_pub *sih);
-extern uint ai_get_buscorerev(struct si_pub *sih);
-
 static inline u32 ai_get_cccaps(struct si_pub *sih)
 {
 	return sih->cccaps;
-- 
1.7.9.5


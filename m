Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36215 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2FEXIN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 19:08:13 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, brudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 03/18] brcmsmac: remove ai_get_buscore{type,rev}()
Date: Wed,  6 Jun 2012 01:07:06 +0200
Message-Id: <1338937641-8519-4-git-send-email-hauke@hauke-m.de> (sfid-20120606_010817_785288_DF1E5B9B)
In-Reply-To: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two functions are not used any more.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   15 ---------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    4 ----
 2 files changed, 19 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 180cdd2..98e7bad 100644
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
 
@@ -805,15 +802,3 @@ bool ai_deviceremoved(struct si_pub *sih)
 
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
index d9f04a6..74beb87 100644
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


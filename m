Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53828 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab2F3NRd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 09:17:33 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 04/18] brcmsmac: use container_of instead of cast
Date: Sat, 30 Jun 2012 15:16:07 +0200
Message-Id: <1341062181-28071-5-git-send-email-hauke@hauke-m.de> (sfid-20120630_151737_926893_DB6CDA0A)
In-Reply-To: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now "struct si_pub pub" does not have to be the first member in struct
si_info any more, if it is the resulting code after compilation should
be the same.

Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 339e533..2a77698 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -582,7 +582,7 @@ void ai_detach(struct si_pub *sih)
 	struct si_pub *si_local = NULL;
 	memcpy(&si_local, &sih, sizeof(struct si_pub **));
 
-	sii = (struct si_info *)sih;
+	sii = container_of(sih, struct si_info, pub);
 
 	if (sii == NULL)
 		return;
@@ -597,7 +597,7 @@ struct bcma_device *ai_findcore(struct si_pub *sih, u16 coreid, u16 coreunit)
 	struct si_info *sii;
 	uint found;
 
-	sii = (struct si_info *)sih;
+	sii = container_of(sih, struct si_info, pub);
 
 	found = 0;
 
@@ -620,7 +620,7 @@ uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val)
 	u32 w;
 	struct si_info *sii;
 
-	sii = (struct si_info *)sih;
+	sii = container_of(sih, struct si_info, pub);
 	cc = sii->icbus->drv_cc.core;
 
 	/* mask and set */
@@ -713,7 +713,7 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 	uint slowminfreq;
 	u16 fpdelay;
 
-	sii = (struct si_info *)sih;
+	sii = container_of(sih, struct si_info, pub);
 	if (ai_get_cccaps(sih) & CC_CAP_PMU) {
 		fpdelay = si_pmu_fast_pwrup_delay(sih);
 		return fpdelay;
@@ -745,7 +745,7 @@ bool ai_clkctl_cc(struct si_pub *sih, enum bcma_clkmode mode)
 	struct si_info *sii;
 	struct bcma_device *cc;
 
-	sii = (struct si_info *)sih;
+	sii = container_of(sih, struct si_info, pub);
 
 	cc = ai_findcore(&sii->pub, BCMA_CORE_CHIPCOMMON, 0);
 	bcma_core_set_clockmode(cc, mode);
@@ -756,7 +756,7 @@ void ai_pci_up(struct si_pub *sih)
 {
 	struct si_info *sii;
 
-	sii = (struct si_info *)sih;
+	sii = container_of(sih, struct si_info, pub);
 
 	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI)
 		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci, true);
@@ -767,7 +767,7 @@ void ai_pci_down(struct si_pub *sih)
 {
 	struct si_info *sii;
 
-	sii = (struct si_info *)sih;
+	sii = container_of(sih, struct si_info, pub);
 
 	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI)
 		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci, false);
@@ -790,7 +790,7 @@ bool ai_deviceremoved(struct si_pub *sih)
 	u32 w;
 	struct si_info *sii;
 
-	sii = (struct si_info *)sih;
+	sii = container_of(sih, struct si_info, pub);
 
 	if (sii->icbus->hosttype != BCMA_HOSTTYPE_PCI)
 		return false;
-- 
1.7.9.5


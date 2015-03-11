Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:2362 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbbCKPLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 11:11:38 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/7] brcmfmac: always perform cores checks
Date: Wed, 11 Mar 2015 16:11:28 +0100
Message-ID: <1426086693-13876-3-git-send-email-arend@broadcom.com> (sfid-20150311_161143_874666_486B0D45)
In-Reply-To: <1426086693-13876-1-git-send-email-arend@broadcom.com>
References: <1426086693-13876-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of checking the cores in the chip only if CONFIG_BRCMDBG
is selected perform the check always and extend it with more sanity
checking.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/chip.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index e679edc..cb08f4e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -419,13 +419,13 @@ static struct brcmf_core *brcmf_chip_add_core(struct brcmf_chip_priv *ci,
 	return &core->pub;
 }
 
-#ifdef DEBUG
 /* safety check for chipinfo */
 static int brcmf_chip_cores_check(struct brcmf_chip_priv *ci)
 {
 	struct brcmf_core_priv *core;
 	bool need_socram = false;
 	bool has_socram = false;
+	bool cpu_found = false;
 	int idx = 1;
 
 	list_for_each_entry(core, &ci->cores, list) {
@@ -435,12 +435,14 @@ static int brcmf_chip_cores_check(struct brcmf_chip_priv *ci)
 
 		switch (core->pub.id) {
 		case BCMA_CORE_ARM_CM3:
+			cpu_found = true;
 			need_socram = true;
 			break;
 		case BCMA_CORE_INTERNAL_MEM:
 			has_socram = true;
 			break;
 		case BCMA_CORE_ARM_CR4:
+			cpu_found = true;
 			if (ci->pub.rambase == 0) {
 				brcmf_err("RAM base not provided with ARM CR4 core\n");
 				return -ENOMEM;
@@ -451,19 +453,21 @@ static int brcmf_chip_cores_check(struct brcmf_chip_priv *ci)
 		}
 	}
 
+	if (!cpu_found) {
+		brcmf_err("CPU core not detected\n");
+		return -ENXIO;
+	}
 	/* check RAM core presence for ARM CM3 core */
 	if (need_socram && !has_socram) {
 		brcmf_err("RAM core not provided with ARM CM3 core\n");
 		return -ENODEV;
 	}
+	if (!ci->pub.ramsize) {
+		brcmf_err("RAM size is undetermined\n");
+		return -ENOMEM;
+	}
 	return 0;
 }
-#else	/* DEBUG */
-static inline int brcmf_chip_cores_check(struct brcmf_chip_priv *ci)
-{
-	return 0;
-}
-#endif
 
 static void brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
 {
-- 
1.9.1


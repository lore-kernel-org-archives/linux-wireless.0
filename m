Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3566 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab1HONen (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:43 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/15] staging: brcm80211: restrict register access
 method for bcm47xx
Date: Mon, 15 Aug 2011 15:34:25 +0200
Message-ID: <1313415267-5264-14-git-send-email-arend@broadcom.com> (sfid-20110815_153459_876995_5769458C)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver contained conditional code for resolving issue with
dma transaction reordering. This code was conditionalized using
__mips__ macro, but it actually is specific to bcm47xx chips.
This patch replaces it for the more speficic CONFIG_BCM47XX macro.

Tested on BCM63281.

Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Tested-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/types.h       |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index c00178d..448afae 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -380,7 +380,7 @@ void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 
 	regs = pi->regs;
 
-#ifdef __mips__
+#ifdef CONFIG_BCM47XX
 	W_REG_FLUSH(&regs->phyregaddr, addr);
 	W_REG(&regs->phyregdata, val);
 	if (addr == 0x72)
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index ad874a7..d44db56 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -362,7 +362,7 @@ do {						\
 		} \
 	} while (0)
 
-#ifdef __mips__
+#ifdef CONFIG_BCM47XX
 /*
  * bcm4716 (which includes 4717 & 4718), plus 4706 on PCIe can reorder
  * transactions. As a fix, a read after write is performed on certain places
@@ -371,7 +371,7 @@ do {						\
 #define W_REG_FLUSH(r, v)	({ W_REG((r), (v)); (void)R_REG(r); })
 #else
 #define W_REG_FLUSH(r, v)	W_REG((r), (v))
-#endif				/* __mips__ */
+#endif				/* CONFIG_BCM47XX */
 
 #define AND_REG(r, v)	W_REG((r), R_REG(r) & (v))
 #define OR_REG(r, v)	W_REG((r), R_REG(r) | (v))
-- 
1.7.4.1



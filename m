Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2905 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023Ab1EMKAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/32] staging: brcm80211: new Kconfig item to enable IO
 reordering fix
Date: Fri, 13 May 2011 11:59:22 +0200
Message-ID: <1305280792-9475-2-git-send-email-arend@broadcom.com> (sfid-20110513_120057_519051_6E472D1A)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

bcm4716 (which includes 4717 & 4718), plus 4706 on PCIe can reorder
transactions. As a fix, a read after write is performed on certain places
in the code. Older chips and the newer 5357 family don't require this fix.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/Kconfig                  |    8 ++++++++
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |    4 ++--
 drivers/staging/brcm80211/include/bcmutils.h       |   11 +++++++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/Kconfig b/drivers/staging/brcm80211/Kconfig
index f4cf9b2..a11ffc7 100644
--- a/drivers/staging/brcm80211/Kconfig
+++ b/drivers/staging/brcm80211/Kconfig
@@ -36,3 +36,11 @@ config BRCMDBG
 	depends on BRCMSMAC || BRCMFMAC
 	---help---
 	  Selecting this enables additional code for debug purposes.
+
+config BRCM_FIX_IO_ORDER
+	bool "Broadcom I/O order fix"
+	default n
+	depends on BRCMSMAC
+	---help---
+	  Select this for for platforms running on bcm4706, 4716, 4717 or 4718.
+	  It resolves an I/O issue with the PCIe core used in these chips.
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index 6cba4df..b3c5f07 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -412,7 +412,7 @@ void write_phy_reg(phy_info_t *pi, u16 addr, u16 val)
 
 	regs = pi->regs;
 
-#ifdef __mips__
+#ifdef CONFIG_BRCM_FIX_IO_ORDER
 	W_REG(&regs->phyregaddr, addr);
 	(void)R_REG(&regs->phyregaddr);
 	W_REG(&regs->phyregdata, val);
@@ -427,7 +427,7 @@ void write_phy_reg(phy_info_t *pi, u16 addr, u16 val)
 			(void)R_REG(&regs->phyversion);
 		}
 	}
-#endif
+#endif /* CONFIG_BRCM_FIX_IO_ORDER */
 }
 
 void and_phy_reg(phy_info_t *pi, u16 addr, u16 val)
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index 224d4ce..a4a2a8d 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -367,6 +367,17 @@ extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
 	} while (0)
 #endif				/* __BIG_ENDIAN */
 
+#ifdef CONFIG_BRCM_FIX_IO_ORDER
+/*
+ * bcm4716 (which includes 4717 & 4718), plus 4706 on PCIe can reorder
+ * transactions. As a fix, a read after write is performed on certain places
+ * in the code. Older chips and the newer 5357 family don't require this fix.
+ */
+#define W_REG_FLUSH(r, v)	{ W_REG((r), (v)); (void)R_REG(r); }
+#else
+#define W_REG_FLUSH(r, v)	W_REG((r), (v))
+#endif				/* CONFIG_BRCM_FIX_IO_ORDER */
+
 #define AND_REG(r, v)	W_REG((r), R_REG(r) & (v))
 #define OR_REG(r, v)	W_REG((r), R_REG(r) | (v))
 
-- 
1.7.4.1



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2956 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab1IAJRn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:43 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 29/30] staging: brcm80211: cleaned up several softmac
 macro's
Date: Thu, 1 Sep 2011 11:17:19 +0200
Message-ID: <1314868640-9425-30-git-send-email-rvossen@broadcom.com> (sfid-20110901_111842_590926_191D45A5)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moved, deleted or substituted macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/d11.h         |    5 ---
 drivers/staging/brcm80211/brcmsmac/dma.c         |    2 -
 drivers/staging/brcm80211/brcmsmac/dma.h         |    9 +++---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   32 +++++++++-------------
 4 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index f0c3f5a..14e60a5 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -23,8 +23,6 @@
 #include "pub.h"
 #include "dma.h"
 
-#define	BCN_TMPL_LEN		512	/* length of the BCN template area */
-
 /* RX FIFO numbers */
 #define	RX_FIFO			0	/* data and ctl frames */
 #define	RX_TXSTATUS_FIFO	3	/* RX fifo for tx status packages */
@@ -1397,9 +1395,6 @@ struct d11rxhdr {
 	u16 RxChan;
 } __packed;
 
-#define	RXHDR_LEN		24	/* sizeof struct d11rxhdr */
-#define	FRAMELEN(h)		((h)->RxFrameSize)
-
 /*
  * rxhdr: received frame header data
  * tsf_l: TSF_L reading
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 85680c8..63e5e0e 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -199,8 +199,6 @@
 
 #define	MAXNAMEL	8	/* 8 char names */
 
-#define	DI_INFO(dmah)	((dma_info_t *)dmah)
-
 /* descriptor bumping macros */
 /* faster than %, but n must be power of 2 */
 #define	XXD(x, n)	((x) & ((n) - 1))
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index 2ce5963..4075dc9 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -20,6 +20,10 @@
 #include <linux/delay.h>
 #include "types.h"		/* forward structure declarations */
 
+/* map/unmap direction */
+#define	DMA_TX	1		/* TX direction for DMA */
+#define	DMA_RX	2		/* RX direction for DMA */
+
 /* DMA structure:
  *  support two DMA engines: 32 bits address or 64 bit addressing
  *  basic DMA register set is per channel(transmit or receive)
@@ -47,11 +51,6 @@ struct dma64regs {
 	u32 status1;	/* active descriptor, xmt error */
 };
 
-/* map/unmap direction */
-#define	DMA_TX	1		/* TX direction for DMA */
-#define	DMA_RX	2		/* RX direction for DMA */
-#define BUS_SWAP32(v)		(v)
-
 /* range param for dma_getnexttxp() and dma_txreclaim */
 enum txd_range {
 	DMA_RANGE_ALL = 1,
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 227beb6..23001c2 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -37,9 +37,6 @@
 #define LOCK(wl)	spin_lock_bh(&(wl)->lock)
 #define UNLOCK(wl)	spin_unlock_bh(&(wl)->lock)
 
-#define HW_TO_WL(hw)	 (hw->priv)
-#define WL_TO_HW(wl)	  (wl->pub->ieee_hw)
-
 /* locking from inside brcms_isr */
 #define ISR_LOCK(wl, flags)\
 	do {\
@@ -308,9 +305,6 @@ static int brcms_ops_start(struct ieee80211_hw *hw)
 {
 	struct brcms_info *wl = hw->priv;
 	bool blocked;
-	/*
-	  struct ieee80211_channel *curchan = hw->conf.channel;
-	*/
 
 	ieee80211_wake_queues(hw);
 	LOCK(wl);
@@ -344,7 +338,7 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		return -EOPNOTSUPP;
 	}
 
-	wl = HW_TO_WL(hw);
+	wl = hw->priv;
 	LOCK(wl);
 	err = brcms_up(wl);
 	UNLOCK(wl);
@@ -361,7 +355,7 @@ brcms_ops_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct brcms_info *wl;
 
-	wl = HW_TO_WL(hw);
+	wl = hw->priv;
 
 	/* put driver in down state */
 	LOCK(wl);
@@ -376,7 +370,7 @@ static int
 ieee_set_channel(struct ieee80211_hw *hw, struct ieee80211_channel *chan,
 		 enum nl80211_channel_type type)
 {
-	struct brcms_info *wl = HW_TO_WL(hw);
+	struct brcms_info *wl = hw->priv;
 	int err = 0;
 
 	switch (type) {
@@ -400,7 +394,7 @@ ieee_set_channel(struct ieee80211_hw *hw, struct ieee80211_channel *chan,
 static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ieee80211_conf *conf = &hw->conf;
-	struct brcms_info *wl = HW_TO_WL(hw);
+	struct brcms_info *wl = hw->priv;
 	int err = 0;
 	int new_int;
 	struct wiphy *wiphy = hw->wiphy;
@@ -468,7 +462,7 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif,
 			struct ieee80211_bss_conf *info, u32 changed)
 {
-	struct brcms_info *wl = HW_TO_WL(hw);
+	struct brcms_info *wl = hw->priv;
 	struct wiphy *wiphy = hw->wiphy;
 	int val;
 
@@ -818,7 +812,7 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 
 static void brcms_ops_rfkill_poll(struct ieee80211_hw *hw)
 {
-	struct brcms_info *wl = HW_TO_WL(hw);
+	struct brcms_info *wl = hw->priv;
 	bool blocked;
 
 	LOCK(wl);
@@ -830,7 +824,7 @@ static void brcms_ops_rfkill_poll(struct ieee80211_hw *hw)
 
 static void brcms_ops_flush(struct ieee80211_hw *hw, bool drop)
 {
-	struct brcms_info *wl = HW_TO_WL(hw);
+	struct brcms_info *wl = hw->priv;
 
 	no_printk("%s: drop = %s\n", __func__, drop ? "true" : "false");
 
@@ -1028,7 +1022,7 @@ static void brcms_remove(struct pci_dev *pdev)
 	int status;
 
 	hw = pci_get_drvdata(pdev);
-	wl = HW_TO_WL(hw);
+	wl = hw->priv;
 	if (!wl) {
 		pr_err("wl: brcms_remove: pci_get_drvdata failed\n");
 		return;
@@ -1090,7 +1084,7 @@ static irqreturn_t brcms_isr(int irq, void *dev_id)
  */
 static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 {
-	struct brcms_info *wl = HW_TO_WL(hw);
+	struct brcms_info *wl = hw->priv;
 	int has_5g;
 	char phy_list[4];
 
@@ -1339,7 +1333,7 @@ static int brcms_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct ieee80211_hw *hw;
 
 	hw = pci_get_drvdata(pdev);
-	wl = HW_TO_WL(hw);
+	wl = hw->priv;
 	if (!wl) {
 		wiphy_err(wl->wiphy,
 			  "brcms_suspend: pci_get_drvdata failed\n");
@@ -1364,7 +1358,7 @@ static int brcms_resume(struct pci_dev *pdev)
 	u32 val;
 
 	hw = pci_get_drvdata(pdev);
-	wl = HW_TO_WL(hw);
+	wl = hw->priv;
 	if (!wl) {
 		wiphy_err(wl->wiphy,
 			  "wl: brcms_resume: pci_get_drvdata failed\n");
@@ -1458,7 +1452,7 @@ void brcms_txflowcontrol(struct brcms_info *wl, struct brcms_if *wlif,
  */
 void brcms_init(struct brcms_info *wl)
 {
-	BCMMSG(WL_TO_HW(wl)->wiphy, "wl%d\n", wl->pub->unit);
+	BCMMSG(wl->pub->ieee_hw->wiphy, "wl%d\n", wl->pub->unit);
 	brcms_reset(wl);
 
 	brcms_c_init(wl->wlc);
@@ -1469,7 +1463,7 @@ void brcms_init(struct brcms_info *wl)
  */
 uint brcms_reset(struct brcms_info *wl)
 {
-	BCMMSG(WL_TO_HW(wl)->wiphy, "wl%d\n", wl->pub->unit);
+	BCMMSG(wl->pub->ieee_hw->wiphy, "wl%d\n", wl->pub->unit);
 	brcms_c_reset(wl->wlc);
 
 	/* dpc will not be rescheduled */
-- 
1.7.4.1



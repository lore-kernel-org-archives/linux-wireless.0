Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34563 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933316Ab2JZOYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:24:15 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 11/18] brcmsmac: Add RX and TX debug macros
Date: Fri, 26 Oct 2012 09:23:26 -0500
Message-Id: <1351261413-20821-12-git-send-email-seth.forshee@canonical.com> (sfid-20121026_162420_825530_E2AEB8D7)
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also convert relevant messages over to use thses macros.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 .../net/wireless/brcm80211/brcmsmac/brcms_debug.h  |    2 ++
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   18 ++++++++----------
 drivers/net/wireless/brcm80211/include/defs.h      |    2 ++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h b/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h
index 12f513b..2b3ca0d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h
@@ -37,5 +37,7 @@ static inline void __brcms_dbg(struct device *dev, u32 level,
 
 #define BRCMS_DBG_INFO(core, f, a...)		BRCMS_DBG(core, BRCM_DL_INFO, f, ##a)
 #define BRCMS_DBG_MAC80211(core, f, a...)	BRCMS_DBG(core, BRCM_DL_MAC80211, f, ##a)
+#define BRCMS_DBG_RX(core, f, a...)		BRCMS_DBG(core, BRCM_DL_RX, f, ##a)
+#define BRCMS_DBG_TX(core, f, a...)		BRCMS_DBG(core, BRCM_DL_TX, f, ##a)
 
 #endif /* _BRCMS_DEBUG_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 09cca57..d6a7076 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -888,7 +888,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	 */
 	if (!(txs->status & TX_STATUS_AMPDU)
 	    && (txs->status & TX_STATUS_INTERMEDIATE)) {
-		BCMMSG(wlc->wiphy, "INTERMEDIATE but not AMPDU\n");
+		BRCMS_DBG_TX(wlc->hw->d11core, "INTERMEDIATE but not AMPDU\n");
 		fatal = false;
 		goto out;
 	}
@@ -931,9 +931,9 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 
 	supr_status = txs->status & TX_STATUS_SUPR_MASK;
 	if (supr_status == TX_STATUS_SUPR_BADCH)
-		BCMMSG(wlc->wiphy,
-		       "%s: Pkt tx suppressed, possibly channel %d\n",
-		       __func__, CHSPEC_CHANNEL(wlc->default_bss->chanspec));
+		BRCMS_DBG_TX(wlc->hw->d11core,
+			     "Pkt tx suppressed, possibly channel %d\n",
+			     CHSPEC_CHANNEL(wlc->default_bss->chanspec));
 
 	tx_rts = le16_to_cpu(txh->MacTxControlLow) & TXC_SENDRTS;
 	tx_frame_count =
@@ -1045,7 +1045,6 @@ static bool
 brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 {
 	bool morepending = false;
-	struct brcms_c_info *wlc = wlc_hw->wlc;
 	struct bcma_device *core;
 	struct tx_status txstatus, *txs;
 	u32 s1, s2;
@@ -1056,7 +1055,7 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 	 */
 	uint max_tx_num = bound ? TXSBND : -1;
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	BRCMS_DBG_TX(core, "wl%d\n", wlc_hw->unit);
 
 	txs = &txstatus;
 	core = wlc_hw->d11core;
@@ -1534,8 +1533,7 @@ brcms_b_set_addrmatch(struct brcms_hardware *wlc_hw, int match_reg_offset,
 	u16 mac_m;
 	u16 mac_h;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: brcms_b_set_addrmatch\n",
-		 wlc_hw->unit);
+	BRCMS_DBG_RX(core, "wl%d: brcms_b_set_addrmatch\n", wlc_hw->unit);
 
 	mac_l = addr[0] | (addr[1] << 8);
 	mac_m = addr[2] | (addr[3] << 8);
@@ -7837,7 +7835,7 @@ static void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 	uint len;
 	bool is_amsdu;
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
+	BRCMS_DBG_RX(wlc->hw->d11core, "wl%d\n", wlc->pub->unit);
 
 	/* frame starts with rxhdr */
 	rxh = (struct d11rxhdr *) (p->data);
@@ -7895,7 +7893,7 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 	uint n = 0;
 	uint bound_limit = bound ? RXBND : -1;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	BRCMS_DBG_RX(wlc_hw->d11core, "wl%d\n", wlc_hw->unit);
 	skb_queue_head_init(&recv_frames);
 
 	/* gather received frames */
diff --git a/drivers/net/wireless/brcm80211/include/defs.h b/drivers/net/wireless/brcm80211/include/defs.h
index 4d6906f..9206d2c 100644
--- a/drivers/net/wireless/brcm80211/include/defs.h
+++ b/drivers/net/wireless/brcm80211/include/defs.h
@@ -81,6 +81,8 @@
 /* Debug levels */
 #define BRCM_DL_INFO		0x00000001
 #define BRCM_DL_MAC80211	0x00000002
+#define BRCM_DL_RX		0x00000004
+#define BRCM_DL_TX		0x00000008
 
 #define PM_OFF	0
 #define PM_MAX	1
-- 
1.7.9.5


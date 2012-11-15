Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58923 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767963Ab2KOOIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:47 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 15/22] brcmsmac: Add rx and tx debug macros
Date: Thu, 15 Nov 2012 08:08:05 -0600
Message-Id: <1352988492-21340-16-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150855_385503_144CBA71)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also convert relevant messages over to use thses macros.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/debug.h |    2 ++
 drivers/net/wireless/brcm80211/brcmsmac/main.c  |   18 ++++++++----------
 drivers/net/wireless/brcm80211/include/defs.h   |    2 ++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.h b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
index f4f5090..b979128 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/debug.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
@@ -37,5 +37,7 @@ static inline void __brcms_dbg(struct device *dev, u32 level,
 
 #define brcms_dbg_info(core, f, a...)		brcms_dbg(core, BRCM_DL_INFO, f, ##a)
 #define brcms_dbg_mac80211(core, f, a...)	brcms_dbg(core, BRCM_DL_MAC80211, f, ##a)
+#define brcms_dbg_rx(core, f, a...)		brcms_dbg(core, BRCM_DL_RX, f, ##a)
+#define brcms_dbg_tx(core, f, a...)		brcms_dbg(core, BRCM_DL_TX, f, ##a)
 
 #endif /* _BRCMS_DEBUG_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 9c976b2..d6df923 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -882,7 +882,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	 */
 	if (!(txs->status & TX_STATUS_AMPDU)
 	    && (txs->status & TX_STATUS_INTERMEDIATE)) {
-		BCMMSG(wlc->wiphy, "INTERMEDIATE but not AMPDU\n");
+		brcms_dbg_tx(wlc->hw->d11core, "INTERMEDIATE but not AMPDU\n");
 		fatal = false;
 		goto out;
 	}
@@ -925,9 +925,9 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 
 	supr_status = txs->status & TX_STATUS_SUPR_MASK;
 	if (supr_status == TX_STATUS_SUPR_BADCH)
-		BCMMSG(wlc->wiphy,
-		       "%s: Pkt tx suppressed, possibly channel %d\n",
-		       __func__, CHSPEC_CHANNEL(wlc->default_bss->chanspec));
+		brcms_dbg_tx(wlc->hw->d11core,
+			     "Pkt tx suppressed, possibly channel %d\n",
+			     CHSPEC_CHANNEL(wlc->default_bss->chanspec));
 
 	tx_rts = le16_to_cpu(txh->MacTxControlLow) & TXC_SENDRTS;
 	tx_frame_count =
@@ -1039,7 +1039,6 @@ static bool
 brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 {
 	bool morepending = false;
-	struct brcms_c_info *wlc = wlc_hw->wlc;
 	struct bcma_device *core;
 	struct tx_status txstatus, *txs;
 	u32 s1, s2;
@@ -1050,7 +1049,7 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 	 */
 	uint max_tx_num = bound ? TXSBND : -1;
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	brcms_dbg_tx(core, "wl%d\n", wlc_hw->unit);
 
 	txs = &txstatus;
 	core = wlc_hw->d11core;
@@ -1528,8 +1527,7 @@ brcms_b_set_addrmatch(struct brcms_hardware *wlc_hw, int match_reg_offset,
 	u16 mac_m;
 	u16 mac_h;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: brcms_b_set_addrmatch\n",
-		 wlc_hw->unit);
+	brcms_dbg_rx(core, "wl%d: brcms_b_set_addrmatch\n", wlc_hw->unit);
 
 	mac_l = addr[0] | (addr[1] << 8);
 	mac_m = addr[2] | (addr[3] << 8);
@@ -7831,7 +7829,7 @@ static void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 	uint len;
 	bool is_amsdu;
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
+	brcms_dbg_rx(wlc->hw->d11core, "wl%d\n", wlc->pub->unit);
 
 	/* frame starts with rxhdr */
 	rxh = (struct d11rxhdr *) (p->data);
@@ -7889,7 +7887,7 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 	uint n = 0;
 	uint bound_limit = bound ? RXBND : -1;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	brcms_dbg_rx(wlc_hw->d11core, "wl%d\n", wlc_hw->unit);
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


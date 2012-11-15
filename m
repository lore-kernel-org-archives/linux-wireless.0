Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58961 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767968Ab2KOOJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:09:02 -0500
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
Subject: [PATCH v2 22/22] brcmsmac: Remove some noisy and uninformative debug messages
Date: Thu, 15 Nov 2012 08:08:12 -0600
Message-Id: <1352988492-21340-23-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150908_309051_0CAA8AEC)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These messages clutter up the trace buffer without adding any useful
information.

Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c  |    2 --
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   25 ------------------------
 2 files changed, 27 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 0f44bd9..511e457 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -1377,8 +1377,6 @@ int dma_txfast(struct brcms_c_info *wlc, struct dma_pub *pub,
 	struct ieee80211_tx_info *tx_info;
 	bool is_ampdu;
 
-	brcms_dbg_dma(di->core, "%s:\n", di->name);
-
 	/* no use to transmit a zero length packet */
 	if (p->len == 0)
 		return 0;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index f7da9b3..f2c05d5 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -647,10 +647,6 @@ static uint brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 		rate = BRCM_RATE_1M;
 	}
 
-	brcms_dbg_mac80211(wlc->hw->d11core,
-			   "wl%d: rspec 0x%x, preamble_type %d, len%d\n",
-			   wlc->pub->unit, ratespec, preamble_type, mac_len);
-
 	if (is_mcs_rate(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
 		int tot_streams = mcs_2_txstreams(mcs) + rspec_stc(ratespec);
@@ -4943,8 +4939,6 @@ uint brcms_c_detach(struct brcms_c_info *wlc)
 	if (wlc == NULL)
 		return 0;
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
-
 	callbacks += brcms_b_detach(wlc);
 
 	/* delete software timers */
@@ -5778,9 +5772,6 @@ brcms_c_calc_ack_time(struct brcms_c_info *wlc, u32 rspec,
 {
 	uint dur = 0;
 
-	brcms_dbg_mac80211(wlc->hw->d11core,
-			   "wl%d: rspec 0x%x, preamble_type %d\n",
-			   wlc->pub->unit, rspec, preamble_type);
 	/*
 	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
 	 * is less than or equal to the rate of the immediately previous
@@ -5798,9 +5789,6 @@ static uint
 brcms_c_calc_cts_time(struct brcms_c_info *wlc, u32 rspec,
 		      u8 preamble_type)
 {
-	brcms_dbg_mac80211(wlc->hw->d11core,
-			   "wl%d: ratespec 0x%x, preamble_type %d\n",
-			   wlc->pub->unit, rspec, preamble_type);
 	return brcms_c_calc_ack_time(wlc, rspec, preamble_type);
 }
 
@@ -5808,9 +5796,6 @@ static uint
 brcms_c_calc_ba_time(struct brcms_c_info *wlc, u32 rspec,
 		     u8 preamble_type)
 {
-	brcms_dbg_mac80211(wlc->hw->d11core,
-			   "wl%d: rspec 0x%x, preamble_type %d\n",
-			   wlc->pub->unit, rspec, preamble_type);
 	/*
 	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
 	 * is less than or equal to the rate of the immediately previous
@@ -5864,10 +5849,6 @@ brcms_c_calc_frame_len(struct brcms_c_info *wlc, u32 ratespec,
 	uint nsyms, mac_len, Ndps, kNdps;
 	uint rate = rspec2rate(ratespec);
 
-	brcms_dbg_mac80211(wlc->hw->d11core,
-			   "wl%d: rspec 0x%x, preamble_type %d, dur %d\n",
-			   wlc->pub->unit, ratespec, preamble_type, dur);
-
 	if (is_mcs_rate(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
 		int tot_streams = mcs_2_txstreams(mcs) + rspec_stc(ratespec);
@@ -7272,9 +7253,6 @@ brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
 {
 	uint nsyms, len = 0, kNdps;
 
-	brcms_dbg_mac80211(wlc->hw->d11core, "wl%d: rate %d, len%d\n",
-			   wlc->pub->unit, rspec2rate(ratespec), mac_len);
-
 	if (is_mcs_rate(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
 		int tot_streams = (mcs_2_txstreams(mcs) + 1) +
@@ -7628,8 +7606,6 @@ static void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 	uint len;
 	bool is_amsdu;
 
-	brcms_dbg_rx(wlc->hw->d11core, "wl%d\n", wlc->pub->unit);
-
 	/* frame starts with rxhdr */
 	rxh = (struct d11rxhdr *) (p->data);
 
@@ -7686,7 +7662,6 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 	uint n = 0;
 	uint bound_limit = bound ? RXBND : -1;
 
-	brcms_dbg_rx(wlc_hw->d11core, "wl%d\n", wlc_hw->unit);
 	skb_queue_head_init(&recv_frames);
 
 	/* gather received frames */
-- 
1.7.9.5


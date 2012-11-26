Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9019 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab2KZM3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 07:29:37 -0500
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>
Subject: [PATCH 1/3] compat-drivers: Remove few cherry-pick patches
Date: Mon, 26 Nov 2012 17:59:55 +0530
Message-ID: <1353932997-8051-2-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20121126_132941_679612_9FECC19C)
In-Reply-To: <1353932997-8051-1-git-send-email-bkamatch@qca.qualcomm.com>
References: <1353932997-8051-1-git-send-email-bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches are moved to stable git, remove it and
refresh next pending patches.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 .../0088-cfg80211-fix-antenna-gain-handling.patch  |   39 ------------
 ...tale-pointers-potentially-causing-access-.patch |   43 -------------
 ...for-TID-only-in-BlockAcks-while-checking-.patch |   65 --------------------
 ...x-signal-strength-noise-measurements-on-a.patch |    2 +-
 4 files changed, 1 insertions(+), 148 deletions(-)
 delete mode 100644 linux-next-cherry-picks/0088-cfg80211-fix-antenna-gain-handling.patch
 delete mode 100644 linux-next-cherry-picks/0093-ath9k-fix-stale-pointers-potentially-causing-access-.patch
 delete mode 100644 linux-next-cherry-picks/0119-ath9k-Test-for-TID-only-in-BlockAcks-while-checking-.patch

diff --git a/linux-next-cherry-picks/0088-cfg80211-fix-antenna-gain-handling.patch b/linux-next-cherry-picks/0088-cfg80211-fix-antenna-gain-handling.patch
deleted file mode 100644
index b5ee43d..0000000
--- a/linux-next-cherry-picks/0088-cfg80211-fix-antenna-gain-handling.patch
+++ /dev/null
@@ -1,39 +0,0 @@
-From c4a9fafc77a5318f5ed26c509bbcddf03e18c201 Mon Sep 17 00:00:00 2001
-From: Felix Fietkau <nbd@openwrt.org>
-Date: Wed, 17 Oct 2012 13:56:19 +0200
-Subject: [PATCH] cfg80211: fix antenna gain handling
-
-No driver initializes chan->max_antenna_gain to something sensible, and
-the only place where it is being used right now is inside ath9k. This
-leads to ath9k potentially using less tx power than it can use, which can
-decrease performance/range in some rare cases.
-
-Rather than going through every single driver, this patch initializes
-chan->orig_mag in wiphy_register(), ignoring whatever value the driver
-left in there. If a driver for some reason wishes to limit it independent
-from regulatory rulesets, it can do so internally.
-
-Signed-off-by: Felix Fietkau <nbd@openwrt.org>
-Cc: stable@vger.kernel.org
-Signed-off-by: Johannes Berg <johannes.berg@intel.com>
----
- net/wireless/core.c |    3 +--
- 1 files changed, 1 insertions(+), 2 deletions(-)
-
-diff --git a/net/wireless/core.c b/net/wireless/core.c
-index 443d4d7..3f72530 100644
---- a/net/wireless/core.c
-+++ b/net/wireless/core.c
-@@ -526,8 +526,7 @@ int wiphy_register(struct wiphy *wiphy)
- 		for (i = 0; i < sband->n_channels; i++) {
- 			sband->channels[i].orig_flags =
- 				sband->channels[i].flags;
--			sband->channels[i].orig_mag =
--				sband->channels[i].max_antenna_gain;
-+			sband->channels[i].orig_mag = INT_MAX;
- 			sband->channels[i].orig_mpwr =
- 				sband->channels[i].max_power;
- 			sband->channels[i].band = band;
--- 
-1.7.4.1
-
diff --git a/linux-next-cherry-picks/0093-ath9k-fix-stale-pointers-potentially-causing-access-.patch b/linux-next-cherry-picks/0093-ath9k-fix-stale-pointers-potentially-causing-access-.patch
deleted file mode 100644
index e3a77ab..0000000
--- a/linux-next-cherry-picks/0093-ath9k-fix-stale-pointers-potentially-causing-access-.patch
+++ /dev/null
@@ -1,43 +0,0 @@
-From 8c6e30936a7893a85f6222084f0f26aceb81137a Mon Sep 17 00:00:00 2001
-From: Felix Fietkau <nbd@openwrt.org>
-Date: Fri, 26 Oct 2012 00:31:11 +0200
-Subject: [PATCH] ath9k: fix stale pointers potentially causing access to free'd skbs
-
-bf->bf_next is only while buffers are chained as part of an A-MPDU
-in the tx queue. When a tid queue is flushed (e.g. on tearing down
-an aggregation session), frames can be enqueued again as normal
-transmission, without bf_next being cleared. This can lead to the
-old pointer being dereferenced again later.
-
-This patch might fix crashes and "Failed to stop TX DMA!" messages.
-
-Signed-off-by: Felix Fietkau <nbd@openwrt.org>
-Cc: stable@vger.kernel.org
-Signed-off-by: John W. Linville <linville@tuxdriver.com>
----
- drivers/net/wireless/ath/ath9k/xmit.c |    2 ++
- 1 files changed, 2 insertions(+), 0 deletions(-)
-
-diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
-index 378bd70..1ffca75 100644
---- a/drivers/net/wireless/ath/ath9k/xmit.c
-+++ b/drivers/net/wireless/ath/ath9k/xmit.c
-@@ -312,6 +312,7 @@ static struct ath_buf *ath_tx_get_buffer(struct ath_softc *sc)
- 	}
- 
- 	bf = list_first_entry(&sc->tx.txbuf, struct ath_buf, list);
-+	bf->bf_next = NULL;
- 	list_del(&bf->list);
- 
- 	spin_unlock_bh(&sc->tx.txbuflock);
-@@ -1774,6 +1775,7 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
- 	list_add_tail(&bf->list, &bf_head);
- 	bf->bf_state.bf_type = 0;
- 
-+	bf->bf_next = NULL;
- 	bf->bf_lastbf = bf;
- 	ath_tx_fill_desc(sc, bf, txq, fi->framelen);
- 	ath_tx_txqaddbuf(sc, txq, &bf_head, false);
--- 
-1.7.4.1
-
diff --git a/linux-next-cherry-picks/0119-ath9k-Test-for-TID-only-in-BlockAcks-while-checking-.patch b/linux-next-cherry-picks/0119-ath9k-Test-for-TID-only-in-BlockAcks-while-checking-.patch
deleted file mode 100644
index 7c2f24e..0000000
--- a/linux-next-cherry-picks/0119-ath9k-Test-for-TID-only-in-BlockAcks-while-checking-.patch
+++ /dev/null
@@ -1,65 +0,0 @@
-From 6fe7cc71bbf3a0bc28c9cec3c00bc11e81344412 Mon Sep 17 00:00:00 2001
-From: Sven Eckelmann <sven@narfation.org>
-Date: Mon, 29 Oct 2012 13:25:20 +0100
-Subject: [PATCH] ath9k: Test for TID only in BlockAcks while checking tx status
-
-The ath9k xmit functions for AMPDUs can send frames as non-aggregate in case
-only one frame is currently available. The client will then answer using a
-normal Ack instead of a BlockAck. This acknowledgement has no TID stored and
-therefore the hardware is not able to provide us the corresponding TID.
-
-The TID set by the hardware in the tx status descriptor has to be seen as
-undefined and not as a valid TID value for normal acknowledgements. Doing
-otherwise results in a massive amount of retransmissions and stalls of
-connections.
-
-Users may experience low bandwidth and complete connection stalls in
-environments with transfers using multiple TIDs.
-
-This regression was introduced in b11b160defc48e4daa283f785192ea3a23a51f8e
-("ath9k: validate the TID in the tx status information").
-
-Signed-off-by: Sven Eckelmann <sven@narfation.org>
-Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
-Cc: stable@vger.kernel.org
-Acked-by: Felix Fietkau <nbd@openwrt.org>
-Signed-off-by: John W. Linville <linville@tuxdriver.com>
----
- drivers/net/wireless/ath/ath9k/xmit.c |    8 ++++++--
- 1 files changed, 6 insertions(+), 2 deletions(-)
-
-diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
-index 1ffca75..741918a 100644
---- a/drivers/net/wireless/ath/ath9k/xmit.c
-+++ b/drivers/net/wireless/ath/ath9k/xmit.c
-@@ -394,7 +394,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
- 	u16 seq_st = 0, acked_cnt = 0, txfail_cnt = 0, seq_first;
- 	u32 ba[WME_BA_BMP_SIZE >> 5];
- 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
--	bool rc_update = true;
-+	bool rc_update = true, isba;
- 	struct ieee80211_tx_rate rates[4];
- 	struct ath_frame_info *fi;
- 	int nframes;
-@@ -438,13 +438,17 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
- 	tidno = ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
- 	tid = ATH_AN_2_TID(an, tidno);
- 	seq_first = tid->seq_start;
-+	isba = ts->ts_flags & ATH9K_TX_BA;
- 
- 	/*
- 	 * The hardware occasionally sends a tx status for the wrong TID.
- 	 * In this case, the BA status cannot be considered valid and all
- 	 * subframes need to be retransmitted
-+	 *
-+	 * Only BlockAcks have a TID and therefore normal Acks cannot be
-+	 * checked
- 	 */
--	if (tidno != ts->tid)
-+	if (isba && tidno != ts->tid)
- 		txok = false;
- 
- 	isaggr = bf_isaggr(bf);
--- 
-1.7.4.1
-
diff --git a/linux-next-pending/0001-ath9k_hw-fix-signal-strength-noise-measurements-on-a.patch b/linux-next-pending/0001-ath9k_hw-fix-signal-strength-noise-measurements-on-a.patch
index 727c904..604dc0d 100644
--- a/linux-next-pending/0001-ath9k_hw-fix-signal-strength-noise-measurements-on-a.patch
+++ b/linux-next-pending/0001-ath9k_hw-fix-signal-strength-noise-measurements-on-a.patch
@@ -14,7 +14,7 @@ Signed-off-by: Felix Fietkau <nbd@openwrt.org>
 
 --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
 +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
-@@ -332,9 +332,9 @@
+@@ -344,9 +344,9 @@
  #define AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ     -95
  #define AR_PHY_CCA_MAX_GOOD_VAL_9300_5GHZ     -100
  
-- 
1.7.4.1


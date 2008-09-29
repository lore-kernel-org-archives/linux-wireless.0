Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26131 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbYI2WeB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 18:34:01 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 15:34:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <akpm@linux-foundation.org>
Subject: [PATCH] ath9k: kill ath9k's memzero() and use memset() instead
Date: Mon, 29 Sep 2008 08:33:48 -0700
Message-ID: <1222702428-6619-1-git-send-email-lrodriguez@atheros.com> (sfid-20080930_003410_888221_05641C88)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Part of the cleanup on ath9k -- this was also causing some
annoying compile time warnings.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Got to scratch the itch.

 drivers/net/wireless/ath9k/beacon.c |    8 ++++----
 drivers/net/wireless/ath9k/core.c   |   14 +++++++-------
 drivers/net/wireless/ath9k/core.h   |    5 +----
 drivers/net/wireless/ath9k/recv.c   |    4 ++--
 drivers/net/wireless/ath9k/xmit.c   |   10 +++++-----
 5 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index eedb465..9e15c30 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -129,7 +129,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 			    ds                    /* first descriptor */
 		);
 
-	memzero(series, sizeof(struct ath9k_11n_rate_series) * 4);
+	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
 	series[0].Tries = 1;
 	series[0].Rate = rate;
 	series[0].ChSel = sc->sc_tx_chainmask;
@@ -282,7 +282,7 @@ int ath_beaconq_setup(struct ath_hal *ah)
 {
 	struct ath9k_tx_queue_info qi;
 
-	memzero(&qi, sizeof(qi));
+	memset(&qi, 0, sizeof(qi));
 	qi.tqi_aifs = 1;
 	qi.tqi_cwmin = 0;
 	qi.tqi_cwmax = 0;
@@ -662,7 +662,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	else
 		av_opmode = sc->sc_ah->ah_opmode;
 
-	memzero(&conf, sizeof(struct ath_beacon_config));
+	memset(&conf, 0, sizeof(struct ath_beacon_config));
 
 	conf.beacon_interval = sc->hw->conf.beacon_int ?
 		sc->hw->conf.beacon_int : ATH_DEFAULT_BINTVAL;
@@ -738,7 +738,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			}
 		} while (nexttbtt < tsftu);
 #undef FUDGE
-		memzero(&bs, sizeof(bs));
+		memset(&bs, 0, sizeof(bs));
 		bs.bs_intval = intval;
 		bs.bs_nexttbtt = nexttbtt;
 		bs.bs_dtimperiod = dtimperiod*intval;
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index d7f5257..5af7dfb 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -65,7 +65,7 @@ static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
 	for (i = 0; i < rt->rateCount; i++)
 		sc->sc_rixmap[rt->info[i].rateCode] = (u8) i;
 
-	memzero(sc->sc_hwmap, sizeof(sc->sc_hwmap));
+	memset(sc->sc_hwmap, 0, sizeof(sc->sc_hwmap));
 	for (i = 0; i < 256; i++) {
 		u8 ix = rt->rateCodeToIndex[i];
 
@@ -417,7 +417,7 @@ static void ath_chainmask_sel_init(struct ath_softc *sc, struct ath_node *an)
 {
 	struct ath_chainmask_sel *cm = &an->an_chainmask_sel;
 
-	memzero(cm, sizeof(struct ath_chainmask_sel));
+	memset(cm, 0, sizeof(struct ath_chainmask_sel));
 
 	cm->cur_tx_mask = sc->sc_tx_chainmask;
 	cm->cur_rx_mask = sc->sc_rx_chainmask;
@@ -526,7 +526,7 @@ int ath_vap_attach(struct ath_softc *sc,
 	if (avp == NULL)
 		return -ENOMEM;
 
-	memzero(avp, sizeof(struct ath_vap));
+	memset(avp, 0, sizeof(struct ath_vap));
 	avp->av_if_data = if_data;
 	/* Set the VAP opmode */
 	avp->av_opmode = opmode;
@@ -1219,7 +1219,7 @@ struct ath_node *ath_node_attach(struct ath_softc *sc, u8 *addr, int if_id)
 	an = kmalloc(sizeof(struct ath_node), GFP_ATOMIC);
 	if (an == NULL)
 		return NULL;
-	memzero(an, sizeof(*an));
+	memset(an, 0, sizeof(*an));
 
 	an->an_sc = sc;
 	memcpy(an->an_addr, addr, ETH_ALEN);
@@ -1606,7 +1606,7 @@ int ath_descdma_setup(struct ath_softc *sc,
 		error = -ENOMEM;
 		goto fail2;
 	}
-	memzero(bf, bsize);
+	memset(bf, 0, bsize);
 	dd->dd_bufptr = bf;
 
 	INIT_LIST_HEAD(head);
@@ -1638,7 +1638,7 @@ fail2:
 	pci_free_consistent(sc->pdev,
 		dd->dd_desc_len, dd->dd_desc, dd->dd_desc_paddr);
 fail:
-	memzero(dd, sizeof(*dd));
+	memset(dd, 0, sizeof(*dd));
 	return error;
 #undef ATH_DESC_4KB_BOUND_CHECK
 #undef ATH_DESC_4KB_BOUND_NUM_SKIPPED
@@ -1663,7 +1663,7 @@ void ath_descdma_cleanup(struct ath_softc *sc,
 
 	INIT_LIST_HEAD(head);
 	kfree(dd->dd_bufptr);
-	memzero(dd, sizeof(*dd));
+	memset(dd, 0, sizeof(*dd));
 }
 
 /*************/
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 872f0c5..80814c9 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -84,9 +84,6 @@ struct ath_node;
 #define TSF_TO_TU(_h,_l) \
 	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
 
-/* XXX: remove */
-#define memzero(_buf, _len) memset(_buf, 0, _len)
-
 #define ATH9K_BH_STATUS_INTACT		0
 #define ATH9K_BH_STATUS_CHANGE		1
 
@@ -184,7 +181,7 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht);
 		(_bf)->bf_lastbf = NULL;			\
 		(_bf)->bf_lastfrm = NULL;			\
 		(_bf)->bf_next = NULL;				\
-		memzero(&((_bf)->bf_state),			\
+		memset(&((_bf)->bf_state), 0,			\
 			    sizeof(struct ath_buf_state));	\
 	} while (0)
 
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 4982563..f4be5d1 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -892,7 +892,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		hdr = (struct ieee80211_hdr *)skb->data;
 		fc = hdr->frame_control;
-		memzero(&rx_status, sizeof(struct ath_recv_status));
+		memset(&rx_status, 0, sizeof(struct ath_recv_status));
 
 		if (ds->ds_rxstat.rs_more) {
 			/*
@@ -1166,7 +1166,7 @@ int ath_rx_aggr_start(struct ath_softc *sc,
 		} else {
 			/* Ensure the memory is zeroed out (all internal
 			 * pointers are null) */
-			memzero(rxtid->rxbuf, ATH_TID_MAX_BUFS *
+			memset(rxtid->rxbuf, 0, ATH_TID_MAX_BUFS *
 				sizeof(struct ath_rxbuf));
 			DPRINTF(sc, ATH_DBG_AGGR,
 				"%s: Allocated @%p\n", __func__, rxtid->rxbuf);
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 2592905..bdcb9e1 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -729,7 +729,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	/*
 	 * Setup HAL rate series
 	 */
-	memzero(series, sizeof(struct ath9k_11n_rate_series) * 4);
+	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
 
 	for (i = 0; i < 4; i++) {
 		if (!bf->bf_rcs[i].tries)
@@ -817,7 +817,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		 * Disable multi-rate retry when using RTS/CTS by clearing
 		 * series 1, 2 and 3.
 		 */
-		memzero(&series[1], sizeof(struct ath9k_11n_rate_series) * 3);
+		memset(&series[1], 0, sizeof(struct ath9k_11n_rate_series) * 3);
 	}
 
 	/*
@@ -930,7 +930,7 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 					ATH_DS_BA_BITMAP(ds),
 					WME_BA_BMP_SIZE >> 3);
 			} else {
-				memzero(ba, WME_BA_BMP_SIZE >> 3);
+				memset(ba, 0, WME_BA_BMP_SIZE >> 3);
 
 				/*
 				 * AR5416 can become deaf/mute when BA
@@ -943,7 +943,7 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 					needreset = 1;
 			}
 		} else {
-			memzero(ba, WME_BA_BMP_SIZE >> 3);
+			memset(ba, 0, WME_BA_BMP_SIZE >> 3);
 		}
 	}
 
@@ -2098,7 +2098,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 	struct ath9k_tx_queue_info qi;
 	int qnum;
 
-	memzero(&qi, sizeof(qi));
+	memset(&qi, 0, sizeof(qi));
 	qi.tqi_subtype = subtype;
 	qi.tqi_aifs = ATH9K_TXQ_USEDEFAULT;
 	qi.tqi_cwmin = ATH9K_TXQ_USEDEFAULT;
-- 
1.5.6.rc2.15.g457bb.dirty


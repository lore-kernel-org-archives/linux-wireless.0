Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3751 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab1ILKPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:23 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 10/20] staging: brcm80211: removed unused
 encryption/security functionality
Date: Mon, 12 Sep 2011 12:14:54 +0200
Message-ID: <1315822504-24210-11-git-send-email-rvossen@broadcom.com> (sfid-20110912_121544_692748_AD251016)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Softmac relies on Mac80211 for this.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/alloc.c |   15 ----
 drivers/staging/brcm80211/brcmsmac/main.c  |   59 +----------------
 drivers/staging/brcm80211/brcmsmac/main.h  |   97 ----------------------------
 drivers/staging/brcm80211/brcmsmac/pub.h   |   12 ----
 4 files changed, 3 insertions(+), 180 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index 7a499ba..344c0ad 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -210,20 +210,6 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 	}
 	brcms_c_bsscfg_ID_assign(wlc, wlc->cfg);
 
-	wlc->wsec_def_keys[0] =
-		kzalloc(sizeof(struct wsec_key) * BRCMS_DEFAULT_KEYS,
-			GFP_ATOMIC);
-	if (wlc->wsec_def_keys[0] == NULL) {
-		*err = 1015;
-		goto fail;
-	} else {
-		int i;
-		for (i = 1; i < BRCMS_DEFAULT_KEYS; i++)
-			wlc->wsec_def_keys[i] = (struct wsec_key *)
-			    ((unsigned long)wlc->wsec_def_keys[0] +
-			     (sizeof(struct wsec_key) * i));
-	}
-
 	wlc->protection = kzalloc(sizeof(struct brcms_protection),
 				  GFP_ATOMIC);
 	if (wlc->protection == NULL) {
@@ -280,7 +266,6 @@ void brcms_c_detach_mfree(struct brcms_c_info *wlc)
 	brcms_c_pub_mfree(wlc->pub);
 	kfree(wlc->modulecb);
 	kfree(wlc->default_bss);
-	kfree(wlc->wsec_def_keys[0]);
 	kfree(wlc->protection);
 	kfree(wlc->stf);
 	kfree(wlc->bandstate[0]);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index d755c18..cc669d6 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -32,16 +32,6 @@
 #include "ucode_loader.h"
 #include "main.h"
 
-
-/*
- * WPA(2) definitions
- */
-#define RSN_CAP_4_REPLAY_CNTRS		2
-#define RSN_CAP_16_REPLAY_CNTRS		3
-
-#define WPA_CAP_4_REPLAY_CNTRS		RSN_CAP_4_REPLAY_CNTRS
-#define WPA_CAP_16_REPLAY_CNTRS		RSN_CAP_16_REPLAY_CNTRS
-
 /*
  * Indication for txflowcontrol that all priority bits in
  * TXQ_STOP_FOR_PRIOFC_MASK are to be considered.
@@ -181,9 +171,6 @@
 /* stop txq enqueue for ampdu flow control */
 #define TXQ_STOP_FOR_AMPDU_FLOW_CNTRL	0x00000200
 
-/* number of 802.11 default (non-paired, group keys) */
-#define WSEC_MAX_DEFAULT_KEYS	4	/* # of default keys */
-
 #define	BRCMS_HWRXOFF		38	/* chip rx buffer offset */
 
 #define OSL_SYSUPTIME()		((u32)jiffies * (1000 / HZ))
@@ -376,18 +363,7 @@
 #define BRCMS_TX_FIFO_ENAB(wlc, fifo) \
 			((wlc)->tx_prec_map |= (wlc)->fifo2prec_map[fifo])
 
-/*
- * if wpa is in use then portopen is true when the
- * group key is plumbed otherwise it is always true
- */
-#define WSEC_ENABLED(wsec) ((wsec) & (WEP_ENABLED | TKIP_ENABLED | AES_ENABLED))
-
-#define BRCMS_SW_KEYS(wlc, bsscfg) ((((wlc)->wsec_swkeys) || \
-	((bsscfg)->wsec & WSEC_SWFLAG)))
-
-#define BRCMS_PORTOPEN(cfg) \
-	(((cfg)->WPA_auth != WPA_AUTH_DISABLED && WSEC_ENABLED((cfg)->wsec)) ? \
-	(cfg)->wsec_portopen : true)
+#define BRCMS_PORTOPEN(cfg) true
 
 #define brcms_b_copyfrom_shm(wlc_hw, offset, buf, len)                 \
 	brcms_b_copyfrom_objmem(wlc_hw, offset, buf, len, OBJADDR_SHM_SEL)
@@ -4325,8 +4301,6 @@ static void brcms_b_watchdog(void *arg)
 static void brcms_c_watchdog(void *arg)
 {
 	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
-	int i;
-	struct brcms_bss_cfg *cfg;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
@@ -4372,14 +4346,6 @@ static void brcms_c_watchdog(void *arg)
 	if ((wlc->pub->now % SW_TIMER_MAC_STAT_UPD) == 0)
 		brcms_c_statsupd(wlc);
 
-	/* Manage TKIP countermeasures timers */
-	FOREACH_BSS(wlc, i, cfg)
-		if (cfg->tk_cm_dt)
-			cfg->tk_cm_dt--;
-		if (cfg->tk_cm_bt)
-			cfg->tk_cm_bt--;
-	END_FOREACH_BSS()
-
 	if (BRCMS_ISNPHY(wlc->band) && !wlc->pub->tempsense_disable &&
 	    ((wlc->pub->now - wlc->tempsense_lasttime) >=
 	     BRCMS_TEMPSENSE_PERIOD)) {
@@ -4469,15 +4435,6 @@ void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 	wlc->SRL = RETRY_SHORT_DEF;
 	wlc->LRL = RETRY_LONG_DEF;
 
-	/* Set flag to indicate that hw keys should be used when available. */
-	wlc->wsec_swkeys = false;
-
-	/* init the 4 static WEP default keys */
-	for (i = 0; i < WSEC_MAX_DEFAULT_KEYS; i++) {
-		wlc->wsec_keys[i] = wlc->wsec_def_keys[i];
-		wlc->wsec_keys[i]->idx = (u8) i;
-	}
-
 	/* WME QoS mode is Auto by default */
 	wlc->pub->_wme = AUTO;
 	wlc->pub->_ampdu = AMPDU_AGG_HOST;
@@ -7128,7 +7085,7 @@ static u16
 brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		     struct sk_buff *p, struct scb *scb, uint frag,
 		     uint nfrags, uint queue, uint next_frag_len,
-		     struct wsec_key *key, u32 rspec_override)
+		     u32 rspec_override)
 {
 	struct ieee80211_hdr *h;
 	struct d11txh *txh;
@@ -7171,14 +7128,6 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	len = brcmu_pkttotlen(p);
 	phylen = len + FCS_LEN;
 
-	/* If WEP enabled, add room in phylen for the additional bytes of
-	 * ICV which MAC generates.  We do NOT add the additional bytes to
-	 * the packet itself, thus phylen = packet length + ICV_LEN + FCS_LEN
-	 * in this case
-	 */
-	if (key)
-		phylen += key->icv_len;
-
 	/* Get tx_info */
 	tx_info = IEEE80211_SKB_CB(p);
 
@@ -7796,9 +7745,7 @@ void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 	prio = ieee80211_is_data(d11_header->frame_control) ? sdu->priority :
 		MAXPRIO;
 	fifo = prio2fifo[prio];
-	if (unlikely
-	    (brcms_c_d11hdrs_mac80211(
-		wlc, hw, sdu, scb, 0, 1, fifo, 0, NULL, 0)))
+	if (brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0, 0))
 		return;
 	brcms_c_txq_enq(wlc, scb, sdu, BRCMS_PRIO_TO_PREC(prio));
 	brcms_c_send_q(wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index a0dcacc..674750b 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -237,44 +237,6 @@ struct brcms_stf {
 #define BRCMS_CHAN_CHANNEL(x)     (((x) & RXS_CHAN_ID_MASK) \
 				   >> RXS_CHAN_ID_SHIFT)
 
-/* Maximum # of keys that wl driver supports in S/W.
- * Keys supported in H/W is less than or equal to WSEC_MAX_KEYS.
- */
-#define WSEC_MAX_KEYS		54 /* Max # of keys (50 + 4 default keys) */
-#define BRCMS_DEFAULT_KEYS	4 /* Default # of keys */
-
-/*
-* Max # of keys currently supported:
-*
-*     s/w keys if WSEC_SW(wlc->wsec).
-*     h/w keys otherwise.
-*/
-
-struct wsec_iv {
-	u32 hi;		/* upper 32 bits of IV */
-	u16 lo;		/* lower 16 bits of IV */
-};
-
-#define BRCMS_NUMRXIVS	16	/* # rx IVs (one per 802.11e TID) */
-
-struct wsec_key {
-	u8 ea[ETH_ALEN];	/* per station */
-	u8 idx;		/* key index in wsec_keys array */
-	u8 id;		/* key ID [0-3] */
-	u8 algo;	/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
-	u8 rcmta;	/* rcmta entry index, same as idx by default */
-	u16 flags;	/* misc flags */
-	u8 algo_hw;	/* cache for hw register */
-	u8 aes_mode;	/* cache for hw register */
-	s8 iv_len;	/* IV length */
-	s8 icv_len;	/* ICV length */
-	u32 len;	/* key length..don't move this var */
-	/* data is 4byte aligned */
-	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
-	struct wsec_iv rxiv[BRCMS_NUMRXIVS];	/* Rx IV (one per TID) */
-	struct wsec_iv txiv;		/* Tx IV */
-};
-
 /*
  * core state (mac)
  */
@@ -575,10 +537,6 @@ struct brcms_txq_info {
  * bsscfg: set of BSS configurations, idx 0 is default and always valid.
  * cfg: the primary bsscfg (can be AP or STA).
  * tx_queues: common TX Queue list.
- * wsec_keys[WSEC_MAX_KEYS]: dynamic key storage.
- * wsec_def_keys[BRCMS_DEFAULT_KEYS]: default key storage.
- * wsec_swkeys: indicates that all keys should be treated as
- *		sw keys (used for debugging).
  * modulecb:
  * mimoft: SIGN or 11N.
  * cck_40txbw: 11N, cck tx b/w override when in 40MHZ mode.
@@ -718,10 +676,6 @@ struct brcms_c_info {
 	/* tx queue */
 	struct brcms_txq_info *tx_queues;
 
-	/* security */
-	struct wsec_key *wsec_keys[WSEC_MAX_KEYS];
-	struct wsec_key *wsec_def_keys[BRCMS_DEFAULT_KEYS];
-	bool wsec_swkeys;
 	struct modulecb *modulecb;
 
 	u8 mimoft;
@@ -808,28 +762,6 @@ struct antsel_info {
  * nmac: # of entries on maclist array
  * macmode: allow/deny stations on maclist array
  * maclist: list of source MAC addrs to match
-
- * security
- * --------
- * wsec: wireless security bitvec
- * auth: 802.11 authentication: Open, Shared Key, WPA
- * openshared: try Open auth first, then Shared Key
- * wsec_restrict: drop unencrypted packets if wsec is enabled
- * eap_restrict: restrict data until 802.1X auth succeeds
- * WPA_auth: WPA authenticated key management
- * wpa2_preauth: default is true, wpa_cap sets value
- * wsec_portopen: indicates keys are plumbed
- * wpa_none_txiv: global txiv for WPA_NONE, tkip and aes
- * wsec_index: 0-3: default tx key, -1: not set
- * bss_def_keys: default key storage
- *
- * TKIP countermeasures
- * --------------------
- * tkip_countermeasures: flags TKIP no-assoc period
- * tk_cm_dt: detect timer
- * tk_cm_bt: blocking timer
- * tk_cm_bt_tmstmp: Timestamp when TKIP BT is activated
- * tk_cm_activate: activate countermeasures after EAPOL-Key sent
  *
  * BSSID: BSSID (associated)
  * cur_etheraddr: h/w address
@@ -839,12 +771,7 @@ struct antsel_info {
  * bcn: AP beacon
  * bcn_len: AP beacon length
  * ar_disassoc: disassociated in associated recreation
- * auth_atmptd: auth type (open/shared) attempted
  *
- * pmkid_cand: PMKID candidate list
- * npmkid_cand: num PMKID candidates
- * pmkid: PMKID cache
- * npmkid: num cached PMKIDs
  * current_bss: BSS parms in ASSOCIATED state
  *
  * PM states
@@ -854,8 +781,6 @@ struct antsel_info {
  * priorPMstate: Detecting PM state transitions
  * PSpoll: flags there is an outstanding PS-Poll frame
  *
- * rcmta: BSSID entry in RCMTA, use the wsec key to manage the RCMTA entries.
- *
  * ID: 'unique' ID of this bsscfg, assigned at bsscfg allocation
  *
  * txrspecidx: index into tx rate circular buffer
@@ -875,22 +800,6 @@ struct brcms_bss_cfg {
 	uint nmac;
 	int macmode;
 	struct ether_addr *maclist;
-	u32 wsec;
-	s16 auth;
-	s16 openshared;
-	bool wsec_restrict;
-	bool eap_restrict;
-	u16 WPA_auth;
-	bool wpa2_preauth;
-	bool wsec_portopen;
-	struct wsec_iv wpa_none_txiv;
-	int wsec_index;
-	struct wsec_key *bss_def_keys[BRCMS_DEFAULT_KEYS];
-	bool tkip_countermeasures;
-	u32 tk_cm_dt;
-	u32 tk_cm_bt;
-	u32 tk_cm_bt_tmstmp;
-	bool tk_cm_activate;
 	u8 BSSID[ETH_ALEN];
 	u8 cur_etheraddr[ETH_ALEN];
 	u16 bcmc_fid;
@@ -899,17 +808,11 @@ struct brcms_bss_cfg {
 	u8 *bcn;
 	uint bcn_len;
 	bool ar_disassoc;
-	int auth_atmptd;
-	struct pmkid_cand pmkid_cand[MAXPMKID];
-	uint npmkid_cand;
-	struct pmkid pmkid[MAXPMKID];
-	uint npmkid;
 	struct brcms_bss_info *current_bss;
 	bool PMawakebcn;
 	bool PMpending;
 	bool priorPMstate;
 	bool PSpoll;
-	struct wsec_key *rcmta;
 	u16 ID;
 	uint txrspecidx;
 	u32 txrspec[NTXRATE][2];
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 20582f1..9e767fb 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -128,16 +128,6 @@ struct brcms_c_rateset {
 	u8 mcs[MCSSET_LEN];	/* supported mcs index bit map */
 };
 
-struct rsn_parms {
-	u8 flags;		/* misc booleans (e.g., supported) */
-	u8 multicast;	/* multicast cipher */
-	u8 ucount;		/* count of unicast ciphers */
-	u8 unicast[4];	/* unicast ciphers */
-	u8 acount;		/* count of auth modes */
-	u8 auth[4];		/* Authentication modes */
-	u8 PAD[4];		/* padding for future growth */
-};
-
 /* All the HT-specific default advertised capabilities (including AMPDU)
  * should be grouped here at one place
  */
@@ -160,8 +150,6 @@ struct brcms_bss_info {
 	s8 phy_noise;		/* noise right after tx (in dBm) */
 	u16 capability;	/* Capability information */
 	u8 wme_qosinfo;	/* QoS Info from WME IE; valid if BSS_WME flag set */
-	struct rsn_parms wpa;
-	struct rsn_parms wpa2;
 	u16 qbss_load_aac;	/* qbss load available admission capacity */
 	/* qbss_load_chan_free <- (0xff - chan utilization of qbss_load_ie_t) */
 	u8 qbss_load_chan_free;	/* indicates how free the channel is */
-- 
1.7.4.1



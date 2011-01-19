Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34044 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1ASWkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 17:40:40 -0500
Received: by fxm20 with SMTP id 20so1423529fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 14:40:39 -0800 (PST)
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFT 7/8] staging: brcm80211: Replace ether_addr with fixed size array.
Date: Wed, 19 Jan 2011 23:35:31 +0100
Message-Id: <1295476532-21130-8-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1295476532-21130-7-git-send-email-jonas.gorski@gmail.com>
References: <1295476532-21130-1-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-2-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-3-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-4-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-5-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-6-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-7-git-send-email-jonas.gorski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace the ether_addr struct with a fixed size array.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 drivers/staging/brcm80211/include/bcmutils.h       |    2 +-
 drivers/staging/brcm80211/include/proto/802.11.h   |   18 ++++----
 drivers/staging/brcm80211/include/proto/bcmevent.h |    2 +-
 drivers/staging/brcm80211/include/proto/ethernet.h |    8 ---
 drivers/staging/brcm80211/include/wlioctl.h        |   22 ++++----
 drivers/staging/brcm80211/sys/wl_mac80211.c        |    3 +-
 drivers/staging/brcm80211/sys/wlc_alloc.c          |    4 +-
 drivers/staging/brcm80211/sys/wlc_ampdu.c          |    2 +-
 drivers/staging/brcm80211/sys/wlc_bmac.c           |   34 ++++++-------
 drivers/staging/brcm80211/sys/wlc_bmac.h           |   14 ++---
 drivers/staging/brcm80211/sys/wlc_bsscfg.h         |    6 +-
 drivers/staging/brcm80211/sys/wlc_key.h            |    2 +-
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |   50 +++++++++-----------
 drivers/staging/brcm80211/sys/wlc_mac80211.h       |   12 ++---
 drivers/staging/brcm80211/sys/wlc_pub.h            |   10 ++--
 drivers/staging/brcm80211/sys/wlc_scb.h            |    2 +-
 drivers/staging/brcm80211/util/bcmsrom.c           |   16 +++---
 drivers/staging/brcm80211/util/bcmutils.c          |    4 +-
 18 files changed, 95 insertions(+), 116 deletions(-)

diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index a8f76d8..7e6c1b0 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -157,7 +157,7 @@ extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
 	extern uint pkttotlen(struct osl_info *osh, struct sk_buff *p);
 
 /* ethernet address */
-	extern int bcm_ether_atoe(char *p, struct ether_addr *ea);
+	extern int bcm_ether_atoe(char *p, u8 *ea);
 
 /* ip address */
 	struct ipv4_addr;
diff --git a/drivers/staging/brcm80211/include/proto/802.11.h b/drivers/staging/brcm80211/include/proto/802.11.h
index ffde19c..11940fe 100644
--- a/drivers/staging/brcm80211/include/proto/802.11.h
+++ b/drivers/staging/brcm80211/include/proto/802.11.h
@@ -48,18 +48,18 @@
 BWL_PRE_PACKED_STRUCT struct dot11_header {
 	u16 fc;
 	u16 durid;
-	struct ether_addr a1;
-	struct ether_addr a2;
-	struct ether_addr a3;
+	u8 a1[ETH_ALEN];
+	u8 a2[ETH_ALEN];
+	u8 a3[ETH_ALEN];
 	u16 seq;
-	struct ether_addr a4;
+	u8 a4[ETH_ALEN];
 } BWL_POST_PACKED_STRUCT;
 
 BWL_PRE_PACKED_STRUCT struct dot11_rts_frame {
 	u16 fc;
 	u16 durid;
-	struct ether_addr ra;
-	struct ether_addr ta;
+	u8 ra[ETH_ALEN];
+	u8 ta[ETH_ALEN];
 } BWL_POST_PACKED_STRUCT;
 
 #define	DOT11_RTS_LEN		16
@@ -72,9 +72,9 @@ BWL_PRE_PACKED_STRUCT struct dot11_rts_frame {
 BWL_PRE_PACKED_STRUCT struct dot11_management_header {
 	u16 fc;
 	u16 durid;
-	struct ether_addr da;
-	struct ether_addr sa;
-	struct ether_addr bssid;
+	u8 da[ETH_ALEN];
+	u8 sa[ETH_ALEN];
+	u8 bssid[ETH_ALEN];
 	u16 seq;
 } BWL_POST_PACKED_STRUCT;
 #define	DOT11_MGMT_HDR_LEN	24
diff --git a/drivers/staging/brcm80211/include/proto/bcmevent.h b/drivers/staging/brcm80211/include/proto/bcmevent.h
index f61c048..5802ea0 100644
--- a/drivers/staging/brcm80211/include/proto/bcmevent.h
+++ b/drivers/staging/brcm80211/include/proto/bcmevent.h
@@ -34,7 +34,7 @@ typedef BWL_PRE_PACKED_STRUCT struct {
 	u32 reason;
 	u32 auth_type;
 	u32 datalen;
-	struct ether_addr addr;
+	u8 addr[ETH_ALEN];
 	char ifname[BCM_MSG_IFNAME_MAX];
 } BWL_POST_PACKED_STRUCT wl_event_msg_t;
 
diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index b401fda..f52f430 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -19,12 +19,4 @@
 
 #include <linux/if_ether.h>
 
-#include <packed_section_start.h>
-
-BWL_PRE_PACKED_STRUCT struct ether_addr {
-	u8 octet[ETH_ALEN];
-} BWL_POST_PACKED_STRUCT;
-
-#include <packed_section_end.h>
-
 #endif				/* _NET_ETHERNET_H_ */
diff --git a/drivers/staging/brcm80211/include/wlioctl.h b/drivers/staging/brcm80211/include/wlioctl.h
index 9be793c..9b85f31 100644
--- a/drivers/staging/brcm80211/include/wlioctl.h
+++ b/drivers/staging/brcm80211/include/wlioctl.h
@@ -46,7 +46,7 @@ typedef struct wl_bss_info {
 	u32 length;		/* byte length of data in this record,
 				 * starting at version and including IEs
 				 */
-	struct ether_addr BSSID;
+	u8 BSSID[ETH_ALEN];
 	u16 beacon_period;	/* units are Kusec */
 	u16 capability;	/* Capability information */
 	u8 SSID_len;
@@ -128,7 +128,7 @@ typedef struct wl_extdscan_params {
 
 typedef struct wl_scan_params {
 	wlc_ssid_t ssid;	/* default: {0, ""} */
-	struct ether_addr bssid;	/* default: bcast */
+	u8 bssid[ETH_ALEN];	/* default: bcast */
 	s8 bss_type;		/* default: any,
 				 * DOT11_BSSTYPE_ANY/INFRASTRUCTURE/INDEPENDENT
 				 */
@@ -234,8 +234,8 @@ typedef struct wl_iscan_results {
 
 typedef struct wl_probe_params {
 	wlc_ssid_t ssid;
-	struct ether_addr bssid;
-	struct ether_addr mac;
+	u8 bssid[ETH_ALEN];
+	u8 mac[ETH_ALEN];
 } wl_probe_params_t;
 #endif /* BRCM_FULLMAC */
 
@@ -262,7 +262,7 @@ typedef struct wl_u32_list {
 
 /* used for association with a specific BSSID and chanspec list */
 typedef struct wl_assoc_params {
-	struct ether_addr bssid;	/* 00:00:00:00:00:00: broadcast scan */
+	u8 bssid[ETH_ALEN];	/* 00:00:00:00:00:00: broadcast scan */
 	s32 chanspec_num;	/* 0: all available channels,
 				 * otherwise count of chanspecs in chanspec_list
 				 */
@@ -492,7 +492,7 @@ typedef struct wl_wsec_key {
 		u16 lo;	/* lower 16 bits of IV */
 	} rxiv;
 	u32 pad_5[2];
-	struct ether_addr ea;	/* per station */
+	u8 ea[ETH_ALEN];	/* per station */
 } wl_wsec_key_t;
 
 #define WSEC_MIN_PSK_LEN	8
@@ -534,7 +534,7 @@ typedef struct {
 #define	MAXPMKID		16
 
 typedef struct _pmkid {
-	struct ether_addr BSSID;
+	u8 BSSID[ETH_ALEN];
 	u8 PMKID[WPA2_PMKID_LEN];
 } pmkid_t;
 
@@ -544,7 +544,7 @@ typedef struct _pmkid_list {
 } pmkid_list_t;
 
 typedef struct _pmkid_cand {
-	struct ether_addr BSSID;
+	u8 BSSID[ETH_ALEN];
 	u8 preauth;
 } pmkid_cand_t;
 
@@ -572,7 +572,7 @@ typedef struct {
 /* Used to get specific STA parameters */
 typedef struct {
 	u32 val;
-	struct ether_addr ea;
+	u8 ea[ETH_ALEN];
 } scb_val_t;
 #endif /* BRCM_FULLMAC */
 
@@ -586,7 +586,7 @@ typedef struct channel_info {
 /* For ioctls that take a list of MAC addresses */
 struct maclist {
 	uint count;		/* number of MAC addresses */
-	struct ether_addr ea[1];	/* variable length array of MAC addresses */
+	u8 *ea;			/* variable length array of MAC addresses */
 };
 
 /* get pkt count struct passed through ioctl */
@@ -1614,7 +1614,7 @@ struct ampdu_tid_control {
 
 /* structure for identifying ea/tid for sending addba/delba */
 struct ampdu_ea_tid {
-	struct ether_addr ea;	/* Station address */
+	u8 ea[ETH_ALEN];	/* Station address */
 	u8 tid;		/* tid */
 };
 /* structure for identifying retry/tid for retry_limit_tid/rr_retry_limit_tid */
diff --git a/drivers/staging/brcm80211/sys/wl_mac80211.c b/drivers/staging/brcm80211/sys/wl_mac80211.c
index bdd629d..ca87eb1 100644
--- a/drivers/staging/brcm80211/sys/wl_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wl_mac80211.c
@@ -395,8 +395,7 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 			info->aid, info->bssid);
 		/* BSSID changed, for whatever reason (IBSS and managed mode) */
 		/* FIXME: need to store bssid in bsscfg */
-		wlc_set_addrmatch(wl->wlc, RCM_BSSID_OFFSET,
-				  (struct ether_addr *)info->bssid);
+		wlc_set_addrmatch(wl->wlc, RCM_BSSID_OFFSET, info->bssid);
 	}
 	if (changed & BSS_CHANGED_BEACON) {
 		WL_ERROR("BSS_CHANGED_BEACON\n");
diff --git a/drivers/staging/brcm80211/sys/wlc_alloc.c b/drivers/staging/brcm80211/sys/wlc_alloc.c
index 746439e..02ae320 100644
--- a/drivers/staging/brcm80211/sys/wlc_alloc.c
+++ b/drivers/staging/brcm80211/sys/wlc_alloc.c
@@ -86,8 +86,8 @@ static struct wlc_pub *wlc_pub_malloc(struct osl_info *osh, uint unit,
 	/* need to init the tunables now */
 	wlc_tunables_init(pub->tunables, devid);
 
-	pub->multicast = (struct ether_addr *)wlc_calloc(osh, unit,
-		(sizeof(struct ether_addr) * MAXMULTILIST));
+	pub->multicast = (u8 *)wlc_calloc(osh, unit,
+		(ETH_ALEN * MAXMULTILIST));
 	if (pub->multicast == NULL) {
 		*err = 1003;
 		goto fail;
diff --git a/drivers/staging/brcm80211/sys/wlc_ampdu.c b/drivers/staging/brcm80211/sys/wlc_ampdu.c
index d749917..31e79cf 100644
--- a/drivers/staging/brcm80211/sys/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/sys/wlc_ampdu.c
@@ -1329,7 +1329,7 @@ void wlc_ampdu_macaddr_upd(struct wlc_info *wlc)
 
 	/* driver needs to write the ta in the template; ta is at offset 16 */
 	memset(template, 0, sizeof(template));
-	bcopy((char *)wlc->pub->cur_etheraddr.octet, template, ETH_ALEN);
+	bcopy(wlc->pub->cur_etheraddr, template, ETH_ALEN);
 	wlc_write_template_ram(wlc, (T_BA_TPL_BASE + 16), (T_RAM_ACCESS_SZ * 2),
 			       template);
 }
diff --git a/drivers/staging/brcm80211/sys/wlc_bmac.c b/drivers/staging/brcm80211/sys/wlc_bmac.c
index 69f600a..d4ca079 100644
--- a/drivers/staging/brcm80211/sys/wlc_bmac.c
+++ b/drivers/staging/brcm80211/sys/wlc_bmac.c
@@ -1032,9 +1032,9 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		err = 21;
 		goto fail;
 	}
-	bcm_ether_atoe(macaddr, &wlc_hw->etheraddr);
-	if (is_broadcast_ether_addr(wlc_hw->etheraddr.octet) ||
-	    is_zero_ether_addr(wlc_hw->etheraddr.octet)) {
+	bcm_ether_atoe(macaddr, wlc_hw->etheraddr);
+	if (is_broadcast_ether_addr(wlc_hw->etheraddr) ||
+	    is_zero_ether_addr(wlc_hw->etheraddr)) {
 		WL_ERROR("wl%d: wlc_bmac_attach: bad macaddr %s\n",
 			 unit, macaddr);
 		err = 22;
@@ -1348,13 +1348,12 @@ void wlc_bmac_wait_for_wake(struct wlc_hw_info *wlc_hw)
 	ASSERT(wlc_bmac_read_shm(wlc_hw, M_UCODE_DBGST) != DBGST_ASLEEP);
 }
 
-void wlc_bmac_hw_etheraddr(struct wlc_hw_info *wlc_hw, struct ether_addr *ea)
+void wlc_bmac_hw_etheraddr(struct wlc_hw_info *wlc_hw, u8 *ea)
 {
 	bcopy(&wlc_hw->etheraddr, ea, ETH_ALEN);
 }
 
-void wlc_bmac_set_hw_etheraddr(struct wlc_hw_info *wlc_hw,
-			       struct ether_addr *ea)
+void wlc_bmac_set_hw_etheraddr(struct wlc_hw_info *wlc_hw, u8 *ea)
 {
 	bcopy(ea, &wlc_hw->etheraddr, ETH_ALEN);
 }
@@ -1720,8 +1719,7 @@ static void wlc_ucode_mute_override_clear(struct wlc_hw_info *wlc_hw)
  * Write a MAC address to the rcmta structure
  */
 void
-wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx,
-		   const struct ether_addr *addr)
+wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx, const u8 *addr)
 {
 	d11regs_t *regs = wlc_hw->regs;
 	volatile u16 *objdata16 = (volatile u16 *)&regs->objdata;
@@ -1734,10 +1732,8 @@ wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx,
 	ASSERT(wlc_hw->corerev > 4);
 
 	mac_hm =
-	    (addr->octet[3] << 24) | (addr->octet[2] << 16) | (addr->
-							       octet[1] << 8) |
-	    addr->octet[0];
-	mac_l = (addr->octet[5] << 8) | addr->octet[4];
+	    (addr[3] << 24) | (addr[2] << 16) | (addr[1] << 8) |  addr[0];
+	mac_l = (addr[5] << 8) | addr[4];
 
 	osh = wlc_hw->osh;
 
@@ -1754,7 +1750,7 @@ wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx,
  */
 void
 wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw, int match_reg_offset,
-		       const struct ether_addr *addr)
+		       const u8 *addr)
 {
 	d11regs_t *regs;
 	u16 mac_l;
@@ -1767,9 +1763,9 @@ wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw, int match_reg_offset,
 	ASSERT((match_reg_offset < RCM_SIZE) || (wlc_hw->corerev == 4));
 
 	regs = wlc_hw->regs;
-	mac_l = addr->octet[0] | (addr->octet[1] << 8);
-	mac_m = addr->octet[2] | (addr->octet[3] << 8);
-	mac_h = addr->octet[4] | (addr->octet[5] << 8);
+	mac_l = addr[0] | (addr[1] << 8);
+	mac_m = addr[2] | (addr[3] << 8);
+	mac_h = addr[4] | (addr[5] << 8);
 
 	osh = wlc_hw->osh;
 
@@ -3042,7 +3038,7 @@ void wlc_intrsrestore(struct wlc_info *wlc, u32 macintmask)
 
 void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
 {
-	struct ether_addr null_ether_addr = { {0, 0, 0, 0, 0, 0} };
+	u8 null_ether_addr[] = {0, 0, 0, 0, 0, 0};
 
 	if (on) {
 		/* suspend tx fifos */
@@ -3053,7 +3049,7 @@ void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
 
 		/* zero the address match register so we do not send ACKs */
 		wlc_bmac_set_addrmatch(wlc_hw, RCM_MAC_OFFSET,
-				       &null_ether_addr);
+				       null_ether_addr);
 	} else {
 		/* resume tx fifos */
 		if (!wlc_hw->wlc->tx_suspended) {
@@ -3065,7 +3061,7 @@ void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
 
 		/* Restore address */
 		wlc_bmac_set_addrmatch(wlc_hw, RCM_MAC_OFFSET,
-				       &wlc_hw->etheraddr);
+				       wlc_hw->etheraddr);
 	}
 
 	wlc_phy_mute_upd(wlc_hw->band->pi, on, flags);
diff --git a/drivers/staging/brcm80211/sys/wlc_bmac.h b/drivers/staging/brcm80211/sys/wlc_bmac.h
index 98150aa..0461f50 100644
--- a/drivers/staging/brcm80211/sys/wlc_bmac.h
+++ b/drivers/staging/brcm80211/sys/wlc_bmac.h
@@ -201,12 +201,10 @@ extern void wlc_bmac_write_template_ram(struct wlc_hw_info *wlc_hw, int offset,
 extern void wlc_bmac_copyfrom_vars(struct wlc_hw_info *wlc_hw, char **buf,
 				   uint *len);
 
-extern void wlc_bmac_process_ps_switch(struct wlc_hw_info *wlc,
-				       struct ether_addr *ea, s8 ps_on);
-extern void wlc_bmac_hw_etheraddr(struct wlc_hw_info *wlc_hw,
-				  struct ether_addr *ea);
-extern void wlc_bmac_set_hw_etheraddr(struct wlc_hw_info *wlc_hw,
-				      struct ether_addr *ea);
+extern void wlc_bmac_process_ps_switch(struct wlc_hw_info *wlc, u8 *ea,
+				       s8 ps_on);
+extern void wlc_bmac_hw_etheraddr(struct wlc_hw_info *wlc_hw, u8 *ea);
+extern void wlc_bmac_set_hw_etheraddr(struct wlc_hw_info *wlc_hw, u8 *ea);
 extern bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw);
 
 extern bool wlc_bmac_radio_read_hwdisabled(struct wlc_hw_info *wlc_hw);
@@ -227,10 +225,10 @@ extern void wlc_ucode_wake_override_clear(struct wlc_hw_info *wlc_hw,
 					  u32 override_bit);
 
 extern void wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx,
-			       const struct ether_addr *addr);
+			       const u8 *addr);
 extern void wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw,
 				   int match_reg_offset,
-				   const struct ether_addr *addr);
+				   const u8 *addr);
 extern void wlc_bmac_write_hw_bcntemplates(struct wlc_hw_info *wlc_hw,
 					   void *bcn, int len, bool both);
 
diff --git a/drivers/staging/brcm80211/sys/wlc_bsscfg.h b/drivers/staging/brcm80211/sys/wlc_bsscfg.h
index d6a1971..b2a2aa7 100644
--- a/drivers/staging/brcm80211/sys/wlc_bsscfg.h
+++ b/drivers/staging/brcm80211/sys/wlc_bsscfg.h
@@ -71,7 +71,7 @@ struct wlc_bsscfg {
 	/* MAC filter */
 	uint nmac;		/* # of entries on maclist array */
 	int macmode;		/* allow/deny stations on maclist array */
-	struct ether_addr *maclist;	/* list of source MAC addrs to match */
+	u8 *maclist;	/* list of source MAC addrs to match */
 
 	/* security */
 	u32 wsec;		/* wireless security bitvec */
@@ -93,8 +93,8 @@ struct wlc_bsscfg {
 	u32 tk_cm_bt_tmstmp;	/* Timestamp when TKIP BT is activated */
 	bool tk_cm_activate;	/* activate countermeasures after EAPOL-Key sent */
 
-	struct ether_addr BSSID;	/* BSSID (associated) */
-	struct ether_addr cur_etheraddr;	/* h/w address */
+	u8 BSSID[ETH_ALEN];	/* BSSID (associated) */
+	u8 cur_etheraddr[ETH_ALEN];	/* h/w address */
 	u16 bcmc_fid;	/* the last BCMC FID queued to TX_BCMC_FIFO */
 	u16 bcmc_fid_shm;	/* the last BCMC FID written to shared mem */
 
diff --git a/drivers/staging/brcm80211/sys/wlc_key.h b/drivers/staging/brcm80211/sys/wlc_key.h
index 6678c69..3e23d51 100644
--- a/drivers/staging/brcm80211/sys/wlc_key.h
+++ b/drivers/staging/brcm80211/sys/wlc_key.h
@@ -87,7 +87,7 @@ typedef struct wsec_iv {
 #define WLC_NUMRXIVS	16	/* # rx IVs (one per 802.11e TID) */
 
 typedef struct wsec_key {
-	struct ether_addr ea;	/* per station */
+	u8 ea[ETH_ALEN];	/* per station */
 	u8 idx;		/* key index in wsec_keys array */
 	u8 id;		/* key ID [0-3] */
 	u8 algo;		/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index 0bf70fc..6af50ba 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -300,7 +300,7 @@ static int _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		      struct wlc_if *wlcif);
 
 #if defined(BCMDBG)
-void wlc_get_rcmta(struct wlc_info *wlc, int idx, struct ether_addr *addr)
+void wlc_get_rcmta(struct wlc_info *wlc, int idx, u8 *addr)
 {
 	d11regs_t *regs = wlc->regs;
 	u32 v32;
@@ -315,15 +315,15 @@ void wlc_get_rcmta(struct wlc_info *wlc, int idx, struct ether_addr *addr)
 	W_REG(osh, &regs->objaddr, (OBJADDR_RCMTA_SEL | (idx * 2)));
 	(void)R_REG(osh, &regs->objaddr);
 	v32 = R_REG(osh, &regs->objdata);
-	addr->octet[0] = (u8) v32;
-	addr->octet[1] = (u8) (v32 >> 8);
-	addr->octet[2] = (u8) (v32 >> 16);
-	addr->octet[3] = (u8) (v32 >> 24);
+	addr[0] = (u8) v32;
+	addr[1] = (u8) (v32 >> 8);
+	addr[2] = (u8) (v32 >> 16);
+	addr[3] = (u8) (v32 >> 24);
 	W_REG(osh, &regs->objaddr, (OBJADDR_RCMTA_SEL | ((idx * 2) + 1)));
 	(void)R_REG(osh, &regs->objaddr);
 	v32 = R_REG(osh, (volatile u16 *)&regs->objdata);
-	addr->octet[4] = (u8) v32;
-	addr->octet[5] = (u8) (v32 >> 8);
+	addr[4] = (u8) v32;
+	addr[5] = (u8) (v32 >> 8);
 }
 #endif				/* defined(BCMDBG) */
 
@@ -679,7 +679,7 @@ int wlc_set_mac(wlc_bsscfg_t *cfg)
 
 	if (cfg == wlc->cfg) {
 		/* enter the MAC addr into the RXE match registers */
-		wlc_set_addrmatch(wlc, RCM_MAC_OFFSET, &cfg->cur_etheraddr);
+		wlc_set_addrmatch(wlc, RCM_MAC_OFFSET, cfg->cur_etheraddr);
 	}
 
 	wlc_ampdu_macaddr_upd(wlc);
@@ -696,7 +696,7 @@ void wlc_set_bssid(wlc_bsscfg_t *cfg)
 
 	/* if primary config, we need to update BSSID in RXE match registers */
 	if (cfg == wlc->cfg) {
-		wlc_set_addrmatch(wlc, RCM_BSSID_OFFSET, &cfg->BSSID);
+		wlc_set_addrmatch(wlc, RCM_BSSID_OFFSET, cfg->BSSID);
 	}
 #ifdef SUPPORT_HWKEYS
 	else if (BSSCFG_STA(cfg) && cfg->BSS) {
@@ -1728,7 +1728,6 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	ASSERT(WSEC_MAX_DEFAULT_KEYS == WLC_DEFAULT_KEYS);
 
 	/* some code depends on packed structures */
-	ASSERT(sizeof(struct ether_addr) == ETH_ALEN);
 	ASSERT(sizeof(struct ethhdr) == ETH_HLEN);
 	ASSERT(sizeof(d11regs_t) == SI_CORE_SIZE);
 	ASSERT(sizeof(ofdm_phy_hdr_t) == D11_PHY_HDR_LEN);
@@ -1838,10 +1837,9 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 			wlc->core->txavail[i] = wlc->hw->txavail[i];
 	}
 
-	wlc_bmac_hw_etheraddr(wlc->hw, &wlc->perm_etheraddr);
+	wlc_bmac_hw_etheraddr(wlc->hw, wlc->perm_etheraddr);
 
-	bcopy((char *)&wlc->perm_etheraddr, (char *)&pub->cur_etheraddr,
-	      ETH_ALEN);
+	bcopy(wlc->perm_etheraddr, pub->cur_etheraddr, ETH_ALEN);
 
 	for (j = 0; j < NBANDS(wlc); j++) {
 		/* Use band 1 for single band 11a */
@@ -3602,8 +3600,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 				if (src_key->flags & WSEC_PRIMARY_KEY)
 					key.flags |= WL_PRIMARY_KEY;
 
-				bcopy(src_key->ea.octet, key.ea.octet,
-				      ETH_ALEN);
+				bcopy(src_key->ea, key.ea, ETH_ALEN);
 			}
 
 			bcopy((char *)&key, arg, sizeof(key));
@@ -3639,7 +3636,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 				u32 hi;
 				/* group keys in WPA-NONE (IBSS only, AES and TKIP) use a global TXIV */
 				if ((bsscfg->WPA_auth & WPA_AUTH_NONE) &&
-				    is_zero_ether_addr(key->ea.octet)) {
+				    is_zero_ether_addr(key->ea)) {
 					lo = bsscfg->wpa_none_txiv.lo;
 					hi = bsscfg->wpa_none_txiv.hi;
 				} else {
@@ -5811,7 +5808,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 			rspec[k] = WLC_RATE_1M;
 		} else {
 			if (WLANTSEL_ENAB(wlc) &&
-			    !is_multicast_ether_addr(h->a1.octet)) {
+			    !is_multicast_ether_addr(h->a1)) {
 				/* set tx antenna config */
 				wlc_antsel_antcfg_get(wlc->asi, false, false, 0,
 						      0, &antcfg, &fbantcfg);
@@ -5974,7 +5971,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 
 	/* DUR field for main rate */
 	if ((fc != FC_PS_POLL) &&
-	    !is_multicast_ether_addr(h->a1.octet) && !use_rifs) {
+	    !is_multicast_ether_addr(h->a1) && !use_rifs) {
 		durid =
 		    wlc_compute_frame_dur(wlc, rspec[0], preamble_type[0],
 					  next_frag_len);
@@ -5992,7 +5989,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	/* DUR field for fallback rate */
 	if (fc == FC_PS_POLL)
 		txh->FragDurFallback = h->durid;
-	else if (is_multicast_ether_addr(h->a1.octet) || use_rifs)
+	else if (is_multicast_ether_addr(h->a1) || use_rifs)
 		txh->FragDurFallback = 0;
 	else {
 		durid = wlc_compute_frame_dur(wlc, rspec[1],
@@ -6004,7 +6001,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	if (frag == 0)
 		mcl |= TXC_STARTMSDU;
 
-	if (!is_multicast_ether_addr(h->a1.octet))
+	if (!is_multicast_ether_addr(h->a1))
 		mcl |= TXC_IMMEDACK;
 
 	if (BAND_5G(wlc->band->bandtype))
@@ -6039,7 +6036,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	txh->TxFesTimeFallback = htol16(0);
 
 	/* TxFrameRA */
-	bcopy((char *)&h->a1, (char *)&txh->TxFrameRA, ETH_ALEN);
+	bcopy(h->a1, txh->TxFrameRA, ETH_ALEN);
 
 	/* TxFrameID */
 	txh->TxFrameID = htol16(frameid);
@@ -6233,7 +6230,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	if (SCB_WME(scb) && qos && wlc->edcf_txop[ac]) {
 		uint frag_dur, dur, dur_fallback;
 
-		ASSERT(!is_multicast_ether_addr(h->a1.octet));
+		ASSERT(!is_multicast_ether_addr(h->a1));
 
 		/* WME: Update TXOP threshold */
 		if ((!(tx_info->flags & IEEE80211_TX_CTL_AMPDU)) && (frag == 0)) {
@@ -7043,8 +7040,8 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	if (!is_amsdu) {
 		/* CTS and ACK CTL frames are w/o a2 */
 		if (FC_TYPE(fc) == FC_TYPE_DATA || FC_TYPE(fc) == FC_TYPE_MNG) {
-			if ((is_zero_ether_addr(h->a2.octet) ||
-			     is_multicast_ether_addr(h->a2.octet))) {
+			if ((is_zero_ether_addr(h->a2) ||
+			     is_multicast_ether_addr(h->a2))) {
 				WL_ERROR("wl%d: %s: dropping a frame with invalid src mac address, a2: %pM\n",
 					 wlc->pub->unit, __func__, &h->a2);
 				WLCNTINCR(wlc->pub->_cnt->rxbadsrcmac);
@@ -8222,13 +8219,12 @@ void wlc_write_hw_bcntemplates(struct wlc_info *wlc, void *bcn, int len,
 }
 
 void
-wlc_set_addrmatch(struct wlc_info *wlc, int match_reg_offset,
-		  const struct ether_addr *addr)
+wlc_set_addrmatch(struct wlc_info *wlc, int match_reg_offset, const u8 *addr)
 {
 	wlc_bmac_set_addrmatch(wlc->hw, match_reg_offset, addr);
 }
 
-void wlc_set_rcmta(struct wlc_info *wlc, int idx, const struct ether_addr *addr)
+void wlc_set_rcmta(struct wlc_info *wlc, int idx, const u8 *addr)
 {
 	wlc_bmac_set_rcmta(wlc->hw, idx, addr);
 }
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.h b/drivers/staging/brcm80211/sys/wlc_mac80211.h
index 5df996b..a9c907c 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.h
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.h
@@ -470,7 +470,7 @@ struct wlc_hw_info {
 	uint mac_suspend_depth;	/* current depth of mac_suspend levels */
 	u32 wake_override;	/* Various conditions to force MAC to WAKE mode */
 	u32 mute_override;	/* Prevent ucode from sending beacons */
-	struct ether_addr etheraddr;	/* currently configured ethernet address */
+	u8 etheraddr[ETH_ALEN];	/* currently configured ethernet address */
 	u32 led_gpio_mask;	/* LED GPIO Mask */
 	bool noreset;		/* true= do not reset hw, used by WLC_OUT */
 	bool forcefastclk;	/* true if the h/w is forcing the use of fast clk */
@@ -566,7 +566,7 @@ struct wlc_info {
 
 	u32 machwcap;	/* MAC capabilities, BMAC shadow */
 
-	struct ether_addr perm_etheraddr;	/* original sprom local ethernet address */
+	u8 perm_etheraddr[ETH_ALEN];	/* original sprom local ethernet address */
 
 	bool bandlocked;	/* disable auto multi-band switching */
 	bool bandinit_pending;	/* track band init in auto band */
@@ -835,13 +835,11 @@ extern void wlc_write_template_ram(struct wlc_info *wlc, int offset, int len,
 extern void wlc_write_hw_bcntemplates(struct wlc_info *wlc, void *bcn, int len,
 				      bool both);
 #if defined(BCMDBG)
-extern void wlc_get_rcmta(struct wlc_info *wlc, int idx,
-			  struct ether_addr *addr);
+extern void wlc_get_rcmta(struct wlc_info *wlc, int idx, u8 *addr);
 #endif
-extern void wlc_set_rcmta(struct wlc_info *wlc, int idx,
-			  const struct ether_addr *addr);
+extern void wlc_set_rcmta(struct wlc_info *wlc, int idx, const u8 *addr);
 extern void wlc_set_addrmatch(struct wlc_info *wlc, int match_reg_offset,
-			      const struct ether_addr *addr);
+			      const u8 *addr);
 extern void wlc_read_tsf(struct wlc_info *wlc, u32 *tsf_l_ptr,
 			 u32 *tsf_h_ptr);
 extern void wlc_set_cwmin(struct wlc_info *wlc, u16 newmin);
diff --git a/drivers/staging/brcm80211/sys/wlc_pub.h b/drivers/staging/brcm80211/sys/wlc_pub.h
index 146a690..c8f5cd8 100644
--- a/drivers/staging/brcm80211/sys/wlc_pub.h
+++ b/drivers/staging/brcm80211/sys/wlc_pub.h
@@ -154,7 +154,7 @@ typedef void *wlc_pkt_t;
 /* Event data type */
 typedef struct wlc_event {
 	wl_event_msg_t event;	/* encapsulated event */
-	struct ether_addr *addr;	/* used to keep a trace of the potential present of
+	u8 *addr;		/* used to keep a trace of the potential present of
 					 * an address in wlc_event_msg_t
 					 */
 	int bsscfgidx;		/* BSS config when needed */
@@ -165,7 +165,7 @@ typedef struct wlc_event {
 
 /* wlc internal bss_info, wl external one is in wlioctl.h */
 typedef struct wlc_bss_info {
-	struct ether_addr BSSID;	/* network BSSID */
+	u8 BSSID[ETH_ALEN];	/* network BSSID */
 	u16 flags;		/* flags for internal attributes */
 	u8 SSID_len;		/* the length of SSID */
 	u8 SSID[32];		/* SSID string */
@@ -291,9 +291,9 @@ struct wlc_pub {
 	s8 _coex;		/* 20/40 MHz BSS Management AUTO, ENAB, DISABLE */
 	bool _priofc;		/* Priority-based flowcontrol */
 
-	struct ether_addr cur_etheraddr;	/* our local ethernet address */
+	u8 cur_etheraddr[ETH_ALEN];	/* our local ethernet address */
 
-	struct ether_addr *multicast;	/* ptr to list of multicast addresses */
+	u8 *multicast;		/* ptr to list of multicast addresses */
 	uint nmulticast;	/* # enabled multicast addresses */
 
 	u32 wlfeatureflag;	/* Flags to control sw features from registry */
@@ -524,7 +524,7 @@ extern void wlc_statsupd(struct wlc_info *wlc);
 extern int wlc_get_header_len(void);
 extern void wlc_mac_bcn_promisc_change(struct wlc_info *wlc, bool promisc);
 extern void wlc_set_addrmatch(struct wlc_info *wlc, int match_reg_offset,
-			      const struct ether_addr *addr);
+			      const u8 *addr);
 extern void wlc_wme_setparams(struct wlc_info *wlc, u16 aci, void *arg,
 			      bool suspend);
 
diff --git a/drivers/staging/brcm80211/sys/wlc_scb.h b/drivers/staging/brcm80211/sys/wlc_scb.h
index fe84e99..142b756 100644
--- a/drivers/staging/brcm80211/sys/wlc_scb.h
+++ b/drivers/staging/brcm80211/sys/wlc_scb.h
@@ -58,7 +58,7 @@ struct scb {
 	u32 flags;		/* various bit flags as defined below */
 	u32 flags2;		/* various bit flags2 as defined below */
 	u8 state;		/* current state bitfield of auth/assoc process */
-	struct ether_addr ea;	/* station address */
+	u8 ea[ETH_ALEN];	/* station address */
 	void *fragbuf[NUMPRIO];	/* defragmentation buffer per prio */
 	uint fragresid[NUMPRIO];	/* #bytes unused in frag buffer per prio */
 
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index 19d4502..79038e0 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -1725,16 +1725,16 @@ static void _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, varbuf_t *b)
 			continue;
 
 		if (flags & SRFL_ETHADDR) {
-			struct ether_addr ea;
+			u8 ea[ETH_ALEN];
 
-			ea.octet[0] = (srom[srv->off - off] >> 8) & 0xff;
-			ea.octet[1] = srom[srv->off - off] & 0xff;
-			ea.octet[2] = (srom[srv->off + 1 - off] >> 8) & 0xff;
-			ea.octet[3] = srom[srv->off + 1 - off] & 0xff;
-			ea.octet[4] = (srom[srv->off + 2 - off] >> 8) & 0xff;
-			ea.octet[5] = srom[srv->off + 2 - off] & 0xff;
+			ea[0] = (srom[srv->off - off] >> 8) & 0xff;
+			ea[1] = srom[srv->off - off] & 0xff;
+			ea[2] = (srom[srv->off + 1 - off] >> 8) & 0xff;
+			ea[3] = srom[srv->off + 1 - off] & 0xff;
+			ea[4] = (srom[srv->off + 2 - off] >> 8) & 0xff;
+			ea[5] = srom[srv->off + 2 - off] & 0xff;
 
-			varbuf_append(b, "%s=%pM", name, ea.octet);
+			varbuf_append(b, "%s=%pM", name, ea);
 		} else {
 			ASSERT(mask_valid(srv->mask));
 			ASSERT(mask_width(srv->mask));
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index fd30cc6..caab133 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -348,12 +348,12 @@ struct sk_buff *BCMFASTPATH pktq_mdeq(struct pktq *pq, uint prec_bmp,
 }
 
 /* parse a xx:xx:xx:xx:xx:xx format ethernet address */
-int bcm_ether_atoe(char *p, struct ether_addr *ea)
+int bcm_ether_atoe(char *p, u8 *ea)
 {
 	int i = 0;
 
 	for (;;) {
-		ea->octet[i++] = (char)simple_strtoul(p, &p, 16);
+		ea[i++] = (char)simple_strtoul(p, &p, 16);
 		if (!*p++ || i == 6)
 			break;
 	}
-- 
1.5.6.5


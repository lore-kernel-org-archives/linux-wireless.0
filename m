Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1469 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 26/31] staging: brcm80211: replace occurrences of
 __attribute__((packed))
Date: Wed, 6 Jul 2011 00:02:53 +0200
Message-ID: <1309903378-29021-27-git-send-email-arend@broadcom.com> (sfid-20110706_000359_300292_A491E077)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One of the checkpatch warning on this driver is about usage of the
__attribute__ keyword. This patch changes this to using the __packed
keyword.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/d11.h  |   14 +++++++-------
 drivers/staging/brcm80211/brcmsmac/main.h |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index 70d3802..e7ff0e6 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -625,7 +625,7 @@ struct ofdm_phy_hdr {
 	u8 rlpt[3];		/* rate, length, parity, tail */
 	u16 service;
 	u8 pad;
-} __attribute__((packed));
+} __packed;
 
 #define	D11A_PHY_HDR_GRATE(phdr)	((phdr)->rlpt[0] & 0x0f)
 #define	D11A_PHY_HDR_GRES(phdr)		(((phdr)->rlpt[0] >> 4) & 0x01)
@@ -660,7 +660,7 @@ struct cck_phy_hdr {
 	u8 service;
 	u16 length;
 	u16 crc;
-} __attribute__((packed));
+} __packed;
 
 #define	D11B_PHY_HDR_LEN	6
 
@@ -735,7 +735,7 @@ struct d11txh {
 	u8 RTSPhyHeader[D11_PHY_HDR_LEN];	/* 0x2c - 0x2e */
 	struct ieee80211_rts rts_frame;	/* 0x2f - 0x36 */
 	u16 PAD;		/* 0x37 */
-} __attribute__((packed));
+} __packed;
 
 #define	D11_TXH_LEN		112	/* bytes */
 
@@ -852,7 +852,7 @@ struct tx_status {
 	u16 sequence;
 	u16 phyerr;
 	u16 ackphyrxsh;
-} __attribute__((packed));
+} __packed;
 
 #define	TXSTATUS_LEN	16
 
@@ -1245,7 +1245,7 @@ struct shm_acparams {
 	u16 reggap;
 	u16 status;
 	u16 rsvd[8];
-} __attribute__((packed));
+} __packed;
 #define M_EDCF_QLEN	(16 * 2)
 
 #define WME_STATUS_NEWAC	(1 << 8)
@@ -1306,7 +1306,7 @@ struct d11rxhdr {
 	u16 RxStatus2;	/* extended MAC Rx status */
 	u16 RxTSFTime;	/* RxTSFTime time of first MAC symbol + M_PHY_PLCPRX_DLY */
 	u16 RxChan;		/* gain code, channel radio code, and phy type */
-} __attribute__((packed));
+} __packed;
 
 #define	RXHDR_LEN		24	/* sizeof struct d11rxhdr */
 #define	FRAMELEN(h)		((h)->RxFrameSize)
@@ -1319,7 +1319,7 @@ struct brcms_d11rxhdr {
 	s8 rxpwr1;		/* obsoleted, place holder for legacy ROM code. use rxpwr[] */
 	s8 do_rssi_ma;	/* do per-pkt sampling for per-antenna ma in HIGH */
 	s8 rxpwr[WL_RSSI_ANT_MAX];	/* rssi for supported antennas */
-} __attribute__((packed));
+} __packed;
 
 /* PhyRxStatus_0: */
 #define	PRXS0_FT_MASK		0x0003	/* NPHY only: CCK, OFDM, preN, N */
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 2d0a567..f204b1f 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -438,7 +438,7 @@ struct edcf_acparam {
 	u8 ACI;
 	u8 ECW;
 	u16 TXOP;
-} __attribute__((packed));
+} __packed;
 
 struct wme_param_ie {
 	u8 oui[3];
@@ -448,7 +448,7 @@ struct wme_param_ie {
 	u8 qosinfo;
 	u8 rsvd;
 	struct edcf_acparam acparam[AC_COUNT];
-} __attribute__((packed));
+} __packed;
 
 /* virtual interface */
 struct brcms_c_if {
-- 
1.7.4.1



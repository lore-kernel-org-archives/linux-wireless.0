Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53193 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab1BMOk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 09:40:59 -0500
Received: by mail-bw0-f46.google.com with SMTP id 15so4702333bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 06:40:58 -0800 (PST)
From: Stanislav Fomichev <kernel@fomichev.me>
To: linux-wireless@vger.kernel.org
Cc: brudley@broadcom.com, gregkh@suse.de
Subject: [PATCH 3/8] brcm80211: replace dot11_management_header with ieee80211_mgmt
Date: Sun, 13 Feb 2011 17:40:38 +0300
Message-Id: <1297608043-18381-3-git-send-email-kernel@fomichev.me>
In-Reply-To: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
References: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
---
 drivers/staging/brcm80211/include/proto/802.11.h |    8 --------
 drivers/staging/brcm80211/sys/wlc_mac80211.c     |   16 ++++++++--------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/brcm80211/include/proto/802.11.h b/drivers/staging/brcm80211/include/proto/802.11.h
index db4328d..11f7987 100644
--- a/drivers/staging/brcm80211/include/proto/802.11.h
+++ b/drivers/staging/brcm80211/include/proto/802.11.h
@@ -52,14 +52,6 @@
 #define DOT11_BA_BITMAP_LEN		128
 #define DOT11_BA_LEN		4
 
-BWL_PRE_PACKED_STRUCT struct dot11_management_header {
-	u16 fc;
-	u16 durid;
-	struct ether_addr da;
-	struct ether_addr sa;
-	struct ether_addr bssid;
-	u16 seq;
-} BWL_POST_PACKED_STRUCT;
 #define	DOT11_MGMT_HDR_LEN	24
 
 BWL_PRE_PACKED_STRUCT struct dot11_bcn_prb {
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index 391e958..ddaa515 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -1737,7 +1737,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	ASSERT(sizeof(d11rxhdr_t) == RXHDR_LEN);
 	ASSERT(sizeof(struct ieee80211_hdr) == DOT11_A4_HDR_LEN);
 	ASSERT(sizeof(struct ieee80211_rts) == DOT11_RTS_LEN);
-	ASSERT(sizeof(struct dot11_management_header) == DOT11_MGMT_HDR_LEN);
+	ASSERT(IEEE80211_MIN_ACTION_SIZE - 1 == DOT11_MGMT_HDR_LEN);
 	ASSERT(sizeof(struct dot11_bcn_prb) == DOT11_BCN_PRB_LEN);
 	ASSERT(sizeof(tx_status_t) == TXSTATUS_LEN);
 	ASSERT(sizeof(ht_cap_ie_t) == HT_CAP_IE_LEN);
@@ -7614,7 +7614,7 @@ wlc_bcn_prb_template(struct wlc_info *wlc, uint type, ratespec_t bcn_rspec,
 		     wlc_bsscfg_t *cfg, u16 *buf, int *len)
 {
 	cck_phy_hdr_t *plcp;
-	struct dot11_management_header *h;
+	struct ieee80211_mgmt *h;
 	int hdr_len, body_len;
 
 	ASSERT(*len >= 142);
@@ -7647,20 +7647,20 @@ wlc_bcn_prb_template(struct wlc_info *wlc, uint type, ratespec_t bcn_rspec,
 		wlc_beacon_phytxctl_txant_upd(wlc, bcn_rspec);
 
 	if (MBSS_BCN_ENAB(cfg) && type == FC_BEACON)
-		h = (struct dot11_management_header *)&plcp[0];
+		h = (struct ieee80211_mgmt *)&plcp[0];
 	else
-		h = (struct dot11_management_header *)&plcp[1];
+		h = (struct ieee80211_mgmt *)&plcp[1];
 
 	/* fill in 802.11 header */
-	h->fc = htol16((u16) type);
+	h->frame_control = cpu_to_le16((u16) type);
 
 	/* DUR is 0 for multicast bcn, or filled in by MAC for prb resp */
 	/* A1 filled in by MAC for prb resp, broadcast for bcn */
 	if (type == FC_BEACON)
-		bcopy((const char *)&ether_bcast, (char *)&h->da,
+		bcopy((const char *)&ether_bcast, h->da,
 		      ETH_ALEN);
-	bcopy((char *)&cfg->cur_etheraddr, (char *)&h->sa, ETH_ALEN);
-	bcopy((char *)&cfg->BSSID, (char *)&h->bssid, ETH_ALEN);
+	bcopy((char *)&cfg->cur_etheraddr, h->sa, ETH_ALEN);
+	bcopy((char *)&cfg->BSSID, h->bssid, ETH_ALEN);
 
 	/* SEQ filled in by MAC */
 
-- 
1.7.1


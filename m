Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1633 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759491Ab1KWBWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:11 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/24] brcm80211: smac: added support for mac80211
 filter flags
Date: Tue, 22 Nov 2011 17:21:43 -0800
Message-ID: <1322011319-24863-9-git-send-email-frankyl@broadcom.com> (sfid-20111123_022256_142366_ED27B07B)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Added support for handling FIF_PROMISC_IN_BSS, FIF_FCSFAIL,
FIF_CONTROL, FIF_OTHER_BSS and FIF_PSPOLL.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   38 +++++++---------
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   45 ++++++++-----------
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |    6 +--
 3 files changed, 38 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index ba3e4b5..76376eb 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -40,10 +40,10 @@
 #define MAC_FILTERS (FIF_PROMISC_IN_BSS | \
 	FIF_ALLMULTI | \
 	FIF_FCSFAIL | \
-	FIF_PLCPFAIL | \
 	FIF_CONTROL | \
 	FIF_OTHER_BSS | \
-	FIF_BCN_PRBRESP_PROMISC)
+	FIF_BCN_PRBRESP_PROMISC | \
+	FIF_PSPOLL)
 
 #define CHAN2GHZ(channel, freqency, chflags)  { \
 	.band = IEEE80211_BAND_2GHZ, \
@@ -373,7 +373,7 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 						   conf->listen_interval);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
-		wiphy_err(wiphy, "%s: change monitor mode: %s (implement)\n",
+		wiphy_dbg(wiphy, "%s: change monitor mode: %s\n",
 			  __func__, conf->flags & IEEE80211_CONF_MONITOR ?
 			  "true" : "false");
 	if (changed & IEEE80211_CONF_CHANGE_PS)
@@ -550,29 +550,25 @@ brcms_ops_configure_filter(struct ieee80211_hw *hw,
 
 	changed_flags &= MAC_FILTERS;
 	*total_flags &= MAC_FILTERS;
+
 	if (changed_flags & FIF_PROMISC_IN_BSS)
-		wiphy_err(wiphy, "FIF_PROMISC_IN_BSS\n");
+		wiphy_dbg(wiphy, "FIF_PROMISC_IN_BSS\n");
 	if (changed_flags & FIF_ALLMULTI)
-		wiphy_err(wiphy, "FIF_ALLMULTI\n");
+		wiphy_dbg(wiphy, "FIF_ALLMULTI\n");
 	if (changed_flags & FIF_FCSFAIL)
-		wiphy_err(wiphy, "FIF_FCSFAIL\n");
-	if (changed_flags & FIF_PLCPFAIL)
-		wiphy_err(wiphy, "FIF_PLCPFAIL\n");
+		wiphy_dbg(wiphy, "FIF_FCSFAIL\n");
 	if (changed_flags & FIF_CONTROL)
-		wiphy_err(wiphy, "FIF_CONTROL\n");
+		wiphy_dbg(wiphy, "FIF_CONTROL\n");
 	if (changed_flags & FIF_OTHER_BSS)
-		wiphy_err(wiphy, "FIF_OTHER_BSS\n");
-	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		spin_lock_bh(&wl->lock);
-		if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
-			wl->pub->mac80211_state |= MAC80211_PROMISC_BCNS;
-			brcms_c_mac_bcn_promisc_change(wl->wlc, 1);
-		} else {
-			brcms_c_mac_bcn_promisc_change(wl->wlc, 0);
-			wl->pub->mac80211_state &= ~MAC80211_PROMISC_BCNS;
-		}
-		spin_unlock_bh(&wl->lock);
-	}
+		wiphy_dbg(wiphy, "FIF_OTHER_BSS\n");
+	if (changed_flags & FIF_PSPOLL)
+		wiphy_dbg(wiphy, "FIF_PSPOLL\n");
+	if (changed_flags & FIF_BCN_PRBRESP_PROMISC)
+		wiphy_dbg(wiphy, "FIF_BCN_PRBRESP_PROMISC\n");
+
+	spin_lock_bh(&wl->lock);
+	brcms_c_mac_promisc(wl->wlc, *total_flags);
+	spin_unlock_bh(&wl->lock);
 	return;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 897e252..87f8f5d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3062,7 +3062,7 @@ static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 		return false;
 
 	/* disallow PS when one of these meets when not scanning */
-	if (wlc->monitor)
+	if (wlc->filter_flags & FIF_PROMISC_IN_BSS)
 		return false;
 
 	if (cfg->associated) {
@@ -3582,29 +3582,31 @@ static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 }
 
 /*
- * Set or clear maccontrol bits MCTL_PROMISC, MCTL_BCNS_PROMISC and
- * MCTL_KEEPCONTROL
+ * Set or clear filtering related maccontrol bits based on
+ * specified filter flags
  */
-static void brcms_c_mac_promisc(struct brcms_c_info *wlc)
+void brcms_c_mac_promisc(struct brcms_c_info *wlc, uint filter_flags)
 {
 	u32 promisc_bits = 0;
 
-	if (wlc->bcnmisc_monitor)
+	wlc->filter_flags = filter_flags;
+
+	if (filter_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS))
+		promisc_bits |= MCTL_PROMISC;
+
+	if (filter_flags & FIF_BCN_PRBRESP_PROMISC)
 		promisc_bits |= MCTL_BCNS_PROMISC;
 
-	if (wlc->monitor)
-		promisc_bits |=
-			MCTL_PROMISC | MCTL_BCNS_PROMISC | MCTL_KEEPCONTROL;
+	if (filter_flags & FIF_FCSFAIL)
+		promisc_bits |= MCTL_KEEPBADFCS;
 
-	brcms_b_mctrl(wlc->hw,
-			MCTL_PROMISC | MCTL_BCNS_PROMISC | MCTL_KEEPCONTROL,
-			promisc_bits);
-}
+	if (filter_flags & (FIF_CONTROL | FIF_PSPOLL))
+		promisc_bits |= MCTL_KEEPCONTROL;
 
-void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc, bool promisc)
-{
-	wlc->bcnmisc_monitor = promisc;
-	brcms_c_mac_promisc(wlc);
+	brcms_b_mctrl(wlc->hw,
+		MCTL_PROMISC | MCTL_BCNS_PROMISC |
+		MCTL_KEEPCONTROL | MCTL_KEEPBADFCS,
+		promisc_bits);
 }
 
 /*
@@ -3634,9 +3636,6 @@ static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
 	} else {
 		/* disable an active IBSS if we are not on the home channel */
 	}
-
-	/* update the various promisc bits */
-	brcms_c_mac_promisc(wlc);
 }
 
 static void brcms_c_write_rate_shm(struct brcms_c_info *wlc, u8 rate,
@@ -8072,14 +8071,8 @@ static void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 	len = p->len;
 
 	if (rxh->RxStatus1 & RXS_FCSERR) {
-		if (wlc->pub->mac80211_state & MAC80211_PROMISC_BCNS) {
-			wiphy_err(wlc->wiphy, "FCSERR while scanning******* -"
-				  " tossing\n");
+		if (!(wlc->filter_flags & FIF_FCSFAIL))
 			goto toss;
-		} else {
-			wiphy_err(wlc->wiphy, "RCSERR!!!\n");
-			goto toss;
-		}
 	}
 
 	/* check received pkt has at least frame control field */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index 251c350..e2de97d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -519,8 +519,7 @@ struct brcms_c_info {
 	struct brcms_timer *radio_timer;
 
 	/* promiscuous */
-	bool monitor;
-	bool bcnmisc_monitor;
+	uint filter_flags;
 
 	/* driver feature */
 	bool _rifs;
@@ -658,8 +657,7 @@ extern void brcms_c_print_txdesc(struct d11txh *txh);
 #endif
 
 extern int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config);
-extern void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc,
-					   bool promisc);
+extern void brcms_c_mac_promisc(struct brcms_c_info *wlc, uint filter_flags);
 extern void brcms_c_send_q(struct brcms_c_info *wlc);
 extern int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu,
 			    uint *fifo);
-- 
1.7.5.4



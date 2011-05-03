Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1625 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab1ECJgS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 14/61] staging: brcm80211: honour basic rate
 configuration from mac80211
Date: Tue, 3 May 2011 11:35:14 +0200
Message-ID: <1304415361-7813-15-git-send-email-arend@broadcom.com> (sfid-20110503_113802_117036_88B78F0F)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The basic rates to be used are provided by the wireless access point
within the beacon information. The station should conform to those
rates and this information is passed by mac80211 to the driver. The
patch processes the information and applies the basic rates accor-
dingly. This is required functionality for mac80211 drivers.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   50 +++++++++++++++++++++-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c    |   11 ++++-
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h     |    5 ++
 drivers/staging/brcm80211/brcmsmac/wlc_rate.h    |    8 +---
 4 files changed, 63 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 0faf105..770ff93 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -83,6 +83,7 @@ static int __devinit wl_pci_probe(struct pci_dev *pdev,
 				  const struct pci_device_id *ent);
 static void wl_remove(struct pci_dev *pdev);
 static void wl_free(struct wl_info *wl);
+static void wl_set_basic_rate(struct wl_rateset *rs, u16 rate, bool is_br);
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver.");
@@ -367,9 +368,37 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 			mode & IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT);
 	}
 	if (changed & BSS_CHANGED_BASIC_RATES) {
+		struct ieee80211_supported_band *bi;
+		u32 br_mask, i;
+		u16 rate;
+		struct wl_rateset rs;
+		int error;
+
 		/* Basic rateset changed */
-		wiphy_err(wiphy, "%s: Need to change Basic Rates: 0x%x"
-			  " (implement)\n", __func__, (u32) info->basic_rates);
+		no_printk("%s: change basic rates: 0x%x\n",
+			 __func__, (u32) info->basic_rates);
+
+		/* retrieve the current rates */
+		error = wlc_ioctl(wl->wlc, WLC_GET_CURR_RATESET,
+				  &rs, sizeof(rs), NULL);
+		if (error) {
+			wiphy_err(wiphy, "%s: retrieve rateset failed: %d\n",
+				  __func__, error);
+			return;
+		}
+		br_mask = info->basic_rates;
+		bi = hw->wiphy->bands[wlc_get_curband(wl->wlc)];
+		for (i = 0; i < bi->n_bitrates; i++) {
+			/* convert to internal rate value */
+			rate = (bi->bitrates[i].bitrate << 1) / 10;
+
+			/* set/clear basic rate flag */
+			wl_set_basic_rate(&rs, rate, br_mask & 1);
+			br_mask >>= 1;
+		}
+
+		/* update the rate set */
+		wlc_ioctl(wl->wlc, WLC_SET_RATESET, &rs, sizeof(rs), NULL);
 	}
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		/* Beacon interval changed */
@@ -1355,6 +1384,23 @@ static void wl_free(struct wl_info *wl)
 	wl->regsva = NULL;
 }
 
+/* flags the given rate in rateset as requested */
+static void wl_set_basic_rate(struct wl_rateset *rs, u16 rate, bool is_br)
+{
+	u32 i;
+
+	for (i = 0; i < rs->count; i++) {
+		if (rate != (rs->rates[i] & 0x7f))
+			continue;
+
+		if (is_br)
+			rs->rates[i] |= WLC_RATE_FLAG;
+		else
+			rs->rates[i] &= WLC_RATE_MASK;
+		return;
+	}
+}
+
 /*
  * precondition: perimeter lock has been acquired
  */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 05ce854..aa0a23c 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -3006,8 +3006,8 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	wlc_bss_info_t *current_bss;
 
 	/* update bsscfg pointer */
-	bsscfg = NULL;		/* XXX: Hack bsscfg to be size one and use this globally */
-	current_bss = NULL;
+	bsscfg = wlc->cfg;
+	current_bss = bsscfg->current_bss;
 
 	/* initialize the following to get rid of compiler warning */
 	nextscb = NULL;
@@ -3582,7 +3582,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			wl_rateset_t *ret_rs = (wl_rateset_t *) arg;
 			wlc_rateset_t *rs;
 
-			if (bsscfg->associated)
+			if (wlc->pub->associated)
 				rs = &current_bss->rateset;
 			else
 				rs = &wlc->default_bss->rateset;
@@ -8451,3 +8451,8 @@ void wlc_inval_dma_pkts(struct wlc_hw_info *hw,
 			dma_walk_packets(dmah, dma_callback_fn, sta);
 	}
 }
+
+int wlc_get_curband(struct wlc_info *wlc)
+{
+	return wlc->band->bandunit;
+}
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index 2b51440..08e5fb5 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -59,6 +59,10 @@
  */
 #define WLC_TXPWR_MAX		(127)	/* ~32 dBm = 1,500 mW */
 
+/* rate related definitions */
+#define	WLC_RATE_FLAG	0x80	/* Flag to indicate it is a basic rate */
+#define	WLC_RATE_MASK	0x7f	/* Rate value mask w/o basic rate flag */
+
 /* legacy rx Antenna diversity for SISO rates */
 #define	ANT_RX_DIV_FORCE_0		0	/* Use antenna 0 */
 #define	ANT_RX_DIV_FORCE_1		1	/* Use antenna 1 */
@@ -564,6 +568,7 @@ extern void wlc_enable_mac(struct wlc_info *wlc);
 extern void wlc_associate_upd(struct wlc_info *wlc, bool state);
 extern void wlc_scan_start(struct wlc_info *wlc);
 extern void wlc_scan_stop(struct wlc_info *wlc);
+extern int wlc_get_curband(struct wlc_info *wlc);
 
 static inline int wlc_iovar_getuint(struct wlc_info *wlc, const char *name,
 				    uint *arg)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_rate.h b/drivers/staging/brcm80211/brcmsmac/wlc_rate.h
index f406a79..5575e83 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_rate.h
@@ -54,12 +54,8 @@ extern const mcs_info_t mcs_table[];
 	(_is40 ? mcs_table[_mcs].phy_rate_40 : mcs_table[_mcs].phy_rate_20))
 #define VALID_MCS(_mcs)	((_mcs < MCS_TABLE_SIZE))
 
-/* rate related definitions */
-#define	WLC_RATE_FLAG	0x80	/* Rate flag to indicate it is a basic rate */
-#define	WLC_RATE_MASK	0x7f	/* Rate value mask w/o basic rate flag */
-
-/* Macro to use in the rate_info table */
-#define	WLC_RATE_MASK_FULL	0xff /* Rate value mask with basic rate flag */
+/* Macro to use the rate_info table */
+#define	WLC_RATE_MASK_FULL 0xff	/* Rate value mask with basic rate flag */
 
 #define WLC_RATE_500K_TO_BPS(rate)	((rate) * 500000)	/* convert 500kbps to bps */
 
-- 
1.7.4.1



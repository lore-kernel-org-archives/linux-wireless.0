Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4244 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411Ab1GNVaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:30:02 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 15/35] staging: brcm80211: replaced typedef wl_rateset_t
 by struct brcm_rateset
Date: Thu, 14 Jul 2011 14:29:11 -0700
Message-ID: <1310678971-28952-16-git-send-email-frankyl@broadcom.com> (sfid-20110714_233118_460256_725B27C8)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    7 ++++---
 drivers/staging/brcm80211/brcmsmac/main.c        |    6 ++++--
 drivers/staging/brcm80211/include/defs.h         |    4 ++--
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index a9494e7..e9ccf06 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2025,7 +2025,7 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 			     const u8 *addr,
 			     const struct cfg80211_bitrate_mask *mask)
 {
-	struct wl_rateset rateset;
+	struct brcm_rateset rateset;
 	s32 rate;
 	s32 val;
 	s32 err_bg;
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 84245b9..ccbd9d7 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -84,7 +84,8 @@ static int __devinit brcms_pci_probe(struct pci_dev *pdev,
 				  const struct pci_device_id *ent);
 static void brcms_remove(struct pci_dev *pdev);
 static void brcms_free(struct brcms_info *wl);
-static void brcms_set_basic_rate(struct wl_rateset *rs, u16 rate, bool is_br);
+static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate,
+				 bool is_br);
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver.");
@@ -376,7 +377,7 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		struct ieee80211_supported_band *bi;
 		u32 br_mask, i;
 		u16 rate;
-		struct wl_rateset rs;
+		struct brcm_rateset rs;
 		int error;
 
 		/* retrieve the current rates */
@@ -1373,7 +1374,7 @@ static void brcms_free(struct brcms_info *wl)
 }
 
 /* flags the given rate in rateset as requested */
-static void brcms_set_basic_rate(struct wl_rateset *rs, u16 rate, bool is_br)
+static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate, bool is_br)
 {
 	u32 i;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 038115b..c96f43a 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -6134,7 +6134,8 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 		break;
 
 	case BRCM_GET_CURR_RATESET:{
-			wl_rateset_t *ret_rs = (wl_rateset_t *) arg;
+			struct brcm_rateset *ret_rs =
+						(struct brcm_rateset *) arg;
 			struct brcms_c_rateset *rs;
 
 			if (wlc->pub->associated)
@@ -6155,7 +6156,8 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 
 	case BRCM_SET_RATESET:{
 			struct brcms_c_rateset rs;
-			wl_rateset_t *in_rs = (wl_rateset_t *) arg;
+			struct brcm_rateset *in_rs =
+						(struct brcm_rateset *) arg;
 
 			if (len < (int)(in_rs->count + sizeof(in_rs->count))) {
 				bcmerror = -EOVERFLOW;
diff --git a/drivers/staging/brcm80211/include/defs.h b/drivers/staging/brcm80211/include/defs.h
index 8b3e17d..838424c 100644
--- a/drivers/staging/brcm80211/include/defs.h
+++ b/drivers/staging/brcm80211/include/defs.h
@@ -54,10 +54,10 @@
 
 #define WL_NUMRATES		16	/* max # of rates in a rateset */
 
-typedef struct wl_rateset {
+struct brcm_rateset {
 	u32 count;		/* # rates in this set */
 	u8 rates[WL_NUMRATES];	/* rates in 500kbps units w/hi bit set if basic */
-} wl_rateset_t;
+};
 
 #define BRCM_CNTRY_BUF_SZ	4	/* Country string is 3 bytes + NUL */
 
-- 
1.7.1



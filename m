Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3501 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab1IPT20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:26 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 12/19] staging: brcm80211: fixed sparse endianness
 warnings on fullmac ratespec
Date: Fri, 16 Sep 2011 12:28:01 -0700
Message-ID: <1316201288-29635-13-git-send-email-frankyl@broadcom.com> (sfid-20110916_212853_425375_53B70056)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Structure that is sent to the dongle has been annotated.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    7 +++++++
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   12 +++++-------
 drivers/staging/brcm80211/brcmsmac/pub.h         |    7 +++++++
 drivers/staging/brcm80211/include/defs.h         |    7 -------
 4 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index af0ad1f..e543640 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -400,6 +400,13 @@ struct brcmf_bss_info {
 	/* variable length Information Elements */
 };
 
+struct brcm_rateset_le {
+	/* # rates in this set */
+	__le32 count;
+	/* rates in 500kbps units w/hi bit set if basic */
+	u8 rates[WL_NUMRATES];
+};
+
 struct brcmf_ssid {
 	u32 SSID_len;
 	unsigned char SSID[32];
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 3b0c1a3..6ac4cc7 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1864,7 +1864,7 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 			     const u8 *addr,
 			     const struct cfg80211_bitrate_mask *mask)
 {
-	struct brcm_rateset rateset;
+	struct brcm_rateset_le rateset_le;
 	s32 rate;
 	s32 val;
 	s32 err_bg;
@@ -1878,15 +1878,13 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 
 	/* addr param is always NULL. ignore it */
 	/* Get current rateset */
-	err = brcmf_dev_ioctl(dev, BRCM_GET_CURR_RATESET, &rateset,
-			sizeof(rateset));
+	err = brcmf_dev_ioctl(dev, BRCM_GET_CURR_RATESET, &rateset_le,
+			      sizeof(rateset_le));
 	if (unlikely(err)) {
 		WL_ERR("could not get current rateset (%d)\n", err);
 		goto done;
 	}
 
-	rateset.count = le32_to_cpu(rateset.count);
-
 	legacy = ffs(mask->control[IEEE80211_BAND_2GHZ].legacy & 0xFFFF);
 	if (!legacy)
 		legacy = ffs(mask->control[IEEE80211_BAND_5GHZ].legacy &
@@ -1894,9 +1892,9 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 
 	val = wl_g_rates[legacy - 1].bitrate * 100000;
 
-	if (val < rateset.count)
+	if (val < le32_to_cpu(rateset_le.count))
 		/* Select rate by rateset index */
-		rate = rateset.rates[val] & 0x7f;
+		rate = rateset_le.rates[val] & 0x7f;
 	else
 		/* Specified rate in bps */
 		rate = val / 500000;
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index c72f7b5..9670309 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -101,6 +101,13 @@
 
 #define MAX_STREAMS_SUPPORTED	4	/* max number of streams supported */
 
+struct brcm_rateset {
+	/* # rates in this set */
+	u32 count;
+	/* rates in 500kbps units w/hi bit set if basic */
+	u8 rates[WL_NUMRATES];
+};
+
 struct brcms_c_rateset {
 	uint count;		/* number of rates in rates[] */
 	 /* rates in 500kbps units w/hi bit set if basic */
diff --git a/drivers/staging/brcm80211/include/defs.h b/drivers/staging/brcm80211/include/defs.h
index 3438c54..1e5f310 100644
--- a/drivers/staging/brcm80211/include/defs.h
+++ b/drivers/staging/brcm80211/include/defs.h
@@ -48,13 +48,6 @@
 
 #define WL_NUMRATES		16	/* max # of rates in a rateset */
 
-struct brcm_rateset {
-	/* # rates in this set */
-	u32 count;
-	/* rates in 500kbps units w/hi bit set if basic */
-	u8 rates[WL_NUMRATES];
-};
-
 #define BRCM_CNTRY_BUF_SZ	4	/* Country string is 3 bytes + NUL */
 
 #define BRCM_SET_CHANNEL	30
-- 
1.7.1



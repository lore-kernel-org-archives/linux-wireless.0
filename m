Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2101 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab1HWMOU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 08:14:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 8/8] staging: brcm80211: fill in proper rx rate in
 mac80211 rx status
Date: Tue, 23 Aug 2011 14:14:00 +0200
Message-ID: <1314101640-4229-9-git-send-email-arend@broadcom.com> (sfid-20110823_141431_878264_14583AC6)
In-Reply-To: <1314101640-4229-1-git-send-email-arend@broadcom.com>
References: <1314101640-4229-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcmsmac driver supports different rates on 5GHz but this is not
taken into account when providing the rate index in the receive
status information passed to mac80211.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    9 +++++++--
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    6 ++++++
 drivers/staging/brcm80211/brcmsmac/main.c        |    8 ++++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 7179edd..2370171 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -971,6 +971,10 @@ static struct ieee80211_channel brcms_5ghz_nphy_chantable[] = {
 	.hw_value = (rate100m / 5), \
 }
 
+/*
+ * The rate table is used for both 2.4G and 5G rates. The
+ * latter being a subset as it does not support CCK rates.
+ */
 static struct ieee80211_rate legacy_ratetable[] = {
 	RATE(10, 0),
 	RATE(20, IEEE80211_RATE_SHORT_PREAMBLE),
@@ -1012,8 +1016,9 @@ static struct ieee80211_supported_band brcms_band_5GHz_nphy = {
 	.band = IEEE80211_BAND_5GHZ,
 	.channels = brcms_5ghz_nphy_chantable,
 	.n_channels = ARRAY_SIZE(brcms_5ghz_nphy_chantable),
-	.bitrates = legacy_ratetable + 4,
-	.n_bitrates = ARRAY_SIZE(legacy_ratetable) - 4,
+	.bitrates = legacy_ratetable + BRCMS_LEGACY_5G_RATE_OFFSET,
+	.n_bitrates = ARRAY_SIZE(legacy_ratetable) -
+			BRCMS_LEGACY_5G_RATE_OFFSET,
 	.ht_cap = {
 		   .cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20 |
 			  IEEE80211_HT_CAP_SGI_40 |
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index fcd711a..7f290d7 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -20,6 +20,12 @@
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 
+/*
+ * Starting index for 5G rates in the
+ * legacy rate table.
+ */
+#define BRCMS_LEGACY_5G_RATE_OFFSET	4
+
 /* softmac ioctl definitions */
 #define BRCMS_SET_SHORTSLOT_OVERRIDE		146
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 7e729d29..339ab28 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -8252,6 +8252,14 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 			wiphy_err(wlc->wiphy, "%s: Unknown rate\n", __func__);
 		}
 
+		/*
+		 * For 5GHz, we should decrease the index as it is
+		 * a subset of the 2.4G rates. See bitrates field
+		 * of brcms_band_5GHz_nphy (in mac80211_if.c).
+		 */
+		if (rx_status->band == IEEE80211_BAND_5GHZ)
+			rx_status->rate_idx -= BRCMS_LEGACY_5G_RATE_OFFSET;
+
 		/* Determine short preamble and rate_idx */
 		preamble = 0;
 		if (IS_CCK(rspec)) {
-- 
1.7.4.1



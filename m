Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2440 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569Ab2GCSqa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 14:46:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Vladimir Kondratiev" <qca_vkondrat@qca.qualcomm.com>,
	"Johannes Berg" <johannes.berg@intel.com>
Subject: [PATCH] brcmsmac: fix brcms_c_regd_init() which crashed after
 11ad patch
Date: Tue, 3 Jul 2012 20:46:02 +0200
Message-ID: <1341341162-2709-1-git-send-email-arend@broadcom.com> (sfid-20120703_204637_485798_4E1F76E1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes an OOPS in brcmsmac driver, which was introduced
by the 11ad patch 'cfg80211: add 802.11ad (60gHz band) support'.
The value IEEE80211_NUM_BANDS increased, which was used in the
brcms_c_regd_init() function.

Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Acked-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 2d365d3..9a4c63f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -763,20 +763,17 @@ void brcms_c_regd_init(struct brcms_c_info *wlc)
 	int band_idx, i;
 
 	/* Disable any channels not supported by the phy */
-	for (band_idx = 0; band_idx < IEEE80211_NUM_BANDS; band_idx++) {
-		if (band_idx == IEEE80211_BAND_2GHZ)
-			band = wlc->bandstate[BAND_2G_INDEX];
-		else
-			band = wlc->bandstate[BAND_5G_INDEX];
-
-		/* skip if band not initialized */
-		if (band->pi == NULL)
-			continue;
+	for (band_idx = 0; band_idx < wlc->pub->_nbands; band_idx++) {
+		band = wlc->bandstate[band_idx];
 
 		wlc_phy_chanspec_band_validch(band->pi, band->bandtype,
 					      &sup_chan);
 
-		sband = wiphy->bands[band_idx];
+		if (band_idx == BAND_2G_INDEX)
+			sband = wiphy->bands[IEEE80211_BAND_2GHZ];
+		else
+			sband = wiphy->bands[IEEE80211_BAND_5GHZ];
+
 		for (i = 0; i < sband->n_channels; i++) {
 			ch = &sband->channels[i];
 			if (!isset(sup_chan.vec, ch->hw_value))
-- 
1.7.9.5



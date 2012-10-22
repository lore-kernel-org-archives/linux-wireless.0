Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1985 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894Ab2JVRgl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:36:41 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/14] brcmfmac: add function converting
 ieee80211_channel to chanspec
Date: Mon, 22 Oct 2012 10:36:22 -0700
Message-ID: <1350927387-25608-10-git-send-email-frankyl@broadcom.com> (sfid-20121022_193654_413370_22F182FE)
In-Reply-To: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
References: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The firmware carries channel information in a different format
as the provided ieee80211_channel structure. Conversion is needed
when receiving requests from cfg80211 carrying ieee80211_channel
structures. This patch adds a utility function to do that.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   52 ++++++++++---------
 1 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index cb491d9..5a3093d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -392,6 +392,31 @@ static u8 brcmf_mw_to_qdbm(u16 mw)
 	return qdbm;
 }
 
+static u16 channel_to_chanspec(struct ieee80211_channel *ch)
+{
+	u16 chanspec;
+
+	chanspec = ieee80211_frequency_to_channel(ch->center_freq);
+	chanspec &= WL_CHANSPEC_CHAN_MASK;
+
+	if (ch->band == IEEE80211_BAND_2GHZ)
+		chanspec |= WL_CHANSPEC_BAND_2G;
+	else
+		chanspec |= WL_CHANSPEC_BAND_5G;
+
+	if (ch->flags & IEEE80211_CHAN_NO_HT40) {
+		chanspec |= WL_CHANSPEC_BW_20;
+		chanspec |= WL_CHANSPEC_CTL_SB_NONE;
+	} else {
+		chanspec |= WL_CHANSPEC_BW_40;
+		if (ch->flags & IEEE80211_CHAN_NO_HT40PLUS)
+			chanspec |= WL_CHANSPEC_CTL_SB_LOWER;
+		else
+			chanspec |= WL_CHANSPEC_CTL_SB_UPPER;
+	}
+	return chanspec;
+}
+
 static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 				 struct brcmf_wsec_key_le *key_le)
 {
@@ -701,8 +726,6 @@ static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
 	s32 i;
 	s32 offset;
 	u16 chanspec;
-	u16 channel;
-	struct ieee80211_channel *req_channel;
 	char *ptr;
 	struct brcmf_ssid_le ssid_le;
 
@@ -726,30 +749,9 @@ static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
 	WL_SCAN("### List of channelspecs to scan ### %d\n", n_channels);
 	if (n_channels > 0) {
 		for (i = 0; i < n_channels; i++) {
-			chanspec = 0;
-			req_channel = request->channels[i];
-			channel = ieee80211_frequency_to_channel(
-					req_channel->center_freq);
-			if (req_channel->band == IEEE80211_BAND_2GHZ)
-				chanspec |= WL_CHANSPEC_BAND_2G;
-			else
-				chanspec |= WL_CHANSPEC_BAND_5G;
-
-			if (req_channel->flags & IEEE80211_CHAN_NO_HT40) {
-				chanspec |= WL_CHANSPEC_BW_20;
-				chanspec |= WL_CHANSPEC_CTL_SB_NONE;
-			} else {
-				chanspec |= WL_CHANSPEC_BW_40;
-				if (req_channel->flags &
-						IEEE80211_CHAN_NO_HT40PLUS)
-					chanspec |= WL_CHANSPEC_CTL_SB_LOWER;
-				else
-					chanspec |= WL_CHANSPEC_CTL_SB_UPPER;
-			}
-
-			chanspec |= (channel & WL_CHANSPEC_CHAN_MASK);
+			chanspec = channel_to_chanspec(request->channels[i]);
 			WL_SCAN("Chan : %d, Channel spec: %x\n",
-				channel, chanspec);
+				request->channels[i]->hw_value, chanspec);
 			params_le->channel_list[i] = cpu_to_le16(chanspec);
 		}
 	} else {
-- 
1.7.6



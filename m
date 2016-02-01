Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20492 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbcBAJlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 04:41:25 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Interoperability workaround for 80+80 and 160 MHz channels
Date: Mon, 1 Feb 2016 11:40:55 +0200
Message-ID: <1454319655-32170-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20160201_104128_675945_C97620F5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Number of deployed 80 MHz capable VHT stations that do not support 80+80
and 160 MHz bandwidths seem to misbehave when trying to connect to an AP
that advertises 80+80 or 160 MHz channel bandwidth in the VHT Operation
element. To avoid such issues with deployed devices, modify the design
based on recently accepted IEEE 802.11 standard changes (*).

This allows poorly implemented VHT 80 MHz stations to connect with the
AP in 80 MHz mode. 80+80 and 160 MHz capable stations need to support
the new workaround mechanism to allow full bandwidth to be used.
However, there are more or less no impacted station with 80+80/160
capability deployed.

The rebased version of this patch is based on the updated version from
Johannes Berg to take the HT/VHT chandef refactoring into account.

(*) Changes in
https://mentor.ieee.org/802.11/dcn/15/11-15-1530-04-000m-vht160-operation-signaling-through-non-zero-ccfs1.docx
were accepted during the IEEE 802.11 January 2016 meeting.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/util.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index fb90d9c..df1eca8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2364,10 +2364,23 @@ u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 
 	switch (chandef->width) {
 	case NL80211_CHAN_WIDTH_160:
-		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_160MHZ;
+		/*
+		 * Convert 160 MHz channel width to new style as interop
+		 * workaround.
+		 */
+		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80MHZ;
+		vht_oper->center_freq_seg2_idx = vht_oper->center_freq_seg1_idx;
+		if (chandef->chan->center_freq < chandef->center_freq1)
+			vht_oper->center_freq_seg1_idx -= 8;
+		else
+			vht_oper->center_freq_seg1_idx += 8;
 		break;
 	case NL80211_CHAN_WIDTH_80P80:
-		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80P80MHZ;
+		/*
+		 * Convert 80+80 MHz channel width to new style as interop
+		 * workaround.
+		 */
+		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80MHZ;
 		break;
 	case NL80211_CHAN_WIDTH_80:
 		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80MHZ;
@@ -2430,6 +2443,20 @@ bool ieee80211_chandef_vht_oper(const struct ieee80211_vht_operation *oper,
 	case IEEE80211_VHT_CHANWIDTH_80MHZ:
 		new.width = NL80211_CHAN_WIDTH_80;
 		new.center_freq1 = cf1;
+		/* If needed, adjust based on the newer interop workaround. */
+		if (oper->center_freq_seg2_idx) {
+			unsigned int diff;
+
+			diff = abs(oper->center_freq_seg2_idx -
+				   oper->center_freq_seg1_idx);
+			if (diff == 8) {
+				new.width = NL80211_CHAN_WIDTH_160;
+				new.center_freq1 = cf2;
+			} else if (diff > 8) {
+				new.width = NL80211_CHAN_WIDTH_80P80;
+				new.center_freq2 = cf2;
+			}
+		}
 		break;
 	case IEEE80211_VHT_CHANWIDTH_160MHZ:
 		new.width = NL80211_CHAN_WIDTH_160;
-- 
1.9.1


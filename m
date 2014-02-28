Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaB1I5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 03:57:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14] mac80211: fix association to 20/40 MHz VHT networks
Date: Fri, 28 Feb 2014 09:57:36 +0100
Message-Id: <1393577856-9882-1-git-send-email-johannes@sipsolutions.net> (sfid-20140228_095743_631849_AFCEE6DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a VHT network uses 20 or 40 MHz as per the HT operation
information, the channel center frequency segment 0 field in
the VHT operation information is reserved, so ignore it.

This fixes association with such networks when the AP puts 0
into the field, previously we'd disconnect due to an invalid
channel with the message
wlan0: AP VHT information is invalid, disable VHT

Cc: stable@vger.kernel.org
Fixes: f2d9d270c15ae ("mac80211: support VHT association")
Reported-by: Tim Nelson <tim.l.nelson@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c415f00cd6b6..245dce969b31 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -222,6 +222,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	switch (vht_oper->chan_width) {
 	case IEEE80211_VHT_CHANWIDTH_USE_HT:
 		vht_chandef.width = chandef->width;
+		vht_chandef.center_freq1 = chandef->center_freq1;
 		break;
 	case IEEE80211_VHT_CHANWIDTH_80MHZ:
 		vht_chandef.width = NL80211_CHAN_WIDTH_80;
-- 
1.8.5.3


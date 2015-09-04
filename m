Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33928 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbbIDC6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2015 22:58:31 -0400
Received: by padhy16 with SMTP id hy16so7232638pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2015 19:58:31 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: fix the setting of center freq segment 2 in VHT oper ie
Date: Fri,  4 Sep 2015 10:58:05 +0800
Message-Id: <1441335485-5314-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20150904_045835_942326_291C53D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to avoid the Channel Center Frequency Segment 2
in broadcasted VHT operation element contains the non-zero
value for non 80+80 MHz that may failed the comparison of
cfg80211_chandef_identical.

This is tested with Bob's patches related to VHT mesh support.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1104421..f167056 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2324,6 +2324,8 @@ u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 	if (chandef->center_freq2)
 		vht_oper->center_freq_seg2_idx =
 			ieee80211_frequency_to_channel(chandef->center_freq2);
+	else
+		vht_oper->center_freq_seg2_idx = 0x00;
 
 	switch (chandef->width) {
 	case NL80211_CHAN_WIDTH_160:
-- 
2.3.0


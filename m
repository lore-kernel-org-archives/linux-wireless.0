Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59878 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbaBRPDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 10:03:46 -0500
Received: by mail-pa0-f52.google.com with SMTP id bj1so16848074pad.11
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 07:03:46 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] staging: wlan-ng: replace function ieee80211_dsss_chan_to_freq()
Date: Tue, 18 Feb 2014 23:03:27 +0800
Message-Id: <f99a78ffae170ca4f41f84a503f45ff85101c202.1392735504.git.gamerh2o@gmail.com> (sfid-20140218_160351_135791_B9BB2ECC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace ieee80211_dsss_chan_to_freq() with more generic
ieee80211_channel_to_frequency(), and add a variable to deal with 80
characters problem.

File cfg80211.c is included by p80211netdev.c, p80211netdev.c includes
<net/cfg80211.h>, both ieee80211_channel_to_frequency() and
IEEE80211_BAND_2GHZ is defined / declared in <net/cfg80211.h>. So this
change is safe.

This change is a preparation for the removal of function
ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---

add Cc to linux-wireless for consistency.

 drivers/staging/wlan-ng/cfg80211.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index a7d24c9..6c31730 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -400,6 +400,8 @@ static int prism2_scan(struct wiphy *wiphy,
 	numbss = msg1.numbss.data;
 
 	for (i = 0; i < numbss; i++) {
+		int freq;
+
 		memset(&msg2, 0, sizeof(msg2));
 		msg2.msgcode = DIDmsg_dot11req_scan_results;
 		msg2.bssindex.data = i;
@@ -414,9 +416,10 @@ static int prism2_scan(struct wiphy *wiphy,
 		ie_buf[1] = msg2.ssid.data.len;
 		ie_len = ie_buf[1] + 2;
 		memcpy(&ie_buf[2], &(msg2.ssid.data.data), msg2.ssid.data.len);
+		freq = ieee80211_channel_to_frequency(msg2.dschannel.data,
+						      IEEE80211_BAND_2GHZ);
 		bss = cfg80211_inform_bss(wiphy,
-			ieee80211_get_channel(wiphy,
-			      ieee80211_dsss_chan_to_freq(msg2.dschannel.data)),
+			ieee80211_get_channel(wiphy, freq),
 			(const u8 *) &(msg2.bssid.data.data),
 			msg2.timestamp.data, msg2.capinfo.data,
 			msg2.beaconperiod.data,
-- 
1.8.5.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759616AbYEVWgn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 18:36:43 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: dcbw@redhat.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: reorder channel and freq reporting in wext scan report
Date: Fri, 23 May 2008 01:36:36 +0300
Message-Id: <1211495796-2881-1-git-send-email-tomas.winkler@intel.com> (sfid-20080523_003646_622189_43C35403)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch switch order of channel and freq (SIOCGIWFREQ) reports
in scan results in order to overcome wpa_supplicant inability
to handle channel numbers in 5.2Ghz band.
Wext reporting channel number is ambiguous as channels 7-12 (802.11j)
exist on both bands.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7cfd12e..c7eca4d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4095,18 +4095,17 @@ ieee80211_sta_scan_result(struct net_device *dev,
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = bss->freq;
-	iwe.u.freq.e = 6;
+	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
+	iwe.u.freq.e = 0;
 	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
-	iwe.u.freq.e = 0;
+	iwe.u.freq.m = bss->freq;
+	iwe.u.freq.e = 6;
 	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
-
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = IWEVQUAL;
 	iwe.u.qual.qual = bss->signal;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


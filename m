Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54352 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab2DFSsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 14:48:16 -0400
Received: by vbbff1 with SMTP id ff1so1342518vbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2012 11:48:16 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 6 Apr 2012 20:48:15 +0200
Message-ID: <CAA2SeNJNan7uwJ_VELCb-rDX4ddq+=K0Ud3n5mrv6MJ+O-Bb9w@mail.gmail.com> (sfid-20120406_204820_102441_D44C6E18)
Subject: [PATCH] mac80211: fix an issue in ieee80211_tx_info count field management
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I noticed a possible issue in the status count field management of the
ieee80211_tx_info data structure. In particular, when the AGGR
processing is employed,
status.rates[].count is set just for the first frame and not for
others belonging to the same burst, leading to wrong statistic data in
the mac80211 debug file system.

Regards

Lorenzo

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -355,7 +355,13 @@
 	int rtap_len;

 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
-		if (info->status.rates[i].idx < 0) {
+		if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
+		    !(info->flags & IEEE80211_TX_STAT_AMPDU)) {
+			/* just the first aggr frame carry status info */
+			info->status.rates[i].idx = -1;
+			info->status.rates[i].count = 0;
+			break;
+		} else if (info->status.rates[i].idx < 0) {
 			break;
 		} else if (i >= hw->max_report_rates) {
 			/* the HW cannot have attempted that rate */
--

UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep

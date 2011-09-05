Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:39194 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322Ab1IEMC5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 08:02:57 -0400
Received: by mail-yi0-f43.google.com with SMTP id 27so3788512yia.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Sep 2011 05:02:56 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>
Subject: [RFC 0/5] Scan optimization
Date: Mon,  5 Sep 2011 15:02:26 +0300
Message-Id: <1315224151-16552-1-git-send-email-VictorG@ti.com> (sfid-20110905_140300_950548_7D2FC2D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To be able to stop a triggered scan earlier (when one finds the desired
amount of scan results or some specific BSSID), the user needs to be 
notified with intermediate scan result on reception of each new beacon/probe
response during the scan process.

Next patches adding the ability:
 1. 	To stop a running scan with new 'scan cancel' command,
	this v2 patch has mostly cosmetic changes.
 2. 	To get new intermediate scan result event, during running scan.
 3. 	To setup min RSSI threshold for intermediate scan events, which will 
    	reduce significantly irrelevant intermediate scan result notification 
    	(i.e. kernel-user traffic).


Victor Goldenshtein (5):
  nl80211/cfg80211: adding 'scan_cancel' command.
  mac80211: adding 'scan_cancel' command.
  nl80211/cfg80211: adding intermediate scan result event.
  mac80211: adding intermediate scan result event call.
  nl80211/cfg80211: adding intermediate scan result filter.

 include/linux/nl80211.h |   29 ++++++++++++++++++
 include/net/cfg80211.h  |   12 +++++++
 net/mac80211/cfg.c      |    8 +++++
 net/mac80211/scan.c     |    6 +++-
 net/wireless/core.h     |   12 +++++++
 net/wireless/nl80211.c  |   74 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    3 ++
 net/wireless/scan.c     |   63 ++++++++++++++++++++++++++++++++++++++++
 net/wireless/util.c     |    3 ++
 9 files changed, 209 insertions(+), 1 deletions(-)


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:63157 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab3G2Iji (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 04:39:38 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 0/3] introduce chan_time parameter to scan request
Date: Mon, 29 Jul 2013 10:39:15 +0200
Message-ID: <1375087158-22077-1-git-send-email-michal.kazior@tieto.com> (sfid-20130729_103941_885990_9756E761)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset adds a new scan parameter. It allows
specyfing for how long each channel should be
visited during scan.

I've tested this with ath9k (which doesn't have
hw_scan) and ath10k (does have hw_scan). It's not
super time-precise, but seems reasonable.

The main motivation behind this is to allow easier
ACS implementation in hostapd.

This could also perhaps be useful for spectral
scan and anyone interested in having ability to
tune scan times (e.g. very fast initial channel
scanning on mobile devices, long passive scans).

I'm wondering if it would be okay to set swscan
probe delay to 0 if chan_time is non-zero? Or does
probe delay need to be non-zero? Or maybe it
should also be configurable via a parameter?


Pozdrawiam / Best regards,
Michal Kazior.


Michal Kazior (3):
  nl/cfg80211: add chan_time for scan request
  mac80211: add support for scan chan_time parameter
  ath10k: respect chan_time parameter in scan request

 drivers/net/wireless/ath/ath10k/mac.c |    6 ++++++
 include/net/cfg80211.h                |    3 +++
 include/uapi/linux/nl80211.h          |    7 +++++++
 net/mac80211/scan.c                   |   22 ++++++++++++++++++++--
 net/wireless/nl80211.c                |    4 ++++
 5 files changed, 40 insertions(+), 2 deletions(-)

-- 
1.7.9.5


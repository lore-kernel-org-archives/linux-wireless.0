Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53746 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZBCFCe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 00:02:34 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 21:02:34 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [RFC 0/2] cfg80211/mac80211: help world roaming through beacons reg hints
Date: Mon, 2 Feb 2009 21:01:51 -0800
Message-ID: <1233637313-16786-1-git-send-email-lrodriguez@atheros.com> (sfid-20090203_060238_898933_9FE26E7E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support to help the wireless core with world roaming
by providing hints to when we receive beacons from APs. Devices
can be world roaming when the world regulatory domain is set or
the device has a custom regulatory domain and no country IEs have
been received.

This should should help users more on 5 GHz which doesn't allow beaconing
or active scanning when world roaming.

We call mac80211's beacon hint from ieee80211_mlme_notify_scan_completed(),
which is called at the end of ieee80211_scan_completed(). This guarantees
that we take advantage of devices which do hw-scanning or sw-scanning.

Review with the locking is appreciated, but I think this is OK.

Luis R. Rodriguez (2):
  wireless: add regulatory_hint_found_beacon() to make help world
    roaming
  ath9k: follow beacon hints on reg_notifier when world roaming

 drivers/net/wireless/ath9k/regd.c |   92 ++++++++++++-------
 include/net/wireless.h            |   20 ++++
 net/mac80211/mlme.c               |   35 +++++++
 net/wireless/reg.c                |  181 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 295 insertions(+), 33 deletions(-)


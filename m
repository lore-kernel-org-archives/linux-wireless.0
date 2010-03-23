Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:32156 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab0CWHFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 03:05:48 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, luciano.coelho@nokia.com
Subject: [PATCH 0/2] mac80211: cfg80211: Roam trigger support
Date: Tue, 23 Mar 2010 09:02:32 +0200
Message-Id: <1269327754-995-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To implement good performance WLAN roaming, it is not sufficient to start
scanning for other available AP's only after the currently serving association
is lost.

The entity controlling the roaming will need to get indication of a
deteriorating WLAN connection in order to start preparing for roaming already
before the serving association is lost. This way, it can roam to a better AP
perhaps even before the serving association becomes too bad in quality.

These patches propose an implementation facilitating this using a simple RSSI
threshold and hysteresis approach.

These patches add a nl80211 interface for simply configuring a rssi threshold
and hysteresis value to facilitate very basic connection quality monitoring.

For the triggering, these patches currently rely on HW support, host based
triggering is not implemented, but could be added later if needed.

These patches have been tested with the wl1271 driver.

Juuso Oikarinen (2):
  cfg80211: Add connection quality monitoring support to nl80211
  mac80211: Add support for connection quality monitoring

 include/linux/nl80211.h |   46 ++++++++++++++++
 include/net/cfg80211.h  |   19 +++++++
 include/net/mac80211.h  |   29 ++++++++++
 net/mac80211/cfg.c      |   27 ++++++++++
 net/mac80211/mlme.c     |   15 +++++
 net/wireless/mlme.c     |   13 +++++
 net/wireless/nl80211.c  |  131 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    6 ++
 8 files changed, 286 insertions(+), 0 deletions(-)


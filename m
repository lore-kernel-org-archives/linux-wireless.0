Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:19101 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab0CVKSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 06:18:49 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2MAIkva011861
	for <linux-wireless@vger.kernel.org>; Mon, 22 Mar 2010 12:18:47 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: luciano.coelho@nokia.com
Subject: [RFC PATCHv6 0/2] mac80211: cfg80211: Roam trigger support
Date: Mon, 22 Mar 2010 12:15:41 +0200
Message-Id: <1269252943-2450-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v6 of these patches incorporate more changes based on of Johannes' comments.
Some parts of the code was refactored to improve extendability.

v6 also has fixes a problem in configuring the rssi threshold and hysteresis
to the driver. It's now only done when associated.



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

Thanks in advance for your comments and suggestions.

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


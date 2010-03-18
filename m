Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:33870 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0CRI7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 04:59:51 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2I8xRRl003047
	for <linux-wireless@vger.kernel.org>; Thu, 18 Mar 2010 10:59:48 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: luciano.coelho@nokia.com
Subject: [RFC PATCHv4 0/2] mac80211: cfg80211: Roam trigger support
Date: Thu, 18 Mar 2010 10:56:50 +0200
Message-Id: <1268902612-27492-1-git-send-email-juuso.oikarinen@nokia.com>
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

Thanks in advance for your comments and suggestions.

Juuso Oikarinen (2):
  cfg80211: Add connection quality monitoring support to nl80211
  mac80211: Add support for connection quality monitoring

 include/linux/nl80211.h |   31 ++++++++++++
 include/net/cfg80211.h  |   18 +++++++
 include/net/mac80211.h  |   26 ++++++++++
 net/mac80211/cfg.c      |   27 +++++++++++
 net/mac80211/mlme.c     |    8 +++
 net/wireless/mlme.c     |   11 ++++
 net/wireless/nl80211.c  |  118 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    5 ++
 8 files changed, 244 insertions(+), 0 deletions(-)


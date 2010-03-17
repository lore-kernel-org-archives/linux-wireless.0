Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:34155 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab0CQNEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 09:04:21 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2HD3wPQ000923
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 15:04:18 +0200
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2HD42g2030104
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 15:04:02 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv3 0/2] mac80211: cfg80211: Roam trigger support
Date: Wed, 17 Mar 2010 15:01:15 +0200
Message-Id: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
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

 include/linux/nl80211.h |   42 ++++++++++++++++
 include/net/cfg80211.h  |   18 +++++++
 include/net/mac80211.h  |   27 +++++++++++
 net/mac80211/cfg.c      |   26 ++++++++++
 net/mac80211/mlme.c     |    9 ++++
 net/wireless/mlme.c     |   12 +++++
 net/wireless/nl80211.c  |  119 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    5 ++
 8 files changed, 258 insertions(+), 0 deletions(-)


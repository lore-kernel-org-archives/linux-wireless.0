Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32556 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936195Ab0COM6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 08:58:50 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2FCwMfO016499
	for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 14:58:48 +0200
Received: from localhost.localdomain (trdhcp21227.nmp.nokia.com [172.22.212.27])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2FCwXrL010482
	for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 14:58:33 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv2 0/2] mac80211: cfg80211: Roam trigger support
Date: Mon, 15 Mar 2010 14:55:49 +0200
Message-Id: <1268657751-1042-1-git-send-email-juuso.oikarinen@nokia.com>
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

These patches are currently still under development, and still mostly untested.

This v2 of the patches have seen rework based on Johannes Berg's comments.

Thanks in advance for your comments and suggestions.

Juuso Oikarinen (2):
  cfg80211: Add connection quality monitoring support to nl80211
  mac80211: Add support for connection quality monitoring

 include/linux/nl80211.h |   36 ++++++++++++++
 include/net/cfg80211.h  |   17 +++++++
 include/net/mac80211.h  |   26 ++++++++++
 net/mac80211/cfg.c      |   26 ++++++++++
 net/mac80211/mlme.c     |    9 ++++
 net/wireless/mlme.c     |   12 +++++
 net/wireless/nl80211.c  |  123 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    5 ++
 8 files changed, 254 insertions(+), 0 deletions(-)


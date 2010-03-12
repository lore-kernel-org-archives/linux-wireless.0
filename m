Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:54835 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab0CLLhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 06:37:16 -0500
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2CBaww5001785
	for <linux-wireless@vger.kernel.org>; Fri, 12 Mar 2010 13:37:14 +0200
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2CBb6aB028203
	for <linux-wireless@vger.kernel.org>; Fri, 12 Mar 2010 13:37:06 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 0/2] mac80211: cfg80211: Roam trigger support
Date: Fri, 12 Mar 2010 13:34:29 +0200
Message-Id: <1268393671-5498-1-git-send-email-juuso.oikarinen@nokia.com>
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

These patches add a nl80211 interface for simply enabling and disabling a 
roam trigger, and configuring a RSSI threshold and hysteresis value to 
facilitate the triggering.

For the triggering, these patches currently rely on HW support, host based
triggering is not implemented, but could be added later if needed.

These patches are currently still under development, and mostly untested.

Thanks in advance for your comments and suggestions.

Juuso Oikarinen (2):
  cfg80211: Add roaming trigger support to nl80211
  mac80211: Add support for roam trigger configuration

 include/linux/nl80211.h |   21 ++++++++
 include/net/cfg80211.h  |   33 ++++++++++++
 include/net/mac80211.h  |   28 +++++++++++
 net/mac80211/cfg.c      |   29 +++++++++++
 net/mac80211/mlme.c     |    9 +++
 net/wireless/core.c     |   12 +++++
 net/wireless/mlme.c     |   25 +++++++++
 net/wireless/nl80211.c  |  125 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    5 ++
 9 files changed, 287 insertions(+), 0 deletions(-)


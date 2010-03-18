Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:61880 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab0CRHPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 03:15:37 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2I7FVY8031449
	for <linux-wireless@vger.kernel.org>; Thu, 18 Mar 2010 09:15:35 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: luciano.coelho@nokia.com
Subject: [RFC PATCHv4 0/1] mac80211: Support for HW connection recovery
Date: Thu, 18 Mar 2010 09:12:25 +0200
Message-Id: <1268896346-15397-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When PSM is enabled, the wl1271 performs connection recovery independently by
sending probe-requests to the associated-to AP if it detects beacon loss.

The wl1271 only indicates connection problem after the probe-requests have
failed. At this stage, it's useless for the mac80211 to send further
probe requests in attempt to recover the connection.

This v4 of the patch introduces the ieee80211_connection_loss function to be
used instead of ieee80211_beacon_loss for HW doing it's own connection
maintenance.

This patch has been tested with the wl1271 driver.

I'm hoping to be close to completion with these patches, but obviously,
comments and suggestions are welcomed.

Juuso Oikarinen (1):
  mac80211: Add support connection monitor in hardware

 include/net/mac80211.h     |   24 +++++++++++++++-
 net/mac80211/ieee80211_i.h |    4 +-
 net/mac80211/iface.c       |    2 +-
 net/mac80211/mlme.c        |   64 +++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 82 insertions(+), 12 deletions(-)


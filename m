Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:58206 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0CQM52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 08:57:28 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2HCv3SS003626
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 14:57:26 +0200
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2HCtge5018216
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 14:55:42 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv3 0/1] mac80211: Support for HW connection recovery
Date: Wed, 17 Mar 2010 14:52:56 +0200
Message-Id: <1268830377-3450-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When PSM is enabled, the wl1271 performs connection recovery independently by
sending probe-requests to the associated-to AP if it detects beacon loss.

The wl1271 only indicates connection problem after the probe-requests have
failed. At this stage, it's useless for the mac80211 to send further
probe requests in attempt to recover the connection.

As the wl1271 is also capable of transmitting periodic keep-alive frames to
the AP, I realised these functionalities should be bundled.

Instead of any new functions, this v2 of this proposed feature does not add
any functions, instead it introduces the IEEE80211_HW_CONNECTION_MONITOR flag,
which prevents mac80211 from sending periodic keep-alive probe-requests to the
AP and prevents it from sending probe-requests on beacon loss.

This patch has been tested with the wl1271 driver.

I'm hoping to be close to completion with these patches, but obviously,
comments and suggestions are welcomed.

Juuso Oikarinen (1):
  mac80211: Add support connection monitor in hardware

 include/net/mac80211.h |   10 ++++++++++
 net/mac80211/mlme.c    |   38 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 1 deletions(-)


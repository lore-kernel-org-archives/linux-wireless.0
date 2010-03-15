Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:20725 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934452Ab0COMMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 08:12:06 -0400
Received: from mgw-mx06.nokia.com (mgw-mx06.nokia.com [192.100.122.233])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2FBPTUI029188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 13:25:30 +0200
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2FB00aQ020173
	for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 13:00:13 +0200
Received: from localhost.localdomain (trdhcp21227.nmp.nokia.com [172.22.212.27])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2FB04uh011263
	for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 13:00:05 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv2 0/1] mac80211: Support for HW connection recovery
Date: Mon, 15 Mar 2010 12:57:22 +0200
Message-Id: <1268650643-23191-1-git-send-email-juuso.oikarinen@nokia.com>
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

Any suggestions or comments are welcomed.

Juuso Oikarinen (1):
  mac80211: Add support connection monitor in hardware

 include/net/mac80211.h |    4 ++++
 net/mac80211/mlme.c    |   33 ++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletions(-)


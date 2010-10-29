Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:24207 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933746Ab0J2L2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 07:28:36 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o9TBSRkW003381
	for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 06:28:35 -0500
Received: from wimaxnb.nmp.nokia.com (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o9TBRrfE023236
	for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 14:27:54 +0300
From: juuso.oikarinen@nokia.com
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 0/2] mac80211: Possibility for driver to get AP probereq template
Date: Fri, 29 Oct 2010 14:27:51 +0300
Message-Id: <1288351673-12224-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The wl1271 has hardware connection monitoring, i.e. the hardware chipset 
internally handles periodic null-funcs and probe-req transmitting in case of
non-acked periodic null-func or beacon loss.

To be able to transmit a valid probe-request to the associated to AP, the
hardware needs a template for it. Currently, there is no way for the hardware
to have this template, as the SSID and supported rate IE's are not passed down
by the mac80211.

These patches propose adding a function to mac80211, which the driver can use
to get a template for the currently associated-to AP, filled with the basic
needed IE's. The wl1271 patch uses this function, and configures it to the
hardware.

Any thoughts?


Juuso Oikarinen (2):
  mac80211: Add function to get probe request template for current AP
  wl1271: Fix setting of the hardware connection monitoring probe-req
    template

 drivers/net/wireless/wl12xx/wl1271.h      |    3 ++
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   28 +++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |    2 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   32 ++++++++++++++++++----------
 drivers/net/wireless/wl12xx/wl1271_scan.c |    4 +++
 include/net/mac80211.h                    |   12 ++++++++++
 net/mac80211/ieee80211_i.h                |    4 +++
 net/mac80211/mlme.c                       |   24 +++++++++++++++++++++
 net/mac80211/util.c                       |   23 ++++++++++++++++----
 9 files changed, 115 insertions(+), 17 deletions(-)


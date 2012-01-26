Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:36742 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab2AZMjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:39:03 -0500
Received: by ggnh4 with SMTP id h4so241141ggn.22
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:39:01 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>
Subject: [RFC 0/9] nl/cfg/mac80211: add DFS master ability
Date: Thu, 26 Jan 2012 14:37:55 +0200
Message-Id: <1327581484-22047-1-git-send-email-victorg@ti.com> (sfid-20120126_133907_376530_8EA79B68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set (with hostap patch series) adds support for DFS (Dynamic Frequency Selection) according 802.11h.


Main idea
===================

DFS master algorithm is implemented in the hostapd, while nl/cfg/mac80211 will pipe relevant commands/events to the driver/hostapd.

Based on the assumption that the device/driver supports radar interference detection i.e., it is capable to generate radar_detected event by using different pattern detection techniques:


1. Pattern detection in the HW: the device generates 'radar_detected' event.
2. Pattern detection in the driver: the driver receives radar pulses from the device and generates 'radar detected' event.


Main DFS procedures
===================

1. Hostapd gets driver's dfs capabilities.

2. If 80211h is enabled in the hostapd.conf and the driver supports one of the above radar detection techniques, hostapd may use DFS channels.

3. Hostapd selects an operational channel (default from hostapd.conf), if selected channel is a DFS channel, hostapd sends start_radar_detection command to the device/driver which starts monitoring for radar interference while hostapd sets a timer for a CAC (Channel Availability Check) time, which is 60 seconds.

4. As CAC timer expires and no radar has been detected, hostapd may continue with the init flow, otherwise if interference is detected hostapd selects another channel (random selection) and repeats the CAC on the new channel (in case the new channel is also a DFS channel), while the original channel is added to a "black list" for a period of ''No-Occupancy'' time (time that the channel can't be used/selected).

5. While using the channel the device/driver continuously monitors for potential radar interference. If interference is detected hostapd notified with 'radar detected' event, which selects a new channel and triggers a channel switch procedure, if the new channel is also a DFS channel, hostapd performs the CAC test, once it's successfully passed hostapd instructs the driver to initiate the transmission on the channel.



Victor Goldenshtein (9):
  nl80211/cfg80211: add radar detection command/event
  mac80211: add radar detection command/event
  nl80211/cfg80211: add ability to enable TX on op-channel
  mac80211: add ability to enable TX on op-channel
  nl80211/cfg80211: add ap channel switch command/event
  mac80211: add ap channel switch command/event
  nl80211/cfg80211: add DFS feature flag
  mac80211: add DFS capabilities flag
  mac80211: add DFS support to monitor interface

 include/linux/nl80211.h     |   39 ++++++++++
 include/net/cfg80211.h      |   38 +++++++++
 include/net/mac80211.h      |   33 ++++++++
 net/mac80211/cfg.c          |   67 ++++++++++++++++
 net/mac80211/driver-ops.h   |   24 ++++++
 net/mac80211/driver-trace.h |   12 +++
 net/mac80211/main.c         |    3 +
 net/mac80211/mlme.c         |   18 +++++
 net/mac80211/tx.c           |   15 ++--
 net/wireless/mlme.c         |   21 +++++
 net/wireless/nl80211.c      |  178 ++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h      |   10 +++
 12 files changed, 450 insertions(+), 8 deletions(-)

-- 
1.7.5.4


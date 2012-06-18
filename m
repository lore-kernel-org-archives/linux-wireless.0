Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:49699 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220Ab2FROw7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 10:52:59 -0400
Received: by yenl13 with SMTP id l13so3899961yen.20
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 07:52:47 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH 0/7] hostap: add DFS master ability
Date: Mon, 18 Jun 2012 17:49:39 +0300
Message-Id: <1340030986-29118-1-git-send-email-victorg@ti.com> (sfid-20120618_165307_009848_FA246A80)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In continuation to proposed RFC, this patch set (with nl/cfg/mac80211 patch series) adds support for DFS (Dynamic Frequency Selection) according 802.11h.


Main idea
=========

DFS master algorithm is implemented in the hostapd, while nl/cfg/mac80211 will pipe relevant commands/events to the driver/hostapd.
Based on the assumption that the device/driver supports radar interference detection i.e., it is capable to generate radar_detected event by using different pattern detection techniques:

1. Pattern detection in the HW: the device generates 'radar_detected' event.
2. Pattern detection in the driver: the driver receives radar pulses from the device and generates 'radar detected' event.


Main DFS procedures
===================

1. Hostapd gets driver's dfs and channel switch capabilities.
2. If 80211h is enabled in the hostapd.conf, the driver supports one of the above radar detection techniques and supports an AP channel switch, hostapd may use DFS channels.
3. Hostapd selects an operational channel (default from hostapd.conf), if selected channel is a DFS channel, hostapd sends start_radar_detection command to the device/driver which starts monitoring for radar interference while hostapd sets a timer for a CAC (Channel Availability Check) time, which is 60 seconds.
4. As CAC timer expires and no radar has been detected, hostapd may continue with the init flow, otherwise if interference is detected hostapd selects another channel (random selection) and repeats the CAC on the new channel (in case the new channel is also a DFS channel), while the original channel is added to a "black list" for a period of ''No-Occupancy'' time (time that the channel can't be used/selected).
5. While using the channel the device/driver continuously monitors for potential radar interference. If interference is detected hostapd is notified with 'radar detected' event, which selects a new channel and triggers a channel switch procedure, if the new channel is also a DFS channel, hostapd performs the CAC test, once it's successfully passed hostapd instructs the driver to initiate the transmission on the channel.


Updates & changes from the proposed RFC
=======================================

1. In addition to nl/cfg80211 safeguards which ensures that no TX will occur on DFS channels prior performing a valid channel availability check, added additional protection to hostap which now saves a time stamp of the last start radar detection command and prior enabling the tx on the DFS channels will validate whether DFS_MIN_CAC_TIME (60 seconds) has passed since the beginning of the CAC.
2. Changed the Signed-off-by to Signed-hostap.
3. Added sanity checks in drv ops such as “ if the channel is DFS, if the DFS is supported/enabled”
4. Removed “eloop_enable()”, instead just restore “eloop.terminate” state at the end of eloop_run().
5. Filter out irrelevant events during DFS init phase.
6. Added AP channel switch capability check, if this capability is not available DFS cannot be started.
7. Removed “channel” parameter from “struct hostapd_channel_switch”.


Victor Goldenshtein (7):
  hostapd: implement dfs drv ops functions
  hostapd: add channel switch ability
  hostapd: add dfs events
  hostapd: add dfs support into interface init flow
  nl80211: add support to enable TX on oper-channel
  nl80211: add channel switch command/event
  nl80211: add start radar detection command/event

 hostapd/config_file.c        |   10 +++
 src/ap/ap_config.h           |    4 +
 src/ap/ap_drv_ops.c          |   83 ++++++++++++++++++++++
 src/ap/ap_drv_ops.h          |    5 ++
 src/ap/beacon.c              |   16 ++++
 src/ap/drv_callbacks.c       |   47 ++++++++++++
 src/ap/hostapd.c             |  161 ++++++++++++++++++++++++++++++++++++++++--
 src/ap/hostapd.h             |   12 +++
 src/ap/hw_features.c         |   48 ++++++++++---
 src/ap/hw_features.h         |   10 +++
 src/ap/ieee802_11.c          |  117 ++++++++++++++++++++++++++++++
 src/ap/ieee802_11.h          |    4 +
 src/drivers/driver.h         |   91 +++++++++++++++++++++++-
 src/drivers/driver_common.c  |    2 +
 src/drivers/driver_nl80211.c |  129 +++++++++++++++++++++++++++++++++
 src/utils/eloop.c            |    1 +
 16 files changed, 723 insertions(+), 17 deletions(-)

-- 
1.7.5.4


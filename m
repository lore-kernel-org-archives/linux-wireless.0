Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:60722 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464Ab2FROto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 10:49:44 -0400
Received: by obbtb18 with SMTP id tb18so7954364obb.33
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 07:49:42 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: =?UTF-8?q?=5BPATCH=200/7=5D=20nl/cfg/mac80211=3A=20add=20DFS=20master=20ability?=
Date: Mon, 18 Jun 2012 17:46:31 +0300
Message-Id: <1340030798-28992-1-git-send-email-victorg@ti.com> (sfid-20120618_164949_461072_E3F833D2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In continuation to proposed RFC, this patch set (with hostap patch series) adds support for DFS (Dynamic Frequency Selection) according 802.11h.


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

1.   Added safeguards to protect from userspace stupidities to enable TX on DFS channel prior performing a CAC.
2.   Removed IEEE80211_HW_SUPPORTS_RADAR_DETECTION & WIPHY_FLAG_SUPPORTS_DFS flags.
3.   Removed "hw_ prefix" & "_notify" suffix from function names.
4.   Don't set default return value “ int ret = -ENOENT” In the ieee80211_dfs_start_radar_detection().
5.   Removed mutex protection from drv_start_radar_detection() & drv_dfs_en_tx().
6.   Change the tracer to trace_drv_return_int() in drv_start_radar_detection & drv_dfs_en_tx.
7.   Added "dfs_supported" sanity checks in.
8.   Updated commit log in - mac80211: add radar detection command/event.
9.   Renamed NL80211_CMD_DFS_RADAR_DETECTION to CMD_RADAR_DETECT.
10. Renamed dfs_start_radar_detection() to start_radar_detection().
11. Added “unit” in  "@freq: radar detected" event documentation.
12. Removed ASSERT_RDEV_LOCK from nl80211_dfs_start_radar_detection, nl80211_dfs_en_tx and nl80211_ap_channel_switch.
13. Updated documentation for the CMD_RADAR_DETECT.
14. Updated commit log in - nl80211/cfg80211: add ap channel switch command/event.
15. New "NL80211_FEATURE_AP_CH_SWITCH" which is enabled if drv_ap_channel_switch() is set by the driver.
16. New "ieee80211_ap_channel_switch" struct & drv_ap_channel_switch() callback.
17. Moved the “if (!new_ch || new_ch->flags&  IEEE80211_CHAN_DISABLED)” from "mac80211: add ap channel switch command/event" to upper nl80211/cfg80211 layer.
18. Removed the “nl80211_put_feature_flags, driver will set DFS capabilities directly.


Victor Goldenshtein (7):
  nl80211/cfg80211: add radar detection command/event
  mac80211: add radar detection command/event
  nl80211/cfg80211: add ability to enable TX on op-channel
  mac80211: add ability to enable TX on op-channel
  nl80211/cfg80211: add ap channel switch command/event
  mac80211: add ap channel switch command/event
  mac80211: add DFS support to monitor interface

 include/linux/nl80211.h     |   43 ++++++++++
 include/net/cfg80211.h      |   40 +++++++++
 include/net/mac80211.h      |   60 ++++++++++++++
 net/mac80211/cfg.c          |   57 +++++++++++++
 net/mac80211/driver-ops.h   |   37 +++++++++
 net/mac80211/driver-trace.h |   43 ++++++++++
 net/mac80211/main.c         |    3 +
 net/mac80211/mlme.c         |   17 ++++
 net/mac80211/tx.c           |   14 ++--
 net/wireless/core.h         |    6 ++
 net/wireless/mlme.c         |   47 +++++++++++
 net/wireless/nl80211.c      |  189 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h      |   10 +++
 13 files changed, 560 insertions(+), 6 deletions(-)

-- 
1.7.5.4


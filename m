Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34473 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab2JNOzs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2012 10:55:48 -0400
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v4 0/6] nl/cfg/mac80211: add DFS master ability
Date: Sun, 14 Oct 2012 16:48:51 +0200
Message-ID: <1350226137-13704-1-git-send-email-victorg@ti.com> (sfid-20121014_165554_270625_40EA71DA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v4:
========================================================
mac80211: add DFS support to monitor interface
        1. patch deleted.

mac80211: add ap channel switch command/event
        1. reordered tracing in ieee80211_ap_ch_switch_work().
        2. add return value to the ap_channel_switch callback.
        3. handle channel switch complete in new.
        "ieee80211_ap_ch_switch_work" to prevent possible circular
        locking dependency.
        4. new "ap_cs_channel" & "ap_cs_type" parameters in ieee80211_local.
        5. add "ieee80211_stop_queues_by_reason" in
        ieee80211_ap_process_chanswitch().
        6. add "ieee80211_wake_queues_by_reason" in ieee80211_ap_ch_switch_work.

nl80211/cfg80211: add ap channel switch command
        1. move the NL80211_CMD_AP_CH_SWITCH to the end of the enum
        nl80211_commands.
        2. document types for NL80211_ATTR_CH_SWITCH_COUNT,
        NL80211_ATTR_CH_SWITCH_BLOCK_TX, NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX.
        3. updated documentation for @NL80211_CMD_AP_CH_SWITCH.
        4. validate that device supports AP channel switch in
        nl80211_start_radar_detection() & nl80211_dfs_en_tx().
        5. add NL80211_CHAN_NO_HT support in nl80211_ap_channel_switch().
        6. fix bogus documentation of the struct ieee80211_ap_ch_switch.   

mac80211: add ability to enable TX on op-channel
        1. document that dfs_en_tx callback can sleep.
        2. added channel frequency to the trace_drv_dfs_en_tx.

nl80211/cfg80211: add ability to enable TX on op-channel
        1. remove dfs_supported flag from nl80211_dfs_en_tx().
        2. add NL80211_CHAN_NO_HT support in nl80211_dfs_en_tx().
        3. add chan->cac_started check to the nl80211_dfs_en_tx().

mac80211: add radar detection command/event
        1. remove ret variable in ieee80211_start_radar_detection().
        2. add channel frequancy to the trace_drv_start_radar_detection.
        3. remove "sdata->wdev.preset_chan->cac_type = 0;" line from
        ieee80211_do_stop().
        4. document that start_radar_detection callback can sleep.

nl80211/cfg80211: add radar detection command/event
        1. remove dfs_supported flag in nl80211_start_radar_detection().
        2. new bool cac_started in the struct ieee80211_channel.
        3. manually inline cfg80211_start_radar_detection() into
        nl80211_start_radar_detection().
        4. rename IEEE80211_DFS_MIN_CAC_TIME_MS to
        NL80211_DFS_MIN_CAC_TIME_MS and move it to nl80211.h
        5. add NL80211_CHAN_NO_HT support in 
        nl80211_start_radar_detection().
        6. rename NL80211_FEATURE_DFS to NL80211_FEATURE_20MHZ_DFS.
        7. reset the "cac_started" flag in __nl80211_set_channel().
        8. don't reset radar_detect_timeout flag.


hostap TODO:
====================================
NL80211_FEATURE_DFS should be renamed to NL80211_FEATURE_20MHZ_DFS in
phy_info_handler().


Victor Goldenshtein (6):
  nl80211/cfg80211: add radar detection command/event
  mac80211: add radar detection command/event
  nl80211/cfg80211: add ability to enable TX on op-channel
  mac80211: add ability to enable TX on op-channel
  nl80211/cfg80211: add ap channel switch command
  mac80211: add ap channel switch command/event

 include/linux/nl80211.h    |   48 ++++++++++++
 include/net/cfg80211.h     |   65 ++++++++++++++++
 include/net/mac80211.h     |   45 +++++++++++
 net/mac80211/cfg.c         |   57 ++++++++++++++
 net/mac80211/driver-ops.h  |   40 ++++++++++
 net/mac80211/ieee80211_i.h |    4 +
 net/mac80211/iface.c       |    7 ++
 net/mac80211/main.c        |    3 +
 net/mac80211/mlme.c        |   53 +++++++++++++
 net/mac80211/trace.h       |  116 ++++++++++++++++++++++++++++
 net/wireless/mlme.c        |   13 +++
 net/wireless/nl80211.c     |  184 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h     |    6 ++
 13 files changed, 641 insertions(+), 0 deletions(-)

-- 
1.7.5.4


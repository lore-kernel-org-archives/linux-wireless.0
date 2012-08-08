Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:56550 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757976Ab2HHMCI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:02:08 -0400
Received: by yenq13 with SMTP id q13so847602yen.26
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:02:06 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 0/7] hostap: add DFS master ability
Date: Wed,  8 Aug 2012 14:55:31 +0300
Message-Id: <1344426938-1883-1-git-send-email-victorg@ti.com> (sfid-20120808_140211_485589_5ABF54F5)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v3:

Rebased to latest.

0001-hostapd-implement-dfs-drv-ops-functions.patch
1. added HT40 check in hostapd_channel_switch() & hostapd_start_radar_detection().

0003-hostapd-add-dfs-events.patch
1. removed "channel_switch_complete" in wpa_event_data union.
2. renamed "EVENT_CHANNEL_SWITCH_COMPLETE" to "EVENT_AP_CH_SWITCH_COMPLETE".
3. renamed "hostapd_event_complete_channel_switch()" to hostapd_event_ap_ch_switch().

0006-nl80211-add-channel-switch-command-event.patch
1. reuse "NL80211_CMD_CH_SWITCH_NOTIFY" event also for AP.
2. set also the NL80211_ATTR_WIPHY_CHANNEL_TYPE in nl80211_ap_channel_switch().
3. update the "bss->freq" only if the channel switch command succeeded.

0007-nl80211-add-start-radar-detection-command-event.patch
1. set also the NL80211_ATTR_WIPHY_CHANNEL_TYPE in nl80211_start_radar_detection().

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
 src/ap/ap_drv_ops.c          |   95 +++++++++++++++++++++++++
 src/ap/ap_drv_ops.h          |    5 ++
 src/ap/beacon.c              |   16 ++++
 src/ap/drv_callbacks.c       |   45 ++++++++++++
 src/ap/hostapd.c             |  161 ++++++++++++++++++++++++++++++++++++++++--
 src/ap/hostapd.h             |   13 ++++
 src/ap/hw_features.c         |   48 ++++++++++---
 src/ap/hw_features.h         |   10 +++
 src/ap/ieee802_11.c          |  117 ++++++++++++++++++++++++++++++
 src/ap/ieee802_11.h          |    4 +
 src/drivers/driver.h         |   89 +++++++++++++++++++++++-
 src/drivers/driver_common.c  |    2 +
 src/drivers/driver_nl80211.c |  152 ++++++++++++++++++++++++++++++++++++++-
 src/utils/eloop.c            |    1 +
 16 files changed, 751 insertions(+), 21 deletions(-)

-- 
1.7.5.4


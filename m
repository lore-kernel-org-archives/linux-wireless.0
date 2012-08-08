Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:44266 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757128Ab2HHMAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:00:19 -0400
Received: by obhx4 with SMTP id x4so1347694obh.14
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:00:12 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 0/7] nl/cfg/mac80211: add DFS master ability 
Date: Wed,  8 Aug 2012 14:53:36 +0300
Message-Id: <1344426823-1795-1-git-send-email-victorg@ti.com> (sfid-20120808_140050_608658_4E573205)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v3:
	
 Rebased to "wireless-testing".


 nl80211/cfg80211: add radar detection command/event
	Added units documentation to "radar_detect_timeout".
	Added "cac_type" - which indicates that CAC is started for this channel type.
	Added NL80211_ATTR_WIPHY_CHANNEL_TYPE. 
	Fixed merge problem.
	Removed "!!" in nl80211_start_radar_detection.
	Return -EBUSY in start_radar_detection if detection already started for this specific channel.
	
	
 mac80211: add radar detection command/event
	Added tracer to ieee80211_radar_detected().
	Changed freq argument in ieee80211_radar_detected() to "struct ieee80211_channel *chan"
	Reset CAC during interface down.


 nl80211/cfg80211: add ability to enable TX on op-channel
	Removed "!!" in nl80211_dfs_en_tx().
	Typo fix in the documentation.
	Added additional check to validate that we're on NL80211_CHAN_HT20 channel, otherwise return -EPERM.
	
	
 nl80211/cfg80211: add ap channel switch command/event
	Moved struct ieee80211_ap_ch_switch from mac to cfg + pass it as argument in ap_channel_switch()
	Add "if (ch_type != NL80211_CHAN_NO_HT) return -EOPNOTSUPP"
	Changed freq argument in ap_ch_switch_complete_notify() to "struct ieee80211_channel *chan"


 mac80211: add ap channel switch command/event
	Renamed ieee80211_ap_ch_switch_complete_notify to ieee80211_ap_ch_switch_done. 
	Removed the freq argument in ieee80211_ap_ch_switch_done().
	Save the target channel in new "local->next_ap_channel" and update the operational channel in ieee80211_ap_ch_switch_done.
	Add tracer to ieee80211_ap_ch_switch_done().
	Updated commit log message.
	Added sanity checks in ap_channel_switch() + ieee80211_ap_ch_switch_complete


 mac80211: add DFS support to monitor interface
	Removed "!!" in ieee80211_monitor_start_xmit().

Victor Goldenshtein (7):
  nl80211/cfg80211: add radar detection command/event
  mac80211: add radar detection command/event
  nl80211/cfg80211: add ability to enable TX on op-channel
  mac80211: add ability to enable TX on op-channel
  nl80211/cfg80211: add ap channel switch command
  mac80211: add ap channel switch command/event
  mac80211: add DFS support to monitor interface

 include/linux/nl80211.h   |   42 +++++++++++
 include/net/cfg80211.h    |   63 +++++++++++++++++
 include/net/mac80211.h    |   37 ++++++++++
 net/mac80211/cfg.c        |   50 +++++++++++++
 net/mac80211/driver-ops.h |   38 ++++++++++
 net/mac80211/iface.c      |    7 ++
 net/mac80211/main.c       |    3 +
 net/mac80211/mlme.c       |   32 +++++++++
 net/mac80211/trace.h      |   87 +++++++++++++++++++++++
 net/mac80211/tx.c         |   13 ++--
 net/wireless/core.h       |    4 +
 net/wireless/mlme.c       |   38 ++++++++++
 net/wireless/nl80211.c    |  171 +++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h    |    6 ++
 14 files changed, 585 insertions(+), 6 deletions(-)

-- 
1.7.5.4


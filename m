Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:32863 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753509AbcKVKaN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 05:30:13 -0500
Received: by mail-wm0-f41.google.com with SMTP id c184so3405083wmd.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2016 02:30:13 -0800 (PST)
Received: from localhost.localdomain (199.red-88-21-51.staticip.rima-tde.net. [88.21.51.199])
        by smtp.gmail.com with ESMTPSA id d8sm2148772wmi.21.2016.11.22.02.30.10
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 22 Nov 2016 02:30:11 -0800 (PST)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3][RESEND][RFC] CQM RSSI event with many thresholds
Date: Tue, 22 Nov 2016 11:29:49 +0100
Message-Id: <1479810592-2474-1-git-send-email-andrew.zaborowski@intel.com> (sfid-20161122_113016_823061_A891C57C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrew Zaborowski <balrogg@gmail.com>

This is a first stab at a nl80211 API using multiple RSSI thresholds
discussed previously.  It is similar to the current CQM RSSI event with
one threshold and a hysteresis parameter.  I tried to avoid creating
new nl80211 commands and events so I extended the existing command.
There's still a NL80211_ATTR_CQM_RSSI_THOLD attribute and a hysteresis
attribute but multiple thresholds can be supplied as an array.

All this is a proposal and open to changes.

There are two different mechanisms for compatibility with the current
behavior in which events are generated every time the RSSI value is
more than $hysteresis dBm away from the last event's level, even if
$threshold wasn't crossed.  For example with the rssi going up from 20dBm
and the threshold set at 40 and hysteresis at 5, there'll be events at
40, 45, 50 and so on.  I assume this is intentional because most
drivers replicate this behavior.  If 2 or more thresholds are supplied
in NL80211_ATTR_CQM_RSSI_THOLD (i.e. it is not 4 byte long) this will
enable the new mechanism and events are only generated when a threshold
is crossed.

My opinion is that the new mechanism is similar enough to the current
one that it would be best if each driver didn't have to implement both
mechanisms, and one could be a special case of the other.  However I
can't update all drivers because I can't test them.  So at the driver
level there have to be two methods until all drivers implement the
new method (set_cqm_rssi_range_config, which uses a low and a high
threshold) and the current behavior can be implemented on to of it.
So the next best thing is that at least the netlink API can present it
as a single interface.  Also both mechanisms never have to be enabled
simultaneously, the driver doesn't have to support them both at the
same time.

Also it seems that the wl1271 (wlcore) driver can offload RSSI
monitoring to hardware using exactly the two parameters used today:
one threshold and a hysteresis value, and no other mechanism is
supported by the hardware, so it wouldn't make sense for it to drop
the current method.

Andrew Zaborowski (3):
  mac80211: Pass new RSSI level in CQM RSSI notification
  cfg80211: Pass new RSSI level in CQM RSSI notification
  nl80211/mac80211: Accept multiple RSSI thresholds for CQM

 drivers/net/wireless/intel/iwlwifi/mvm/rx.c      |   2 +
 drivers/net/wireless/marvell/mwifiex/sta_event.c |   4 +-
 drivers/net/wireless/rndis_wlan.c                |   2 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c      |   2 +-
 drivers/net/wireless/st/cw1200/sta.c             |   2 +-
 drivers/net/wireless/ti/wl1251/event.c           |   4 +-
 drivers/net/wireless/ti/wlcore/event.c           |   3 +-
 include/net/cfg80211.h                           |  15 ++-
 include/net/mac80211.h                           |   8 ++
 include/uapi/linux/nl80211.h                     |   7 +-
 net/mac80211/cfg.c                               |  28 +++++
 net/mac80211/mlme.c                              |  33 ++++-
 net/mac80211/trace.h                             |  11 +-
 net/wireless/core.c                              |  13 ++
 net/wireless/core.h                              |   9 ++
 net/wireless/nl80211.c                           | 146 +++++++++++++++++++++--
 net/wireless/rdev-ops.h                          |  12 ++
 net/wireless/trace.h                             |  33 ++++-
 18 files changed, 299 insertions(+), 35 deletions(-)

-- 
2.7.4

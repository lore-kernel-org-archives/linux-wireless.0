Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37302 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933791AbaGQOOF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:05 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so2029148wgh.18
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:03 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 00/15] mac80211 TDLS QoS/HT support
Date: Thu, 17 Jul 2014 17:14:16 +0300
Message-Id: <1405606471-30128-1-git-send-email-arik@wizery.com> (sfid-20140717_161415_899585_FDB883AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds HT and QoS support for mac80211 drivers implementing TDLS.

It also includes some error path fixes, as well as a compatibility fix for
older usermode (as requested by Jouni Malinen).

A couple of wpa_supplicant patches are also required to properly propagate
WMM capability to kernel and fix a recently introduced issue into the hwsim
TDLS tests. These will be sent soon.

Arik Nemtsov (14):
  mac80211: track TDLS initiator internally
  mac80211: fix error path for TDLS setup
  mac80211: consolidate TDLS IE treatment
  mac80211: split extra TDLS IEs in setup frames
  mac80211: avoid adding some IEs on TDLS setup failure packets
  mac80211: set TDLS capab to zero on failure frames
  mac80211: add QoS IE during TDLS setup start
  mac80211: add TDLS QoS param IE on setup-confirm
  mac80211: move TDLS data to mgd private part
  mac80211: support HT for TDLS stations
  mac80211: set Rx highest rate in ht_cap
  mac80211: disable VHT for TDLS
  cfg80211: fix TDLS setup with VHT peers
  mac80211: ignore frames between TDLS peers when operating as AP

Liad Kaufman (1):
  mac80211: make sure TDLS teardown packet is sent on time

 include/linux/ieee80211.h  |  20 ++
 net/mac80211/ht.c          |  10 +-
 net/mac80211/ibss.c        |  13 +-
 net/mac80211/ieee80211_i.h |   7 +-
 net/mac80211/iface.c       |   2 -
 net/mac80211/mlme.c        |  14 +-
 net/mac80211/rx.c          |   8 +
 net/mac80211/sta_info.h    |   3 +
 net/mac80211/tdls.c        | 459 ++++++++++++++++++++++++++++++++++++++-------
 net/mac80211/util.c        |  15 ++
 net/mac80211/vht.c         |   4 +
 net/wireless/nl80211.c     |   3 +-
 12 files changed, 462 insertions(+), 96 deletions(-)

-- 
1.9.1


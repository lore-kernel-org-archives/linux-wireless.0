Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48678 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754432Ab1L2MkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Dec 2011 07:40:09 -0500
Received: by mail-lpp01m010-f46.google.com with SMTP id d3so2600118lah.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Dec 2011 04:40:08 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 0/3] notify driver about changes in station state
Date: Thu, 29 Dec 2011 14:41:38 +0200
Message-Id: <1325162501-7996-1-git-send-email-eliad@wizery.com> (sfid-20111229_134029_345293_0DEAAE0F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset is a sequel for Johannes' "station management rework"
patchset. It adds a new sta_state callback, so low-level driver
will be able to register for station state changes.

v2: call drv_sta_state() within the sta addition process (thanks Johannes)

Eliad Peller (3):
  mac80211: check sta_apply_parameters() return value
  mac80211: move sta_state into sta->sta
  mac80211: add sta_state callback

 include/net/mac80211.h      |   17 +++++++++++++++++
 net/mac80211/cfg.c          |    7 ++++++-
 net/mac80211/driver-ops.h   |   17 +++++++++++++++++
 net/mac80211/driver-trace.h |   28 ++++++++++++++++++++++++++++
 net/mac80211/sta_info.c     |   33 ++++++++++++++++++++++-----------
 net/mac80211/sta_info.h     |   11 -----------
 net/mac80211/util.c         |    9 ++++++++-
 7 files changed, 98 insertions(+), 24 deletions(-)

-- 
1.7.6.401.g6a319


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46124 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab1LWMXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 07:23:23 -0500
Received: by wgbdr13 with SMTP id dr13so17384114wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 04:23:22 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/3] notify driver about changes in station state
Date: Fri, 23 Dec 2011 14:24:32 +0200
Message-Id: <1324643075-29385-1-git-send-email-eliad@wizery.com> (sfid-20111223_132327_172217_163BD2AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset is a sequel for Johannes' "station management rework"
patchset. It adds a new sta_state callback, so low-level driver
will be able to register for station state changes.

Note: I took the easy approach and added a specific sta_state() callback.
If someone thinks it would be better to add a generic sta_changed()
callback (and pass an additional "changed" mask), we can do it
instead...

Eliad Peller (3):
  mac80211: check sta_apply_parameters() return value
  mac80211: move sta_state into sta->sta
  mac80211: add sta_state callback

 include/net/mac80211.h      |   17 +++++++++++++++++
 net/mac80211/cfg.c          |    7 ++++++-
 net/mac80211/driver-ops.h   |   17 +++++++++++++++++
 net/mac80211/driver-trace.h |   28 ++++++++++++++++++++++++++++
 net/mac80211/sta_info.c     |   26 ++++++++++++++++----------
 net/mac80211/sta_info.h     |   11 -----------
 6 files changed, 84 insertions(+), 22 deletions(-)

-- 
1.7.6.401.g6a319


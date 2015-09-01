Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37610 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbbIAKOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 06:14:52 -0400
Received: by wicfx3 with SMTP id fx3so6873259wic.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2015 03:14:51 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [RFC 0/2] Send own beacons to monitor interfaces
Date: Tue,  1 Sep 2015 12:12:42 +0200
Message-Id: <1441102364-32516-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20150901_121456_144414_98A47E7C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sending as RFC to gather some feedback. It can be quite useful
to see own beacons on monitor interfaces for debugging purposes.

However, since there is no tx status for beacons on most drivers
this patchset sends a copy of each beacon fetched via
ieee80211_beacon_get_tim to the monitor interfaces.

Of course, the beacon won't have proper seq numbers for example
as these are filled in in hw/fw.

Still this can be very helpful for debugging.

Helmut Schaa (2):
  mac80211: Split sending tx'ed frames to monitor interfaces into its
    own function
  mac80211: Copy tx'ed beacons to monitor mode

 net/mac80211/ieee80211_i.h |   3 ++
 net/mac80211/status.c      | 108 +++++++++++++++++++++++++--------------------
 net/mac80211/tx.c          |  10 +++++
 3 files changed, 72 insertions(+), 49 deletions(-)

-- 
1.8.4.5


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35009 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbcGHWVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 18:21:04 -0400
Received: by mail-oi0-f54.google.com with SMTP id r2so77639433oih.2
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jul 2016 15:21:04 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC v2 0/3] Improve wireless netdev detection
Date: Sat,  9 Jul 2016 01:16:04 -0500
Message-Id: <1468044967-9236-1-git-send-email-denkenz@gmail.com> (sfid-20160709_002109_981191_724B98E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current mechanism to detect hot-plug / unplug of wireless devices is
somewhat arcane.  One has to listen to NEW_WIPHY/DEL_WIPHY events over
nl80211 as well as RTM_NEWLINK / RTM_DELLINK events over rtnl, then
somehow find a correlation between these events.  This involves userspace
sending GET_INTERFACE or GET_WIPHY commands to the kernel, which incurs
additional roundtrips.

This patch series proposes that NEW_INTERFACE and DEL_INTERFACE events are
always emitted, regardless of whether a netdev was added/removed by the
driver or explicitly via NEW_INTERFACE/DEL_INTERFACE commands.

v2: Squished patches 2+3, 4+5.  DEL_INTERFACE event notification is now
sent inside cfg80211_unregister_wdev instead of nl80211_del_interface.

Denis Kenzior (3):
  nl80211: Add nl80211_notify_iface
  core: Always notify of new wireless netdevs
  core: Always notify when wireless netdev is removed

 net/wireless/core.c    |  6 +++++
 net/wireless/nl80211.c | 69 +++++++++++++++++++++++++++-----------------------
 net/wireless/nl80211.h |  3 +++
 3 files changed, 47 insertions(+), 31 deletions(-)

-- 
2.7.3


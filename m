Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:45298 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaCGNiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 08:38:03 -0500
Received: by mail-ea0-f181.google.com with SMTP id k10so2339882eaj.40
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 05:38:02 -0800 (PST)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de
Subject: [RFC PATCH 0/8] Add new channel type -- 5MHz and 10MHz
Date: Fri,  7 Mar 2014 14:37:47 +0100
Message-Id: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140307_143809_195570_0CD50492)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds new channel types -- 5MHz and 10MHz.  Channels
with such bandwidth are used in IEEE 802.11p with frequencies
ranging from 5850 to 5925 MHz. Since OCB mode defined in 802.11p
does not use beacons, the channel frequencies including the
bandwidth should be set by all STAs before joining the network.
This patchset adds the possibility of setting the channel
bandwidth via netlink (i.e. from userspace).

Potential issues:
CRDA reports to the kernel the information about the maximum
channel bandwidth allowed for some particular range of channels/
frequencies. In case the maximum BW is usual 20 or 40 MHz, e.g.
(2400 - 2483.5 @ 40), it is possible to configure a channel with
5MHz or 10MHz in that range.  Is this behavior acceptable or
should it be prevented?


Rostislav Lisovy (8):
  nl80211: Add new channel types -- 5MHz and 10MHz
  nl80211: Add attributes describing channel bandwidth
  cfg80211: Add attributes describing channel bandwidth
  cfg80211: Modify chandef related functions to work with 5/10MHz
    channels
  nl80211: Modify chandef related functions to work with 5/10MHz
    channels
  nl80211: Support for 5/10 MHz channels when reporting BW restrictions
  cfg80211: Use 5MHz bandwidth when checking usable channels
  mac80211: Update conf_is_ht() to work properly with 5/10MHz channels

 include/net/cfg80211.h       | 10 ++++++++++
 include/net/mac80211.h       |  4 +++-
 include/uapi/linux/nl80211.h | 14 +++++++++++++-
 net/wireless/chan.c          | 10 ++++++++++
 net/wireless/nl80211.c       | 10 ++++++++++
 net/wireless/reg.c           | 22 +++++++++++++++-------
 6 files changed, 61 insertions(+), 9 deletions(-)

-- 
1.8.5.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:34501 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966343AbcIYQkD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Sep 2016 12:40:03 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mac80211: multicast with AP_VLAN optimizations
Date: Sun, 25 Sep 2016 18:39:53 +0200
Message-Id: <1474821596-12155-1-git-send-email-michael-dev@fami-braun.de> (sfid-20160925_184017_822827_AE04EDA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this series tries to optimize multicast delivery on access points with
AP_VLAN interfaces.

My setup is as follows: hostapd creates one AP_VLAN interface per station
(per_sta_vif=1), which enables bridge igmp snooping to decide which
stations need to receive a multicast packet.

This series then
 - avoids multicast packets by tracking the number of authenticated
   stations per interface more accurately and drops packets if there is no
   receiver connected,
 - converts multicast packets to unicast packets for the most common
   protocols, so they get delivered faster and more reliable. Additionally,
   waking up non-receivers in other VLANs is avoided.
 - speeds up station lookup if there is only one authenticated station
   assigned to the AP_VLAN interface.

Sincerely,
M. Braun

Michael Braun (3):
  mac80211: filter multicast data packets on AP / AP_VLAN
  mac80211: multicast to unicast conversion
  mac80211: cache the only AP_VLAN station

 net/mac80211/cfg.c            |  26 +++++-----
 net/mac80211/debugfs_netdev.c |  38 ++++++++++++++
 net/mac80211/ieee80211_i.h    |  61 ++++++++++++++++++++++
 net/mac80211/rx.c             |   5 +-
 net/mac80211/sta_info.c       |  41 +++++++++++----
 net/mac80211/tx.c             | 115 ++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 258 insertions(+), 28 deletions(-)

-- 
2.1.4

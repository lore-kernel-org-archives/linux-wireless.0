Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:36344 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3BFLtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 06:49:13 -0500
Received: by mail-bk0-f54.google.com with SMTP id w5so594465bku.27
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2013 03:49:11 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org, Marco Porsch <marco@cozybit.com>
Subject: [RFCv2 0/3] mesh power save - hardware doze
Date: Wed,  6 Feb 2013 12:48:42 +0100
Message-Id: <1360151325-6368-1-git-send-email-marco@cozybit.com> (sfid-20130206_124916_881824_23D02F08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commits #2 and #3 implement the actual power saving mechanism
for mesh.

When the current peer link states allow doze state, the HW is
configured accordingly.
STA wake up from doze state for
1) sending their own beacon and tailing awake window
2) receiving beacons of peers they are in light sleep towards
In these two situations a Mesh Peer Service Period may be
initiated to extend the awake phase to transmit/receive
frames.

Design goal was to implement most PS routines in mac80211 to
keep maintainability high and allow simple driver adaption.
Since mesh PS requires waiting for beacon/multicasts (CAB) per
STA, these routines are re-implemented in mac80211.

The implementation should be capable of managing multiple
concurrent mesh vif, although this has rarely been tested, yet.

(For more info see https://github.com/cozybit/open80211s/wiki
/Mesh-Powersave-Implementation-Notes.)

On some test devices (WNDR3700/3800 with openwrt r35284) I
experience frequent crashes ("Data bus error"). Adding udelay
to ath9k_hw_set_power_awake and ath9k_set_power_network_sleep as
described in https://dev.openwrt.org/ticket/9107 seems to help.
I am unsure if I just stumble over a bug or cause it myself
here.

v2:
mac80211:
- trigger wakeups in HW (Johannes)
- got rid of hrtimer usage (Johannes)
- got rid of pre-TBTT wakeup margin
- got rid of HW sleep/awake status variable in local
- fix deep sleep wakeup schedule
ath9k:
- program HW's TIM timer registers to perform wakeups

Marco Porsch (3):
  mac80211: move mesh sync beacon handler into neighbour_update
  mac80211: mesh power save doze scheduling
  ath9k: mesh powersave support

 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 +
 drivers/net/wireless/ath/ath9k/beacon.c |   21 +-
 drivers/net/wireless/ath/ath9k/hw.c     |   20 +-
 drivers/net/wireless/ath/ath9k/main.c   |   67 ++++++-
 include/net/mac80211.h                  |   29 +++
 net/mac80211/ieee80211_i.h              |   17 +-
 net/mac80211/mesh.c                     |   25 ++-
 net/mac80211/mesh.h                     |   22 ++-
 net/mac80211/mesh_plink.c               |   17 +-
 net/mac80211/mesh_ps.c                  |  316 +++++++++++++++++++++++++++++++
 net/mac80211/mesh_sync.c                |   47 ++---
 net/mac80211/sta_info.c                 |    3 +
 net/mac80211/sta_info.h                 |   10 +
 net/mac80211/tx.c                       |    2 +
 14 files changed, 541 insertions(+), 56 deletions(-)

-- 
1.7.9.5


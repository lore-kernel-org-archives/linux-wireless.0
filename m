Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46304 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab1GMXqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 19:46:07 -0400
Received: by iyb12 with SMTP id 12so5995000iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2011 16:46:06 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 0/5] mac80211: mesh beaconing
Date: Wed, 13 Jul 2011 16:45:42 -0700
Message-Id: <1310600747-9583-1-git-send-email-thomas@cozybit.com> (sfid-20110714_014611_337942_6AC9E17F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, mesh beacons have IEs either missing or in the wrong order. Update
the mesh beacon to the proper format specified in 802.11s draft 12.0. This
patch set will be part of a greater effort to update the mesh stack in mac80211
in anticipation of the ratification of the 802.11s standard.

Thomas Pedersen (5):
  mac80211: give if_mesh a beacon
  mac80211: correct mesh beacon head
  mac80211: Ext. Supported Rates go in mesh beacon tail
  mac80211: move RSN IE to tail of mesh beacon
  mac80211: mesh beacon includes TIM IE

 net/mac80211/cfg.c         |   31 ++++++--
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh.c        |  185 ++++++++++++++++++++++++++++++++------------
 net/mac80211/tx.c          |   51 ++++++------
 4 files changed, 187 insertions(+), 81 deletions(-)

-- 
1.7.6


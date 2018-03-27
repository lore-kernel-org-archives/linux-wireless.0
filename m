Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52614 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752538AbeC0Nry (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 09:47:54 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 0/3] cfg80211/mac80211: Notify proper sta opmode change value
Date: Tue, 27 Mar 2018 19:16:14 +0530
Message-Id: <1522158377-3566-1-git-send-email-tamizhr@codeaurora.org> (sfid-20180327_154807_807865_C6B0CDA2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently bw and smps_mode are u8 type value in sta_opmode_info
structure. This values filled in mac80211 from ieee80211_sta_rx_bandwidth
and ieee80211_smps_mode. These enum values are specific to mac80211 and
userspace/cfg80211 doesn't know about that. This patchset change its
data type in the sta_opmode_info structure and mapping from mac80211
specific enum to nl80211 enum value.

Tamizh chelvam (3):
  cfg80211: fix data type of sta_opmode_info parameter
  mac80211: Use proper smps_mode enum in sta opmode event
  mac80211: Use proper chan_width enum in sta opmode event

 include/net/cfg80211.h     |  8 ++++----
 net/mac80211/ht.c          | 15 +++++++++++++++
 net/mac80211/ieee80211_i.h |  4 ++++
 net/mac80211/rx.c          |  6 ++++--
 net/mac80211/vht.c         | 32 +++++++++++++++++++++++++++++++-
 5 files changed, 58 insertions(+), 7 deletions(-)

-- 
1.9.1

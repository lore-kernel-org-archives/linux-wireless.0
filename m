Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35119 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbbHFVrh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 17:47:37 -0400
Received: by wibxm9 with SMTP id xm9so39046337wib.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2015 14:47:36 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 0/4] mac80211: define VHT rate mask logic
Date: Thu,  6 Aug 2015 23:47:29 +0200
Message-Id: <1438897653-4629-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150806_234741_020314_8E4D5C3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support to mask vht rates using ratemask configured by the user through
iw command (e.g. iw dev wlan0 set bitrates vht-mcs-5 2:2,4).
Remove ieee80211_tx_rate dependency in rate mask code in order to use
mcs/legacy rate mask logic for station rate table as well.
This patchset has been tested using mac80211/mt76 driver on
Buffalo WHR-1166D router running OpenWrt trunk

Lorenzo Bianconi (4):
  mac80211: remove ieee80211_tx_info from rate_control_apply_mask
    signature
  mac80211: remove ieee80211_tx_rate dependency in rate mask code
  mac80211: define rate_control_apply_mask_ratetbl()
  mac80211: add rate mask logic for vht rates

 net/mac80211/cfg.c            |  16 ++-
 net/mac80211/debugfs_netdev.c |  34 ++++++
 net/mac80211/ieee80211_i.h    |   5 +
 net/mac80211/iface.c          |  14 ++-
 net/mac80211/rate.c           | 251 ++++++++++++++++++++++++++++++------------
 net/mac80211/vht.c            |  27 +++++
 6 files changed, 271 insertions(+), 76 deletions(-)

-- 
2.1.4


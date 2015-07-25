Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33412 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbbGYOcd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2015 10:32:33 -0400
Received: by wicmv11 with SMTP id mv11so91732169wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2015 07:32:32 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC 0/4] mac80211: define VHT rate mask logic
Date: Sat, 25 Jul 2015 16:32:25 +0200
Message-Id: <1437834749-23765-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150725_163241_712242_F81024B0)
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


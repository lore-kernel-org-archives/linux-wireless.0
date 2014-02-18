Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50017 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbaBRNgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 08:36:15 -0500
Received: by mail-pd0-f180.google.com with SMTP id x10so16310210pdj.11
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 05:36:15 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/7] api clean: ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
Date: Tue, 18 Feb 2014 21:35:56 +0800
Message-Id: <cover.1392728354.git.gamerh2o@gmail.com> (sfid-20140218_143626_007835_64DA570F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set's purpose is to remove function
ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}, by replacing them
with more generic function ieee80211_{channel_to_frequency,
frequency_to_channel}.

The error number they return is different. the 'dsss' one return -1,
the other return zero. Fortunately most of the code have correct error
check to handle both situation. Good luck to those code which never
check the return value.

By the way, this patch set only compile tested.

Zhao, Gang (7):
  airo: replace function ieee80211_{dsss_chan_to_freq,
    freq_to_dsss_chan}
  atmel: replace function ieee80211_{dsss_chan_to_freq,
    freq_to_dsss_chan}
  wl3501_cs: replace function ieee80211_{dsss_chan_to_freq,
    freq_to_dsss_chan}
  rndis_wlan: replace function ieee80211_{dsss_chan_to_freq,
    freq_to_dsss_chan}
  zd1201: replace function ieee80211_{dsss_chan_to_freq,
    freq_to_dsss_chan}
  orinoco: replace function ieee80211_{dsss_chan_to_freq,
    freq_to_dsss_chan}
  ieee80211: remove function ieee80211_{dsss_chan_to_freq,
    freq_to_dsss_chan}

 drivers/net/wireless/airo.c         | 13 ++++++++-----
 drivers/net/wireless/atmel.c        |  8 ++++----
 drivers/net/wireless/orinoco/cfg.c  |  4 ++--
 drivers/net/wireless/orinoco/hw.c   |  2 +-
 drivers/net/wireless/orinoco/scan.c |  5 +++--
 drivers/net/wireless/orinoco/wext.c |  2 +-
 drivers/net/wireless/rndis_wlan.c   |  3 ++-
 drivers/net/wireless/wl3501_cs.c    |  5 +++--
 drivers/net/wireless/zd1201.c       |  9 +++------
 include/linux/ieee80211.h           | 36 ------------------------------------
 10 files changed, 27 insertions(+), 60 deletions(-)

-- 
1.8.5.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1JEJzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:55:40 -0400
Received: by eya28 with SMTP id 28so1405752eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:55:39 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/29] wl12xx: start preparing the driver for multi-vif support
Date: Wed,  5 Oct 2011 11:55:37 +0200
Message-Id: <1317808566-18857-1-git-send-email-eliad@wizery.com> (sfid-20111005_115543_550084_8647D273)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl12xx fw currently supports only a single vif at a time.
Upcoming fw versions are going to support concurrentl vifs.

While mac80211 works well with multiple vifs, the wl12xx
driver assumes it handles only a single interface.

This is the first patchset in order to make the driver ready
for multiple vifs support. The main action here is defining
a new per-interface data struct (wlvif), and moving the
currently-global fields into it.

(Additional global fields/flags will be addressed by further patchsets)

Note that this patchset only adds functionality - it doesn't
break compatability with the current fw.

Eliad Peller (29):
  wl12xx: disable AP-mode-specific quirks
  wl12xx: replace wl->mac_addr with vif->addr
  wl12xx: start reworking the init sequence
  wl12xx: define wl12xx_vif
  wl12xx: move rate_set into wlvif
  wl12xx: move basic_rate into wlvif
  wl12xx: replace wl->bssid with vif->bss_conf.bssid
  wl12xx: move bss_type into wlvif
  wl12xx: remove set_bss_type field
  wl12xx: move p2p into wlvif
  wl12xx: move ssid and ssid_len into wlvif
  wl12xx: move probereq into wlvif
  wl12xx: move aid into wlvif
  wl12xx: move role_id into wlvif
  wl12xx: move dev_role_id into wlvif
  wl12xx: move sta_hlid into wlvif
  wl12xx: move ap_global_hlid and ap_bcast_hlid into wlvif
  wl12xx: move session_counter into wlvif
  wl12xx: move some logic into wl12xx_init_vif_data
  wl12xx: move dev_hlid into wlvif
  wl12xx: move beacon_int into wlvif
  wl12xx: move default_key into wlvif
  wl12xx: move pspoll_work into wlvif
  wl12xx: move ps_compl into wlvif
  wl12xx: move ps_poll_failures and psm_entry_retry into wlvif
  wl12xx: move rssi_thold and last_rssi_event into wlvif
  wl12xx: move ba fields into wlvif
  wl12xx: move ap_hlid_map into wlvif.ap
  wl12xx: move recorded_ap_keys into wlvif

 drivers/net/wireless/wl12xx/acx.c     |  138 ++++---
 drivers/net/wireless/wl12xx/acx.h     |   75 ++--
 drivers/net/wireless/wl12xx/boot.c    |    3 -
 drivers/net/wireless/wl12xx/cmd.c     |  231 ++++++-----
 drivers/net/wireless/wl12xx/cmd.h     |   42 ++-
 drivers/net/wireless/wl12xx/debugfs.c |   23 +-
 drivers/net/wireless/wl12xx/event.c   |  103 +++--
 drivers/net/wireless/wl12xx/event.h   |    3 -
 drivers/net/wireless/wl12xx/init.c    |  413 ++++++++++---------
 drivers/net/wireless/wl12xx/init.h    |    7 +-
 drivers/net/wireless/wl12xx/main.c    |  754 +++++++++++++++++---------------
 drivers/net/wireless/wl12xx/ps.c      |   14 +-
 drivers/net/wireless/wl12xx/ps.h      |    4 +-
 drivers/net/wireless/wl12xx/rx.c      |    4 +-
 drivers/net/wireless/wl12xx/scan.c    |   59 ++-
 drivers/net/wireless/wl12xx/scan.h    |    8 +-
 drivers/net/wireless/wl12xx/tx.c      |  165 ++++---
 drivers/net/wireless/wl12xx/tx.h      |    7 +-
 drivers/net/wireless/wl12xx/wl12xx.h  |  170 ++++----
 19 files changed, 1204 insertions(+), 1019 deletions(-)

-- 
1.7.6.401.g6a319


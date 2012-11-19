Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37423 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab2KSQja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:39:30 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2051722eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 08:39:29 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/15] wlcore: prepare to multi-channel
Date: Mon, 19 Nov 2012 18:39:15 +0200
Message-Id: <1353343170-26516-1-git-send-email-eliad@wizery.com> (sfid-20121119_173938_199656_600E7908)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the connection flow simpler by using only the sta
role (i.e. no need for dev role).

This is possible now, as we know the AP's BSSID even
before authentication.

This means we no longer start dev role when the device
is non-idle, so now we use the .remain_on_channel()
and start device role only then.

Finally, implement the chanctx callbacks in order to
have a clear per-vif channel (instead of the global
hw->channel)

(this patchset depends on
"mac80211: make remain_on_channel() op pass vif param")

Eliad Peller (15):
  wlcore: start sta role on CHANGED_BSSID
  wlcore: set ssid before starting station role
  wlcore: always use sta.hlid
  wlcore: workaround start_sta problem in wl12xx fw
  wlcore: implement .remain_on_channel() callback
  wlcore: use dev_hlid if the tx is offchannel
  wlcore: get channel from bss_conf instead of hw->conf
  wlcore: add chanctx implementation
  wlcore: remove channel handling from op_config
  wlcore: initiate ROC/CROC on sta state updates
  wlcore: set active psm on association
  wlcore: specify correct supported_rates
  wlcore: reconfigure rate policy on association
  wlcore: refactor CHANGED_HT handling
  wlcore: configure the remote rates with our own rates

 drivers/net/wireless/ti/wl12xx/main.c   |    9 +-
 drivers/net/wireless/ti/wlcore/cmd.c    |   56 ++--
 drivers/net/wireless/ti/wlcore/cmd.h    |    6 +-
 drivers/net/wireless/ti/wlcore/event.c  |    7 +
 drivers/net/wireless/ti/wlcore/main.c   |  663 ++++++++++++++++++-------------
 drivers/net/wireless/ti/wlcore/tx.c     |   14 +-
 drivers/net/wireless/ti/wlcore/wlcore.h |    6 +
 7 files changed, 454 insertions(+), 307 deletions(-)

-- 
1.7.6.401.g6a319


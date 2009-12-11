Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63492 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762572AbZLKLlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:41:36 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/31] wl1271: patches for wk50
Date: Fri, 11 Dec 2009 13:40:51 +0200
Message-Id: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These are the patches that have resulted from a one-week debug and
implementation camp with TI.  Mostly bug fixes and improvements, but also we
now added support for a new version of the firmware.

With these patches, the driver should be pretty much functional, even though
there are still a couple of known bugs.

Cheers,
Luca.

Juuso Oikarinen (15):
  wl1271: Configure smart-reflex paramter values.
  wl1271: Remove smart reflex ACX
  wl1271: Use slow rates for association messages
  wl1271: Fix event acknowledging functionality
  wl1271: prevent power save entry while not associated
  wl1271: Implement chipset boot retry
  wl1271: Add pre-power-on sleep
  wl1271: Remove beacon-loss-ind from PSM entry failure handling
  wl1271: Add rudimentary ad-hoc support
  wl1271: Change rates configured for templates
  wl1271: Fix supported rate management
  wl1271: Change booleans in struct wl1271 into a flags bitmask
  wl1271: Add support for acx_pm_config
  wl1271: Check vif for NULL when indicating beacon-loss
  wl1271: Prevent performing "join" before association

Luciano Coelho (16):
  wl1271: updated radio parameters structure for newer firmwares
  wl1271: updated general parameters structure for newer firmwares
  wl1271: update radio and general parameters values
  wl1271: added radio parameters configuration values newer firmwares
  wl1271: use join command with dummy BSSID
  wl1271: remove workaround for disconnection
  wl1271: fix tx power setting function
  wl1271: check result code from the join command
  wl1271: set null data template when BSSID is known
  wl1271: use the correct macro when setting the basic rates
  wl1271: implement dco itrim parameters setting
  wl1271: fix one typo in the rx_rssi_and_proc_compens values
  wl1271: add gpio_power file in debugfs to power the chip on and off
  wl1271: upload only the first 468 bytes from the NVS file
  wl1271: some new configuration values according to new reference
  wl1271: use channel 1 when configuring the data path

 drivers/net/wireless/wl12xx/wl1271.h         |   35 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c     |  142 +++++----
 drivers/net/wireless/wl12xx/wl1271_acx.h     |   37 +-
 drivers/net/wireless/wl12xx/wl1271_boot.c    |    8 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c     |   67 +++--
 drivers/net/wireless/wl12xx/wl1271_cmd.h     |   33 ++-
 drivers/net/wireless/wl12xx/wl1271_conf.h    |  100 ++++---
 drivers/net/wireless/wl12xx/wl1271_debugfs.c |   62 ++++
 drivers/net/wireless/wl12xx/wl1271_event.c   |   20 +-
 drivers/net/wireless/wl12xx/wl1271_event.h   |    2 +-
 drivers/net/wireless/wl12xx/wl1271_init.c    |   12 +-
 drivers/net/wireless/wl12xx/wl1271_main.c    |  456 +++++++++++++++++---------
 drivers/net/wireless/wl12xx/wl1271_ps.c      |   15 +-
 drivers/net/wireless/wl12xx/wl1271_tx.c      |   43 +++-
 14 files changed, 674 insertions(+), 358 deletions(-)


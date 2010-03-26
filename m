Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30656 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab0CZKxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:53:54 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/24] wl1271: bunch of patches from our internal tree wk12
Date: Fri, 26 Mar 2010 12:53:09 +0200
Message-Id: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are 25 more patches for wl1271 which are still pending in our internal
tree.  Please apply. :)

Cheers,
Luca.

Juuso Oikarinen (17):
  wl1271: Clean up RX rate reporting
  wl1271: Add TX rate reporting
  wl1271: Fix memory leaks in SPI initialization
  wl1271: Fix memory leak in scan command handling
  wl1271: Configure clock-request drive mode to open-drain
  wl1271: Fix memory leak in cmd_data_path
  wl1271: Update busyword checking mechanism
  wl1271: Remove device MAC-address randomization
  wl1271: Disable connection monitoring while not associated
  wl1271: Fix ad-hoc mode handling
  wl1271: Update beacon interval properly for ad-hoc
  wl1271: Fix memory leak in firmware crash scenario
  wl1271: Configure probe-request template when associated
  wl1271: Disconnect if PSM entry fails
  wl1271: Configure HW connection monitor
  wl1271: Add keep-alive frame template support
  wl1271: Enable hardware keep alive messages

Luciano Coelho (4):
  wl1271: fix wl1271_spi driver name
  wl1271: wait for join command complete event
  wl1271: wait for disconnect command complete event
  wl1271: remove deprecated usage of RX status noise

Saravanan Dhanabal (1):
  wl1271: Fix msleep() delay while waiting for completion

Teemu Paasikivi (2):
  wl1271: Warnings caused by wrong format specifiers fixed
  wl1271: Removed checking of PSM from handling BSS_LOST_EVENT

 drivers/net/wireless/wl12xx/wl1271.h       |   14 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c   |   73 ++++++++++-
 drivers/net/wireless/wl12xx/wl1271_acx.h   |   33 +++++-
 drivers/net/wireless/wl12xx/wl1271_boot.c  |   14 ++-
 drivers/net/wireless/wl12xx/wl1271_boot.h  |    7 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |   93 +++++++++++--
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |    9 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h  |   35 +++++
 drivers/net/wireless/wl12xx/wl1271_event.c |   40 +-----
 drivers/net/wireless/wl12xx/wl1271_init.c  |   46 +++++--
 drivers/net/wireless/wl12xx/wl1271_main.c  |  198 ++++++++++++++++++++++++----
 drivers/net/wireless/wl12xx/wl1271_rx.c    |   83 +-----------
 drivers/net/wireless/wl12xx/wl1271_rx.h    |    2 +-
 drivers/net/wireless/wl12xx/wl1271_sdio.c  |    4 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c   |   71 ++++-------
 drivers/net/wireless/wl12xx/wl1271_tx.c    |   37 +++--
 drivers/net/wireless/wl12xx/wl1271_tx.h    |    1 +
 17 files changed, 513 insertions(+), 247 deletions(-)


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:64841 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZJLMNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:13:20 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/16] Second batch of patches for wl1271
Date: Mon, 12 Oct 2009 15:08:41 +0300
Message-Id: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here is the second batch of patches to be included in wireless-testing.  I got
a few comments from Johannes about the first batch and those issues will be
fixed after I send the 3rd and final batch.

Cheers,
Luca.

Juuso Oikarinen (10):
  wl1271: Update memory mapping for firmware revision 6.1.0.0.241
  wl1271: Remove RX workaround
  wl1271: Add top-register access functions
  wl1271: RefClk configuration
  wl1271: Update interrupt handling by removing an extra SPI read
  wl1271: Enable ELP
  wl1271: Enable smart reflex
  wl1271: Update TX path block calucation algo
  wl1271: Remove outdated SPI functions
  wl1271: Update boot time configuration for the new firmware

Luciano Coelho (6):
  wl1271: implement cmd_disconnect
  wl1271: workaround to send a disconnect before rejoining
  wl1271: add workaround to avoid distortion due to excessive tx power
  wl1271: enable HW_AVAILABLE interrupt to fix ELP
  wl1271: use acx_rx_config instead of join when updating filters
  wl1271: remove unnecessary joins and join only when the bssid changes

 drivers/net/wireless/wl12xx/wl1271.h       |   14 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c   |   79 +++++++++-
 drivers/net/wireless/wl12xx/wl1271_acx.h   |   28 +++-
 drivers/net/wireless/wl12xx/wl1271_boot.c  |  177 ++++++++++----------
 drivers/net/wireless/wl12xx/wl1271_boot.h  |   22 +--
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |   68 +++++++--
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |   27 +++
 drivers/net/wireless/wl12xx/wl1271_event.c |    8 +-
 drivers/net/wireless/wl12xx/wl1271_init.c  |    7 +-
 drivers/net/wireless/wl12xx/wl1271_main.c  |  160 ++++++++----------
 drivers/net/wireless/wl12xx/wl1271_ps.c    |   11 +-
 drivers/net/wireless/wl12xx/wl1271_reg.h   |    3 +-
 drivers/net/wireless/wl12xx/wl1271_rx.c    |   14 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c   |  251 ++++++++++++----------------
 drivers/net/wireless/wl12xx/wl1271_spi.h   |   65 +++++---
 drivers/net/wireless/wl12xx/wl1271_tx.c    |   14 +-
 16 files changed, 531 insertions(+), 417 deletions(-)


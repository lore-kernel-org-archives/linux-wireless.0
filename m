Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64619 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289AbZJOHfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 03:35:13 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] wl1271: Endianess and power save mode fixes
Date: Thu, 15 Oct 2009 10:33:25 +0300
Message-Id: <1255592010-10287-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here are a few more patches for the wl1271 driver.  First, we have fixed a
problem with the null data packets which was causing problems with power save
mode on some APs.  We were not setting the FCTL_TODS bit as the specification
requires.

Second, we have fixed some sparse warnings and fixed the endianess handling in
the driver (it used to be written for little-endian archs only).

Cheers,
Luca.

Juuso Oikarinen (1):
  wl1271: Set IEEE80211_FCTL_TODS in the null data template

Luciano Coelho (4):
  wl1271: fix sparse warnings about undeclared functions
  wl1271: added missing packed modifier in some acx structs
  wl1271: fix endianess issues
  wl1271: added missing packed modifier in some cmd structs

 drivers/net/wireless/wl12xx/wl1271.h       |   10 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c   |   72 ++++----
 drivers/net/wireless/wl12xx/wl1271_acx.h   |  296 ++++++++++++++--------------
 drivers/net/wireless/wl12xx/wl1271_boot.c  |    6 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |   85 ++++----
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |   74 ++++----
 drivers/net/wireless/wl12xx/wl1271_event.c |    3 +-
 drivers/net/wireless/wl12xx/wl1271_event.h |   28 ++--
 drivers/net/wireless/wl12xx/wl1271_init.h  |    4 +-
 drivers/net/wireless/wl12xx/wl1271_main.c  |   12 +-
 drivers/net/wireless/wl12xx/wl1271_rx.c    |   11 +-
 drivers/net/wireless/wl12xx/wl1271_rx.h    |    4 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c   |    5 +-
 drivers/net/wireless/wl12xx/wl1271_tx.c    |   22 ++-
 drivers/net/wireless/wl12xx/wl1271_tx.h    |   18 +-
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    4 +-
 16 files changed, 336 insertions(+), 318 deletions(-)


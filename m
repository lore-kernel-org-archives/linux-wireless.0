Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:52147 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZKQQsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:48:19 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 00/16] wl1251: beacon filter support and more
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:48:05 +0200
Message-ID: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here is a set of patches for wl1251. New features are EEPROM NVS
support (from David-John Willis) and beacon filtering, but there are
also some serious fixes and optimisations.

These patches are not urgent.

---

David-John Willis (1):
      wl1251: add NVS in EEPROM support

Janne Ylalehto (2):
      wl1251: Filter out unwanted events
      wl1251: Add IRQ looping support

Juuso Oikarinen (5):
      wl1251: Fix regression in IRQ loop handling
      wl1251: Implement delayed entry into ELP mode
      wl1251: Configure beacon filtering on if PSM used
      wl1251: Enable beacon filtering with the stack
      wl1251: Add connection monitoring configuration

Kalle Valo (3):
      wl1251: remove depcreated qual usage
      wl1251: mask aid bits 14 and 15 in ps-poll template
      wl1251: allocate space for firmware with vmalloc()

Vidhya Govindan (5):
      wl1251: Send null data packet with "TODS" bit set
      wl1251: Increase the beacon loss timeout value and handle regain event
      wl1251: Set the correct dtim period to the firmware
      wl1251: Add acx command to set tbtt and dtim period
      wl1251: fix deadlock with ieee80211 beacon filter calls


 drivers/net/wireless/wl12xx/wl1251.h       |    5 +
 drivers/net/wireless/wl12xx/wl1251_acx.c   |   68 +++++++++++-
 drivers/net/wireless/wl12xx/wl1251_acx.h   |   36 ++++++
 drivers/net/wireless/wl12xx/wl1251_boot.c  |   55 +++++++---
 drivers/net/wireless/wl12xx/wl1251_event.c |   18 +++
 drivers/net/wireless/wl12xx/wl1251_init.c  |    8 +
 drivers/net/wireless/wl12xx/wl1251_main.c  |  162 ++++++++++++++++------------
 drivers/net/wireless/wl12xx/wl1251_ps.c    |   44 +++++++-
 drivers/net/wireless/wl12xx/wl1251_ps.h    |    1 
 drivers/net/wireless/wl12xx/wl1251_reg.h   |    6 +
 drivers/net/wireless/wl12xx/wl1251_rx.c    |    4 -
 drivers/net/wireless/wl12xx/wl1251_spi.c   |    2 
 include/linux/spi/wl12xx.h                 |    1 
 13 files changed, 314 insertions(+), 96 deletions(-)


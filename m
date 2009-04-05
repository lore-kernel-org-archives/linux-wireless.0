Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1609 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305AbZDECLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Apr 2009 22:11:08 -0400
From: Bob Copeland <me@bobcopeland.com>
To: kalle.valo@nokia.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/6] wl12xx updates
Date: Sat,  4 Apr 2009 22:10:22 -0400
Message-Id: <1238897428-19639-1-git-send-email-me@bobcopeland.com> (sfid-20090405_041125_414047_4322E3C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Here are some patches that bring wl12xx back to compiling state for
current wireless-testing.  This is on top of your original patch
from your web page.  Review at your leisure, and feel free to roll
them all up into your eventual post for inclusion.

Of note, possible incompatible changes are patch 2 which removes ssid
from the join command, and patch 3 which changes the platform setup
so it can compile on any platform.  Only compile-tested for now.

Bob Copeland (6):
  wl12xx: update to 2.6.29 mac80211 hw scan API
  wl12xx: remove ssid parameters from driver private struct
  wl12xx: separate platform data into arch-independent code
  wl12xx: update tx API usage
  wl12xx: update config callback parameters
  wl12xx: update set_key callback to match current API

 drivers/net/wireless/wl12xx/cmd.c    |    4 +--
 drivers/net/wireless/wl12xx/event.c  |    2 +-
 drivers/net/wireless/wl12xx/main.c   |   47 ++++++++++++++++++----------------
 drivers/net/wireless/wl12xx/tx.c     |   11 +++-----
 drivers/net/wireless/wl12xx/wl12xx.h |    7 +---
 include/linux/spi/wl12xx_spi.h       |   18 +++++++++++++
 6 files changed, 51 insertions(+), 38 deletions(-)
 create mode 100644 include/linux/spi/wl12xx_spi.h



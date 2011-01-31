Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61862 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab1AaQiC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 11:38:02 -0500
Received: by bwz15 with SMTP id 15so5416771bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 08:38:00 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 0/4] wl12xx: move to new firmware (6.1.3.50.49)
Date: Mon, 31 Jan 2011 18:38:15 +0200
Message-Id: <1296491899-25440-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the wl12xx driver start working with the latest
wl12xx firmware (6.1.3.50.49).

The patchset only migrates exisiting functionality. 
(i.e. it doesn't contain the new firmware features)

Note that this new firmware is not backward compatible with the
current firmware, so a new firmware name is being used.

Eliad Peller (4):
  wl12xx: mcp2.5 - add config_ps acx
  wl12xx: move to new firmware (6.1.3.50.49)
  wl12xx: use the conf struct instead of macros for memory
    configuration
  wl12xx: set supported_rates after association

 drivers/net/wireless/wl12xx/acx.c    |   86 ++++++++++++++++++---
 drivers/net/wireless/wl12xx/acx.h    |   41 ++++++++---
 drivers/net/wireless/wl12xx/cmd.c    |   10 +-
 drivers/net/wireless/wl12xx/cmd.h    |   14 +---
 drivers/net/wireless/wl12xx/conf.h   |   49 ++++++++++++
 drivers/net/wireless/wl12xx/event.c  |   14 ----
 drivers/net/wireless/wl12xx/event.h  |    2 -
 drivers/net/wireless/wl12xx/init.c   |   13 +++
 drivers/net/wireless/wl12xx/main.c   |  142 ++++++++++++++++------------------
 drivers/net/wireless/wl12xx/ps.c     |    6 +-
 drivers/net/wireless/wl12xx/rx.c     |    6 +-
 drivers/net/wireless/wl12xx/rx.h     |    2 +-
 drivers/net/wireless/wl12xx/tx.c     |   22 -----
 drivers/net/wireless/wl12xx/wl12xx.h |   66 +++++++++++-----
 14 files changed, 297 insertions(+), 176 deletions(-)


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52466 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1BBH7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 02:59:43 -0500
Received: by wwi17 with SMTP id 17so5712063wwi.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 23:59:42 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 0/4] wl12xx: move to new firmware (6.1.3.50.49)
Date: Wed,  2 Feb 2011 09:59:33 +0200
Message-Id: <1296633577-15199-1-git-send-email-eliad@wizery.com>
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
 drivers/net/wireless/wl12xx/acx.h    |   41 +++++++---
 drivers/net/wireless/wl12xx/cmd.c    |   10 +-
 drivers/net/wireless/wl12xx/cmd.h    |   14 +---
 drivers/net/wireless/wl12xx/conf.h   |   49 ++++++++++++
 drivers/net/wireless/wl12xx/event.c  |   14 ----
 drivers/net/wireless/wl12xx/event.h  |    2 -
 drivers/net/wireless/wl12xx/init.c   |   13 +++
 drivers/net/wireless/wl12xx/main.c   |  143 ++++++++++++++++-----------------
 drivers/net/wireless/wl12xx/ps.c     |    6 +-
 drivers/net/wireless/wl12xx/rx.c     |    6 +-
 drivers/net/wireless/wl12xx/rx.h     |    2 +-
 drivers/net/wireless/wl12xx/tx.c     |   22 -----
 drivers/net/wireless/wl12xx/wl12xx.h |   66 +++++++++++-----
 14 files changed, 298 insertions(+), 176 deletions(-)


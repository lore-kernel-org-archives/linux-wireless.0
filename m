Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:35252 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755476Ab1BIBli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 20:41:38 -0500
Received: by mail-qy0-f179.google.com with SMTP id 19so4778506qyj.17
        for <linux-wireless@vger.kernel.org>; Tue, 08 Feb 2011 17:41:36 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 8 Feb 2011 23:41:36 -0200
Message-ID: <AANLkTins2XMBb0NuEdJVaBX=Pz6=pVpbfiXNqAF409Fs@mail.gmail.com>
Subject: pull request: wl12xx 2011-02-08
From: "Coelho, Luciano" <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is one more pull request for 2.6.39.  It contains initial changes
that add support to our new firmware.  There are some other patches
pending, but I'm currently on vacation, so I didn't have much time to
look into them carefully, so let's hold them till I'm back.  I had
already reviewed carefully the changes for the new firmware, so they
can be included already now.

Please pull or let me know if there's any problem.  This tree is based
on wireless-next/master.

Thanks!


The following changes since commit 3ad97fbcc233a295f2ccc2c6bdeb32323e360a5e:

 mac80211: remove unneeded check (2011-02-07 16:18:28 -0500)

are available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville

Eliad Peller (4):
     wl12xx: mcp2.5 - add config_ps acx
     wl12xx: move to new firmware (6.1.3.50.49)
     wl12xx: use the conf struct instead of macros for memory configuration
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

--
Cheers,
Luca.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:56368 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943Ab1DTS3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 14:29:54 -0400
Received: by mail-ew0-f53.google.com with SMTP id 8so328533ewy.12
        for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2011 11:29:51 -0700 (PDT)
Subject: pull request: wl12xx 2011-04-20
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 21:32:20 +0300
Message-ID: <1303324340.1988.750.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello John,

First pull for 2.6.40.  It took some time, because I wanted to make sure
some tricky issues were stable enough (now I hope they are!) The biggest
change here is support for WL128x chipsets.  The rest of the patches are
some clean-ups and small improvements.

Please pull or let me know if there's any problem.  This tree is based
on wireless-next/master.

Thanks!

The following changes since commit 34a0a2025c8bddc6505b56a58ef2e7333a4e4165:

  ath: Add a missing world regulatory domain 0x6C (2011-04-14 15:35:14 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville

Arik Nemtsov (3):
      wl12xx: 1281/1283 support - Use different FW file for AP mode wl127x/wl128x chips
      wl12xx: Clamp byte mode transfers for 128x chips
      wl12xx: configure channel/band while FW is off

Eliad Peller (2):
      wl12xx: set the actual tid instead of the ac
      wl12xx: rearrange some ELP wake_up/sleep calls

Ido Yariv (5):
      wl12xx: Clean up and fix the 128x boot sequence
      wl12xx: Clean up the block size alignment code
      wl12xx: Clean up the dummy packet mechanism
      wl12xx: Simplify TX blocks accounting
      wl12xx: Handle platforms without level trigger interrupts

Juuso Oikarinen (3):
      wl12xx: Fix potential incorrect band in rx-status
      wl12xx: Add mutex protection for interface list
      wl12xx: Handle duplicate calling of remove interface

Luciano Coelho (11):
      wl12xx: add new board_tcxo_clock element to the platform data
      wl12xx: 1281/1283 support - add block size handling for sdio and spi
      wl12xx: use 1 spare TX block instead of two
      wl12xx: set the skbuff priority for dummy packets
      wl12xx: fix SG BT load value to reflect its new meaning
      wl12xx: fix a couple of sparse warnings about undeclared functions
      wl12xx: use a bitmask instead of list of booleans in scanned_ch
      wl12xx: use kstrtoul functions
      wl12xx: move hardcoded hci_io_ds value into the conf struct
      wl12xx: remove unused conf_radio_params structure
      wl12xx: fix sparse warning about undeclared wl12xx_alloc_dummy_packet

Ohad Ben-Cohen (3):
      wl12xx: update bet_max_consecutive
      wl12xx: fix roaming
      wl12xx: fix "JOIN while associated" commentary

Shahar Levi (11):
      wl12xx: 1281/1283 support - move IRQ polarity
      wl12xx: 1281/1283 support - Add Definitions
      wl12xx: 1281/1283 support - Add acx commands
      wl12xx: 1281/1283 support - New radio structs and functions
      wl12xx: 1281/1283 support - Loading FW & NVS
      wl12xx: 1281/1283 support - New boot sequence
      wl12xx: 1281/1283 support - use dynamic memory for the RX/TX pools
      wl12xx: 1281/1283 support - Improve Tx & Rx path
      wl12xx: 1281/1283 support - Add dummy packet support
      wl12xx: 1281/1283 support - enable chip support
      wl12xx: Add support for 11n Rx STBC one spatial stream

 drivers/net/wireless/wl12xx/Kconfig     |    2 +-
 drivers/net/wireless/wl12xx/acx.c       |   59 +++++-
 drivers/net/wireless/wl12xx/acx.h       |   11 +
 drivers/net/wireless/wl12xx/boot.c      |  279 +++++++++++++++++++++----
 drivers/net/wireless/wl12xx/boot.h      |   52 +++++
 drivers/net/wireless/wl12xx/cmd.c       |   97 ++++++++-
 drivers/net/wireless/wl12xx/cmd.h       |   34 +++
 drivers/net/wireless/wl12xx/conf.h      |   17 +-
 drivers/net/wireless/wl12xx/debugfs.c   |    2 +-
 drivers/net/wireless/wl12xx/event.c     |   17 +-
 drivers/net/wireless/wl12xx/event.h     |    5 +-
 drivers/net/wireless/wl12xx/ini.h       |   98 +++++++++-
 drivers/net/wireless/wl12xx/init.c      |   45 ++++-
 drivers/net/wireless/wl12xx/init.h      |    1 +
 drivers/net/wireless/wl12xx/io.c        |   11 +
 drivers/net/wireless/wl12xx/io.h        |    3 +
 drivers/net/wireless/wl12xx/main.c      |  343 +++++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/ps.c        |    3 -
 drivers/net/wireless/wl12xx/reg.h       |   15 +--
 drivers/net/wireless/wl12xx/rx.c        |   44 +++--
 drivers/net/wireless/wl12xx/scan.c      |   17 +-
 drivers/net/wireless/wl12xx/sdio.c      |   27 +++-
 drivers/net/wireless/wl12xx/sdio_test.c |   20 ++-
 drivers/net/wireless/wl12xx/spi.c       |   17 ++-
 drivers/net/wireless/wl12xx/testmode.c  |    6 +-
 drivers/net/wireless/wl12xx/tx.c        |  234 ++++++++++++++++------
 drivers/net/wireless/wl12xx/tx.h        |   60 +++++-
 drivers/net/wireless/wl12xx/wl12xx.h    |   65 +++++-
 include/linux/wl12xx.h                  |   29 +++-
 29 files changed, 1324 insertions(+), 289 deletions(-)

-- 
Cheers,
Luca.


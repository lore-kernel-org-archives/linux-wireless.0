Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:43317 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYLTKBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 05:01:51 -0500
Received: by ewy10 with SMTP id 10so1457082ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 02:01:49 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Sat, 20 Dec 2008 10:52:00 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Message-Id: <200812201052.00655.IvDoorn@gmail.com> (sfid-20081220_110204_813546_7AFE4E2B)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the latest rt2x00 update.
Lots of new features, optimizations and cleanups.

Ivo

---
The following changes since commit 30b5741a6880688c4540c8f80f90371f42b05a63:
  Winkler, Tomas (1):
        iwl3945: use iwl_rb_status

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Andrey Yurovsky (1):
      rt2x00: Add mesh support

Ivo van Doorn (14):
      rt2x00: Implement Powersaving
      rt2x00: Move link tuning into seperate file
      rt2x00: Reduce calls to bbp_read()
      rt2x00: Restrict interface between rt2x00link and drivers
      rt2x00: Add RFKILL support to rt2500usb and rt73usb
      rt2x00: Rename CONFIG_CRYPTO_COPY_IV
      rt2x00: Implement WDS support
      rt2x00: Split EEPROM_NIC_TX_RX_FIXED
      rt2x00: Move code into seperate functions
      rt2x00: Remove ENTRY_TXD_OFDM_RATE
      rt2x00: Allow drivers to pass the noise value during rxdone
      rt2x00: Introduce RXDONE_SIGNAL_MASK mask
      rt2x00: Fix segementation fault
      rt2x00: Release rt2x00 2.3.0

 drivers/net/wireless/rt2x00/Makefile       |    1 +
 drivers/net/wireless/rt2x00/rt2400pci.c    |   60 +++-
 drivers/net/wireless/rt2x00/rt2500pci.c    |   88 ++++--
 drivers/net/wireless/rt2x00/rt2500usb.c    |   58 ++++-
 drivers/net/wireless/rt2x00/rt2500usb.h    |    8 +
 drivers/net/wireless/rt2x00/rt2x00.h       |  131 +++------
 drivers/net/wireless/rt2x00/rt2x00config.c |    7 +-
 drivers/net/wireless/rt2x00/rt2x00crypto.c |   13 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c  |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |  322 ++------------------
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   87 +++++-
 drivers/net/wireless/rt2x00/rt2x00link.c   |  461 ++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00mac.c    |   42 ++-
 drivers/net/wireless/rt2x00/rt2x00queue.c  |  193 ++++++------
 drivers/net/wireless/rt2x00/rt2x00queue.h  |   15 +-
 drivers/net/wireless/rt2x00/rt2x00reg.h    |   10 +
 drivers/net/wireless/rt2x00/rt2x00usb.c    |    6 +-
 drivers/net/wireless/rt2x00/rt61pci.c      |  144 +++++----
 drivers/net/wireless/rt2x00/rt61pci.h      |    7 +-
 drivers/net/wireless/rt2x00/rt73usb.c      |  134 ++++++---
 drivers/net/wireless/rt2x00/rt73usb.h      |   13 +
 21 files changed, 1138 insertions(+), 666 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00link.c

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58487 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab0KID0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 22:26:39 -0500
Date: Tue, 9 Nov 2010 01:26:51 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull request: bluetooth-2.6 2010-11-09
Message-ID: <20101109032651.GB27554@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

The following batch contains some bugfixes for 2.6.37. A fix for unaligned
access in L2CAP, a Kconfig error, two fixes related to security of
the Bluetooth links, and support for the a MacBook Air Bluetooth device.
There is also a one line patch from Matthew Garret, that enables USB
autosuspend for btusb module, which shall be completely safe. Please
pull, thanks.

The following changes since commit 48a7c3df14d0cda850337a9b3f9e667a0b12a996:

  ath9k_hw: Fix memory leak on ath9k_hw_rf_alloc_ext_banks failure (2010-11-08 16:53:48 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master

Edgar (gimli) Hucek (1):
      Bluetooth: Add MacBookAir3,1(2) support

Gustavo F. Padovan (1):
      Bluetooth: fix endianness conversion in L2CAP

Johan Hedberg (1):
      Bluetooth: Fix non-SSP auth request for HIGH security level sockets

Luiz Augusto von Dentz (1):
      Bluetooth: fix not setting security level when creating a rfcomm session

Matthew Garrett (1):
      Bluetooth: Enable USB autosuspend by default on btusb

Randy Dunlap (1):
      Bluetooth: fix hidp kconfig dependency warning

steven miao (1):
      Bluetooth: fix unaligned access to l2cap conf data

 drivers/bluetooth/btusb.c   |    5 +++++
 net/bluetooth/hci_event.c   |    6 ++++++
 net/bluetooth/hidp/Kconfig  |    2 +-
 net/bluetooth/l2cap.c       |    8 ++++----
 net/bluetooth/rfcomm/core.c |   13 ++++++++++---
 5 files changed, 26 insertions(+), 8 deletions(-)

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi

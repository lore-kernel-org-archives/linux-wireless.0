Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47980 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab1BROGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 09:06:35 -0500
Date: Fri, 18 Feb 2011 10:59:56 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next-2.6 2011-02-17
Message-ID: <20110218135956.GA2256@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Busy times at the Bluetooth subsystem. Here is another big set of patches
intended to 2.6.39. ;)

One of the changes is the end of the L2CAP and SCO kernel modules. We just
merged them into the main bluetooth.ko module. It really never made sense to
have them separated. 

Then we have firmware support to a new Atheros device by Bala Shanmugam.
The First set of patches for Bluetooth Low Energy(LE) support, by Ville Tervo.
Low Energy is a new Bluetooth radio that will bring many new use cases to the
Bluetooth technology. Finally, LE connection update command support by Claudio
Takahasi. The rest is just bugs fixes and cleanups. 

Please pull, or let me know any doubts you have. Thanks.

The following changes since commit a3dc5e881a8a5199bf371fdd4530cfa18280ca83:

  rtlwifi: rtl8192ce: Rework rtl8192ce/phy.c (2011-02-11 16:16:38 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next-2.6.git master

Andrei Warkentin (1):
      Bluetooth: Make hci a child of the corresponding tty device.

Bala Shanmugam (1):
      Bluetooth: Add firmware support for Atheros 3012

Claudio Takahasi (3):
      Bluetooth: Add LE signaling commands handling
      Bluetooth: Add connection parameter update response
      Bluetooth: Send LE Connection Update Command

Gustavo F. Padovan (8):
      Bluetooth: Merge L2CAP and SCO modules into bluetooth.ko
      Bluetooth: remove l2cap_load() hack
      Bluetooth: Add L2CAP mode to debugfs output
      Bluetooth: Use usb_fill_int_urb()
      Bluetooth: Fix crash when ioctl(HCIUARTSETPROTO) fails
      Bluetooth: fix errors reported by checkpatch.pl
      Bluetooth: Fix errors reported by checkpatch.pl
      Bluetooth: fix checkpatch errors in af_bluetooth.c

Szymon Janc (5):
      Bluetooth: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
      Bluetooth: Clean up hci_sniff_subrate_evt function
      Bluetooth: Fix some code style issues in hci_core.h
      Bluetooth: Fix some code style issues in hci_core.c
      Bluetooth: Fix some code style issues in hci_event.c

Vasiliy Kulikov (3):
      Bluetooth: l2cap: fix 1 byte infoleak to userspace
      Bluetooth: bnep: fix buffer overflow
      Bluetooth: sco: fix information leak to userspace

Ville Tervo (9):
      Bluetooth: Add low energy commands and events
      Bluetooth: Add LE connect support
      Bluetooth: Use LE buffers for LE traffic
      Bluetooth: Add LE connection support to L2CAP
      Bluetooth: Add server socket support for LE connection
      Bluetooth: Do not send disconn comand over LE links
      Bluetooth: Treat LE and ACL links separately on timeout
      Bluetooth: Add SMP command structures
      Bluetooth: Use proper timer for hci command timout

Vinicius Costa Gomes (1):
      Bluetooth: Fix initiated LE connections

 drivers/bluetooth/ath3k.c         |  279 +++++++++++++++++++++++++++++
 drivers/bluetooth/btusb.c         |   13 +-
 drivers/bluetooth/hci_ldisc.c     |    1 +
 include/net/bluetooth/bluetooth.h |   28 +++
 include/net/bluetooth/hci.h       |   65 +++++++
 include/net/bluetooth/hci_core.h  |   92 ++++++----
 include/net/bluetooth/l2cap.h     |   23 +++-
 include/net/bluetooth/smp.h       |   76 ++++++++
 net/bluetooth/Kconfig             |   10 +-
 net/bluetooth/Makefile            |    5 +-
 net/bluetooth/af_bluetooth.c      |   34 ++++-
 net/bluetooth/bnep/core.c         |    2 -
 net/bluetooth/bnep/sock.c         |    1 +
 net/bluetooth/cmtp/core.c         |    2 -
 net/bluetooth/hci_conn.c          |   77 ++++++++-
 net/bluetooth/hci_core.c          |  115 ++++++++++--
 net/bluetooth/hci_event.c         |  165 +++++++++++++++--
 net/bluetooth/hci_sysfs.c         |    6 +-
 net/bluetooth/hidp/core.c         |    2 -
 net/bluetooth/l2cap_core.c        |  355 ++++++++++++++++++++++++++++---------
 net/bluetooth/l2cap_sock.c        |   60 ++++---
 net/bluetooth/mgmt.c              |    2 +-
 net/bluetooth/rfcomm/core.c       |    2 -
 net/bluetooth/sco.c               |   17 +--
 24 files changed, 1196 insertions(+), 236 deletions(-)
 create mode 100644 include/net/bluetooth/smp.h

-- 
Gustavo F. Padovan
http://profusion.mobi

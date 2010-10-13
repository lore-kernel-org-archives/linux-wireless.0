Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64916 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab0JMJr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 05:47:57 -0400
Date: Wed, 13 Oct 2010 00:48:08 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next-2.6 2010-10-13
Message-ID: <20101013034808.GA3205@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here goes the Bluetooth patches for the next merge window. In this
patchset we have a new stream-oriented recvmsg() which is used in L2CAP
and RFCOMM. Support for two new MacBookPro devices. A buffer overflow
check for L2CAP to prevent frames exceeding the receiving MTU. All the
rest are simple bugfixes. No big features this time.

One notable change is in the MAINTAINERS file, From now and on I'm going
to maintain the Bluetooth trees as well as send the pull requests to you.
Despite this maintenance change, Marcel will remain helping with patch
review, and ACK/NAK in the Bluetooth subsystem as he always did. Not a
big change in the end. ;)

Thanks,

The following changes since commit 29b4433d991c88d86ca48a4c1cc33c671475be4b:

  net: percpu net_device refcount (2010-10-12 12:35:25 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next-2.6.git master

Andrei Emeltchenko (4):
      Bluetooth: remove extra newline from debug output
      Bluetooth: check L2CAP length in first ACL fragment
      Bluetooth: check for l2cap header in start fragment
      Bluetooth: clean up rfcomm code

David Vrabel (2):
      Bluetooth: HCI devices are either BR/EDR or AMP radios
      Bluetooth: Support SDIO devices that are AMP controllers

Gustavo F. Padovan (4):
      Bluetooth: remove unused variable from cmtp
      Bluetooth: make batostr() print in the right order
      Bluetooth: Use the proper error value from bt_skb_send_alloc()
      Bluetooth: update MAINTAINERS for Bluetooth subsys

Haijun Liu (1):
      Bluetooth: Update conf_state before send config_req out

Johan Hedberg (1):
      Bluetooth: Don't clear the blacklist when closing the HCI device

Karl Beldan (1):
      Bluetooth: hci_uart: Fix typo in stats for sco tx

Mat Martineau (4):
      Bluetooth: Validate PSM values in calls to connect() and bind()
      Bluetooth: Add common code for stream-oriented recvmsg()
      Bluetooth: Use common SOCK_STREAM receive code in RFCOMM
      Bluetooth: Use a stream-oriented recvmsg with SOCK_STREAM L2CAP sockets.

Nobuhiro Iwamatsu (2):
      Bluetooth: Add support Bluetooth controller of MacbookPro 6,2
      Bluetooth: Add support Bluetooth controller of MacbookPro 7,1

Yuri Kululin (1):
      Bluetooth: Fix RFCOMM RPN negotiation

 MAINTAINERS                       |    5 ++-
 drivers/bluetooth/btmrvl_main.c   |    4 +-
 drivers/bluetooth/btsdio.c        |    8 +++
 drivers/bluetooth/btusb.c         |    6 ++
 drivers/bluetooth/hci_ldisc.c     |    2 +-
 include/linux/mmc/sdio_ids.h      |    1 +
 include/net/bluetooth/bluetooth.h |    2 +
 include/net/bluetooth/hci.h       |    2 +-
 include/net/bluetooth/rfcomm.h    |    5 --
 net/bluetooth/af_bluetooth.c      |  109 +++++++++++++++++++++++++++++++++++++
 net/bluetooth/cmtp/core.c         |    6 +--
 net/bluetooth/hci_core.c          |    1 -
 net/bluetooth/hci_sysfs.c         |   21 ++-----
 net/bluetooth/hidp/core.c         |    8 +--
 net/bluetooth/l2cap.c             |   56 ++++++++++++++++---
 net/bluetooth/lib.c               |    4 +-
 net/bluetooth/rfcomm/core.c       |   39 +++++++-------
 net/bluetooth/rfcomm/sock.c       |  104 ++---------------------------------
 net/bluetooth/rfcomm/tty.c        |    4 +-
 19 files changed, 218 insertions(+), 169 deletions(-)


-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi

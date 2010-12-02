Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38684 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0LBAbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 19:31:44 -0500
Date: Wed, 1 Dec 2010 22:32:01 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next-2.6 2010-11-01
Message-ID: <20101202003201.GN16125@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are the first batch for 2.6.38, biggest change here is the move of
the Remote Name Request to the kernel to fix some synchronization
problems with other commands sent during the connection setup in
Bluetooth. The rest is just bug fixes and clean ups in the whole stack,
no big feature this time.

This pull request includes the patches that I sent in the pull request
to 2.6.37, but you should expect no problem when merging everything in
wireless-next-2.6.

Please pull or let me know anything wrong. Thanks.


The following changes since commit 61790c5f3c5f158821821a00797d94504531839f:

  iwlagn: fix microcode error on 4965 (2010-11-30 13:58:18 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next-2.6.git master

Anderson Lizardo (1):
      Bluetooth: Fix error handling for l2cap_init()

Andrei Emeltchenko (8):
      Bluetooth: Check sk is not owned before freeing l2cap_conn
      Bluetooth: timer check sk is not owned before freeing
      Bluetooth: do not use assignment in if condition
      Bluetooth: clean up sco code
      Bluetooth: clean up rfcomm code
      Bluetooth: clean up l2cap code
      Bluetooth: clean up hci code
      Bluetooth: clean up legal text

Bala Shanmugam (1):
      Bluetooth: Add new PID for Atheros 3011

Gustavo F. Padovan (4):
      Bluetooth: Fix not returning proper error in SCO
      Merge git://git.kernel.org/.../padovan/bluetooth-2.6 into test
      Bluetooth: Get rid of __l2cap_get_sock_by_psm()
      Bluetooth: Get rid of __rfcomm_get_sock_by_channel()

Johan Hedberg (3):
      Bluetooth: Simplify remote features callback function logic
      Bluetooth: Create a unified authentication request function
      Bluetooth: Automate remote name requests

Stefan Seyfried (1):
      Bluetooth: Fix log spamming in btusb due to autosuspend

Vasiliy Kulikov (3):
      Bluetooth: bnep: fix information leak to userland
      Bluetooth: cmtp: fix information leak to userland
      Bluetooth: hidp: fix information leak to userland

 drivers/bluetooth/ath3k.c        |    4 +
 drivers/bluetooth/btusb.c        |   12 ++-
 include/net/bluetooth/hci.h      |   16 ++--
 include/net/bluetooth/hci_core.h |   14 ++--
 include/net/bluetooth/l2cap.h    |   22 +++---
 include/net/bluetooth/rfcomm.h   |   18 ++--
 include/net/bluetooth/sco.h      |   20 ++--
 net/bluetooth/bnep/core.c        |    1 +
 net/bluetooth/cmtp/core.c        |    1 +
 net/bluetooth/hci_conn.c         |   23 +++--
 net/bluetooth/hci_core.c         |   66 +++++++++-----
 net/bluetooth/hci_event.c        |  177 +++++++++++++++++++++++++++-----------
 net/bluetooth/hci_sock.c         |   17 +++--
 net/bluetooth/hidp/core.c        |    2 +-
 net/bluetooth/l2cap.c            |   94 ++++++++++++++-------
 net/bluetooth/rfcomm/core.c      |    8 +-
 net/bluetooth/rfcomm/sock.c      |   24 ++---
 net/bluetooth/rfcomm/tty.c       |   28 ++++---
 net/bluetooth/sco.c              |   28 ++++---
 19 files changed, 363 insertions(+), 212 deletions(-)

-- 
Gustavo F. Padovan
http://profusion.mobi

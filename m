Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42971 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1BHR2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 12:28:35 -0500
Date: Tue, 8 Feb 2011 15:29:06 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next-2.6 2011-02-08
Message-ID: <20110208172905.GA2160@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

That is a big one. The major things here are the HCI management interface and
the l2cap.c file split. On the HCI management interface Johan Hedberg took a
big step implement support for many HCI commandsi/events in kernel side.
I did the l2cap.c split, that file was almost 5000 lines big a more code is
expected to come soon.
The rest are only bug fixes, expect a patch from Andrei Emeltchenko to add
support to configure the flushable flag in LMP.

Please pull. Thanks. 


The following changes since commit 3ad97fbcc233a295f2ccc2c6bdeb32323e360a5e:

  mac80211: remove unneeded check (2011-02-07 16:18:28 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next-2.6.git master

Andrei Emeltchenko (3):
      Bluetooth: Use non-flushable by default L2CAP data packets
      Bluetooth: Do not use assignments in IF conditions
      Bluetooth: fix crash by disabling tasklet in sock accept

Bao Liang (1):
      Bluetooth: Set conn state to BT_DISCONN to avoid multiple responses

Cho, Yu-Chen (1):
      Bluetooth: add Atheros BT AR9285 fw supported

Gustavo F. Padovan (19):
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-2.6 into wireless
      Bluetooth: Fix setting of MTU for ERTM and Streaming Mode
      Bluetooth: Rename l2cap.c to l2cap_core.c
      Bluetooth: Initial work for L2CAP split.
      Bluetooth: move l2cap_sock_ops to l2cap_sock.c
      Bluetooth: move l2cap_sock_release() to l2cap_sock.c
      Bluetooth: move l2cap_sock_bind()/listen() to l2cap_sock.c
      Bluetooth: move l2cap_sock_accept() to l2cap_sock.c
      Bluetooth: move l2cap_sock_getname() to l2cap_sock.c
      Bluetooth: move l2cap_sock_setsockopt() to l2cap_sock.c
      Bluetooth: move l2cap_sock_getsockopt() to l2cap_sock.c
      Bluetooth: move l2cap_sock_connect() to l2cap_sock.c
      Bluetooth: move l2cap_sock_recvmsg() to l2cap_sock.c
      Bluetooth: move l2cap_sock_shutdown() to l2cap_sock.c
      Bluetooth: move l2cap_sock_sendmsg() to l2cap_sock.c
      Bluetooth: move L2CAP sock timers function to l2cap_sock.c
      Bluetooth: move l2cap_sock_kill() to l2cap_sock.c
      Bluetooth: move __l2cap_sock_close() to l2cap_sock.c
      Bluetooth: update Bluetooth daemon name in Kconfig help

Jesper Juhl (1):
      Bluetooth: Fix failure to release lock in read_index_list()

Johan Hedberg (25):
      Bluetooth: Implement automatic setup procedure for local adapters
      Bluetooth: Add support for management powered event
      Bluetooth: Add support for set_powered management command
      Bluetooth: Add support for set_discoverable management command
      Bluetooth: Add set_connectable management command
      Bluetooth: Unify mode related management messages to a single struct
      Bluetooth: Add flag to track managment controlled adapters
      Bluetooth: Add send_mode_rsp convenience function for mgmt.c
      Bluetooth: Implement set_pairable managment command
      Bluetooth: Implement UUID handling through the management interface
      Bluetooth: Implement debugfs support for listing UUIDs
      Bluetooth: Reject pairing requests when in non-pairable mode
      Bluetooth: Add special handling with __hci_request and HCI_INIT
      Bluetooth: Add controller side link key clearing to hci_init_req
      Bluetooth: Remove page timeout setting from HCI init sequence
      Bluetooth: Implement a more complete adapter initialization sequence
      Bluetooth: Add class of device control to the management interface
      Bluetooth: Implement link key handling for the management interface
      Bluetooth: Add connected/disconnected management events
      Bluetooth: Add disconnect managment command
      Bluetooth: Add support for connect failed management event
      Bluetooth: Add get_connections managment interface command
      Bluetooth: Create common cmd_complete function for mgmt.c
      Bluetooth: Add support for PIN code handling in the management interface
      Bluetooth: Add set_io_capability management command

Rogério Brito (1):
      Bluetooth: ath3k: Avoid duplication of code

 drivers/bluetooth/ath3k.c               |   10 +-
 drivers/bluetooth/btusb.c               |    3 +
 include/net/bluetooth/bluetooth.h       |    5 +
 include/net/bluetooth/hci.h             |   57 ++
 include/net/bluetooth/hci_core.h        |   62 ++-
 include/net/bluetooth/l2cap.h           |   32 +
 include/net/bluetooth/mgmt.h            |  142 +++
 net/bluetooth/Kconfig                   |    6 +-
 net/bluetooth/Makefile                  |    1 +
 net/bluetooth/af_bluetooth.c            |   19 +-
 net/bluetooth/cmtp/capi.c               |    3 +-
 net/bluetooth/cmtp/core.c               |    9 +-
 net/bluetooth/hci_conn.c                |    1 +
 net/bluetooth/hci_core.c                |  230 ++++-
 net/bluetooth/hci_event.c               |  457 +++++++++-
 net/bluetooth/hci_sock.c                |    6 +-
 net/bluetooth/hci_sysfs.c               |   52 +
 net/bluetooth/hidp/core.c               |    9 +-
 net/bluetooth/{l2cap.c => l2cap_core.c} | 1618 ++++++-------------------------
 net/bluetooth/l2cap_sock.c              | 1150 ++++++++++++++++++++++
 net/bluetooth/mgmt.c                    | 1310 +++++++++++++++++++++++---
 21 files changed, 3668 insertions(+), 1514 deletions(-)
 rename net/bluetooth/{l2cap.c => l2cap_core.c} (78%)
 create mode 100644 net/bluetooth/l2cap_sock.c

--
Gustavo F. Padovan
http://profusion.mobi

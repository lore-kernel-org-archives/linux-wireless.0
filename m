Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:34740 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab0GUSBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 14:01:17 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: =?UTF-8?q?Pull=20request=3A=20bluetooth-next-2=2E6=202010-07-21?=
Date: Wed, 21 Jul 2010 11:01:04 -0700
Message-Id: <cover.1279734130.git.marcel@holtmann.org>
MIME-Version: 1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

these are the Bluetooth patches for 2.6.36 merge window. The big chunk is
from the L2CAP extension that we are now enabling by default. Everything
else are minor fixes and there is one new driver.

Regards

Marcel


Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-next-2.6.git master

This will update the following files:

 drivers/bluetooth/Kconfig          |   12 +
 drivers/bluetooth/Makefile         |    1 +
 drivers/bluetooth/bcm203x.c        |    3 +-
 drivers/bluetooth/bpa10x.c         |    2 +-
 drivers/bluetooth/btmrvl_debugfs.c |    2 +-
 drivers/bluetooth/btmrvl_drv.h     |    5 +-
 drivers/bluetooth/btmrvl_main.c    |    5 +-
 drivers/bluetooth/btmrvl_sdio.c    |  111 +++---
 drivers/bluetooth/btusb.c          |   13 +-
 drivers/bluetooth/dtl1_cs.c        |    2 +-
 drivers/bluetooth/hci_ath.c        |  235 +++++++++++++
 drivers/bluetooth/hci_ldisc.c      |   20 +-
 drivers/bluetooth/hci_ll.c         |    2 +-
 drivers/bluetooth/hci_uart.h       |   15 +-
 fs/compat_ioctl.c                  |    9 +-
 include/net/bluetooth/bluetooth.h  |    3 +-
 include/net/bluetooth/hci.h        |  187 +++++-----
 include/net/bluetooth/hci_core.h   |   28 +-
 include/net/bluetooth/l2cap.h      |   34 +-
 include/net/bluetooth/rfcomm.h     |   14 +-
 net/bluetooth/Kconfig              |   13 -
 net/bluetooth/hci_conn.c           |    2 +-
 net/bluetooth/hci_core.c           |  204 ++++++++----
 net/bluetooth/hci_event.c          |    8 +-
 net/bluetooth/hci_sock.c           |   90 +++++
 net/bluetooth/hci_sysfs.c          |   38 ++
 net/bluetooth/l2cap.c              |  669 ++++++++++++++++++++++--------------
 27 files changed, 1197 insertions(+), 530 deletions(-)
 create mode 100755 drivers/bluetooth/hci_ath.c

through these ChangeSets:

Amitkumar Karwar (1):
    Bluetooth: Process interrupt in main thread of btmrvl driver as well

Cyril Lacoux (1):
    Bluetooth: Added support for controller shipped with iMac i5

Gustavo F. Padovan (39):
    Bluetooth: Remove max_tx and tx_window module paramenters from L2CAP
    Bluetooth: Remove L2CAP Extended Features from Kconfig
    Bluetooth: Fix drop of packets with invalid req_seq/tx_seq
    Bluetooth: Fix bug with ERTM vars increment
    Bluetooth: Only check SAR bits if frame is an I-frame
    Bluetooth: Fix bug in l2cap_ertm_send() behavior
    Bluetooth: Proper shutdown ERTM when closing the channel
    Bluetooth: Fix L2CAP control bit field corruption
    Bluetooth: Stop ack_timer if ERTM enters in Local Busy or SREJ_SENT
    Bluetooth: Update buffer_seq before retransmit frames
    Bluetooth: Fix handle of received P-bit
    Bluetooth: Check the tx_window size on setsockopt
    Bluetooth: Check packet FCS earlier
    Bluetooth: Fix missing retransmission action with RR(P=1)
    Bluetooth: Fix ERTM error reporting to the userspace
    Bluetooth: Add debug output to ERTM code
    Bluetooth: Tweaks to l2cap_send_i_or_rr_or_rnr() flow
    Bluetooth: Change the way we set ERTM mode as mandatory
    Bluetooth: Disconnect the channel if we don't want the proposed mode
    Bluetooth: Prefer Basic Mode on receipt of ConfigReq
    Bluetooth: Actively send request for Basic Mode
    Bluetooth: Refuse ConfigRsp with different mode
    Bluetooth: Remove check for supported mode
    Bluetooth: Disconnect early if mode is not supported
    Bluetooth: Don't accept ConfigReq if we aren't in the BT_CONFIG state
    Bluetooth: Remove the send_lock spinlock from ERTM
    Bluetooth: Add backlog queue to ERTM code
    Bluetooth: Improve ERTM local busy handling
    Bluetooth: Send ConfigReq after send a ConnectionRsp
    Bluetooth: Fix bug in kzalloc allocation size
    Bluetooth: Keep code under column 80
    Bluetooth: Add Copyright notice to L2CAP
    Bluetooth: Update L2CAP version information
    Bluetooth: Add Google's copyright to L2CAP
    Bluetooth: Move bit-field variable in USB driver to data->flags
    Bluetooth: Fix typo in hci_event.c
    Bluetooth: Enable L2CAP Extended features by default
    Bluetooth: Use __packed annotation
    Bluetooth: Use __packed annotation for drivers

Joe Perches (1):
    Bluetooth: Remove unnecessary casts of private_data in drivers

Johan Hedberg (4):
    Bluetooth: Add blacklist support for incoming connections
    Bluetooth: Add debugfs support for showing the blacklist
    Bluetooth: Add missing HCIUARTGETDEVICE ioctl to compat_ioctl.c
    Bluetooth: Add HCIUARTSETFLAGS and HCIUARTGETFLAGS ioctls

João Paulo Rechi Vita (8):
    Bluetooth: Fix SREJ_QUEUE corruption in L2CAP
    Bluetooth: Fix l2cap_sock_connect error return.
    Bluetooth: Make l2cap_streaming_send() void.
    Bluetooth: Fix error return value on sendmsg.
    Bluetooth: Fix error return value on sendmsg.
    Bluetooth: Fix error return for l2cap_connect_rsp().
    Bluetooth: Fix error value for wrong FCS.
    Bluetooth: Fix error return on L2CAP-HCI interface.

Julia Lawall (2):
    Bluetooth: Use kmemdup for drivers
    Bluetooth: Use kzalloc for drivers

Justin P. Mattock (1):
    Bluetooth: Fix warning: variable 'tty' set but not used

Kulikov Vasiliy (1):
    Bluetooth: Silence warning in btmrvl SDIO driver

Nathan Holstein (1):
    Bluetooth: Fix bug with ERTM minimum packet length

Ron Shaffer (2):
    Bluetooth: Remove extraneous white space
    Bluetooth: Reassigned copyright to Code Aurora Forum

Suraj Sumangala (5):
    Bluetooth: Add one more buffer for HCI stream reassembly
    Bluetooth: Implement hci_reassembly helper to reassemble RX packets
    Bluetooth: Modified hci_recv_fragment() to use hci_reassembly helper
    Bluetooth: Implemented HCI frame reassembly for RX from stream
    Bluetooth: Support for Atheros AR300x serial chip


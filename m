Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57781 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300Ab2BOONA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 09:13:00 -0500
Date: Wed, 15 Feb 2012 16:12:49 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth 2012-02-15
Message-ID: <20120215141249.GA28935@x220.ger.corp.intel.com> (sfid-20120215_151306_313816_F423006C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here's one (hopefully) last set of important Bluetooth fixes intended
for 3.3:

- One important SSP fix which fixes security level upgrade handling
  (this was breaking connections with many devices).
- An update to btusb fixing invalid flag usage with usb_submit_urb() as
  well as one new vendor ID for a Broadcom device.
- One compilation warning fix for a bogus inline declaration
- Fix proper timeout value for l2cap_set_timer and sk_sndtimeo and
  hci_conn_put
- Fix a lockdep warning with Bluetooth sockets
- Deadlock fix in hci_conn_hold
- RFCOMM reference counting fix
- QUIRK_NO_RESET fix which was breaking suspend with some laptops
- Two fixes related to synchronization with cancel_delayed_work()

Johan

---

The following changes since commit c27111e5b8d6b1e9296f7075cdc35872f672b524:

  rtlwifi: Modify rtl_pci_init to return 0 on success (2012-02-09 15:17:29 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jh/bluetooth.git master

for you to fetch changes up to 24d2b8c0ac5c8ec41c26ed432238b0e027184882:

  Bluetooth: Fix possible use after free in delete path (2012-02-15 13:09:26 +0200)

----------------------------------------------------------------
Andre Guedes (1):
      Bluetooth: Fix potential deadlock

Andrzej Kaczmarek (2):
      Bluetooth: Fix sk_sndtimeo initialization for L2CAP socket
      Bluetooth: l2cap_set_timer needs jiffies as timeout value

Daniel Wagner (1):
      Bluetooth: Don't mark non xfer isoc endpoint URBs with URB_ISO_ASAP

Johan Hedberg (2):
      Bluetooth: Remove bogus inline declaration from l2cap_chan_connect
      Bluetooth: Add missing QUIRK_NO_RESET test to hci_dev_do_close

Manoj Iyer (1):
      Bluetooth: btusb: Add vendor specific ID (0a5c 21f3) for BCM20702A0

Octavian Purdila (2):
      Bluetooth: silence lockdep warning
      Bluetooth: Fix RFCOMM session reference counting issue

Peter Hurley (1):
      Bluetooth: Fix l2cap conn failures for ssp devices

Ulisses Furquim (2):
      Bluetooth: Remove usage of __cancel_delayed_work()
      Bluetooth: Fix possible use after free in delete path

Vinicius Costa Gomes (1):
      Bluetooth: Fix using an absolute timeout on hci_conn_put()

 drivers/bluetooth/btusb.c         |    4 +---
 include/net/bluetooth/bluetooth.h |    2 ++
 include/net/bluetooth/hci_core.h  |    6 +++---
 include/net/bluetooth/l2cap.h     |   12 ++++++------
 net/bluetooth/af_bluetooth.c      |   12 +++++-------
 net/bluetooth/hci_conn.c          |    4 ++++
 net/bluetooth/hci_core.c          |    3 ++-
 net/bluetooth/l2cap_core.c        |   24 ++++++++++++++----------
 net/bluetooth/l2cap_sock.c        |    4 +++-
 net/bluetooth/rfcomm/core.c       |   18 ++++++++++++------
 net/bluetooth/rfcomm/sock.c       |    2 ++
 11 files changed, 54 insertions(+), 37 deletions(-)


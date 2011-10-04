Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38296 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab1JDC1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 22:27:39 -0400
Date: Mon, 3 Oct 2011 23:28:21 -0300
From: Gustavo Padovan <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2011-10-03
Message-ID: <20111004022821.GA7951@joana> (sfid-20111004_042805_837609_E03DDD38)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Last pull request for 3.2, just a few patches here. The most important ones are
from Mat Martineau that adds support to handle fragmented skbs in
bt_sock_stream_recvmsg(). The rest are just fixes and clean ups.

Please pull! Or let me know any problem, thanks.

	Gustavo


The following changes since commit 76ed94be65c8bd80b565865c186dd9f24bb2f23b:

  ath9k_hw: set pci_express capability true for AR9480 (2011-10-03 15:22:42 -0400)

are available in the git repository at:
  git://github.com/padovan/bluetooth-next.git master

Anderson Lizardo (1):
      Bluetooth: use recommended LE connection parameters

Andre Guedes (1):
      Bluetooth: hci_le_adv_report_evt code refactoring

Mat Martineau (3):
      Bluetooth: Linearize skbs for use in BNEP, CMTP, HIDP, and RFCOMM
      Bluetooth: Handle fragmented skbs in bt_sock_stream_recvmsg()
      Bluetooth: Perform L2CAP SDU reassembly without copying data

Oliver Neukum (1):
      btusb: add device entry for Broadcom SoftSailing

Peter Hurley (1):
      Bluetooth: Allow ACL packets over USB in HCI_RAW mode

Szymon Janc (1):
      Bluetooth: Mark not declared l2cap_core functions as static

Waldemar Rymarkiewicz (1):
      Bluetooth: Fix possible NULL pointer dereference

 drivers/bluetooth/btusb.c     |    6 +-
 include/net/bluetooth/l2cap.h |    3 +-
 net/bluetooth/af_bluetooth.c  |   30 +++++-
 net/bluetooth/bnep/core.c     |    5 +-
 net/bluetooth/cmtp/core.c     |    5 +-
 net/bluetooth/hci_conn.c      |   14 +-
 net/bluetooth/hci_event.c     |   20 ++--
 net/bluetooth/hidp/core.c     |   10 ++-
 net/bluetooth/l2cap_core.c    |  255 ++++++++++++++---------------------------
 net/bluetooth/rfcomm/core.c   |    5 +-
 10 files changed, 157 insertions(+), 196 deletions(-)

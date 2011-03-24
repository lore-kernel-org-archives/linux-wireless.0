Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59194 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933787Ab1CXUnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 16:43:19 -0400
Date: Thu, 24 Mar 2011 17:43:50 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-2.6 2011-03-24
Message-ID: <20110324204349.GL2236@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is my first pull request of fixes for 2.6.39-rc1, the two critical fixes
are HCI_RESET command synchronization that fixes an issues with loosing some
HCI commands responses. And a warning shut up in HCI code by Thomas Gleixner.
The other fixes are all important.

Please pull, thanks. :)

The following changes since commit d78f4b3e2c4dfb9487624f7157af04ab4260e189:

  ath9k: Fix TX queue stuck issue. (2011-03-23 15:22:05 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master

Andrei Emeltchenko (1):
      Bluetooth: delete hanging L2CAP channel

Gustavo F. Padovan (1):
      Bluetooth: Fix HCI_RESET command synchronization

Johan Hedberg (1):
      Bluetooth: Fix missing hci_dev_lock_bh in user_confirm_reply

Marc-Antoine Perennou (1):
      Bluetooth: add support for Apple MacBook Pro 8,2

Suraj Sumangala (1):
      Bluetooth: Increment unacked_frames count only the first transmit

Thomas Gleixner (1):
      Bluetooth: Fix warning with hci_cmd_timer

Vinicius Costa Gomes (1):
      Bluetooth: Fix sending LE data over USB

 drivers/bluetooth/btusb.c   |    6 +++++-
 include/net/bluetooth/hci.h |    2 ++
 net/bluetooth/hci_core.c    |   10 ++++++++--
 net/bluetooth/hci_event.c   |    4 +++-
 net/bluetooth/l2cap_core.c  |    4 +++-
 net/bluetooth/l2cap_sock.c  |    5 +++--
 net/bluetooth/mgmt.c        |    2 ++
 7 files changed, 26 insertions(+), 7 deletions(-)

-- 
Gustavo F. Padovan
http://profusion.mobi

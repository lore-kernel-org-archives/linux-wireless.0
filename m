Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57230 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab0LWDDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 22:03:03 -0500
Date: Thu, 23 Dec 2010 01:05:13 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next-2.6 2010-12-23
Message-ID: <20101223030513.GB26284@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are my last set of patches to 2.6.38. Biggest feature is the new
Bluetooth Management Interface, which intends to replace all HCI raw access
from bluetoothd. That interface is still disabled by default. However you can
enable it via a module parameter.
The other two patches from me is simple fixes in the stack. Tracey's patch is
already in net-next and I only pushed it to solve a merge conflict.

This time I'm using a link to my git tree inside master.kernel.org,
git.kernel.org is really slow today.

Please pull or let me know any problems. Thanks.


The following changes since commit 5c4bc1ce917d93ce8f7dd498fbec6881b3d7743a:

  rtlwifi: Fix large packet issue (2010-12-22 15:45:52 -0500)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/padovan/bluetooth-next-2.6.git master

Gustavo F. Padovan (2):
      Bluetooth: Don't accept ConfigReq if we aren't in the BT_CONFIG state
      Bluetooth: Improve handling of HCI control channel in bind

Johan Hedberg (9):
      Bluetooth: Add Bluetooth Management interface definitions
      Bluetooth: Add initial Bluetooth Management interface callbacks
      Bluetooth: Make hci_send_to_sock usable for management control sockets
      Bluetooth: Add error handling for managment command handlers
      Bluetooth: Add read_version management command
      Bluetooth: Add read_index_list management command
      Bluetooth: Add read_info management command
      Bluetooth: Add management events for controller addition & removal
      Bluetooth: Fix __hci_request synchronization for hci_open_dev

Tracey Dent (1):
      Net: bluetooth: Makefile: Remove deprecated kbuild goal definitions

 include/net/bluetooth/bluetooth.h |    1 +
 include/net/bluetooth/hci.h       |    4 +
 include/net/bluetooth/hci_core.h  |    9 +-
 include/net/bluetooth/mgmt.h      |   87 +++++++++++
 net/bluetooth/Makefile            |    2 +-
 net/bluetooth/hci_core.c          |   17 ++-
 net/bluetooth/hci_event.c         |   33 +++--
 net/bluetooth/hci_sock.c          |   52 ++++++-
 net/bluetooth/l2cap.c             |    8 +-
 net/bluetooth/mgmt.c              |  308 +++++++++++++++++++++++++++++++++++++
 10 files changed, 498 insertions(+), 23 deletions(-)
 create mode 100644 include/net/bluetooth/mgmt.h
 create mode 100644 net/bluetooth/mgmt.c

-- 
Gustavo F. Padovan
http://profusion.mobi

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36622 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab1DRWry (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 18:47:54 -0400
Date: Mon, 18 Apr 2011 19:48:13 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next-2.6 2011-04-18
Message-ID: <20110418224813.GC2472@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Biggest changes are the initial patches for an refactor inside the L2CAP code:
we have to separate the L2CAP socket stuff from the L2CAP core code to make
life of L2CAP users(rfcomm and AMP manager in the future) inside the kernel easy.

Other than that we basically bugfixes and cleanups.

Please pull, thanks!


The following changes since commit a90c7a313a1c5b4fc99f987a2ae8f92ab0ae35c7:

  cfg80211: add a timer for invalid user reg hints (2011-04-07 15:52:29 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next-2.6.git master

Gustavo F. Padovan (26):
      Bluetooth: Create struct l2cap_chan
      Bluetooth: Use struct list_head for L2CAP channels list
      Bluetooth: Remove struct del_list
      Bluetooth: Move ident to struct l2cap_chan
      Bluetooth: Move conf_{req,rsp} stuff to struct l2cap_chan
      Bluetooth: clean up l2cap_sock_recvmsg()
      Bluetooth: Move conn_state to struct l2cap_chan
      Bluetooth: Move of ERTM *_seq vars to struct l2cap_chan
      Bluetooth: Move more ERTM stuff to struct l2cap_chan
      Bluetooth: Move SDU related vars to struct l2cap_chan
      Bluetooth: Move remote info to struct l2cap_chan
      Bluetooth: Move ERTM timers to struct l2cap_chan
      Bluetooth: Move srej and busy queues to struct l2cap_chan
      Bluetooth: Move busy workqueue to struct l2cap_chan
      Bluetooth: Fix lockdep warning with skb list lock
      Bluetooth: Move SREJ list to struct l2cap_chan
      Bluetooth: Remove some sk references from l2cap_core.c
      Bluetooth: Remove unneeded uninitialized_vars()
      Bluetooth: Move tx queue to struct l2cap_chan
      Bluetooth: Fix wrong comparison in listen()
      Bluetooth: Clean up ath3k_load_firmware()
      Bluetooth: Add proper handling of received LE data
      Bluetooth: Check return value of hci_recv_stream_fragment()
      Bluetooth: Don't lock sock inside l2cap_get_sock_by_scid()
      Bluetooth: Fix another locking unbalance
      Bluetooth: Fix lockdep warning in L2CAP

Jiejing Zhang (1):
      Bluetooth: hci_uart: check the return value of recv()

Kevin Gan (1):
      Bluetooth: btmrvl: support Marvell Bluetooth device SD8787

Szymon Janc (1):
      Bluetooth: Fix Out Of Band pairing when mgmt interface is disabled

 drivers/bluetooth/Kconfig       |    4 +-
 drivers/bluetooth/ath3k.c       |    3 -
 drivers/bluetooth/btmrvl_sdio.c |  124 +++-
 drivers/bluetooth/btmrvl_sdio.h |   68 +-
 drivers/bluetooth/hci_ath.c     |    7 +-
 drivers/bluetooth/hci_h4.c      |    7 +-
 drivers/bluetooth/hci_ldisc.c   |    6 +-
 include/net/bluetooth/l2cap.h   |  130 ++--
 net/bluetooth/hci_event.c       |    4 +
 net/bluetooth/l2cap_core.c      | 1344 +++++++++++++++++++++------------------
 net/bluetooth/l2cap_sock.c      |   72 +--
 11 files changed, 964 insertions(+), 805 deletions(-)

-- 
Gustavo F. Padovan
http://profusion.mobi

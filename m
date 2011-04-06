Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44925 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1DFAmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 20:42:07 -0400
Date: Tue, 5 Apr 2011 21:42:28 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: pull request: bluetooth-next-2.6 2011-04-05
Message-ID: <20110406004228.GA2279@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

A bulk of patches to 2.6.39. In this pull request, some more improvements to
HCI Managment Interface from Johan Hedberg, Out of Band Pairing support from
Szymon Janc. The others are API updates (kstrtox and kernel_thread), fixes and
cleanups.

Please pull, thanks!


The following changes since commit 26d59535aa08386b97ece58a27bb16fca4f066db:

  mac80211: clean up station cleanup timer (2011-04-04 16:20:07 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next-2.6.git master

Alexey Dobriyan (1):
      Bluetooth: convert net/bluetooth/ to kstrtox

Andrei Emeltchenko (2):
      Bluetooth: check L2CAP info_rsp ident and state
      Bluetooth: delete hanging L2CAP channel

Gustavo F. Padovan (10):
      Bluetooth: remove unnecessary function declaration
      Bluetooth: Remove unused struct item
      Bluetooth: Improve error message on wrong link type
      Bluetooth: Remove unused struct l2cap_conn item
      Bluetooth: Move bt_accept_enqueue() to outside __l2cap_chan_add
      Bluetooth: Fix HCI_RESET command synchronization
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-2.6
      Bluetooth: Remove gfp_mask param from hci_reassembly()
      Bluetooth: Don't use spin_lock_bh in user context
      Bluetooth: Use GFP_KERNEL in user context

Johan Hedberg (7):
      Bluetooth: Add define for the maximum name length on HCI level
      Bluetooth: mgmt: Add local name information to read_info reply
      Bluetooth: mgmt: Add support for setting the local name
      Bluetooth: Add local Extended Inquiry Response (EIR) support
      Bluetooth: Fix missing hci_dev_lock_bh in user_confirm_reply
      Bluetooth: Add mgmt_device_found event                                                         
      Bluetooth: Add mgmt_remote_name event                                                          
                                                                                                     
Marc-Antoine Perennou (1):                                                                           
      Bluetooth: add support for Apple MacBook Pro 8,2                                               
                                                                                                     
Suraj Sumangala (1):                                                                                 
      Bluetooth: Increment unacked_frames count only the first transmit                              
                                                                                                     
Szymon Janc (15):                                                                                    
      Bluetooth: Opencode macros in bnep/core.c                                                      
      Bluetooth: Fix checkpatch errors and some code style issues in bnep                            
      Bluetooth: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>                           
      Bluetooth: Fix checkpatch errors, code style issues and typos in hidp
      Bluetooth: Do not use assignments in IF conditions
      Bluetooth: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
      Bluetooth: Fix checkpatch error in cmtp.h
      Bluetooth: Rename cmd to param in pending_cmd
      Bluetooth: Allow for NULL data in mgmt_pending_add
      Bluetooth: Add read_local_oob_data management command
      Bluetooth: Add add/remove_remote_oob_data management commands
      Bluetooth: Enable support for out of band association model
      Bluetooth: Use kthread API in hidp
      Bluetooth: Use kthread API in bnep
      Bluetooth: Use kthread API in cmtp

Thomas Gleixner (1):
      Bluetooth: Fix warning with hci_cmd_timer

Vinicius Costa Gomes (1):
      Bluetooth: Fix sending LE data over USB

 drivers/bluetooth/btusb.c        |    6 +-
 include/net/bluetooth/hci.h      |   42 +++-
 include/net/bluetooth/hci_core.h |   25 ++-
 include/net/bluetooth/l2cap.h    |    2 -
 include/net/bluetooth/mgmt.h     |   47 ++++
 net/bluetooth/bnep/bnep.h        |  148 ++++++------
 net/bluetooth/bnep/core.c        |   71 +++---
 net/bluetooth/bnep/sock.c        |    2 +-
 net/bluetooth/cmtp/capi.c        |    6 +-
 net/bluetooth/cmtp/cmtp.h        |   11 +-
 net/bluetooth/cmtp/core.c        |   25 ++-
 net/bluetooth/cmtp/sock.c        |    2 +-
 net/bluetooth/hci_core.c         |   89 ++++++-
 net/bluetooth/hci_event.c        |   99 ++++++--
 net/bluetooth/hci_sysfs.c        |   40 ++--
 net/bluetooth/hidp/core.c        |   90 ++++----
 net/bluetooth/hidp/hidp.h        |    6 +-
 net/bluetooth/hidp/sock.c        |    7 +-
 net/bluetooth/l2cap_core.c       |   31 ++-
 net/bluetooth/l2cap_sock.c       |    5 +-
 net/bluetooth/mgmt.c             |  518 ++++++++++++++++++++++++++++++++++----
 21 files changed, 981 insertions(+), 291 deletions(-)

-- 
Gustavo F. Padovan
http://profusion.mobi

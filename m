Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45588 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbXLJRV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:21:56 -0500
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] [00/48] libertas update
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <libertas-12345@shinybook.infradead.org> (sfid-20071210_172159_079815_0FE12A71)
Date: Mon, 10 Dec 2007 10:45:34 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the first set of patches to clean up the libertas driver, from the
tree at git://git.infradead.org/libertas-2.6.git

It removes the 'struct lbs_adapter' data structure, merging it into
'struct lbs_private', and removes a bunch of pointless unused fields
from it.

It collapses the pointless nest of functions in the transmit path, which
used to go pre_start_xmit->hard_start_xmit->lbs_process_tx->SendSinglePacket
and now can be handled entirely in libertas_hard_start_xmit() -- thus
removing the need to store information about which netdevice the packet
belongs to, so the whole IS_MESH_FRAME / {UN,}SET_MESH_FRAME thing can go
away too.

It slightly cleans up the RX code path too, along similar lines. There's
more to be done here.

It fixes radiotap mode so that you can query it without crashing, and 
can even enable it and see packets, which is a shiny new feature. As an
added bonus, you can even disable it again without crashing, too.

It also fixes a bunch of other things which offended me along the way, 
and makes a start at addressing the locking issues with command and data
transmission to the device, partly by moving the actual TX packet
submission to the context of the main worker thread.

There's more to be done, but it seems to make sense to merge at this point
before I embark on the next batch...


Dan Williams (1):
      libertas: select WIRELESS_EXT

David Woodhouse (39):
      libertas: Fix memory leak of RX skbs
      libertas: Remove cmd_oid from struct cmd_ctrl_node
      libertas: Consolidate lbs_host_to_card_done() function.
      libertas: Don't claim to have checksummed incoming packets.
      libertas: Move SET_BOOT2_VER command to if_usb where it belongs
      libertas: Zero 'pdata_size' field in cmd_ctrl_node reliably.
      libertas: Byteswap cmdptr->size in lbs_cmd()
      libertas: Use lbs_cmd() for setting Boot2 version
      libertas: Remove SET_BOOT2_VER support from the Big Switch Statement.
      libertas: Fix endianness in boot2_version handling.
      libertas: when usb_submit_usb fails, include the error code in the printk
      libertas: Switch to using a callback function pointer for commands
      libertas: Don't set IW_ENCODE_NOKEY when returning WEP keys.
      libertas: Fix up error handling in lbs_setuserscan()
      libertas: kill adapter->nr_cmd_pending
      libertas: switch lbs_cmd() to take a callback function pointer
      libertas: clean up lbs_thread() to make it slightly more readable
      libertas: fix lbs_rtap attribute in sysfs
      libertas: kill TxLockFlag
      libertas: kill struct lbs_adapter
      libertas: use lbs_host_to_card_done() in lbs_tx_timeout()
      libertas: cope with device which already has firmware loaded
      libertas: stop debugfs code looking at cmdpendingq
      libertas: kill internal tx queue for PS mode
      libertas: kill SendSinglePacket() function.
      libertas: move lbs_hard_start_xmit() into tx.c
      libertas: kill lbs_process_tx() by merging it into lbs_hard_start_xmit()
      libertas: clean up lbs_hard_start_xmit()
      libertas: kill lbs_pre_start_xmit(), lib_mesh_pre_start_xmit()
      libertas: stop using ieee80211 for radiotap device
      libertas: set dev_addr on rtap device
      libertas: TX packet is radiotap iff it comes from rtap_dev
      libertas: free successfully transmitted skbs again
      libertas: refactor the 'should I sleep?' decision in lbs_thread()
      libertas: Move actual transmission to main thread
      libertas: remove unreachable code from process_rxed_802_11_packet()
      libertas: fix error cases in lbs_process_rxed_802_11_packet()
      libertas: kill lbs_upload_tx_packet()
      libertas: kill (IS,SET,UNSET)_MESH_FRAME.

Holger Schurig (7):
      libertas: remove cmd_ctrl_node->cmdflags
      libertas: remove cmd_ctrl_node->status
      libertas: make more functions static
      libertas: handy function to call firmware commands
      libertas: fix data packet size errors
      libertas: implement new scanning logic
      libertas: endianness fixes

Li Zefan (1):
      libertas: don't cast a pointer to pointer of

--- 
23 files changed, 1809 insertions(+), 2189 deletions(-)

-- 
dwmw2

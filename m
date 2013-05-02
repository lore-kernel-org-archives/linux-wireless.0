Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46259 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab3EBMaK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 08:30:10 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 00/14] rt2x00: get rid of static data queue descriptors
Date: Thu,  2 May 2013 14:30:15 +0200
Message-Id: <1367497829-7672-1-git-send-email-juhosg@openwrt.org> (sfid-20130502_143016_074318_C0879681)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch-set depends on the following series:

'rt2x00: avoid a few superfluous pointer dereferences'

which are available here:

https://patchwork.kernel.org/bundle/juhosg/rt2x00-avoid-a-few-superfluous-pointer-dereference/

Gabor Juhos (14):
  rt2x00: rt2x00queue: add priv_size field to struct data_queue
  rt2x00: rt2x00queue: move data_queue field initialization to rt2x00queue_init
  rt2x00: rt2x00queue: remove qdesc parameter of rt2x00queue_alloc_entries
  rt2x00: rt2x00dev: use rt2x00dev->bcn->limit
  rt2x00: rt2x00queue: setup queue->threshold from queue->limit
  rt2x00: add queue_init callback to rt2x00_ops
  rt2x00: rt2800usb: implement queue_init callback
  rt2x00: rt2800pci: implement queue_init callback
  rt2x00: rt73usb: implement queue_init callback
  rt2x00: rt2400pci: implement queue_init callback
  rt2x00: rt2500pci: implement queue_init callback
  rt2x00: rt61pci: implement queue_init callback
  rt2x00: rt2500usb: implement queue_init callback
  rt2x00: remove data_queue_desc struct

 drivers/net/wireless/rt2x00/rt2400pci.c   |   65 +++++++++++--------
 drivers/net/wireless/rt2x00/rt2500pci.c   |   65 +++++++++++--------
 drivers/net/wireless/rt2x00/rt2500usb.c   |   65 +++++++++++--------
 drivers/net/wireless/rt2x00/rt2800pci.c   |   60 ++++++++++-------
 drivers/net/wireless/rt2x00/rt2800usb.c   |  100 ++++++++++++++---------------
 drivers/net/wireless/rt2x00/rt2x00.h      |    5 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |   26 ++++----
 drivers/net/wireless/rt2x00/rt2x00queue.h |   21 +-----
 drivers/net/wireless/rt2x00/rt61pci.c     |   54 ++++++++++------
 drivers/net/wireless/rt2x00/rt73usb.c     |   54 ++++++++++------
 11 files changed, 276 insertions(+), 241 deletions(-)

--
1.7.10


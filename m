Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38331 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab3FDLlD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 07:41:03 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 00/13] rt2x00: get rid of static data queue descriptors
Date: Tue,  4 Jun 2013 13:40:37 +0200
Message-Id: <1370346050-7047-1-git-send-email-juhosg@openwrt.org> (sfid-20130604_134107_096851_63881971)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch-set depends on the following patch:

'rt2x00: rt2x00queue: initialize data_queue fields earlier'
https://patchwork.kernel.org/patch/2655201/

Gabor Juhos (13):
  rt2x00: rt2x00queue: add priv_size field to struct data_queue
  rt2x00: rt2x00queue: remove qdesc parameter of
    rt2x00queue_alloc_entries
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
 drivers/net/wireless/rt2x00/rt2x00queue.c |   54 +++-------------
 drivers/net/wireless/rt2x00/rt2x00queue.h |   21 +-----
 drivers/net/wireless/rt2x00/rt61pci.c     |   54 ++++++++++------
 drivers/net/wireless/rt2x00/rt73usb.c     |   54 ++++++++++------
 11 files changed, 274 insertions(+), 271 deletions(-)

--
1.7.10


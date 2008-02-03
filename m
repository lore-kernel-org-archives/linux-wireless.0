Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:27303 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761782AbYBCOqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:46:45 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1586238mue.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:46:44 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/19] rt2x00: Queue handling overhaul
Date: Sun, 3 Feb 2008 15:45:46 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031545.46302.IvDoorn@gmail.com> (sfid-20080203_144648_329542_287BACB3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This introduces a big queue handling overhaul, this also
renames "ring" to "queues".

Move queue handling into rt2x00queue.c and the matching header,
use Kerneldoc to improve rt2x00 library documentation.

Access to the queues is now protected under a spinlock, this
to prevent race conditions which could corrupt the indexing
system of the queue.

Each queue entry allocates x bytes for driver/device specific data,
this cleans up the queue structure significantly and improves
code readability.

rt2500usb no longer needs 2 entries in the beacon queue to correctly
send out the guardian byte. This is now handled in the entry specific
structure.

rt61 and rt73 now use the correct descriptor size for beacon frames,
since this data is written into the registers not the entire TXD
descriptor was used but instead of a subset of it named TXINFO.

Finally this also fixes numerous other bugs related to incorrect
beacon handling or beacon related code.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---

patch size 164k, located on server:
http://kernel.org//pub/linux/kernel/people/ivd/rt2x00-2.1.0/0002-rt2x00-Queue-handling-overhaul.patch

 drivers/net/wireless/rt2x00/Makefile      |    2 +-
 drivers/net/wireless/rt2x00/rt2400pci.c   |  204 ++++++++------
 drivers/net/wireless/rt2x00/rt2500pci.c   |  199 ++++++++------
 drivers/net/wireless/rt2x00/rt2500usb.c   |  201 ++++++++------
 drivers/net/wireless/rt2x00/rt2x00.h      |  133 ++++------
 drivers/net/wireless/rt2x00/rt2x00debug.c |   32 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c   |  403 +++++++--------------------
 drivers/net/wireless/rt2x00/rt2x00dump.h  |    6 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h   |   10 +
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   55 ++--
 drivers/net/wireless/rt2x00/rt2x00pci.c   |  223 ++++++++-------
 drivers/net/wireless/rt2x00/rt2x00pci.h   |   49 +++-
 drivers/net/wireless/rt2x00/rt2x00queue.c |  291 +++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.h |  435 +++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00reg.h   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00ring.h  |  290 -------------------
 drivers/net/wireless/rt2x00/rt2x00usb.c   |  291 +++++++++++---------
 drivers/net/wireless/rt2x00/rt2x00usb.h   |   48 +++-
 drivers/net/wireless/rt2x00/rt61pci.c     |  256 +++++++++--------
 drivers/net/wireless/rt2x00/rt61pci.h     |    1 +
 drivers/net/wireless/rt2x00/rt73usb.c     |  134 ++++++---
 drivers/net/wireless/rt2x00/rt73usb.h     |    1 +
 22 files changed, 1881 insertions(+), 1385 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00queue.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00queue.h
 delete mode 100644 drivers/net/wireless/rt2x00/rt2x00ring.h

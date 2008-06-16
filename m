Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:44255 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYFPRpC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 13:45:02 -0400
Received: by py-out-1112.google.com with SMTP id p76so2084603pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 10:45:02 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Mon, 16 Jun 2008 19:58:17 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200806161958.17285.IvDoorn@gmail.com> (sfid-20080616_194507_551298_4B7D6636)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the latest version bump of rt2x00: 2.1.8

Most important patches are from Gertjan, which reduce
the amount of pre-allocated DMA for all TX queues.
All PCI drivers now TX/RX all frame data directly
from/to the skb buffer saving kilobytes of allocated DMA
and several memcpy() statements.

This also allows a lot of code to be moved out of rt2x00pci/rt2x00usb
and into rt2x00lib which in turn makes management of everything
much easier.

Ivo

---
The following changes since commit 7b57047e2d34c243c4cf2d778df0b34bfdd82c8e:
  John W. Linville (1):
        iwlwifi: fix build breakage

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Gertjan van Wingerde (4):
      rt2x00: Properly clean up beacon skbs.
      rt2x00: Convert rt2x00 to use generic DMA-mapping API
      rt2x00: Centralize allocation of RX skbs.
      rt2x00: Replace statically allocated DMA buffers with mapped skb's.

Ivo van Doorn (5):
      rt2x00: Use ieee80211 fc handlers
      rt2x00: Cleanup symbol exports
      rt2x00: Fix sparse warning on nested container_of()
      rt2x00: Increase queue size
      rt2x00: Release rt2x00 2.1.8

 drivers/net/wireless/rt2x00/rt2400pci.c   |   17 ++--
 drivers/net/wireless/rt2x00/rt2500pci.c   |   14 ++-
 drivers/net/wireless/rt2x00/rt2500usb.c   |    4 +-
 drivers/net/wireless/rt2x00/rt2x00.h      |   59 ++---------
 drivers/net/wireless/rt2x00/rt2x00dev.c   |  100 +++++++++++++++----
 drivers/net/wireless/rt2x00/rt2x00lib.h   |   51 +++++++++-
 drivers/net/wireless/rt2x00/rt2x00pci.c   |  126 ++++--------------------
 drivers/net/wireless/rt2x00/rt2x00pci.h   |   12 --
 drivers/net/wireless/rt2x00/rt2x00queue.c |  157 +++++++++++++++++++++++------
 drivers/net/wireless/rt2x00/rt2x00queue.h |   35 ++++---
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   94 +++---------------
 drivers/net/wireless/rt2x00/rt2x00usb.h   |    6 +
 drivers/net/wireless/rt2x00/rt61pci.c     |   23 +++--
 drivers/net/wireless/rt2x00/rt73usb.c     |    8 ++-
 14 files changed, 368 insertions(+), 338 deletions(-)

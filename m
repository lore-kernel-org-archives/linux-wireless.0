Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41716 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752923AbdBHNNa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 08:13:30 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 0/3] rt2x00 skb_desc cleanup
Date: Wed,  8 Feb 2017 13:51:28 +0100
Message-Id: <1486558291-1615-1-git-send-email-sgruszka@redhat.com> (sfid-20170208_141354_112977_2B2B1AC5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove entry field from skb_desc in order to use this skb_desc
place for other pointer.

This is intended to -next.

Stanislaw Gruszka (3):
  rt61pci: use entry directly
  rt2x00: call entry directly in rt2x00_dump_frame
  rt2x00: remove queue_entry from skbdesc

 drivers/net/wireless/ralink/rt2x00/rt2400pci.c   | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c   | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c   | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c   | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h      | 4 ++--
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c | 7 ++++---
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c   | 4 ++--
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c | 5 +----
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.h | 2 --
 drivers/net/wireless/ralink/rt2x00/rt61pci.c     | 5 ++---
 drivers/net/wireless/ralink/rt2x00/rt73usb.c     | 2 +-
 11 files changed, 16 insertions(+), 21 deletions(-)

-- 
1.8.3.1

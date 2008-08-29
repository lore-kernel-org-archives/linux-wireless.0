Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:61799 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbYH2THy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 15:07:54 -0400
Received: by ey-out-2122.google.com with SMTP id 6so320107eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 12:07:53 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Fri, 29 Aug 2008 21:03:53 +0200
Cc: "rt2400-devel" <rt2400-devel@lists.sourceforge.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808292103.53179.IvDoorn@gmail.com> (sfid-20080829_210758_288789_AD6A575A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is another rt2x00 update for the 2.6.28 kernel,
I believe some patches have been send earlier, but
I lost my overview on my patches, so this bunch will
get rt2x00 completely up to date.

A few patches are needed for rt2800, but they are small,
and clean enough to be merged early.

Ivo

---
The following changes since commit b51f3c6077d59b41e3f9d2af33e2e2f94ecbbc39:
  John W. Linville (1):
        at76_usb: fix for removal of IEEE80211_TX_CTL_DO_NOT_ENCRYPT

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (5):
      rt2x00: Fix race conditions in flag handling
      rt2x00: Map extra_tx_headroom to DMA
      rt2x00: Initialize txop during conf_tx() callback
      rt2x00: Add Signal type flag
      rt2x00: Release rt2x00 2.2.1

Mattias Nissler (2):
      rt2x00: Only configure hardware when radio is enabled
      rt2x00: skb->data pointer should not include TX descriptor

 drivers/net/wireless/rt2x00/rt2400pci.c    |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c    |    4 +-
 drivers/net/wireless/rt2x00/rt2500usb.c    |    7 ++-
 drivers/net/wireless/rt2x00/rt2x00.h       |   17 +++---
 drivers/net/wireless/rt2x00/rt2x00config.c |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   68 +++++++++++--------------
 drivers/net/wireless/rt2x00/rt2x00mac.c    |   75 ++++++++++++++--------------
 drivers/net/wireless/rt2x00/rt2x00queue.c  |   31 +++++++++--
 drivers/net/wireless/rt2x00/rt2x00queue.h  |    9 ++-
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |    6 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c    |   21 ++++----
 drivers/net/wireless/rt2x00/rt61pci.c      |   73 ++++++++++++++++++++++-----
 drivers/net/wireless/rt2x00/rt73usb.c      |   74 ++++++++++++++++++++++-----
 13 files changed, 253 insertions(+), 138 deletions(-)

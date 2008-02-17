Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:5154 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbYBQQfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 11:35:46 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1178110fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2008 08:35:45 -0800 (PST)
To: linville@tuxdriver.com
Subject: Please pull 'upstream' branch of rt2x00
Date: Sun, 17 Feb 2008 17:30:44 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802171730.44353.IvDoorn@gmail.com> (sfid-20080217_163607_807783_2C80B9FC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the 2.1.2 release of rt2x00. Several important bugfixes like a
partial return of TX/RX activity in the PCI drivers.

Note that _none_ of the drivers (PCI or USB) are in a good shape since the
2.1.0 release. With partial RX/TX activity we are at least now on a similar
behavior as the 2.0.14 version inside kernel 2.6.25.

Speaking of the 2.6.25 kernel, it seems that rt2x00 is not in an all too good
shape in there. If more reports about broken TX/RX come in I will consider
reverting a lot of patches to make rt2x00 look a lot like the version in 2.6.24.
That version wasn't good either, but at least people can't complain about
regressions. ;)

Also note that the git pull request below also contains the patches from
previous pull request. But I noticed that you hadn't pulled in the 2.1.1 release yet.
I won't resent those patches to the list, since there aren't any changes in them
since last week. ;)

Ivo

---
The following changes since commit 2b78397a79d3daa2ba6c633526a7e3b455f9fc73:
  Stefano Brivio (1):
        b43legacy: Add driver load messages

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Adam Baker (1):
      rt2x00: correct address calc for queue private data

Gertjan van Wingerde (1):
      Fix hw mode registration with mac80211.

Ivo van Doorn (23):
      rt2x00: Fix invalid DMA free
      rt2x00: Make rt2x00 less verbose
      rt2x00: Remove MGMT ring initialization
      rt2x00: Select CONFIG_NEW_LEDS
      rt2x00: make csr_cache and csr_addr an union
      rt2x00: Fix scheduling while atomic errors in usb drivers
      rt2x00: Add queue statistics to debugfs
      rt2x00: Fix typo in debug statement
      rt2x00: Fix skbdesc->data_len initialization
      rt2x00: Fix queue->qid initialization
      rt2x00: Cleanup Makefile
      rt2x00: Kill guardian urb during disable_radio
      rt2x00: Release rt2x00 2.1.1
      rt2x00: Send frames out with configured TX power
      rt2x00: Don't report driver generated frames to tx_status()
      rt2x00: Fix Descriptor DMA initialization
      rt2x00: Filter ACK_CTS based on FIF_CONTROL
      rt2x00: Remove reset_tsf()
      rt2x00: Rename dscape -> mac80211
      rt2x00: Cleanup mode registration
      rt2x00: Remove async vendor request calls from rt2x00usb
      rt2x00: Fix MAC address defines in rt61pci
      rt2x00: Release rt2x00 2.1.2

 drivers/net/wireless/rt2x00/Kconfig       |    3 +-
 drivers/net/wireless/rt2x00/Makefile      |   41 ++++-------
 drivers/net/wireless/rt2x00/rt2400pci.c   |   39 ++++------
 drivers/net/wireless/rt2x00/rt2400pci.h   |    6 +-
 drivers/net/wireless/rt2x00/rt2500pci.c   |   38 ++++------
 drivers/net/wireless/rt2x00/rt2500pci.h   |    4 +-
 drivers/net/wireless/rt2x00/rt2500usb.c   |   23 ++++---
 drivers/net/wireless/rt2x00/rt2500usb.h   |    4 +-
 drivers/net/wireless/rt2x00/rt2x00.h      |   50 ++++++++-----
 drivers/net/wireless/rt2x00/rt2x00debug.c |   90 ++++++++++++++++++++----
 drivers/net/wireless/rt2x00/rt2x00dev.c   |  100 +++++++++++++++------------
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    5 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   24 ++++++-
 drivers/net/wireless/rt2x00/rt2x00pci.c   |  108 +++++++++++++++++++---------
 drivers/net/wireless/rt2x00/rt2x00pci.h   |   14 ++--
 drivers/net/wireless/rt2x00/rt2x00queue.c |   36 +++++----
 drivers/net/wireless/rt2x00/rt2x00queue.h |   12 +++-
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   90 +++++++-----------------
 drivers/net/wireless/rt2x00/rt2x00usb.h   |   18 -----
 drivers/net/wireless/rt2x00/rt61pci.c     |   54 ++++++--------
 drivers/net/wireless/rt2x00/rt61pci.h     |   12 ++--
 drivers/net/wireless/rt2x00/rt73usb.c     |   56 +++++++--------
 drivers/net/wireless/rt2x00/rt73usb.h     |    4 +-
 23 files changed, 453 insertions(+), 378 deletions(-)

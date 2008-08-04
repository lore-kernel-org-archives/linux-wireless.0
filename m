Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:65349 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYHDORj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 10:17:39 -0400
Received: by nf-out-0910.google.com with SMTP id d3so712078nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 04 Aug 2008 07:17:34 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Mon, 4 Aug 2008 16:36:41 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808041636.41189.IvDoorn@gmail.com> (sfid-20080804_161750_910639_3FBA5238)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Only 5 patches, but they do bump rt2x00 to a new version: 2.2.0
This series will add HW crypto support to rt2x00, by default it
has been enabled for rt61pci and rt73usb.

rt2500usb has also been created, but currently does not work
since it requires different handling then rt61pci and rt73usb. Because
I am focussing on different areas in rt2x00 now, it will take some
time before I get back to rt2500usb HW crypto (if there are any volunteers
to take a shot at rt2500usb HW crypto, they are welcome).

rt2500pci supports HW crypto as well, but I won't implement it due
to the way it has to be enabled. It comes down to the fact that during
TX the key has to be provided, and after the encryption an interupt will
be raised after which the frame can be kicked to the air. In the RX path
the same happens, including that after RX the key has to be provided
as well. This will cause the number of IRQ events to double during HW
crypto, and several changes are required in mac80211 to make it possible.
Because of that I see no point in doing anything with it.

Ivo

----
The following changes since commit 2471b779e2f93d76bd4c041e4a8f5a27c859d7ce:
  John W. Linville (1):
        Revert "mac80211: add direct probe before association"

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (5):
      rt2x00: Implement HW encryption
      rt2x00: Implement HW encryption (rt61pci)
      rt2x00: Implement HW encryption (rt73usb)
      rt2x00: Gather channel information in structure
      rt2x00: Release rt2x00 2.2.0

 drivers/net/wireless/rt2x00/Kconfig        |    6 +
 drivers/net/wireless/rt2x00/Makefile       |    1 +
 drivers/net/wireless/rt2x00/rt2400pci.c    |   40 ++--
 drivers/net/wireless/rt2x00/rt2400pci.h    |   22 +--
 drivers/net/wireless/rt2x00/rt2500pci.c    |   39 +++--
 drivers/net/wireless/rt2x00/rt2500pci.h    |   17 +-
 drivers/net/wireless/rt2x00/rt2500usb.c    |   39 +++--
 drivers/net/wireless/rt2x00/rt2500usb.h    |   17 +-
 drivers/net/wireless/rt2x00/rt2x00.h       |   64 +++++-
 drivers/net/wireless/rt2x00/rt2x00config.c |    4 +
 drivers/net/wireless/rt2x00/rt2x00crypto.c |  215 +++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00debug.c  |   97 +++++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   48 +++--
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   47 ++++
 drivers/net/wireless/rt2x00/rt2x00mac.c    |  110 +++++++++-
 drivers/net/wireless/rt2x00/rt2x00queue.c  |   81 +++++++-
 drivers/net/wireless/rt2x00/rt2x00queue.h  |   73 ++++++-
 drivers/net/wireless/rt2x00/rt2x00reg.h    |   19 ++-
 drivers/net/wireless/rt2x00/rt61pci.c      |  298 ++++++++++++++++++++++++--
 drivers/net/wireless/rt2x00/rt61pci.h      |   38 ++--
 drivers/net/wireless/rt2x00/rt73usb.c      |  314 +++++++++++++++++++++++++---
 drivers/net/wireless/rt2x00/rt73usb.h      |   38 ++--
 22 files changed, 1418 insertions(+), 209 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00crypto.c

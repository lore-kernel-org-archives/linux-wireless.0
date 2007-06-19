Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:20728 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbXFSS3M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2007 14:29:12 -0400
Received: by ug-out-1314.google.com with SMTP id j3so172335ugf
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2007 11:29:12 -0700 (PDT)
To: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Please pull 'upstream' branch of rt2x00
Date: Tue, 19 Jun 2007 20:18:12 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200706192018.12635.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the 2.0.2 release of rt2x00.
As usual most changes are code cleaning,
followed by code moving into the library modules.
Unfortunately, this round still does not contain real bugfixes.
Hopefully the next release will really bugfixes. ;)

The actuall diff is quite big, but that is mainly because
of the cleanup in the register access functions which caused
all register functions to be renamed (which prevents namespace
pollution).

Ivo

---

The following changes since commit 9181e959da76d85d688d8ec763702ed2f3b4edf9:
  John W. Linville (1):
        rt2x00firmware.c: include delay.h to avoid build error on ppc64

are available in the git repository at:

  git://git.serialmonkey.com/rt2x00.git/ upstream

Gertjan van Wingerde (1):
      rt2x00: Clean up register access functions.

Ivo van Doorn (32):
      rt2x00: Remove debug module parameter
      rt2x00: Cleanup header
      rt2x00: *_bbp_check should not return magic value
      rt2x00: rt2400pci - Use BBPCSR for txdesc
      rt2x00: Make antenna selection more transparent
      rt2x00: Don't hardcode beacon interval
      rt2x00: Move config requirement into rt2x00lib
      rt2x00: Remove pointless 0xff checks
      rt2x00: Correct *_bbp_check
      rt2x00: Correctly set the flags for the correct flags field
      rt2x00: Remove unsused structure
      rt2x00: Don't export config functions to outside rt2x00lib
      Merge branch 'wireless-dev'
      rt2x00: Constify txd_size and rxd_size
      rt2x00: rt2x00lib_disable_radio should call toggle_rx
      rt2x00: Move USB radio enabling/disabling into rt2x00usb
      rt2x00: Remove ring->type
      rt2x00: Split rings into tx and rx arrays
      rt2x00: Split tx ring array into tx and bcn
      rt2x00: Move rt2x00{pci,usb} shared code into rt2x00lib
      rt2x00: Move ring allocation into rt2x00lib
      Merge branch 'wireless-dev'
      rt2x00: Fix ring array iteration
      rt2x00: Remove huge macro functions
      rt2x00: Include rt2x00firmware.h
      rt2x00: Move ring allocation partially into rt2x00lib
      rt2x00: Remove unused library call fields
      rt2x00: rt61 and rt73 do not support Atim
      rt2x00: link_tuner should be toggled when the radio is toggled
      rt2x00: Add EEPROM recovery code for mac address
      Merge branch 'wireless-dev'
      rt2x00: Release rt2x00 2.0.2

Mattias Nissler (1):
      rt73: Prevent oops when usb device is disconnected.

 drivers/net/wireless/mac80211/rt2x00/rt2400pci.c   |  627 ++++++---------
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.h   |   28 +-
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.c   |  673 +++++++---------
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.h   |   34 +-
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.c   |  660 ++++++---------
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.h   |   38 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00.h      |  120 ++--
 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c   |  540 ++++++++++---
 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.h   |   60 ++
 .../net/wireless/mac80211/rt2x00/rt2x00firmware.c  |    7 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h   |   13 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c   |   52 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00pci.c   |  283 +------
 drivers/net/wireless/mac80211/rt2x00/rt2x00pci.h   |   29 +
 .../net/wireless/mac80211/rt2x00/rt2x00rfkill.c    |    4 -
 drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c   |  323 +++-----
 drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h   |   14 +-
 drivers/net/wireless/mac80211/rt2x00/rt61pci.c     |  858 +++++++++-----------
 drivers/net/wireless/mac80211/rt2x00/rt61pci.h     |   43 +-
 drivers/net/wireless/mac80211/rt2x00/rt73usb.c     |  758 +++++++----------
 drivers/net/wireless/mac80211/rt2x00/rt73usb.h     |   43 +-
 21 files changed, 2363 insertions(+), 2844 deletions(-)
 create mode 100644 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.h

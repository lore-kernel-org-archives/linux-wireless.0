Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:4082 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbXJ0LYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:24:49 -0400
Received: by nf-out-0910.google.com with SMTP id g13so973044nfb
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:24:47 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Sat, 27 Oct 2007 13:34:34 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271334.34192.IvDoorn@gmail.com> (sfid-20071027_122459_670967_D0B5A150)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the 2.0.12 release of rt2x00.
I noticed you only pulled 2 patches from the 2.0.11 release,
and I don't know why you dropped the remaining patches.
This means that this pull requests also contains the remaining
2.0.11 patches...

Lots of bugfixes this time, finally rfkill is working, link speeds issues
have been resolved and some packet loss issues are gone.

All indivual patches can also be found here:
http://kernel.org//pub/linux/kernel/people/ivd/rt2x00-2.0.12/

Ivo

---

The following changes since commit 0119130478b1706232d79c768cb587c5e0c615de:
  John W. Linville (1):
        Merge branch 'fixes-jgarzik' into everything

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Adam Baker (2):
      rt2x00: Unconstify rt2x00dev
      rt2x00: Place mutex around USB register access

Ivo van Doorn (15):
      rt2x00: Move quality statistics into seperate structure
      rt2x00: Use enum defines
      rt2x00: Correctly translate mac80211 antenna setup to rt2x00
      rt2x00: SW diversity should default to antenna B
      rt2x00: Remove rt2x00_clear_link
      rt2x00: Implement SW diversity
      rt2x00: Cleanup if-statements
      rt2x00: Release rt2x00 2.0.11
      rt2x00: Disable RX when switching antenna
      rt2x00: Split rt61/rt73 antenna selection into RX and TX antenna
      rt2x00: Input-polldev requires input device
      rt2x00: Detect initial rfkill state on register
      rt2x00: Remove unused variables
      rt2x00: Remove data_desc structure
      rt2x00: Release rt2x00 2.0.12

Mattias Nissler (4):
      rt2x00: Fix antenna selection.
      rt2x00: Rework rt61 antenna selection.
      rt2x00: Rework rt73 antenna selection
      rt2x00: Correctly set ACK bit in tx descriptors

 drivers/net/wireless/rt2x00/rt2400pci.c    |  104 +++++----
 drivers/net/wireless/rt2x00/rt2400pci.h    |    4 +-
 drivers/net/wireless/rt2x00/rt2500pci.c    |  112 +++++-----
 drivers/net/wireless/rt2x00/rt2500pci.h    |    4 +-
 drivers/net/wireless/rt2x00/rt2500usb.c    |  169 +++++++++-----
 drivers/net/wireless/rt2x00/rt2500usb.h    |   17 ++-
 drivers/net/wireless/rt2x00/rt2x00.h       |  192 ++++++++++++----
 drivers/net/wireless/rt2x00/rt2x00config.c |   95 ++++++++-
 drivers/net/wireless/rt2x00/rt2x00debug.h  |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |  212 +++++++++++++++---
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    2 +
 drivers/net/wireless/rt2x00/rt2x00pci.c    |    4 +-
 drivers/net/wireless/rt2x00/rt2x00pci.h    |    8 +-
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |   44 ++++-
 drivers/net/wireless/rt2x00/rt2x00ring.h   |   23 +--
 drivers/net/wireless/rt2x00/rt2x00usb.c    |   38 +++-
 drivers/net/wireless/rt2x00/rt2x00usb.h    |   19 +-
 drivers/net/wireless/rt2x00/rt61pci.c      |  332 ++++++++++++++--------------
 drivers/net/wireless/rt2x00/rt61pci.h      |   14 +-
 drivers/net/wireless/rt2x00/rt73usb.c      |  198 ++++++++++-------
 drivers/net/wireless/rt2x00/rt73usb.h      |   14 +-
 21 files changed, 1071 insertions(+), 538 deletions(-)

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:55730 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbXGYUs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 16:48:28 -0400
Received: by ug-out-1314.google.com with SMTP id j3so420021ugf
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 13:48:27 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Wed, 25 Jul 2007 22:49:47 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707252249.47931.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Today a very quick release of 2.0.4,
reason for this quick followup on 2.0.3 are the fixes
regarding the USB ID and the rt61pci interrupts.

The latter one (hopefully) resolves an bugreport recently
raised in the Fedora Bugzilla. (I'll update the report in a few seconds)

And yes I have read the mails of today regarding patch submissions,
so I'll start sending the individual patches as well along with this pull request. ;)

Short note about the state of rt2x00:
  - Code cleaning is progressing, next version will probably contain
    the result of Lindent run. But after that I don't expect big changes regarding
    code style.

  - Writing "Magical" values to the registers has been reduced as much as possible,
    most values that are still magical are really magic and I have no clue on what they
    exactly mean, except that those values should be written. ;)

  - Suspend/resume is completely broken. I am not sure how the device should
    correctly suspend/resume. Most important points on this area are
    deregistering/registering ieee80211_hw and reassociation after resume.
    I am gathering some more info on this, and will post a bigger report on the mailinglist
    in a few days.

  - Statistics reading. Noise and Signal are still empty...
    It would really be nice to have some value to report for these statistics.

  - Bug reports show definite progress, rt2x00 doesn't really seem to break things,
    but neither is it doing a usefull things...

Ivo

---

The following changes since commit 9cc4f5142dd983d178b158e782d5e60900e48270:
  Michael Wu (1):
        mac80211: use more GFP_KERNEL instead of GFP_ATOMIC

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Adam Baker (1):
      rt2x00: Don't export unneeded symbols

Ivo van Doorn (13):
      rt2x00: Check permissions on debugfs write
      Merge branch 'wireless-dev'
      rt2x00: Use rts_cts_rate for CTS frames
      rt2x00: Cleanup allocation/initialization
      rt2x00: rt61pci interrupts are called on MCU CMD done
      rt2x00: Reduce requirement for debugfs wrapper functions
      rt2x00: Don't toggle promisc mode in link_tuner
      rt2x00: Fix MAC address initialization for multiple interfaces
      Merge branch 'wireless-dev'
      rt2x00: Check for all errors on RXdone
      rt2x00: Parse chipset revision for RT chip validation
      rt2x00: Release 2.0.4
      Merge branch 'wireless-dev'

 drivers/net/wireless/mac80211/rt2x00/rt2400pci.c   |   83 +--
 drivers/net/wireless/mac80211/rt2x00/rt2400pci.h   |    2 +-
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.c   |   90 +---
 drivers/net/wireless/mac80211/rt2x00/rt2500pci.h   |    2 +-
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.c   |  105 ++---
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.h   |    4 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00.h      |   17 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c |  237 +++------
 drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h |   27 +-
 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c   |  560 ++++++++++----------
 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.h   |    1 -
 drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c   |   57 ++-
 drivers/net/wireless/mac80211/rt2x00/rt2x00pci.c   |   58 ++-
 drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c   |  126 +++--
 drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h   |    1 -
 drivers/net/wireless/mac80211/rt2x00/rt61pci.c     |   99 ++---
 drivers/net/wireless/mac80211/rt2x00/rt61pci.h     |    2 +-
 drivers/net/wireless/mac80211/rt2x00/rt73usb.c     |  100 ++---
 drivers/net/wireless/mac80211/rt2x00/rt73usb.h     |    2 +-
 19 files changed, 731 insertions(+), 842 deletions(-)

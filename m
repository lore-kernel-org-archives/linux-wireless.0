Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:52877 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761287AbYDURAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 13:00:19 -0400
Received: by fk-out-0910.google.com with SMTP id 19so2556605fkr.5
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 10:00:18 -0700 (PDT)
To: linville@tuxdriver.com
Subject: Please pull 'upstream' branch of rt2x00
Date: Mon, 21 Apr 2008 19:06:45 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Message-Id: <200804211906.45496.IvDoorn@gmail.com> (sfid-20080421_190110_244095_E88CA8D2)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Finally a new official rt2x00 release,
off course I have send a lot of patches over the past few weeks
with several bugfixes, but now I am bumping the versions to 2.1.5.

Please consider this patch series for the 2.6.26 kernel,
they are all either bugfixes or minor cleanups.
with the exception of "[PATCH 4/9] rt2x00: Use rt2x00 queue numbering"
which besides a cleanup will also help with the pending mac80211
queue reorganization to QDisc.

Ivo

PS. Don't be alarmed over the "The following changes since commit"
line below which indicates "mac80211: Add IEEE80211_KEY_FLAG_PAIRWISE"
is used as basis. That patch is _not_ present in the rt2x00.git upstream branch
and none of the following patches depend on that patch.

---
The following changes since commit c8b29c460a389a8561189ad2a77fcb697ef35df9:
  Ivo van Doorn (1):
        mac80211: Add IEEE80211_KEY_FLAG_PAIRWISE

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (9):
      rt2x00: Support hardware RTS and CTS-to-self frames
      rt2x00: Remove DRIVER_SUPPORT_MIXED_INTERFACES
      rt2x00: Don't enable short preamble for 1MBs
      rt2x00: Use rt2x00 queue numbering
      rt2x00: Fix quality/activity led handling
      rt2x00: Clarify supported chipsets in Kconfig
      rt2x00: Add helper macros
      rt2x00: Fix kernel-doc
      rt2x00: Release rt2x00 2.1.5

 drivers/net/wireless/rt2x00/Kconfig       |   55 +++++++++++++++++------------
 drivers/net/wireless/rt2x00/rt2400pci.c   |   36 +++++++------------
 drivers/net/wireless/rt2x00/rt2500pci.c   |   39 +++++++-------------
 drivers/net/wireless/rt2x00/rt2500usb.c   |   22 ++++-------
 drivers/net/wireless/rt2x00/rt2x00.h      |   18 ++++-----
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    5 ++-
 drivers/net/wireless/rt2x00/rt2x00leds.c  |   15 ++++++++
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    6 +++
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   31 +++++++++-------
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.h   |    6 ++-
 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 ++--
 drivers/net/wireless/rt2x00/rt2x00queue.h |   40 +++++++++++++-------
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    4 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h   |   21 +++++++++--
 drivers/net/wireless/rt2x00/rt61pci.c     |   29 +++++----------
 drivers/net/wireless/rt2x00/rt73usb.c     |   35 +++++++-----------
 17 files changed, 191 insertions(+), 179 deletions(-)

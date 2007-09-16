Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbXIPMHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:07:45 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:07:45 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Sun, 16 Sep 2007 14:17:39 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Message-Id: <200709161417.40727.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

It has taken some time to finally release this,
but it contains quite a lot of bugfixes of variating impact.

Overall the stability has been greatly improved,
although there are still some nasty bugs in there.

Note that even after this update rt2x00 in wireless-dev will still not work
for encrypted networks. This is because rt2x00 depends on the encryption
patches by Johannes which are pending for wireless-dev inclusion
(Most notably the patch that fixes the IEEE80211_HW_WEP_INCLUDE_IV
behavior is required to make it work again).

Ivo

---

The following changes since commit e6d77b902151278df6a670b460a32e7cc6b75e9e:
  Luis R. Rodriguez (1):
        Merge branch 'ath5k' into everything

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (24):
      rt2x00: Remove firmware not-NULL check
      rt2x00: Don't check for IEEE80211_TXCTL_REQ_TX_STATUS
      rt2x00: Cleanup rxdone
      rt2x00: Don't allow configuration calls when uninitialized
      rt2x00: Fix rt61pci and rt73usb beacon handling
      rt2x00: Recalculate link quality
      rt2x00: Cleanup entry->flags
      rt2x00: Reduce LNA flags
      rt2x00: Rework RT61 and RT73 Antenna handling
      rt2x00: Rename DEVICE_SUPPORT_ATIM to REQUIRE_BEACON_RING
      rt2x00: Remove rt2x00mac_reset()
      rt2x00: Fix system freeze on device removal
      rt2x00: Reduce magic value writing to device
      rt2x00: New USB ID's for rt73usb and rt2500usb
      rt2x00: Beacon ring entries should have QID_MGMT
      rt2x00: Fix DEV_RATEBIT_ definitions
      rt2x00: Fix rfkill handling
      rt2x00: Merge allocation/free register components
      rt2x00: macro's shouldn't use hidden arguments
      rt2x00: Fix channel initialization
      rt2x00: Add better CONFIG_PM checks
      rt2x00: Add start/stop handlers
      rt2x00: Add additional bit to MAX_FRAME_UNIT
      rt2x00: Release rt2x00 2.0.8

 drivers/net/wireless/rt2x00/rt2400pci.c      |   37 +-
 drivers/net/wireless/rt2x00/rt2500pci.c      |   83 +++--
 drivers/net/wireless/rt2x00/rt2500pci.h      |   40 ++-
 drivers/net/wireless/rt2x00/rt2500usb.c      |  208 ++++++++--
 drivers/net/wireless/rt2x00/rt2500usb.h      |   39 ++-
 drivers/net/wireless/rt2x00/rt2x00.h         |   47 ++-
 drivers/net/wireless/rt2x00/rt2x00config.c   |   12 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c    |   26 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c      |  308 ++++++--------
 drivers/net/wireless/rt2x00/rt2x00firmware.c |    6 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h      |    4 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c      |  111 ++++--
 drivers/net/wireless/rt2x00/rt2x00pci.c      |  127 ++----
 drivers/net/wireless/rt2x00/rt2x00pci.h      |    3 +
 drivers/net/wireless/rt2x00/rt2x00reg.h      |   27 +-
 drivers/net/wireless/rt2x00/rt2x00rfkill.c   |    6 +-
 drivers/net/wireless/rt2x00/rt2x00ring.h     |   29 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c      |  235 +++--------
 drivers/net/wireless/rt2x00/rt2x00usb.h      |    9 +-
 drivers/net/wireless/rt2x00/rt61pci.c        |  617 ++++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt61pci.h        |   87 ++++-
 drivers/net/wireless/rt2x00/rt73usb.c        |  471 +++++++++++++-------
 drivers/net/wireless/rt2x00/rt73usb.h        |   65 +++-
 23 files changed, 1615 insertions(+), 982 deletions(-)

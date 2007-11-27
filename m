Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:23631 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXK0Tjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 14:39:37 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1321058ugc
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 11:39:35 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Please pull 'upstream' branch of rt2x00
Date: Tue, 27 Nov 2007 21:46:53 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711272146.53518.IvDoorn@gmail.com> (sfid-20071127_200531_499305_97B9C489)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the latest version of rt2x00.

Please merge the patches for 2.6.24
09 - Only update rssi average approximation on receiving beacon frames.
10 - Remove redundant code in rfkill setup
11 - Cleanup rfkill

All other patches can wait for 2.6.25, since they are code cleanups and the
new TX/RX frame dumping facility through debugfs.

Ivo

---

The following changes since commit 301df40749bdf144c72637795ba93d82e4b84682:
  Johannes Berg (1):
        mac80211: remove more forgotten code

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (9):
      rt2x00: Replace DRV_NAME with KBUILD_MODNAME
      rt2x00: Extend PLCP descriptor definition for rt2400pci
      rt2x00: Move register value/offset files into new folder
      rt2x00: Add chipset version to chipset debugfs entry
      rt2x00: Add skb descriptor
      rt2x00: Add TX/RX frame dumping facility
      rt2x00: Use IEEE80211_IF_TYPE_INVALID directly
      rt2x00: Cleanup rfkill
      rt2x00: Release rt2x00 2.0.13

Larry Finger (1):
      rt2x00: Remove redundant code in rfkill setup

Mattias Nissler (1):
      rt2x00: Only update rssi average approximation on receiving beacon frames.

 drivers/net/wireless/rt2x00/rt2400pci.c      |   49 ++----
 drivers/net/wireless/rt2x00/rt2400pci.h      |   20 ++-
 drivers/net/wireless/rt2x00/rt2500pci.c      |    9 +-
 drivers/net/wireless/rt2x00/rt2500usb.c      |   39 +++--
 drivers/net/wireless/rt2x00/rt2x00.h         |   26 ++-
 drivers/net/wireless/rt2x00/rt2x00config.c   |    5 -
 drivers/net/wireless/rt2x00/rt2x00debug.c    |  240 +++++++++++++++++++++++---
 drivers/net/wireless/rt2x00/rt2x00dev.c      |   93 ++++++----
 drivers/net/wireless/rt2x00/rt2x00firmware.c |    5 -
 drivers/net/wireless/rt2x00/rt2x00lib.h      |    6 +
 drivers/net/wireless/rt2x00/rt2x00mac.c      |    7 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c      |   59 +++++--
 drivers/net/wireless/rt2x00/rt2x00rfkill.c   |   15 --
 drivers/net/wireless/rt2x00/rt2x00ring.h     |   22 +++
 drivers/net/wireless/rt2x00/rt2x00usb.c      |   41 +++--
 drivers/net/wireless/rt2x00/rt61pci.c        |   36 +++--
 drivers/net/wireless/rt2x00/rt73usb.c        |   36 +++--
 17 files changed, 484 insertions(+), 224 deletions(-)

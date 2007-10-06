Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:17023 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719AbXJFMEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:04:24 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605537ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:04:23 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Sat, 6 Oct 2007 14:19:35 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Message-Id: <200710061419.36324.IvDoorn@gmail.com> (sfid-20071006_131653_879696_BF6C6947)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the rt2x00 2.0.10 update.
Some obvious bugs have been fixed, some not so obvious bugs,
and the code has been cleaned up a bit by moving more
into rt2x00lib.

Note that as of now rt2x00.git will be branched from the wireless-2.6
git tree. I see wireless-dev has already been removed/renamed so
I won't be using that anymore. ;)

All indivual patches can also be found here:
http://kernel.org//pub/linux/kernel/people/ivd/rt2x00-2.0.10/

Ivo

---

The following changes since commit f88cf9b6d7c8dad6eb64a972a753584b8006c545:
  John W. Linville (1):
        zd1211rw-mac80211: undo print_mac API stuff

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (16):
      rt2x00: Remove duplicate code in MAC & BSSID handling
      rt2x00: Remove radio check from rt2x00lib_toggle_rx
      rt2x00: Store "STARTED" state during suspend
      rt2x00: Move rt2x00dev flags into enumeration
      rt2x00: Don't use changed_flags inside configure_packet_filter
      rt2x00: Fix rfkill handling
      rt2x00: Move TSF sync values into rt2x00config
      rt2x00: get_duration expects values in 100kbs
      rt2x00: Cut lines down to 80 characters
      rt2x00: Add get_tx_data_len callback function
      rt2x00: Pass dev_state to rt2x00lib_toggle_rx
      rt2x00: Small optimizations
      rt2x00: Reorganize configuration handler
      rt2x00: Clean disabling of rt73usb_get_tsf
      rt2x00: Allways memset memory obtained from skb_push()
      rt2x00: Release 2.0.10

 drivers/net/wireless/rt2x00/rt2400pci.c    |  186 ++++++++++----------------
 drivers/net/wireless/rt2x00/rt2500pci.c    |  201 +++++++++++-----------------
 drivers/net/wireless/rt2x00/rt2500usb.c    |  200 ++++++++++++----------------
 drivers/net/wireless/rt2x00/rt2x00.h       |   93 ++++++++++---
 drivers/net/wireless/rt2x00/rt2x00config.c |  113 +++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   52 +++++---
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   14 +--
 drivers/net/wireless/rt2x00/rt2x00mac.c    |   38 +++++-
 drivers/net/wireless/rt2x00/rt2x00reg.h    |    9 ++
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |    4 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c    |   29 +++--
 drivers/net/wireless/rt2x00/rt61pci.c      |  166 +++++++----------------
 drivers/net/wireless/rt2x00/rt73usb.c      |  195 +++++++++++----------------
 13 files changed, 642 insertions(+), 658 deletions(-)

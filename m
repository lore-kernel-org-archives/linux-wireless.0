Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:21084 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbYEJMJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:09:46 -0400
Received: by nf-out-0910.google.com with SMTP id d3so883147nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:09:45 -0700 (PDT)
To: linville@tuxdriver.com
Subject: Please pull 'upstream' branch of rt2x00
Date: Sat, 10 May 2008 13:37:13 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805101337.14536.IvDoorn@gmail.com> (sfid-20080510_141007_597850_E22BDE8A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is a new rt2x00 release.
Please note that some patches have been send individually to linux-wireless before,
(including the 2 mac80211 patches) but for completeness I have added them to
this pull request.

This will bump rt2x00 to version 2.1.6, most patches are only intended to make
room for future patches like the mac80211 patch series from Johannes, HW crypto
and pci drivers without a preallocated big chunk of DMA.

Ivo

---
The following changes since commit d30d1674356e223c9f2c164ac9d0be35af8ee4e0:
  Johannes Berg (1):
        mac80211: fix wme code

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Gertjan van Wingerde (3):
      rt2x00: Clean up error handling of PCI queue DMA allocation.
      rt2x00: Fix queue related oops in case of deselected mac80211 multi-queue feature.
      rt2x00: Only initialize the minimum needed fields of PCI TX descriptors.

Ivo van Doorn (13):
      rt2x00: Don't use pskb_expand_head()
      rt2x00: Fix broken recover-on-error path
      mac80211: Don't encrypt beacons
      mac80211: Add RTNL version of ieee80211_iterate_active_interfaces
      rt2x00: trim skb_frame_desc to 32 bytes
      rt2x00: Fix TX status reporting
      rt2x00: Remove ieee80211_tx_control argument from write_tx_desc()
      rt2x00: Preserve descriptor information after memmove()
      rt2x00: Split rt2x00lib_write_tx_desc()
      rt2x00: Remove redundant flags/dev_flags initializations
      rt2x00: Merge RX and TX entry private data
      rt2x00: Remove extra +
      rt2x00: Release rt2x00 2.1.6

 drivers/net/wireless/rt2x00/rt2400pci.c   |  126 +++++++++-------
 drivers/net/wireless/rt2x00/rt2400pci.h   |    5 +
 drivers/net/wireless/rt2x00/rt2500pci.c   |  114 ++++++++------
 drivers/net/wireless/rt2x00/rt2500pci.h   |    5 +
 drivers/net/wireless/rt2x00/rt2500usb.c   |   78 +++++-----
 drivers/net/wireless/rt2x00/rt2500usb.h   |    5 +
 drivers/net/wireless/rt2x00/rt2x00.h      |   48 +++++--
 drivers/net/wireless/rt2x00/rt2x00debug.c |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c   |  190 +++---------------------
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    6 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c   |  105 +++++--------
 drivers/net/wireless/rt2x00/rt2x00pci.h   |   22 +---
 drivers/net/wireless/rt2x00/rt2x00queue.c |  165 ++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00queue.h |   45 ++++--
 drivers/net/wireless/rt2x00/rt2x00reg.h   |   11 --
 drivers/net/wireless/rt2x00/rt2x00usb.c   |  228 +++++++++++++++-------------
 drivers/net/wireless/rt2x00/rt2x00usb.h   |   17 +--
 drivers/net/wireless/rt2x00/rt61pci.c     |  146 ++++++++++---------
 drivers/net/wireless/rt2x00/rt61pci.h     |    5 +
 drivers/net/wireless/rt2x00/rt73usb.c     |   53 ++++----
 drivers/net/wireless/rt2x00/rt73usb.h     |    5 +
 include/net/mac80211.h                    |   25 +++-
 net/mac80211/tx.c                         |    1 +
 net/mac80211/util.c                       |   37 +++++-
 25 files changed, 794 insertions(+), 654 deletions(-)

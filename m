Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:45416 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbYFHVh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 17:37:28 -0400
Received: by ug-out-1314.google.com with SMTP id h2so1022998ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 14:37:26 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Sun, 8 Jun 2008 23:41:58 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806082341.58616.IvDoorn@gmail.com> (sfid-20080608_233731_726480_1BEE8240)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the official pull request for the latest rt2x00.git.
This contains all patches which I had send last tuesday
plus some additional patches intended for 2.6.27.

This series is mostly intended to get the fragmentation
done right. Up until now the drivers never behaved that
nicely with fragmentation or RTS/CTS-to-sellf which was
mostly due because each individual frame forced the
queue to be kicked immediately without waiting for the
other fragments.

It also contains some front work by Gertjan for reducing
DMA requirements in rt2x00 by making use of pci_map_single
on skbuffers instead of preallocating a chunk of DMA.

Ivo

P.S. I won't resend the patches I had send last tuesday
since nothing has changed with them. So only the 10
new patches will be send seperately. I am not sure
if that feature will be ready/stable for 2.6.27 but this
preperational work is harmless for normal operations
to it is better if that is already in.

---
The following changes since commit ef28eab0c928fe8277d7c3dca234c29f734d7f2e:
  Dan Williams (1):
        ipw2200: queue direct scans

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Gertjan van Wingerde (5):
      rt2x00: Restrict DMA to 32-bit addresses.
      rt2x00: Cleanup struct skb_frame_desc.
      rt2x00: Centralize RX packet alignment handling in rt2x00lib.
      rt2x00: Fix double usage of skb->cb in USB RX path.
      rt2x00: Rework alignment check.

Ivo van Doorn (15):
      rt2x00: Calculate register offset during compile time
      rt2x00: Cleanup/optimize set_state() function callback function
      rt2x00: Move led initialization into function
      rt2x00: Remove CTS/RTS check in tx()
      rt2x00: Removed unused descriptor read in txdone
      rt2x00: Don't kill guardian_urb when it wasn't created
      rt2x00: Make rt2x00_set/get_field macros
      rt2x00: Release rt2x00 2.1.7
      rt2x00: Fix queue initialization
      rt2x00: Implement rt2x00usb_kick_tx_queue()
      rt2x00: Move generic TX frame writing code into rt2x00queue
      rt2x00: Don't kick TX queue after each frame
      rt2x00: Use __builtin_choose_expr() instead of ?:
      rt2x00: Clear IEEE80211_TX_CTL_USE_RTS_CTS flag for RTS frame
      rt2x00: Remove unused defines

 drivers/net/wireless/rt2x00/rt2400pci.c   |   95 ++++++++---------
 drivers/net/wireless/rt2x00/rt2400pci.h   |    2 -
 drivers/net/wireless/rt2x00/rt2500pci.c   |   91 +++++++--------
 drivers/net/wireless/rt2x00/rt2500pci.h   |    2 -
 drivers/net/wireless/rt2x00/rt2500usb.c   |   98 ++++++++--------
 drivers/net/wireless/rt2x00/rt2500usb.h   |    2 -
 drivers/net/wireless/rt2x00/rt2x00.h      |   13 ++-
 drivers/net/wireless/rt2x00/rt2x00debug.c |    6 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   21 ++++
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    1 +
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   30 ++----
 drivers/net/wireless/rt2x00/rt2x00pci.c   |   75 ++++---------
 drivers/net/wireless/rt2x00/rt2x00pci.h   |   11 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |  111 ++++++++++++++++---
 drivers/net/wireless/rt2x00/rt2x00queue.h |   27 +++--
 drivers/net/wireless/rt2x00/rt2x00reg.h   |  134 +++++++++++++---------
 drivers/net/wireless/rt2x00/rt2x00usb.c   |  170 +++++++++++------------------
 drivers/net/wireless/rt2x00/rt2x00usb.h   |   22 +++-
 drivers/net/wireless/rt2x00/rt61pci.c     |  111 ++++++++-----------
 drivers/net/wireless/rt2x00/rt61pci.h     |    2 -
 drivers/net/wireless/rt2x00/rt73usb.c     |  112 +++++++++----------
 drivers/net/wireless/rt2x00/rt73usb.h     |    2 -
 22 files changed, 581 insertions(+), 557 deletions(-)

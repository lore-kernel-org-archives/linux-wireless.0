Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:40381 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYFFV5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 17:57:44 -0400
Received: by ug-out-1314.google.com with SMTP id h2so784748ugf.16
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2008 14:57:42 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 00/11] rt2x00 update
Date: Sat, 7 Jun 2008 00:07:00 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806032033.25548.IvDoorn@gmail.com>
In-Reply-To: <200806032033.25548.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806070007.01156.IvDoorn@gmail.com> (sfid-20080606_235757_662513_F50C5694)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 03 June 2008, Ivo van Doorn wrote:
> Hi John,
> 
> I'm a bit fighting with rt2x00.git because I am trying
> to reordering some patches that need to go upstream
> earlier then the patches on which they depend. 
> So this time the rt2x00 update is a patch series through mail only,
> to make sure at least the main bulk of the changes is already
> upstream while I'll sort out the remaining bugfix patches.

The full patch series is now also available through the rt2x00.git upstream branch.

---
The following changes since commit ef28eab0c928fe8277d7c3dca234c29f734d7f2e:
  Dan Williams (1):
        ipw2200: queue direct scans

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Gertjan van Wingerde (1):
      rt2x00: Restrict DMA to 32-bit addresses.

Ivo van Doorn (9):
      rt2x00: Calculate register offset during compile time
      rt2x00: Cleanup/optimize set_state() function callback function
      rt2x00: Move led initialization into function
      rt2x00: Remove CTS/RTS check in tx()
      rt2x00: Removed unused descriptor read in txdone
      rt2x00: Don't kill guardian_urb when it wasn't created
      rt2x00: Make rt2x00_set/get_field macros
      rt2x00: Release rt2x00 2.1.7
      rt2x00: Fix queue initialization

 drivers/net/wireless/rt2x00/rt2400pci.c   |   88 +++++++++----------
 drivers/net/wireless/rt2x00/rt2500pci.c   |   88 +++++++++----------
 drivers/net/wireless/rt2x00/rt2500usb.c   |   76 +++++++++--------
 drivers/net/wireless/rt2x00/rt2x00.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    3 +
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   12 +--
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    3 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |    7 +-
 drivers/net/wireless/rt2x00/rt2x00reg.h   |  130 +++++++++++++++++------------
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    9 +-
 drivers/net/wireless/rt2x00/rt61pci.c     |  102 ++++++++++-------------
 drivers/net/wireless/rt2x00/rt73usb.c     |   90 ++++++++++----------
 12 files changed, 307 insertions(+), 303 deletions(-)

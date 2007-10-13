Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:21986 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbXJMOKs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 10:10:48 -0400
Received: by nf-out-0910.google.com with SMTP id g13so956439nfb
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2007 07:10:47 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Sat, 13 Oct 2007 16:27:21 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200710131627.22505.IvDoorn@gmail.com> (sfid-20071013_151715_465714_713E9D14)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the rt2x00 2.0.11 update.
Highlights for this release are the fix for the TX problems,
and the implementation of the Software Diversity Antenna.

All indivual patches can also be found here:
http://kernel.org//pub/linux/kernel/people/ivd/rt2x00-2.0.11/

Ivo

---

The following changes since commit 2d46d1e00056de79e54c622a60f7e6f8818f6cb4:
  Mattias Nissler (1):
        mac80211: Defer setting of RX_FLAG_DECRYPTED.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (9):
      rt2x00: Move quality statistics into seperate structure
      rt2x00: Use enum defines
      rt2x00: Correctly translate mac80211 antenna setup to rt2x00
      rt2x00: SW diversity should default to antenna B
      rt2x00: Remove rt2x00_clear_link
      rt2x00: Implement SW diversity
      rt2x00: Cleanup if-statements
      rt2x00: Add new rt73usb USB ID
      rt2x00: Release rt2x00 2.0.11

Mattias Nissler (2):
      rt2x00: Fix residual check in PLCP calculations.
      rt2x00: Fix antenna selection.

 drivers/net/wireless/rt2x00/rt2400pci.c    |   80 +++++++-----
 drivers/net/wireless/rt2x00/rt2500pci.c    |   88 ++++++------
 drivers/net/wireless/rt2x00/rt2500usb.c    |   84 +++++++-----
 drivers/net/wireless/rt2x00/rt2500usb.h    |   13 ++-
 drivers/net/wireless/rt2x00/rt2x00.h       |  165 +++++++++++++++++------
 drivers/net/wireless/rt2x00/rt2x00config.c |   85 +++++++++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |  201 ++++++++++++++++++++++++----
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    2 +
 drivers/net/wireless/rt2x00/rt61pci.c      |  116 +++++++++--------
 drivers/net/wireless/rt2x00/rt73usb.c      |   87 +++++++------
 10 files changed, 645 insertions(+), 276 deletions(-)

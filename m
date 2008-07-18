Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:7770 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbYGRSlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 14:41:13 -0400
Received: by nf-out-0910.google.com with SMTP id d3so160308nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 11:41:11 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Fri, 18 Jul 2008 20:43:08 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807182043.08990.IvDoorn@gmail.com> (sfid-20080718_204116_545037_146C18BD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the latest update for rt2x00

I think all patches qualify for 2.6.27, 
with the exception for first 2 patches:
      rt2x00: Remove duplicate declaration
      rt2x00: Fix EIFS timing value
but those are one-liners and have little impact.

The 3 patches from Iwo are the most important ones,
since that fixes a major bug in the beacon handling for the
USB drivers. The 3 patches are a bit big, but without them
beaconing simply won't work.

Ivo

---
The following changes since commit a520bdbe7d344296482f9355e29b0018ea58760f:
  John W. Linville (1):
        iwl-scan.c: fixup merge damage in wireless-testing#master

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ ..BRANCH.NOT.VERIFIED..

Ivo van Doorn (3):
      rt2x00: Remove duplicate declaration
      rt2x00: Fix EIFS timing value
      rt2x00: Fix GCC warning because aifs is now unsigned

Iwo Mergler (3):
      rt2x00: Support for large vendor requests
      rt2x00: Large vendor requests for rt73usb firmware upload and beacons
      rt2x00: Fix the beacon length bug

 drivers/net/wireless/rt2x00/rt2500usb.c |   12 +++++++
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h |    7 ----
 drivers/net/wireless/rt2x00/rt2x00mac.c |    5 +--
 drivers/net/wireless/rt2x00/rt2x00usb.c |   33 ++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00usb.h |   22 ++++++++++++-
 drivers/net/wireless/rt2x00/rt73usb.c   |   50 ++++++++++++------------------
 7 files changed, 87 insertions(+), 44 deletions(-)

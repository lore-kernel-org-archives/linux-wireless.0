Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:14299 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbYGSODP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 10:03:15 -0400
Received: by nf-out-0910.google.com with SMTP id d3so250599nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2008 07:03:13 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Sat, 19 Jul 2008 16:15:22 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807191615.22752.IvDoorn@gmail.com> (sfid-20080719_160319_381709_D23C90C4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is the updated patch series,
I have dropped the compile warning patch because Johannes has
already send it before, the EIFS patch has been updated to use the
correct definition instead of hardcoding the value, and some
coding style fixes went into Iwo's patches.

Patches are still intended for 2.6.27

Ivo

---
The following changes since commit a520bdbe7d344296482f9355e29b0018ea58760f:
  John W. Linville (1):
        iwl-scan.c: fixup merge damage in wireless-testing#master

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (2):
      rt2x00: Remove duplicate declaration
      rt2x00: Fix EIFS timing value

Iwo Mergler (3):
      rt2x00: Support for large vendor requests
      rt2x00: Large vendor requests for rt73usb firmware upload and beacons
      rt2x00: Fix the beacon length bug

 drivers/net/wireless/rt2x00/rt2500usb.c    |   12 ++++++
 drivers/net/wireless/rt2x00/rt2x00.h       |    5 ++-
 drivers/net/wireless/rt2x00/rt2x00config.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    7 ----
 drivers/net/wireless/rt2x00/rt2x00usb.c    |   32 +++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00usb.h    |   22 +++++++++++-
 drivers/net/wireless/rt2x00/rt73usb.c      |   52 +++++++++++----------------
 7 files changed, 90 insertions(+), 42 deletions(-)

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:33793 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbYLBRXK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 12:23:10 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1328678eyi.37
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 09:23:08 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Tue, 2 Dec 2008 18:19:23 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812021819.23756.IvDoorn@gmail.com> (sfid-20081202_182314_618429_BE3B7B66)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is a new batch of updates for rt2x00.

The first patch (rt2x00: Optimize IV/EIV handling) was send individually
a few days ago, but it is probably easier if you pull it along with the rest
of the patches during this merge.

Small warning which might be important:
The patch "Implement HW encryption (rt2500usb)" adds support for HW crypto
but it does _not_ activate it. The module parameter "nohwcrypt" is set to 1
by default for now. This code has been sleeping in the rt2x00 experimental branch
for quite some time now, and doesn't work completely. I hope to debug this
further when I have time, but I am hoping that with the code in wireless-testing
other people will take a look at it to see what might be going wrong.

Ivo

---
The following changes since commit ca072018d6425a55b3f0e6d8bd3e6217ee509065:
  Winkler, Tomas (1):
        iwlwifi: TX update chicken bits

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (5):
      rt2x00: Optimize IV/EIV handling
      rt2x00: Store retry limit values
      rt2x00: Remove duplicate code
      rt2x00: Implement HW encryption (rt2500usb)
      rt2x00: Release rt2x00 2.2.3

 drivers/net/wireless/rt2x00/Kconfig        |    1 +
 drivers/net/wireless/rt2x00/rt2500usb.c    |  132 ++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2500usb.h    |    3 +
 drivers/net/wireless/rt2x00/rt2x00.h       |    9 ++-
 drivers/net/wireless/rt2x00/rt2x00config.c |   39 +++++----
 drivers/net/wireless/rt2x00/rt2x00crypto.c |   56 ++++++------
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    6 ++
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    2 -
 drivers/net/wireless/rt2x00/rt2x00queue.c  |   17 ++--
 drivers/net/wireless/rt2x00/rt2x00queue.h  |   12 +--
 drivers/net/wireless/rt2x00/rt61pci.c      |    8 +-
 drivers/net/wireless/rt2x00/rt73usb.c      |    8 +-
 12 files changed, 211 insertions(+), 82 deletions(-)

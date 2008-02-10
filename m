Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:34552 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYBJVs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:48:29 -0500
Received: by fk-out-0910.google.com with SMTP id z23so4237858fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:48:27 -0800 (PST)
To: linville@tuxdriver.com
Subject: Please pull 'upstream' branch of rt2x00
Date: Sun, 10 Feb 2008 22:46:04 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102246.04515.IvDoorn@gmail.com> (sfid-20080210_214833_495910_A21869F5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is a quick followup release labeled 2.1.1. The previous release
contained many bugs as it was mostly untested. Result was there
were critical issues with it, of which some have now been fixed.

The most critical issues are random panics due to corrupt memory access,
at the moment none of the drivers are displaying any activity yet where
rt73usb is still crashing at random times.

Ivo

---

The following changes since commit d86916b7d36c4f0db8634fcc17fe2d747b317f17:
  John W. Linville (1):
        Merge branch 'at76' into everything

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Adam Baker (1):
      rt2x00: correct address calc for queue private data

Ivo van Doorn (13):
      rt2x00: Fix invalid DMA free
      rt2x00: Make rt2x00 less verbose
      rt2x00: Remove MGMT ring initialization
      rt2x00: Select CONFIG_NEW_LEDS
      rt2x00: make csr_cache and csr_addr an union
      rt2x00: Fix scheduling while atomic errors in usb drivers
      rt2x00: Add queue statistics to debugfs
      rt2x00: Fix typo in debug statement
      rt2x00: Fix skbdesc->data_len initialization
      rt2x00: Fix queue->qid initialization
      rt2x00: Cleanup Makefile
      rt2x00: Kill guardian urb during disable_radio
      rt2x00: Release rt2x00 2.1.1

 drivers/net/wireless/rt2x00/Kconfig       |    1 +
 drivers/net/wireless/rt2x00/Makefile      |   41 +++++-------
 drivers/net/wireless/rt2x00/rt2400pci.c   |    4 -
 drivers/net/wireless/rt2x00/rt2500pci.c   |    4 -
 drivers/net/wireless/rt2x00/rt2500usb.c   |    6 +--
 drivers/net/wireless/rt2x00/rt2x00.h      |   12 ++--
 drivers/net/wireless/rt2x00/rt2x00debug.c |   90 ++++++++++++++++++++++----
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    9 +++-
 drivers/net/wireless/rt2x00/rt2x00pci.c   |   99 +++++++++++++++++++---------
 drivers/net/wireless/rt2x00/rt2x00pci.h   |    8 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |   36 ++++++-----
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   37 ++++++++---
 drivers/net/wireless/rt2x00/rt61pci.c     |    8 +--
 drivers/net/wireless/rt2x00/rt61pci.h     |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c     |    8 +--
 15 files changed, 231 insertions(+), 134 deletions(-)

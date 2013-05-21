Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:33498 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab3EUXHc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 May 2013 19:07:32 -0400
Date: Wed, 22 May 2013 01:07:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@lists.01.org>
Subject: [GIT] [3.10] NFC fixes
Message-ID: <20130521230711.GD4566@zurbaran> (sfid-20130522_010735_163201_09C6AEF8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the first batch of NFC fixes for 3.10, and it contains:

- 3 fixes for the NFC MEI support:
        * We now depend on the correct Kconfig symbol.
        * We register an MEI event callback whenever we enable an NFC device,
          otherwise we fail to read anything after an enable/disable cycle.
        * We only disable an MEI device from its disable mey_phy_ops,
          preventing useless consecutive disable calls.

- An NFC Makefile cleanup, as I forgot to remove a commented out line when
  moving the LLCP code to the NFC top level directory.

The following changes since commit 6bb4880d9ef30375da4507aeabd6dc261a2c6c2b:

  ath9k: fix draining aggregation tid buffers (2013-05-17 14:31:09 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes.git tags/nfc-fixes-3.10-1

for you to fetch changes up to e3a6b14ceda0207c3405c6266e5177a85c0db044:

  NFC: mei: Do not disable MEI devices from their remove routine (2013-05-21 10:48:41 +0200)

----------------------------------------------------------------
Paul Bolle (1):
      NFC: Remove commented out LLCP related Makefile line

Samuel Ortiz (3):
      NFC: mei_phy depends on INTEL_MEI
      NFC: mei_phy: Register event callback when enabling the device
      NFC: mei: Do not disable MEI devices from their remove routine

 drivers/nfc/Kconfig         |    2 +-
 drivers/nfc/mei_phy.c       |    9 +++++++++
 drivers/nfc/microread/mei.c |   20 +++++---------------
 drivers/nfc/pn544/mei.c     |   20 +++++---------------
 net/nfc/Makefile            |    1 -
 5 files changed, 20 insertions(+), 32 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

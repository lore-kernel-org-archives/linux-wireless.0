Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.181]:24297 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbYJ2Q2r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 12:28:47 -0400
Received: by ik-out-1112.google.com with SMTP id c29so76007ika.5
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 09:28:44 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Wed, 29 Oct 2008 17:16:47 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810291716.47342.IvDoorn@gmail.com> (sfid-20081029_172913_827502_0DB09DD7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Well over a month since my last rt2x00 patches, but finally a real rt2x00 update.
The first 2 patches are updates based on recent mac80211 changes,
especially the configuration patch is important.

I also noticed that the recent Kconfig fixes introduced a possibility of a build error,
not sure if it was reported by somebody yet, but in any case it was possible to
build mac80211 as module and rt2x00 compiled into the kernel, causing obvious
problems.

Ivo

---
The following changes since commit 43288a0fdd6b970dec3017ceaffb70cf6347e5f0:
  John W. Linville (1):
        ath5k: fixup warnings created by "ath5k: Reset key cache..."

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (5):
      rt2x00: Optimize configuration handling
      rt2x00: Remove ieee80211_bss_conf from rt2x00_intf
      rt2x00: Improve interface_modes initialization
      rt2x00: Fix build error when mac80211=M rt2x00=Y
      rt2x00: Release rt2x00 2.2.2

 drivers/net/wireless/rt2x00/Kconfig        |    2 +-
 drivers/net/wireless/rt2x00/rt2400pci.c    |  167 ++++++++++-----------
 drivers/net/wireless/rt2x00/rt2500pci.c    |  206 ++++++++++++-------------
 drivers/net/wireless/rt2x00/rt2500usb.c    |  110 ++++++-------
 drivers/net/wireless/rt2x00/rt2x00.h       |   44 ++----
 drivers/net/wireless/rt2x00/rt2x00config.c |  164 +++-----------------
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   16 ++-
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c    |   12 +--
 drivers/net/wireless/rt2x00/rt61pci.c      |  231 ++++++++++++++--------------
 drivers/net/wireless/rt2x00/rt73usb.c      |  216 +++++++++++++-------------
 11 files changed, 501 insertions(+), 670 deletions(-)

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:38427 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab3DMAMD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Apr 2013 20:12:03 -0400
Received: by mail-ob0-f169.google.com with SMTP id wp18so2812415obc.28
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2013 17:12:02 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 13 Apr 2013 02:12:02 +0200
Message-ID: <CACna6rxduYfWw2B+tHLSGTC-m0hDf3=dTWCFq6twjK2kpCuqwg@mail.gmail.com> (sfid-20130413_021208_450487_2D97C8BD)
Subject: pull request: b43-next 2013-04-13
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

I wanted to ask you for pulling b43 changes queued for 3.10. They are all
sitting in my git repo at infradead I've announced a few weeks ago.

Changes include:
1) Minor improvements for HT-PHY code (BCM4331)
2) Code cleaning for HT-PHY and N-PHY
They are mostly coming from me, but I've also included Hauke's minor cleanup.

All patches were posted (and I believe all of them reviewed) on b43-dev ML.

I've used various hardware to cover and test all code paths that has been
touched. That included BCM4321, BCM4322 and BCM43224. No regressions spotted.
I've also built b43 for my Broadcom SoC based router to test HT-PHY code on
BCM4331.

Please let me know if that looks OK and if you can pull this tree, or if there
are any problems.


The following changes since commit 9cc04d692c031bf2113338b03974511670ac5cc9:

  Merge branch 'master' of
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next
(2013-03-27 17:33:52 -0400)

are available in the git repository at:


  git://git.infradead.org/users/rafal/b43-next.git master

for you to fetch changes up to adca58e2b4f350e9a93ca6c953be3f8e76ed541e:

  b43: N-PHY: don't use deprecated b43_radio_foo16 (2013-04-13 01:32:48 +0200)

----------------------------------------------------------------
Hauke Mehrtens (1):
      b43: N-PHY: use bcma_pmu_spuravoid_pllupdate()

Rafał Miłecki (21):
      b43: HT-PHY: rename defines addressing cores on the 2059 radio
      b43: HT-PHY: tables: don't duplicate core-generic regs
      b43: HT-PHY: finish calculating values for idle TSSI
      b43: HT-PHY: do some extra TSSI setup after configuring TX
      b43: HT-PHY: define regs for power estimation
      b43: HT-PHY: store TX power state before disabling it
      b43: HT-PHY: use enum for RSSI types
      b43: N-PHY: use enum for RAIL type
      b43: N-PHY: simplify conditions in RSSI offset scale function
      b43: N-PHY: use more friendly variables names in RSSI code
      b43: N-PHY: rename RSSI types to be shorter and more accurate
      b43: N-PHY: use enum for RSSI type everywhere we use it
      b43: N-PHY: fix "NB" RSSI calibration on PHYs rev2-
      b43: use defines for board_type
      b43: N-PHY: define missing registers
      b43: N-PHY: use enum for INTC override function argument
      b43: N-PHY: use shortcut "ctl" in functions names
      b43: N-PHY: use defines for (re)storing VCM config
      b43: N-PHY: move tables init function to tables file
      b43: N-PHY: clean init tables
      b43: N-PHY: don't use deprecated b43_radio_foo16

 drivers/net/wireless/b43/phy_ht.c      |  119 ++++--
 drivers/net/wireless/b43/phy_ht.h      |    6 +
 drivers/net/wireless/b43/phy_lp.c      |    4 +-
 drivers/net/wireless/b43/phy_n.c       |  705 ++++++++++++++++----------------
 drivers/net/wireless/b43/phy_n.h       |  146 +++++++
 drivers/net/wireless/b43/radio_2059.c  |   39 +-
 drivers/net/wireless/b43/radio_2059.h  |   14 +-
 drivers/net/wireless/b43/tables_nphy.c |   97 +++--
 drivers/net/wireless/b43/tables_nphy.h |   29 +-
 9 files changed, 663 insertions(+), 496 deletions(-)

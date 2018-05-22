Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56842 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbeEVO2P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 10:28:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2018-05-22
Date: Tue, 22 May 2018 17:28:11 +0300
Message-ID: <87603fg3yc.fsf@kamboji.qca.qualcomm.com> (sfid-20180522_162834_964910_B9E87089)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

here's a pull request to net tree for 4.17. Please let me know if you
have any problems.

Kalle

The following changes since commit a8d7aa17bbc970971ccdf71988ea19230ab368b1:

  dccp: fix tasklet usage (2018-05-03 15:14:57 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git =
tags/wireless-drivers-for-davem-2018-05-22

for you to fetch changes up to 813477aa49aac5deba04eb4956360dde58a0e807:

  MAINTAINERS: change Kalle as wcn36xx maintainer (2018-05-22 15:36:41 +030=
0)

----------------------------------------------------------------
wireless-drivers fixes for 4.17

Hopefully the last fixes for 4.17. ssb is again causing problems so we
had to revert a commit and fix it better. Also a small fix to bcma and
some MAINTAINERS file updates.

ssb

* fix regression with all module PCI cards, for example using b43 and
  b44 drivers

* try again fixing a MIPS linker error

bcma

* fix truncated info log messages

----------------------------------------------------------------
Kalle Valo (3):
      MAINTAINERS: update Kalle's email address
      MAINTAINERS: change Kalle as ath.ko maintainer
      MAINTAINERS: change Kalle as wcn36xx maintainer

Rafa=C5=82 Mi=C5=82ecki (3):
      bcma: fix buffer size caused crash in bcma_core_mips_print_irq()
      Revert "ssb: Prevent build of PCI host features in module"
      ssb: make SSB_PCICORE_HOSTMODE depend on SSB =3D y

 MAINTAINERS                | 8 ++++----
 drivers/bcma/driver_mips.c | 2 +-
 drivers/ssb/Kconfig        | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

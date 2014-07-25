Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18663 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaGYJRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 05:17:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Pull request: ath 20140725
Date: Fri, 25 Jul 2014 12:10:57 +0300
Message-ID: <87wqb1pzvi.fsf@kamboji.qca.qualcomm.com> (sfid-20140725_111759_287626_2D7FE1F4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's an ath10k pull request which I'm still hoping to get to 3.17,
especially because of the rx reordering and IBSS advertisement fixes.
But if we don't get these to 3.17 it won't be the end of the world
either :)

Please let me know if there are any problems.

The changelog:

Michal and Janusz did some important RX aggregation fixes, basically we
were missing RX reordering altogether. The 10.1 firmware doesn't support
Ad-Hoc mode and Michal fixed ath10k so that it doesn't advertise Ad-Hoc
support with that firmware. Also he implemented a workaround for a KVM
issue.


The following changes since commit bac9832076ee3b134bc859e07698c99276fc9459:

  b43: enable 5 GHz support for N-PHY devices (2014-07-23 13:08:36 -0400)

are available in the git repository at:

  git://github.com/kvalo/ath.git tags/for-linville-20140725

for you to fetch changes up to 0ccb7a3485e5526dca69f036b0d6c5148c78b3f8:

  ath10k: handle attention flags correctly when using A-MSDU (2014-07-25 11:51:07 +0300)

----------------------------------------------------------------
Janusz Dziedzic (1):
      ath10k: handle attention flags correctly when using A-MSDU

Kalle Valo (1):
      Merge remote-tracking branch 'wireless-next/master' into ath-next

Michal Kazior (7):
      ath10k: workaround boot issues with KVM/PCI-passthrough
      ath10k: prevent some tx flushing failures
      ath10k: simplify tx helpers
      ath10k: workaround qos nullfunc bug
      ath10k: prevent endless pci rx loop
      ath10k: fix Rx aggregation reordering
      ath10k: don't advertise IBSS iftype for 10.x

 drivers/net/wireless/ath/ath10k/htc.c    |   20 ++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c |  122 +++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/htt_tx.c |    6 ++
 drivers/net/wireless/ath/ath10k/mac.c    |   96 +++++++++++++++--------
 drivers/net/wireless/ath/ath10k/mac.h    |    4 +-
 drivers/net/wireless/ath/ath10k/pci.c    |   17 +++--
 drivers/net/wireless/ath/ath10k/txrx.c   |    3 +-
 drivers/net/wireless/ath/ath10k/txrx.h   |    1 +
 drivers/net/wireless/ath/ath10k/wmi.c    |    2 +-
 9 files changed, 217 insertions(+), 54 deletions(-)

-- 
Kalle Valo

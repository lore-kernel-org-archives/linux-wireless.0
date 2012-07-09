Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41194 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab2GIJPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:15:50 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20474.41207.326533.209947@gargle.gargle.HOWL> (sfid-20120709_111553_988349_958F811A)
Date: Mon, 9 Jul 2012 14:44:31 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 00/11] ath9k updates
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series addresses beacon handling and multi interface usage
in ath9k, mainly to address concurrent issues with P2P.

TODO:

* caldata handling.
* RX poll work.
* A few more cases in dynamic interface addition/deletion.
* TX queue management.

Please review !

Sujith

Rajkumar Manoharan (1):
  ath9k: Fix race in reset-work usage

Sujith Manoharan (10):
  ath9k: Fix beacon setup
  ath9k_hw: Cleanup ath9k_hw_set_tsfadjust
  ath9k: Cleanup interface handling
  ath9k: Simplify ASSOC handling
  ath9k: Cleanup beacon logic
  ath9k: Remove is_bslot_active
  ath9k: Cleanup beacon queue configuration
  ath9k: Set the TSF adjust value properly
  ath9k: Cleanup the beacon tasklet
  ath9k: Fix ANI management

 drivers/net/wireless/ath/ath9k/ath9k.h        |  24 +-
 drivers/net/wireless/ath/ath9k/beacon.c       | 510 ++++++++++----------------
 drivers/net/wireless/ath/ath9k/debug.c        |   5 +-
 drivers/net/wireless/ath/ath9k/debug.h        |  24 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   2 +-
 drivers/net/wireless/ath/ath9k/hw.c           |   4 +-
 drivers/net/wireless/ath/ath9k/hw.h           |   2 +-
 drivers/net/wireless/ath/ath9k/init.c         |   2 +-
 drivers/net/wireless/ath/ath9k/link.c         |  70 +++-
 drivers/net/wireless/ath/ath9k/main.c         | 255 ++++---------
 drivers/net/wireless/ath/ath9k/mci.c          |   2 +-
 drivers/net/wireless/ath/ath9k/recv.c         |   2 +-
 drivers/net/wireless/ath/ath9k/xmit.c         |  13 +-
 13 files changed, 372 insertions(+), 543 deletions(-)

-- 
1.7.11.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17988 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaFDNr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:47:26 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 00/13] ath9k: Channel context support
Date: Wed, 4 Jun 2014 19:16:26 +0530
Message-ID: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140604_154730_462216_8279F744)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These patches adds a basic infrastruture for multi channel
context. Currently channel context usage is restricted by
modparam "use_chanctx" as it is not yet fully implemented.

This is based on Felix's initial patches for MCC.

Felix Fietkau (12):
  ath9k: Add channel context structure
  ath9k: Move txpower limit to channel context
  ath9k: Move acq to channel context
  ath9k: Add channel context worker thread
  ath9k: channel context based transmission
  ath9k: send powersave frame on channel switch
  ath9k: Implement hw_scan support
  ath9k: Implement remain-on-channal support
  ath9k: Implement channel context ops
  ath9k: Move caldata into channel context
  ath9k: Add ATH_OP_MULTI_CHANNEL
  ath9k: save tsf in channel context

Rajkumar Manoharan (1):
  ath9k: Fetch appropriate opereting channel context

 drivers/net/wireless/ath/ath.h           |   1 +
 drivers/net/wireless/ath/ath9k/Makefile  |   3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h   |  94 ++++++-
 drivers/net/wireless/ath/ath9k/beacon.c  |   2 +-
 drivers/net/wireless/ath/ath9k/channel.c | 411 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.c   |   2 +-
 drivers/net/wireless/ath/ath9k/hw.c      |  23 +-
 drivers/net/wireless/ath/ath9k/hw.h      |   1 +
 drivers/net/wireless/ath/ath9k/init.c    |  19 +-
 drivers/net/wireless/ath/ath9k/link.c    |   4 +-
 drivers/net/wireless/ath/ath9k/main.c    | 454 +++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/mci.c     |   4 +-
 drivers/net/wireless/ath/ath9k/pci.c     |   1 +
 drivers/net/wireless/ath/ath9k/recv.c    |   9 +-
 drivers/net/wireless/ath/ath9k/tx99.c    |   2 +-
 drivers/net/wireless/ath/ath9k/wow.c     |   1 +
 drivers/net/wireless/ath/ath9k/xmit.c    |  72 +++--
 17 files changed, 944 insertions(+), 159 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/channel.c

-- 
2.0.0


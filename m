Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48283 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172Ab2DJPNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 11:13:30 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [WIP 00/11] Add support for Wake on Wireless
Date: Tue, 10 Apr 2012 20:43:10 +0530
Message-ID: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120410_171345_887948_AB2AFD3B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

*this patch set adds initial code support for WoW in
ath9k, offloading features of WoW is not yet added.
*this had to be completely tested, its not working currently
 and there are few known issues that need to be addressed.

thanks to

"Russell Hu" <rhu@qca.qualcomm.com>
"Aeolus Yang" <aeolus@qca.qualcomm.com>
Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Raja Mani <rmani@qca.qualcomm.com>
and Luis for his initial WoW patches and help

once this is properly tested and working,
we will send it patches, with issues fixed.

Mohammed Shafi Shajakhan (11):
  ath9k_hw: Add register definitions for WoW support
  ath9k: Add definitions and structures to support WoW
  ath9k_hw: Add WoW hardware capability flags
  ath9k_hw: advertise WoW support for capable chipsets
  ath9k: advertise supported WoW flags to upper layer
  ath9k_hw: INI changes for WoW for AR9002 chipsets
  ath9k_hw: Add hardware code for WoW
  ath9k: Add WoW related mac80211 callbacks
  ath: Add Wake-on-Wireless debug mask
  ath9k: Add debug messages for WoW
  ath9k: do not disable hardware while wow is enabled

 drivers/net/wireless/ath/ath.h                   |    2 +
 drivers/net/wireless/ath/ath9k/Makefile          |    1 +
 drivers/net/wireless/ath/ath9k/ar9002_hw.c       |    5 +
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h |   14 +
 drivers/net/wireless/ath/ath9k/ath9k.h           |   30 ++
 drivers/net/wireless/ath/ath9k/hw.c              |    8 +
 drivers/net/wireless/ath/ath9k/hw.h              |   74 +++
 drivers/net/wireless/ath/ath9k/init.c            |   21 +-
 drivers/net/wireless/ath/ath9k/main.c            |  453 ++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/pci.c             |    6 +
 drivers/net/wireless/ath/ath9k/reg.h             |  170 +++++++-
 drivers/net/wireless/ath/ath9k/wow.c             |  547 ++++++++++++++++++++++
 12 files changed, 1319 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/wow.c


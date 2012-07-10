Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53638 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab2GJJWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 05:22:40 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH v4 00/10] Add support for WOW in ath9k
Date: Tue, 10 Jul 2012 14:52:29 +0530
Message-ID: <1341912149-11807-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120710_112244_297555_5B8CEC17)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Add support for hardware WoW in ath9k. Magic-packet,
beacon loss triggers, deauth/disassoc patterns
(a special case of user pattern) are tested. 
User pattern needs a bit of investigation
on parsing to appropriate 802.11 format.
we will do more rigorous testing and address bugs.

Thanks a lot to Vadivel for providing me the hardware and
inputs to test. Thanks to Rajkumar, Sujith for their review &
Russell for his all help. Thanks to Aeolous, Senthil and Raja. 
Thanks a lot to Luis for providing the complete
frame work for WoW in his initial wow patches.

Mohammed Shafi Shajakhan (10):
  ath9k_hw: Add register definitions for WoW support
  ath9k: Add definitions and structures to support WoW
  ath9k_hw: Add WoW hardware capability flags
  ath9k_hw: advertise WoW support for capable chipsets
  ath9k: advertise supported WoW flags to upper layer
  ath9k_hw: INI changes for WoW for AR9002 chipsets
  ath9k_hw: Add hardware code for WoW
  ath: Add Wake-on-Wireless debug mask
  ath9k: Add WoW related mac80211 callbacks
  ath9k: do not disable hardware while wow is enabled

 drivers/net/wireless/ath/ath.h                   |    2 +
 drivers/net/wireless/ath/ath9k/Makefile          |    1 +
 drivers/net/wireless/ath/ath9k/ar9002_hw.c       |    5 +
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h |   14 +
 drivers/net/wireless/ath/ath9k/ath9k.h           |   13 +
 drivers/net/wireless/ath/ath9k/hw.c              |    8 +
 drivers/net/wireless/ath/ath9k/hw.h              |   82 ++++
 drivers/net/wireless/ath/ath9k/init.c            |   18 +
 drivers/net/wireless/ath/ath9k/main.c            |  373 +++++++++++++++
 drivers/net/wireless/ath/ath9k/pci.c             |    3 +
 drivers/net/wireless/ath/ath9k/reg.h             |  145 ++++++-
 drivers/net/wireless/ath/ath9k/wow.c             |  532 ++++++++++++++++++++++
 12 files changed, 1195 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/wow.c


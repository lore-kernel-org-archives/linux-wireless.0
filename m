Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42633 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab2FRGWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 02:22:13 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 00/10] Add support for WOW in ath9k
Date: Mon, 18 Jun 2012 11:51:44 +0530
Message-ID: <1340000514-7779-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120618_082216_802434_CA6EFE92)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Add support for hardware WoW in ath9k. Magic-packet,
beacon loss triggers are tested with AR9485, AR9280.
Hardware code was cleaned up addressing Rajkumar's
comments. User pattern needs a bit of investigation 
on parsing to appropriate 802.11 format,
few bug related to that are addressed.
this RFC series is better tested and cleaned up compared
to the WIP series. one more final review needed 
to fix any possible bugs and correctness of the code.

Thanks a lot to Vadivel, Rajkumar and Russell for
their invaluable help.

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
 drivers/net/wireless/ath/ath9k/ath9k.h           |   29 ++
 drivers/net/wireless/ath/ath9k/hw.c              |    8 +
 drivers/net/wireless/ath/ath9k/hw.h              |   75 +++
 drivers/net/wireless/ath/ath9k/init.c            |   21 +-
 drivers/net/wireless/ath/ath9k/main.c            |  375 ++++++++++++++-
 drivers/net/wireless/ath/ath9k/pci.c             |    6 +
 drivers/net/wireless/ath/ath9k/reg.h             |  145 ++++++-
 drivers/net/wireless/ath/ath9k/wow.c             |  554 ++++++++++++++++++++++
 12 files changed, 1223 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/wow.c


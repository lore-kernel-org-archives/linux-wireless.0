Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48756 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbbFRHBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 03:01:33 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH V2 00/10] Add QCA99X0 support
Date: Thu, 18 Jun 2015 12:31:00 +0530
Message-ID: <1434610870-5505-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150618_090137_311565_A8A2F19F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set adds changes for QCA99X0 chip in pci probe,
Copy Engine init and firmware downloads. Since it is still
work in progress the support for this chip is not yet
advertised in pci device table.

Vasanthakumar Thiagarajan (10):
  ath10k: Add a table to store hw specific values
  ath10k: Add new reg_address/mask to hw register table
  ath10k: Add hw register/values for QCA99X0 chip
  ath10k: Copy Engine related changes for QCA99X0
  ath10k: Make target cpu address to CE address conversion chip specific
  ath10k: Add chip reset sequence for QCA99X0
  ath10k: Extend CE src desc flags for interrupt indication
  ath10k: Fix BMI communication timeout for QCA99X0
  ath10k: Add support for code swap
  ath10k: Add BMI param value to execute otp to hw_param

---
V2:
	- Rebased on the latest master

 drivers/net/wireless/ath/ath10k/Makefile    |   3 +-
 drivers/net/wireless/ath/ath10k/bmi.h       |   2 +-
 drivers/net/wireless/ath/ath10k/ce.c        |   1 +
 drivers/net/wireless/ath/ath10k/ce.h        |  17 ++-
 drivers/net/wireless/ath/ath10k/core.c      |  52 ++++++-
 drivers/net/wireless/ath/ath10k/core.h      |   9 ++
 drivers/net/wireless/ath/ath10k/hw.c        |  86 +++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h        |  61 ++++++--
 drivers/net/wireless/ath/ath10k/pci.c       | 180 ++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/pci.h       |  12 --
 drivers/net/wireless/ath/ath10k/swap.c      | 208 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/swap.h      |  72 ++++++++++
 drivers/net/wireless/ath/ath10k/targaddrs.h |   3 +
 13 files changed, 659 insertions(+), 47 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/swap.c
 create mode 100644 drivers/net/wireless/ath/ath10k/swap.h

-- 
1.9.1


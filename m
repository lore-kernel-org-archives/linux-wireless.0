Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62427 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab1JYKhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:37:48 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 0/7] ath6kl: Add WOW support
Date: Tue, 25 Oct 2011 16:07:20 +0530
Message-ID: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20111025_123752_310618_7BF700CA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Using these patch sets, WOW patterns can be controlled 
and configured via iw command. Please refer iw help menu for more details.

There are some limitation in the recent "iw" command such as it doesn't 
take the pattern offset where to start pattern matching in the received packets.
Such a enhancement will be done later..

These patch sets are re-based on master branch, available in git://github.com/kvalo/ath6kl.git

Raja Mani (7):
  ath6kl: Add wmi functions to add/delete wow patterns
  ath6kl: Add wmi functions to configure wow mode and host sleep mode
  ath6kl: Introduce new variable to track wow state machine
  ath6kl: Add new functions to handle wow suspend/resume operations
  ath6kl: Invoke wow suspend/resume calls during PM operations
  ath6kl: Perform WOW resume in RX path in case of SDIO IRQ wakeup
  ath6kl: Expose ath6kl wow capabilities to cfg layer

 drivers/net/wireless/ath/ath6kl/cfg80211.c |  163 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |   13 ++-
 drivers/net/wireless/ath/ath6kl/hif-ops.h  |    5 +
 drivers/net/wireless/ath/ath6kl/hif.h      |    1 +
 drivers/net/wireless/ath/ath6kl/init.c     |    2 +-
 drivers/net/wireless/ath/ath6kl/sdio.c     |   18 +++-
 drivers/net/wireless/ath/ath6kl/txrx.c     |    2 +
 drivers/net/wireless/ath/ath6kl/wmi.c      |  141 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |   47 ++++++++
 9 files changed, 389 insertions(+), 3 deletions(-)


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60372 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750704AbeECGBa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 May 2018 02:01:30 -0400
From: Yu Wang <yyuwang@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: add quiet mode support for QCA6174/QCA9377
Date: Thu,  3 May 2018 14:01:24 +0800
Message-Id: <1525327285-15392-1-git-send-email-yyuwang@codeaurora.org> (sfid-20180503_080214_662018_B69EF386)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To enable thermal throttling for QCA6174 and QCA9377,
implement gen_pdev_set_quiet_mode for them.
With this change, quiet period for QCA6174/QCA9377 can
be also set/get via debugfs.
Usage:
To set quiet period:
	echo <period> > /sys/kernel/debug/ieee80211/phyX/ath10k/quiet_period
To get the current quiet period:
	cat /sys/kernel/debug/ieee80211/phyX/ath10k/quiet_period

Yu Wang (1):
  ath10k: add quiet mode support for QCA6174/QCA9377

 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 33 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 16 +++++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

-- 
1.9.1

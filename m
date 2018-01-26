Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35756 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751664AbeAZFk2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 00:40:28 -0500
From: Yu Wang <yyuwang@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: correct the length of DRAM dump for QCA6174 hw3.x/QCA9377 hw1.1
Date: Fri, 26 Jan 2018 13:40:20 +0800
Message-Id: <1516945221-4710-1-git-send-email-yyuwang@codeaurora.org> (sfid-20180126_064043_476783_C152A3F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The length of DRAM dump for QCA6174 hw3.0/hw3.2 and QCA9377 hw1.1
are less than the actual value, some coredump contents are missed.
To fix it, change the length from 0x90000 to 0xa8000.

Fixes: 703f261dd77f ("ath10k: add memory dump support for QCA6174/QCA9377")

Yu Wang (1):
  ath10k: correct the length of DRAM dump for QCA6174 hw3.x/QCA9377
    hw1.1

 drivers/net/wireless/ath/ath10k/coredump.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.9.1

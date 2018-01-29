Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36680 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbeA2IAF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 03:00:05 -0500
From: Yu Wang <yyuwang@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: fix kernel panic issue during pci probe
Date: Mon, 29 Jan 2018 16:00:00 +0800
Message-Id: <1517212801-7523-1-git-send-email-yyuwang@codeaurora.org> (sfid-20180129_090013_721018_7744C549)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If device gone during chip reset, ar->normal_mode_fw.board is not
initialized, but ath10k_debug_print_hwfw_info() will try to access its
member, which will cause 'kernel NULL pointer' issue. This was found
using a faulty device (pci link went down sometimes) in a random
insmod/rmmod/other-op test.
To fix it, check ar->normal_mode_fw.board before accessing the member.

Yu Wang (1):
  ath10k: fix kernel panic issue during pci probe

 drivers/net/wireless/ath/ath10k/debug.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

-- 
1.9.1

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36657 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752417AbcJDMju (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 08:39:50 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH 0/2] ath10k: Trivial cleanup in HTT tx buffer allocation
Date: Tue, 4 Oct 2016 18:09:30 +0530
Message-ID: <1475584772-4091-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20161004_143953_940188_E793EE92)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Pre-requisite cleanup changes for one time tx buffer allocation
to avoid contigous DMA tx buffer allocation failure for tx
(thanks Vasanth) for long hour stress testing with continuous wifi
down/up with multiple vaps in low memory systems. This change also
holds good as a trivial standalone cleanup change

Mohammed Shafi Shajakhan (2):
  ath10k: clean up HTT tx buffer allocation and free
  ath10k: Remove extraneous error message in tx alloc

 drivers/net/wireless/ath/ath10k/htt_tx.c | 80 +++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 28 deletions(-)

-- 
1.9.1

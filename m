Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25384 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbcG0MhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 08:37:09 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 0/4] ath10k: Padding related clean ups in rx
Date: Wed, 27 Jul 2016 18:06:42 +0530
Message-ID: <1469623006-13178-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20160727_143714_763952_D54BAA33)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set adds abstraction for rx_hw_desc processing so that
we can make use of newer desc fields notifying padding information
which is done on rx payload. "ath10k: Properly remove padding from
the start of rx payload" fixes padding related bug in ethernet decap
mode for QCA99X0, QCA9984 qnd QCA4019 but even fixing this bug will
not make ethernet decap mode work, there needs to be some more fix
wich would follow this patch series.

Vasanthakumar Thiagarajan (4):
  ath10k: Move ath10k_hw_params definition to hw.h
  ath10k: Add provision for Rx descriptor abstraction
  ath10k: Properly remove padding from the start of rx payload
  ath10k: Remove 4-addr padding related hw_param configuration

 drivers/net/wireless/ath/ath10k/core.c   | 21 ++++++----
 drivers/net/wireless/ath/ath10k/core.h   | 48 +--------------------
 drivers/net/wireless/ath/ath10k/htt_rx.c | 36 +++++++++-------
 drivers/net/wireless/ath/ath10k/hw.c     | 13 ++++++
 drivers/net/wireless/ath/ath10k/hw.h     | 71 +++++++++++++++++++++++++++++---
 5 files changed, 114 insertions(+), 75 deletions(-)

-- 
1.9.1


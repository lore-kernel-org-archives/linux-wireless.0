Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:40847 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaEZKKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 06:10:20 -0400
Received: by mail-we0-f175.google.com with SMTP id t61so7844292wes.34
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 03:10:18 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, apenwarr@gmail.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/2] ath10k: pci fixes 2014-05-15
Date: Mon, 26 May 2014 12:02:57 +0200
Message-Id: <1401098579-31842-1-git-send-email-michal.kazior@tieto.com> (sfid-20140526_121023_555289_92BD4402)
In-Reply-To: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com>
References: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Patches are a result of analysing `ath10k firmware
crash after 4 hours of heavy TCP traffic` bug
reported by Avery.

v2:
 * dropped patch 3/3 (memory barrier addition) [Kalle]

Based on github.com/kvalo/ath/master


Michal Kazior (2):
  ath10k: protect src_ring state with ce_lock in tx_sg()
  ath10k: abort incomplete scatter-gather pci tx properly

 drivers/net/wireless/ath/ath10k/ce.c  | 27 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/ce.h  |  2 ++
 drivers/net/wireless/ath/ath10k/pci.c | 27 ++++++++++++++++++---------
 3 files changed, 47 insertions(+), 9 deletions(-)

-- 
1.8.5.3


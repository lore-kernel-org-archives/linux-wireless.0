Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:34215 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaC1HkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 03:40:22 -0400
Received: by mail-ee0-f48.google.com with SMTP id b57so3673852eek.7
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 00:40:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/3] ath10k: ce fixes
Date: Fri, 28 Mar 2014 08:34:22 +0100
Message-Id: <1395992065-10086-1-git-send-email-michal.kazior@tieto.com> (sfid-20140328_084025_870771_D2E80782)
In-Reply-To: <1395745943-29492-1-git-send-email-michal.kazior@tieto.com>
References: <1395745943-29492-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This addresses memory allocations failures
recently reported by Avery Pennarun.


v2:
 * add a new patch (result of splitting)
 * fix commit message


Michal Kazior (3):
  ath10k: convert pci_alloc_consistent() to dma_alloc_coherent()
  ath10k: split ce initialization and allocation
  ath10k: deinit copy engine before resetting

 drivers/net/wireless/ath/ath10k/ce.c  | 356 +++++++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/ce.h  |  15 +-
 drivers/net/wireless/ath/ath10k/pci.c |  88 +++++----
 3 files changed, 264 insertions(+), 195 deletions(-)

-- 
1.8.5.3


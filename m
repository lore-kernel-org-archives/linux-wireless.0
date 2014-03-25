Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:50431 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaCYLST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 07:18:19 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so310297eek.36
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 04:18:17 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: ce fixes
Date: Tue, 25 Mar 2014 12:12:21 +0100
Message-Id: <1395745943-29492-1-git-send-email-michal.kazior@tieto.com> (sfid-20140325_121823_748978_E618503D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This addresses memory allocations failures
recently reported by Avery Pennarun.


Michal Kazior (2):
  ath10k: convert pci_alloc_consistent() to dma_alloc_coherent()
  ath10k: split ce initialization and allocation

 drivers/net/wireless/ath/ath10k/ce.c  | 356 +++++++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/ce.h  |  15 +-
 drivers/net/wireless/ath/ath10k/pci.c |  88 +++++----
 3 files changed, 264 insertions(+), 195 deletions(-)

-- 
1.8.5.3


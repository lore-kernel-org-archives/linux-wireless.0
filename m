Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62930 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbaHGJNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:13:49 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so4583486wiw.6
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:13:48 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/5] ath10k: fixes 2014-08-07, part 2
Date: Thu,  7 Aug 2014 11:04:15 +0200
Message-Id: <1407402260-29854-1-git-send-email-michal.kazior@tieto.com> (sfid-20140807_111352_483372_15548997)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is part 2 (of 3) of my patches. Split for
your reviewing pleasure.

This is related to irq handling only. Prepares for
more start/restart sequences fixes.

This is based on:
  [PATCH 0/6] ath10k: fixes 2014-08-07, part 1


Michal Kazior (5):
  ath10k: fix legacy irq workaround
  ath10k: setup irq method in probe
  ath10k: remove early irq handling
  ath10k: split ce irq/handler setup
  ath10k: unmask ce irqs after posting rx buffers

 drivers/net/wireless/ath/ath10k/ce.c   |  36 ++---
 drivers/net/wireless/ath/ath10k/ce.h   |  12 +-
 drivers/net/wireless/ath/ath10k/core.h |   1 -
 drivers/net/wireless/ath/ath10k/pci.c  | 281 ++++++++++-----------------------
 4 files changed, 99 insertions(+), 231 deletions(-)

-- 
1.8.5.3


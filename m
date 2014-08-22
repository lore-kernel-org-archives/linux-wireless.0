Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38986 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbaHVMnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 08:43:05 -0400
Received: by mail-lb0-f174.google.com with SMTP id c11so9366970lbj.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 05:43:04 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/5] ath10k: fixes 2014-08-07, part 3
Date: Fri, 22 Aug 2014 14:33:13 +0200
Message-Id: <1408710798-25198-1-git-send-email-michal.kazior@tieto.com> (sfid-20140822_144310_432083_56515FCE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is part 3 (of 3) of my patches. Split for
your reviewing pleasure.

This is related to start/restart sequences.

This is based on:
  [PATCH v2 0/6] ath10k: fixes 2014-08-07, part 2

v2:
 * patch [2/5] replaced
 * fixes, see notes


Michal Kazior (5):
  ath10k: rework posting pci rx buffers
  ath10k: update comment regarding warm reset
  ath10k: ignore ar_pci->started in pipe cleanup
  ath10k: remove ar_pci->started
  ath10k: flush hif buffers before recovery

 drivers/net/wireless/ath/ath10k/ce.c   |  71 +++++----
 drivers/net/wireless/ath/ath10k/ce.h   |  16 +-
 drivers/net/wireless/ath/ath10k/core.c |   1 +
 drivers/net/wireless/ath/ath10k/pci.c  | 259 +++++++++++++++------------------
 drivers/net/wireless/ath/ath10k/pci.h  |   4 +-
 5 files changed, 165 insertions(+), 186 deletions(-)

-- 
1.8.5.3


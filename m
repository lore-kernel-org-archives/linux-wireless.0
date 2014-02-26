Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42175 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaBZLju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 06:39:50 -0500
Received: by mail-ee0-f46.google.com with SMTP id d49so426496eek.5
        for <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 03:39:49 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/8] ath10k: performance improvements
Date: Wed, 26 Feb 2014 12:34:17 +0100
Message-Id: <1393414465-3666-1-git-send-email-michal.kazior@tieto.com> (sfid-20140226_123954_317811_7A96C4D5)
In-Reply-To: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These patches aim at reducing host CPU load and
thus improve performance on low-end systems.

In my setup I get a relative improvement of
100mbps for both UDP Tx and Rx.

               Tx ----->
laptop:eth---eth:AP135:ath10k---ath10k:laptop
               <----- Rx


v2:
 * improve comments/commit messages
 * fix 1 unbalanced locking
 * fix var naming (s/err/ret)
 * remove code that didn't belong here
 * split batch tx/rx into 2 patches
   (+ath10k: reduce htt tx/rx spinlock overhead)

Michal Kazior (8):
  ath10k: remove DMA mapping wrappers
  ath10k: remove is_aborted from skb_cb
  ath10k: replace send_head() with tx_sg()
  ath10k: bypass htc for htt tx path
  ath10k: batch htt tx/rx completions
  ath10k: reduce htt tx/rx spinlock overhead
  ath10k: remove pci completion list
  ath10k: minimize coherent dma accesses

 drivers/net/wireless/ath/ath10k/ce.c     |  16 +-
 drivers/net/wireless/ath/ath10k/ce.h     |   9 +-
 drivers/net/wireless/ath/ath10k/core.h   |  33 +--
 drivers/net/wireless/ath/ath10k/hif.h    |  25 +-
 drivers/net/wireless/ath/ath10k/htc.c    |  25 +-
 drivers/net/wireless/ath/ath10k/htt.h    |  17 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c | 147 ++++++++----
 drivers/net/wireless/ath/ath10k/htt_tx.c | 205 ++++++++--------
 drivers/net/wireless/ath/ath10k/mac.c    |   4 +-
 drivers/net/wireless/ath/ath10k/pci.c    | 389 +++++++------------------------
 drivers/net/wireless/ath/ath10k/pci.h    |  28 ---
 drivers/net/wireless/ath/ath10k/txrx.c   |  15 +-
 drivers/net/wireless/ath/ath10k/wmi.c    |  17 +-
 13 files changed, 379 insertions(+), 551 deletions(-)

-- 
1.8.5.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:54415 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaBQJhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 04:37:52 -0500
Received: by mail-ee0-f47.google.com with SMTP id d49so6909785eek.20
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 01:37:51 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC/RFT 0/7] ath10k: performance improvements
Date: Mon, 17 Feb 2014 10:32:36 +0100
Message-Id: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com> (sfid-20140217_103801_401313_22873888)
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


Michal Kazior (7):
  ath10k: remove DMA mapping wrappers
  ath10k: remove is_aborted from skb_cb
  ath10k: replace send_head() with tx_sg()
  ath10k: bypass htc for htt tx path
  ath10k: batch htt tx/rx completions
  ath10k: remove pci completion list
  ath10k: minimize coherent dma accesses

 drivers/net/wireless/ath/ath10k/ce.c     |  16 +-
 drivers/net/wireless/ath/ath10k/ce.h     |   9 +-
 drivers/net/wireless/ath/ath10k/core.h   |  33 +--
 drivers/net/wireless/ath/ath10k/hif.h    |  25 +-
 drivers/net/wireless/ath/ath10k/htc.c    |  25 +-
 drivers/net/wireless/ath/ath10k/htt.h    |  16 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c | 152 +++++++-----
 drivers/net/wireless/ath/ath10k/htt_tx.c | 207 ++++++++--------
 drivers/net/wireless/ath/ath10k/mac.c    |   4 +-
 drivers/net/wireless/ath/ath10k/pci.c    | 389 +++++++------------------------
 drivers/net/wireless/ath/ath10k/pci.h    |  28 ---
 drivers/net/wireless/ath/ath10k/txrx.c   |  15 +-
 drivers/net/wireless/ath/ath10k/wmi.c    |  17 +-
 13 files changed, 382 insertions(+), 554 deletions(-)

-- 
1.8.5.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:40457 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaJTNyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:54:15 -0400
Received: by mail-la0-f50.google.com with SMTP id s18so3945408lam.23
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:54:13 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/9] ath10k: htt rx fixes and clean ups
Date: Mon, 20 Oct 2014 15:40:29 +0200
Message-Id: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com> (sfid-20141020_155418_625374_3C2C3BF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've found a couple of issues while reworking rx
path.


Michal Kazior (9):
  ath10k: don't drop control and null func Rx
  ath10k: remove unused variable
  ath10k: use ieee80211 defines for crypto param lengths
  ath10k: fix rx buffer tracing
  ath10k: deduplicate htt rx dma unmapping
  ath10k: don't drop frames aggressively
  ath10k: add extra sanity check when popping amsdu
  ath10k: don't forget to replenish after fragmented Rx
  ath10k: clear htt->rx_confused on load

 drivers/net/wireless/ath/ath10k/htt_rx.c | 91 ++++++++++++++------------------
 1 file changed, 39 insertions(+), 52 deletions(-)

-- 
1.8.5.3


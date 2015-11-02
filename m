Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33412 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbbKBOEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 09:04:02 -0500
Received: by lfbf136 with SMTP id f136so47905993lfb.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2015 06:04:01 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/8] ath10k: clean up ath10k_skb_cb
Date: Mon,  2 Nov 2015 15:03:00 +0100
Message-Id: <1446472988-2603-1-git-send-email-michal.kazior@tieto.com> (sfid-20151102_150408_489637_6F958CFD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath10k_skb_cb structure wasn't really space
efficient. Some stuff is removed or replaced with
more compact representation.

This cleanup is necessary for future features.

The size of ath10k_skb_cb:

          before   after
 x86-32   26       12
 x86-64   34       20


Michal Kazior (8):
  ath10k: merge is_protected with nohwcrypt
  ath10k: rename function to adhere to naming convention
  ath10k: remove txmode from skb_cb
  ath10k: remove is_offchan
  ath10k: remove freq from skb_cb
  ath10k: pack up flags in skb_cb
  ath10k: replace vdev_id and tid in skb cb
  ath10k: store msdu_id instead of txbuf pointers

 drivers/net/wireless/ath/ath10k/core.h   |  27 +++----
 drivers/net/wireless/ath/ath10k/htt.h    |   3 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 111 ++++++++++++++++++-----------
 drivers/net/wireless/ath/ath10k/mac.c    | 116 +++++++++++++++----------------
 drivers/net/wireless/ath/ath10k/mac.h    |   1 +
 drivers/net/wireless/ath/ath10k/txrx.c   |   7 +-
 drivers/net/wireless/ath/ath10k/wmi.c    |  22 ++++--
 7 files changed, 165 insertions(+), 122 deletions(-)

-- 
2.1.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36320 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbbKJNND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 08:13:03 -0500
Received: by lbblt2 with SMTP id lt2so100751970lbb.3
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2015 05:13:01 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/9] ath10k: clean up ath10k_skb_cb
Date: Tue, 10 Nov 2015 14:10:46 +0100
Message-Id: <1447161055-2283-1-git-send-email-michal.kazior@tieto.com> (sfid-20151110_141335_304469_36302D53)
In-Reply-To: <1446472988-2603-1-git-send-email-michal.kazior@tieto.com>
References: <1446472988-2603-1-git-send-email-michal.kazior@tieto.com>
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


v2:
 * fix a bug (patch 7/9 introduced)


Michal Kazior (9):
  ath10k: merge is_protected with nohwcrypt
  ath10k: rename function to adhere to naming convention
  ath10k: remove txmode from skb_cb
  ath10k: remove is_offchan
  ath10k: remove freq from skb_cb
  ath10k: pack up flags in skb_cb
  ath10k: fix tx header parsing
  ath10k: replace vdev_id and tid in skb cb
  ath10k: store msdu_id instead of txbuf pointers

 drivers/net/wireless/ath/ath10k/core.h   |  28 +++-----
 drivers/net/wireless/ath/ath10k/htt.h    |   4 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 112 ++++++++++++++++++-----------
 drivers/net/wireless/ath/ath10k/mac.c    | 119 ++++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/mac.h    |   1 +
 drivers/net/wireless/ath/ath10k/txrx.c   |  15 ++--
 drivers/net/wireless/ath/ath10k/wmi.c    |  22 ++++--
 7 files changed, 173 insertions(+), 128 deletions(-)

-- 
2.1.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33426 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbKRF7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 00:59:31 -0500
Received: by lbbkw15 with SMTP id kw15so18475902lbb.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2015 21:59:29 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 0/9] ath10k: clean up ath10k_skb_cb
Date: Wed, 18 Nov 2015 06:59:14 +0100
Message-Id: <1447826363-16818-1-git-send-email-michal.kazior@tieto.com> (sfid-20151118_065937_111393_25D6B290)
In-Reply-To: <87mvuj585b.fsf@kamboji.qca.qualcomm.com>
References: <87mvuj585b.fsf@kamboji.qca.qualcomm.com>
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


v3:
 * rebase

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
 drivers/net/wireless/ath/ath10k/htt_tx.c | 116 +++++++++++++++++++-----------
 drivers/net/wireless/ath/ath10k/mac.c    | 117 ++++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/txrx.c   |  15 ++--
 drivers/net/wireless/ath/ath10k/wmi.c    |  22 ++++--
 6 files changed, 173 insertions(+), 129 deletions(-)

-- 
2.1.4


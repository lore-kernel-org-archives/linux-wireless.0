Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:34723 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbcCAKcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 05:32:08 -0500
Received: by mail-lf0-f53.google.com with SMTP id j78so110090246lfb.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2016 02:32:07 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 00/11] ath10k: implement push-pull tx model
Date: Tue,  1 Mar 2016 11:32:45 +0100
Message-Id: <1456828376-2795-1-git-send-email-michal.kazior@tieto.com> (sfid-20160301_113212_346126_3EE36719)
In-Reply-To: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for the new logic where host
tells firmware how many frames are queued for each
station/tid and then firmware asks host to submit
frames for given station/tid.

The patch count is a bit high but I tried
splitting the patches as much as possible to keep
them short and easy to review. Hopefully it's not
going to be a huge headache.

v2:
 - squashes some patches
 - reworked pending frame scheduling


Michal Kazior (11):
  ath10k: refactor tx code
  ath10k: unify txpath decision
  ath10k: refactor tx pending management
  ath10k: maintain peer_id for each sta and vif
  ath10k: add fast peer_map lookup
  ath10k: add new htt message generation/parsing logic
  ath10k: implement wake_tx_queue
  ath10k: implement updating shared htt txq state
  ath10k: store txq in skb_cb
  ath10k: keep track of queue depth per txq
  ath10k: implement push-pull tx

 drivers/net/wireless/ath/ath10k/core.c   |   2 +
 drivers/net/wireless/ath/ath10k/core.h   |  16 +
 drivers/net/wireless/ath/ath10k/htt.h    |  21 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c | 298 ++++++++++++++++-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 261 +++++++++++----
 drivers/net/wireless/ath/ath10k/mac.c    | 534 +++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/mac.h    |   6 +
 drivers/net/wireless/ath/ath10k/txrx.c   |  11 +-
 8 files changed, 1019 insertions(+), 130 deletions(-)

-- 
2.1.4


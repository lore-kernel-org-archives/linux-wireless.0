Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34735 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759348AbcAMN76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 08:59:58 -0500
Received: by mail-lb0-f178.google.com with SMTP id cl12so73599432lbc.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2016 05:59:58 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/5] ath10k: add basic hostq support
Date: Wed, 13 Jan 2016 15:01:03 +0100
Message-Id: <1452693668-30030-1-git-send-email-michal.kazior@tieto.com> (sfid-20160113_150008_614104_68A8AB0C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's a new firmware feature which uses a shared
DMA memory so host can share it's per-sta per-tid
queue size which is then subsequently used for
firmware to assist in deciding which frames to put
on the intermediate host-device tx queue.

This patchset adds only basic support to make
the firmware supporting the feature happy and
running at all. Without it firmware would freeze
shortly after booting.

More patches will follow some time later to add
the "new data path" logic.


Michal Kazior (5):
  ath10k: rename some HTT events
  ath10k: add new htt definitions
  ath10k: add new FW_FEATURE_PEER_FLOW_CONTROL
  ath10k: clean up cont frag desc init code
  ath10k: implement basic support for new tx path firmware

 drivers/net/wireless/ath/ath10k/core.c   |   1 +
 drivers/net/wireless/ath/ath10k/core.h   |   9 ++
 drivers/net/wireless/ath/ath10k/htt.c    |   8 +-
 drivers/net/wireless/ath/ath10k/htt.h    | 169 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/htt_rx.c |   8 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 146 +++++++++++++++++++++-----
 6 files changed, 302 insertions(+), 39 deletions(-)

-- 
2.1.4


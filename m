Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:46247 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbBYHxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 02:53:04 -0500
Received: by lams18 with SMTP id s18so2044474lam.13
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 23:53:02 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH v2 0/4] ath10k: add basic tdls support
Date: Wed, 25 Feb 2015 08:55:07 +0100
Message-Id: <1424850911-21017-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20150225_085309_309112_B53DB2CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset introduces tdls funtionality without tdls peer uapsd
and tdls channel switching. Tdls is supported by qca6174 hardware
what is indicated by firmware through supported services.
Tdls station when authorized requires some parameters that are filled in
by rate control initialization. Because of that this patches contains
one patch for mac80211 which moves rate control initialization before
calling drivers station state with transition to authorized state.

v2:
-introduce tdls peer counter
-minor changes after review

Marek Puzyniak (3):
  ath10k: make peer type configurable
  mac80211: initialize rate control earlier for tdls station
  ath10k: introduce basic tdls functionality

Michal Kazior (1):
  ath10k: unify tx mode and dispatch

 drivers/net/wireless/ath/ath10k/core.h    |   3 +
 drivers/net/wireless/ath/ath10k/htt_rx.c  |   8 -
 drivers/net/wireless/ath/ath10k/htt_tx.c  |  30 ++-
 drivers/net/wireless/ath/ath10k/mac.c     | 307 +++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/mac.h     |   8 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  50 ++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 157 ++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  52 +++++
 drivers/net/wireless/ath/ath10k/wmi.c     |   3 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |  43 +++++
 net/mac80211/cfg.c                        |  20 +-
 11 files changed, 597 insertions(+), 84 deletions(-)

-- 
2.1.4


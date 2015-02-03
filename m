Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:61794 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339AbbBCKkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 05:40:18 -0500
Received: by mail-we0-f173.google.com with SMTP id w62so44151481wes.4
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2015 02:40:17 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [RFC 0/4] ath10k: add basic tdls support
Date: Tue,  3 Feb 2015 11:41:50 +0100
Message-Id: <1422960114-25137-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20150203_114029_834182_773BDA0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset introduces tdls funtionality without tdls peer uapsd
and tdls channel switching. Tdls is supported by qca6174 hardware
what is indicated by firmware through supported services.
Tdls station when authorized requires some parameters that are filled in
by rate control initialization. Because of that this patches contains
one patch for mac80211 which moves rate control initialization before
calling drivers station state with transition to authorized state.
        
This patchset is RFC because it based on patchset from Michal:
ath10k: add multi-channel support
which is still under review.

Marek Puzyniak (3):
  ath10k: make peer type configurable
  mac80211: initialize rate control earlier for tdls station
  ath10k: introduce basic tdls functionality

Michal Kazior (1):
  ath10k: unify tx mode and dispatch

 drivers/net/wireless/ath/ath10k/core.h    |   2 +
 drivers/net/wireless/ath/ath10k/htt_rx.c  |   8 -
 drivers/net/wireless/ath/ath10k/htt_tx.c  |  30 ++--
 drivers/net/wireless/ath/ath10k/mac.c     | 263 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/mac.h     |   8 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  50 +++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 156 +++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  52 ++++++
 drivers/net/wireless/ath/ath10k/wmi.c     |   3 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |  43 +++++
 net/mac80211/cfg.c                        |  20 ++-
 11 files changed, 561 insertions(+), 74 deletions(-)

-- 
2.1.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:36703 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbbCQMdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 08:33:21 -0400
Received: by lamx15 with SMTP id x15so7108750lam.3
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2015 05:33:20 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 0/7] ath10k: add multi-channel support
Date: Tue, 17 Mar 2015 12:30:41 +0000
Message-Id: <1426595448-1630-1-git-send-email-michal.kazior@tieto.com> (sfid-20150317_133325_567822_146872AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New qca6174 with wmi-tlv firmware supports
multi-channel operation. To make use of it
ath10k needs a few changes: implement mac80211's
chanctx API and rework tx queue control a bit.


Changes since RFC:
 * I've sent `ath10k: defer AP self-peer removal
   wait` separately now because it's not really
   required for multi-channel per se

v2:
 * fix null deref after rebasing
 * fix commit log typo

v3:
 * remove some duplication wrt mac80211 [Johannes]
 * small fixes

v4:
 * rebased
 * fix STA CSA
 * drop ar->arvifs data_lock protection patch
 * drop ar->arvifs for vif iteration in favour of
   ieee80211_iterate_active_interfaces()
 * small refactor in monitor recalc
 * add a patch to fix fw resource allocation for
   multi-vif/chan


Michal Kazior (7):
  ath10k: allow empty ssid vdev config
  ath10k: implement chanctx API
  ath10k: implement adaptive qcs command
  ath10k: rework tx queue locking
  ath10k: implement tx pause wmi event
  ath10k: enable multi-channel on supported devices
  ath10k: allocate fw resources for iface combinations

 drivers/net/wireless/ath/ath10k/core.h    |  18 +
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 102 +++-
 drivers/net/wireless/ath/ath10k/htt_tx.c  |   4 +-
 drivers/net/wireless/ath/ath10k/hw.h      |   6 +-
 drivers/net/wireless/ath/ath10k/mac.c     | 940 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/mac.h     |  24 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  16 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  88 ++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  46 ++
 drivers/net/wireless/ath/ath10k/wmi.c     |  18 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |   1 +
 11 files changed, 1125 insertions(+), 138 deletions(-)

-- 
2.1.4


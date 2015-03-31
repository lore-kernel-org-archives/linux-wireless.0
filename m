Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34599 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbbCaKdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 06:33:03 -0400
Received: by lboc7 with SMTP id c7so9036965lbo.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2015 03:33:02 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v6 0/7] ath10k: add multi-channel support
Date: Tue, 31 Mar 2015 10:26:19 +0000
Message-Id: <1427797586-5132-1-git-send-email-michal.kazior@tieto.com> (sfid-20150331_123309_614925_554A2AE8)
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

v5:
 * rebased on top of pending branch
 * 12 char commit ids
 * increase vif limit to 3 in ifcombs

v6:
 * fix rcu locking
 * rebased on master branch
   (mind the cfg80211_get_bss conflict when
    applying to pending branch)

Michal Kazior (7):
  ath10k: allow empty ssid vdev config
  ath10k: implement chanctx API
  ath10k: implement adaptive qcs command
  ath10k: rework tx queue locking
  ath10k: implement tx pause wmi event
  ath10k: enable multi-channel on supported devices
  ath10k: allocate fw resources for iface combinations

 drivers/net/wireless/ath/ath10k/core.h    |  18 +
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 100 +++-
 drivers/net/wireless/ath/ath10k/htt_tx.c  |   4 +-
 drivers/net/wireless/ath/ath10k/hw.h      |   6 +-
 drivers/net/wireless/ath/ath10k/mac.c     | 956 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/mac.h     |  14 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  16 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  88 ++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  46 ++
 drivers/net/wireless/ath/ath10k/wmi.c     |  18 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |   1 +
 11 files changed, 1126 insertions(+), 141 deletions(-)

-- 
2.1.4


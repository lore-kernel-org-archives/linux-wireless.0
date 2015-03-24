Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34991 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbbCXMpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 08:45:52 -0400
Received: by laae1 with SMTP id e1so26264368laa.2
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2015 05:45:51 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v5 0/7] ath10k: add multi-channel support
Date: Tue, 24 Mar 2015 12:43:06 +0000
Message-Id: <1427200993-7550-1-git-send-email-michal.kazior@tieto.com> (sfid-20150324_134555_871497_650309B3)
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
 drivers/net/wireless/ath/ath10k/mac.c     | 941 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/mac.h     |  24 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  16 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  88 ++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  46 ++
 drivers/net/wireless/ath/ath10k/wmi.c     |  18 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |   1 +
 11 files changed, 1125 insertions(+), 139 deletions(-)

-- 
2.1.4

